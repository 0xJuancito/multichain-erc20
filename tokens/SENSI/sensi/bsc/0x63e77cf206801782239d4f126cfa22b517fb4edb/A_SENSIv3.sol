// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

/**
 * @dev Interface for the optional metadata functions from the ERC20 standard.
 *
 * _Available since v4.1._
 */
interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}


pragma solidity ^0.8.0;


/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IERC721 is IERC165 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool _approved) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);
}

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)

pragma solidity ^0.8.0;


/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

interface IDEXRouter {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
    function addLiquidity(address tokenA, address tokenB, uint amountADesired, uint amountBDesired, uint amountAMin, uint amountBMin, address to, uint deadline) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
}

interface IERC20Extented is IERC20 {
    function decimals() external view returns (uint8);
}

contract A_SENSIv3 is Context, Ownable, IERC20, IERC20Metadata {
    //erc20 properties
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    uint256 private _totalSupply;
    uint256 private _totalSupplyStart;
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    //dex properties
    IERC20 public lpAddress;

    //tax properties
    IERC721 public taxBuyWaiverNft;
    mapping(address => bool) public taxWhitelist;
    mapping(uint8 => uint16) public taxPercents;
    mapping(uint8 => uint16) public taxDivisors;
    mapping(uint8 => address) public taxAddresses;
    
    //burn proeprties
    uint8 public burnBuyPercent;
    uint8 public burnBuyDivisor;
    uint8 public burnSellPercent;
    uint8 public burnSellDivisor;

    //events
    event TransferSummary(uint8 direction, address taxAddress, uint256 taxAmount, uint256 burnAmount, uint256 remainingAmount, uint256 nftBalance);


    constructor() {
        //testnet
        //_name = "NewTest3";
        //_symbol = "NewTest3";
        //lpAddress = IERC20(0x2AA952C42aBF8CbeB7c6123e8A0A82033E614711);
        //IERC20Extented sensiV2Token = IERC20Extented(0xbf8A4AC7e3f7aE24933C89e7e765DCed1395aE30);
        
        //mainnet
        _name = "Sensi";
        _symbol = "SENSI";
        IERC20Extented sensiV2Token = IERC20Extented(0x7869044D36ea75975B793ca4312608cc3817895B);

        //configure decimals and supply to scale from v2 contract
        uint8 sensiV2Decimals = sensiV2Token.decimals();
        _decimals = sensiV2Decimals;
        uint256 sensiV2TokenSupply = sensiV2Token.totalSupply();
        _totalSupplyStart = (sensiV2TokenSupply / 1000000) + ((250000000 * 5 / 100) * 10 ** _decimals);
        _mint(msg.sender, _totalSupplyStart);

        //whitelist owner
        taxWhitelist[msg.sender] = true;
    }

    function name() public view virtual override returns (string memory) { return _name; }
    function symbol() public view virtual override returns (string memory) { return _symbol; }
    function decimals() public view virtual override returns (uint8) { return _decimals; }
    function totalSupply() public view virtual override returns (uint256) { return _totalSupply; }
    function totalSupplyStart() public view returns (uint256) { return _totalSupplyStart; }
    function balanceOf(address account) public view virtual override returns (uint256) { return _balances[account]; }
    function allowance(address owner, address spender) public view virtual override returns (uint256) { return _allowances[owner][spender]; }
    
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

    function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, allowance(owner, spender) + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        address owner = _msgSender();
        uint256 currentAllowance = allowance(owner, spender);
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(owner, spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    function _transfer(address from, address to, uint256 amount) internal virtual {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");

        uint256 remainingAmount = amount;
        if (taxWhitelist[from] == false && taxWhitelist[to] == false) {
            //calculate trade direction
            uint8 direction = 3;
            if (address(from) == address(lpAddress)) { direction = 1; }
            else if (address(to) == address(lpAddress)) { direction = 2; }

            //calculate taxes
            address taxAddress = taxAddresses[direction];
            uint16 taxPercent = taxPercents[direction];
            uint16 taxDivisor = taxDivisors[direction];
            uint256 taxAmount = (taxAddress == address(0) || taxPercent == 0 || taxDivisor == 0 ? 0 : remainingAmount * taxPercent / taxDivisor);

            //apply nft fee waiver
            uint256 taxBuyWaiverNftBalance = 0;
            if (direction == 1) {
                if (address(taxBuyWaiverNft) != address(0)) { taxBuyWaiverNftBalance = taxBuyWaiverNft.balanceOf(to); }
                if (taxBuyWaiverNftBalance > 0) { taxAmount = 0; }
            }

            //execute taxes
            if (taxAmount > 0 && taxAddress != address(0)) {
                remainingAmount -= taxAmount; 
                _balances[taxAddress] += taxAmount;
                emit Transfer(from, taxAddress, taxAmount);
            }

            //execute burn
            uint256 burnAmount = 0;
            if (direction == 1 && burnBuyPercent > 0 && taxBuyWaiverNftBalance == 0) { burnAmount = remainingAmount * burnBuyPercent / burnBuyDivisor; }
            else if (direction == 2 && burnSellPercent > 0) { burnAmount = remainingAmount * burnSellPercent / burnSellDivisor; }

            if (burnAmount > 0) {
                _totalSupply -= burnAmount;
                remainingAmount -= burnAmount;
                emit Transfer(from, address(0), burnAmount);
            }

            emit TransferSummary(direction, taxAddress, taxAmount, burnAmount, remainingAmount, taxBuyWaiverNftBalance);
        }

        require(remainingAmount > 0, "TRANSFER_TOO_SMALL"); 

        //execute actual token transfer
        unchecked { _balances[from] = fromBalance - amount; }
        _balances[to] += remainingAmount;
        emit Transfer(from, to, remainingAmount);
    }

    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
        }
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }

    function burnTokens(uint256 amount) external {
        _burn(msg.sender, amount);
    }


    //
    //ADMIN FUNCTIONS
    //
    function setTaxWhitelist(address[] calldata addresses, bool[] calldata statuses) external onlyOwner {
        require(addresses.length == statuses.length, "INVALID_INPUT");
        for (uint8 i = 0; i < addresses.length; i++) {
            taxWhitelist[addresses[i]] = statuses[i];
        }
    }

    function setTax(uint8 taxType, uint8 taxAmount, uint8 taxDivisor, address taxAddress) external onlyOwner {
        require(taxType > 0 && taxType <= 3, "INVALID_TAX_TYPE");
        taxPercents[taxType] = taxAmount;
        taxDivisors[taxType] = taxDivisor;
        taxAddresses[taxType] = taxAddress;
    }

    function setTaxNft(address nftAddress) external onlyOwner {
        taxBuyWaiverNft = IERC721(nftAddress);
    }

    function setBurn(uint8 newburnBuyPercent, uint8 newBurnBuyDivisor, uint8 newburnSellPercent, uint8 newBurnSellDivisor) external onlyOwner {
        require(newBurnBuyDivisor > 0 && newBurnSellDivisor > 0, "INVALID_DIVISOR");
        burnBuyPercent = newburnBuyPercent;
        burnBuyDivisor = newBurnBuyDivisor;
        burnSellPercent = newburnSellPercent;
        burnSellDivisor = newBurnSellDivisor;
    }

    function setLpAddress(IERC20 _lpAddress) external onlyOwner {
        lpAddress = _lpAddress;
    }

    function withdrawToken(address destinationAddress, IERC20 token, uint256 amount) external onlyOwner {
        if (address(token) == address(0)) {
            (bool success, ) = destinationAddress.call{value: (amount == 0 ? address(this).balance : amount)}(new bytes(0)); 
            require(success, 'STE');
        } else {
            (bool success, bytes memory data) = address(token).call(abi.encodeWithSelector(IERC20.transfer.selector, destinationAddress, (amount == 0 ? token.balanceOf(address(this)) : amount))); 
            require(success && (data.length == 0 || abi.decode(data, (bool))), 'ST');
        }
    }

    receive() external payable {}
}