// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity 0.8.4;

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
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

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
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
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

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

/// @notice DRF Token
contract DRF is Context, IERC20, IERC20Metadata {
    // --- ERC20 Data ---
    string private constant _name = "Derify Protocol Token";
    string private constant _symbol = "DRF";
    string private constant _version = "1.0";
    uint8  private constant _decimals = 18;
    uint256 private constant _totalSupply = 100000000e18;  // 100 million DRF

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    constructor(
        address founderTeamAccount, 
        address peInvestorsAccount, 
        address publicSaleAccount, 
        address strategicReserveAccount, 
        address communityFundAccount
    ) {
        _balances[founderTeamAccount] += _totalSupply * 15 / 100;
        emit Transfer(address(0), founderTeamAccount, _totalSupply * 15 / 100);

        _balances[peInvestorsAccount] += _totalSupply * 15 / 100;
        emit Transfer(address(0), peInvestorsAccount, _totalSupply * 15 / 100);

        _balances[publicSaleAccount] += _totalSupply * 5 / 100;
        emit Transfer(address(0), publicSaleAccount, _totalSupply * 5 / 100);

        _balances[strategicReserveAccount] += _totalSupply * 5 / 100;
        emit Transfer(address(0), strategicReserveAccount, _totalSupply * 5 / 100);

        _balances[communityFundAccount] += _totalSupply * 60 / 100;
        emit Transfer(address(0), communityFundAccount, _totalSupply * 60 / 100);
    }

    /// @notice Returns the name of the token
    function name() external view virtual override returns (string memory) {
        return _name;
    }

    /// @notice Returns the symbol of the token
    function symbol() external view virtual override returns (string memory) {
        return _symbol;
    }

    /// @notice Returns the number of decimals used to get its user representation
    function decimals() external view virtual override returns (uint8) {
        return _decimals;
    }

    /// @notice Returns the version of the token
    function version() external view virtual returns (string memory) {
        return _version;
    }

    /// @notice Returns the totalSupply of the token
    function totalSupply() external view virtual override returns (uint256) {
        return _totalSupply;
    }

    /// @notice Returns the amount of tokens owned by `account`
    function balanceOf(address account) external view virtual override returns (uint256) {
        return _balances[account];
    }

    /// @notice Returns the remaining number of tokens that `spender` will be allowed to spend on behalf of `owner`
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /// @notice Sets `amount` as the allowance of `spender` over the caller's tokens
    function approve(address spender, uint256 amount) external virtual override returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, amount);
        return true;
    }

    /// @notice Increases the allowance granted to `spender` by the caller
    function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, allowance(owner, spender) + addedValue);
        return true;
    }

    /// @notice Decreases the allowance granted to `spender` by the caller
    function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
        address owner = _msgSender();
        uint256 currentAllowance = allowance(owner, spender);
        require(currentAllowance >= subtractedValue, "DRF::decreaseAllowance: decreased allowance below zero");
        unchecked {
            _approve(owner, spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    /// @notice Moves `amount` tokens from the caller's account to `to`
    function transfer(address to, uint256 amount) external virtual override returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }

    /// @notice Moves `amount` tokens from `from` to `to` using the allowance mechanism
    function transferFrom(
        address from, 
        address to, 
        uint256 amount
    ) external virtual override returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "DRF::_approve: approve from the zero address");
        require(spender != address(0), "DRF::_approve: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {
        require(from != address(0), "DRF::_transfer: transfer from the zero address");
        require(to != address(0), "DRF::_transfer: transfer to the zero address");

        _beforeTokenTransfer(from, to, amount);

        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "DRF::_transfer: transfer amount exceeds balance");
        unchecked {
            _balances[from] = fromBalance - amount;
        }
        _balances[to] += amount;

        emit Transfer(from, to, amount);

        _afterTokenTransfer(from, to, amount);
    }

    function _spendAllowance(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "DRF::_spendAllowance: insufficient allowance");
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
}