// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.19;

import {
    ERC20CappedUpgradeable,
    ERC20Upgradeable
} from "@oz/contracts-upgradeable/token/ERC20/extensions/ERC20CappedUpgradeable.sol";
import {SafeOwnableUpgradeable} from "src/utils/SafeOwnableUpgradeable.sol";
import {UUPSUpgradeable} from "src/oz/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {ERC20PermitUpgradeable} from "src/oz/contracts-upgradeable/token/ERC20/extensions/draft-ERC20PermitUpgradeable.sol";
import {ERC20BurnableUpgradeable} from "src/oz/contracts-upgradeable/token/ERC20/extensions/ERC20BurnableUpgradeable.sol";
import {IRebornToken} from "src/interfaces/IRebornToken.sol";
import {RBTStorage} from "src/RBTStorage.sol";

contract RBT is
    ERC20PermitUpgradeable,
    ERC20CappedUpgradeable,
    SafeOwnableUpgradeable,
    UUPSUpgradeable,
    IRebornToken,
    RBTStorage,
    ERC20BurnableUpgradeable
{
    function initialize(string memory name_, string memory symbol_, uint256 cap_, address owner_) public initializer {
        __ERC20_init_unchained(name_, symbol_);
        __ERC20Capped_init(cap_);
        __ERC20Permit_init(name_);
        __Ownable_init(owner_);
    }

    // directly revert upgrade
    function _authorizeUpgrade(address) internal override onlyOwner {}

    /**
     * @dev allow minter to mint it
     */
    function mint(address to, uint256 amount) external override onlyMinter {
        _mint(to, amount);
    }

    /**
     * @dev update minters
     */
    function updateMinter(address[] calldata toAdd, address[] calldata toRemove) external onlyOwner {
        for (uint256 i = 0; i < toAdd.length; i++) {
            minters[toAdd[i]] = true;
            emit MinterUpdate(toAdd[i], true);
        }
        for (uint256 i = 0; i < toRemove.length; i++) {
            delete minters[toRemove[i]];
            emit MinterUpdate(toRemove[i], false);
        }
    }

    function blockUser(address user, bool status) public onlyOwner {
        blocked[user] = status;

        emit BlockUser(user, status);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override {
        if (blocked[from]) {
            revert TransferBlocked();
        }
    }

    /**
     * @dev See {ERC20-_mint}.
     */
    function _mint(address account, uint256 amount)
        internal
        virtual
        override(ERC20CappedUpgradeable, ERC20Upgradeable)
    {
        require(ERC20Upgradeable.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
        ERC20Upgradeable._mint(account, amount);
    }

    modifier onlyMinter() {
        if (!minters[msg.sender]) {
            revert NotMinter();
        }
        _;
    }
}
