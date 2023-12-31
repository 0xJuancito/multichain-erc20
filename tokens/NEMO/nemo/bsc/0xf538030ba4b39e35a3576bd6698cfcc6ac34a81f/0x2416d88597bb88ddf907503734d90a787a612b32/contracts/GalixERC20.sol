// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20SnapshotUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/draft-ERC20PermitUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";
import "./common/GalixContextUpgradeable.sol";

/**
 * @title GALIX Token
 * @author GALIX Inc
*/

contract GalixERC20 is
    Initializable,
    GalixContextUpgradeable,
    ERC20Upgradeable,
    OwnableUpgradeable,
    ERC20PausableUpgradeable,
    ERC20SnapshotUpgradeable,
    ERC20PermitUpgradeable,
    AccessControlEnumerableUpgradeable
{
    using SafeMathUpgradeable for uint256;

    bytes32 public constant MINTER_ROLE     = keccak256("MINTER_ROLE");
    bytes32 public constant FREEZE_ROLE     = keccak256("FREEZE_ROLE");
    uint256 private _maxSupply; // 0 unlimited
    uint256 private _supply;
    mapping(address => uint8) public proxyRegistryAddress;

    function initialize(string memory _name, string memory _symbol, uint256 __maxSupply) public virtual initializer {        
        __ERC20_init(_name, _symbol);
        __Ownable_init();
        __ERC20Permit_init(_name);
        
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _setupRole(MINTER_ROLE, _msgSender());
        _maxSupply = __maxSupply;
        _supply = 0;
    }

    function _msgSender() internal override view virtual returns (address) {
        return _msgSenderViaWalletProxy();
    }

    function _mint(address account, uint256 amount) internal virtual override {
        require(_supply.add(amount) <= _maxSupply || _maxSupply == 0, "Over maxSupply");
        _supply = _supply.add(amount);
        super._mint(account, amount);
    }

    ////////////////// ADMIN /////////////////
    function setProxyRegistryAddress(address _proxyRegistryAddress) public onlyOwner {
        proxyRegistryAddress[_proxyRegistryAddress] = 1;
    }

    function removeProxyRegistryAddress(address _proxyRegistryAddress) public onlyOwner {
        require((proxyRegistryAddress[_proxyRegistryAddress] == 1), "ERC20: proxyAdress input invalid");
        delete proxyRegistryAddress[_proxyRegistryAddress];
    }

    function createSnapshot() external returns (uint256) {
        require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()),"Must have admin role to snapshot");
        return _snapshot();
    }

    function mintFrom(address account, uint256 amount) external {
        require(hasRole(MINTER_ROLE, _msgSender()), "Must have minter role to mint");
        _mint(account, amount);        
    }

    function mint(uint256 amount) external {
        require(hasRole(MINTER_ROLE, _msgSender()), "Must have minter role to mint");
        _mint(_msgSender(), amount);
    }

    function burnFrom(address account, uint256 amount) external {
        require(hasRole(MINTER_ROLE, _msgSender()), "Must have minter role to burnFrom");
        _burn(account, amount);
    }

    function addMinter(address account) external {
        require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Must have admin role to addMinter");
        grantRole(MINTER_ROLE, account);
    }

    function removeMinter(address account) external {
        require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "must have admin role to removeMinter");
        revokeRole(MINTER_ROLE, account);
    }

    function pause() external {
        require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Must have admin role to pause");
        _pause();
    }

    function unpause() external {
        require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Must have admin role to unpause");
        _unpause();
    }

    ////////////////// MINTER /////////////////
    function freeze(address account) external {
        require(hasRole(MINTER_ROLE, _msgSender()), "Must have minter role to freeze");
        grantRole(FREEZE_ROLE, account);
    }

    function unfreeze(address account) external {
        require(hasRole(MINTER_ROLE, _msgSender()), "Must have minter role to unfreeze");
        revokeRole(FREEZE_ROLE, account);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override(
        ERC20Upgradeable,
        ERC20PausableUpgradeable,
        ERC20SnapshotUpgradeable
    ) {
        require(!hasRole(FREEZE_ROLE, from), "Account temporarily unavailable.");
        super._beforeTokenTransfer(from, to, amount);
    }

    ////////////////// ANON /////////////////
    function burn(uint256 amount) external {
        _burn(_msgSender(), amount);
    }

    function allowance(address owner, address spender) public view override returns(uint256) {
        if (proxyRegistryAddress[spender] == 1)
            return type(uint256).max;
        return super.allowance(owner, spender);
    }

    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual override returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual override returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, allowance(owner, spender) + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual override returns (bool) {
        address owner = _msgSender();
        uint256 currentAllowance = allowance(owner, spender);
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(owner, spender, currentAllowance - subtractedValue);
        }

        return true;
    }
    
    function maxSupply() external view returns (uint256) {
        if(_maxSupply > 0){
            return _maxSupply;
        }else{
            return _supply;
        }
    }

    function version() external view virtual returns (uint256) {
        return 202210121;
    }

    /*
    t.Approval
    t.DEFAULT_ADMIN_ROLE
    t.DOMAIN_SEPARATOR
    t.FREEZE_ROLE
    t.MINTER_ROLE
    t.Paused
    t.RoleAdminChanged
    t.RoleGrantedt.RoleRevoked
    t.Snapshot
    t.Transfer
    t.Unpaused
    t.abi
    t.addMinter
    t.address
    t.allEvents
    t.allowance
    t.approve
    t.balanceOf
    t.balanceOfAt
    t.burn
    t.constructor
    t.contract
    t.decimals
    t.decreaseAllowance
    t.freeze
    t.getPastEvents
    t.getRoleAdmin
    t.getRoleMember
    t.getRoleMemberCount
    t.grantRole
    t.hasRole
    t.increaseAllowance
    t.initialize
    t.methods
    t.mint
    t.mintFrom
    t.name
    t.nonces
    t.pause
    t.paused
    t.permit
    t.removeMinter
    t.renounceRole
    t.revokeRole
    t.send
    t.sendTransaction
    t.supportsInterface
    t.symbol
    t.totalSupply
    t.totalSupplyAt
    t.transactionHash
    t.transfer
    t.transferFrom
    t.unfreeze
    t.unpause
    */
}
