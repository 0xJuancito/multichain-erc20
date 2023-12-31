pragma solidity ^0.7.0;
// SPDX-License-Identifier: UNLICENSED






/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
  /**
    * @dev Returns the addition of two unsigned integers, reverting on
    * overflow.
    *
    * Counterpart to Solidity's `+` operator.
    *
    * Requirements:
    *
    * - Addition cannot overflow.
    */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a, "SafeMath: addition overflow");

    return c;
  }

  /**
    * @dev Returns the subtraction of two unsigned integers, reverting on
    * overflow (when the result is negative).
    *
    * Counterpart to Solidity's `-` operator.
    *
    * Requirements:
    *
    * - Subtraction cannot overflow.
    */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    return sub(a, b, "SafeMath: subtraction overflow");
  }

  /**
    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
    * overflow (when the result is negative).
    *
    * Counterpart to Solidity's `-` operator.
    *
    * Requirements:
    *
    * - Subtraction cannot overflow.
    */
  function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    require(b <= a, errorMessage);
    uint256 c = a - b;

    return c;
  }

  /**
    * @dev Returns the multiplication of two unsigned integers, reverting on
    * overflow.
    *
    * Counterpart to Solidity's `*` operator.
    *
    * Requirements:
    *
    * - Multiplication cannot overflow.
    */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
    if (a == 0) {
      return 0;
    }

    uint256 c = a * b;
    require(c / a == b, "SafeMath: multiplication overflow");

    return c;
  }

  /**
    * @dev Returns the integer division of two unsigned integers. Reverts on
    * division by zero. The result is rounded towards zero.
    *
    * Counterpart to Solidity's `/` operator. Note: this function uses a
    * `revert` opcode (which leaves remaining gas untouched) while Solidity
    * uses an invalid opcode to revert (consuming all remaining gas).
    *
    * Requirements:
    *
    * - The divisor cannot be zero.
    */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    return div(a, b, "SafeMath: division by zero");
  }

  /**
    * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
    * division by zero. The result is rounded towards zero.
    *
    * Counterpart to Solidity's `/` operator. Note: this function uses a
    * `revert` opcode (which leaves remaining gas untouched) while Solidity
    * uses an invalid opcode to revert (consuming all remaining gas).
    *
    * Requirements:
    *
    * - The divisor cannot be zero.
    */
  function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    require(b > 0, errorMessage);
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }

  /**
    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
    * Reverts when dividing by zero.
    *
    * Counterpart to Solidity's `%` operator. This function uses a `revert`
    * opcode (which leaves remaining gas untouched) while Solidity uses an
    * invalid opcode to revert (consuming all remaining gas).
    *
    * Requirements:
    *
    * - The divisor cannot be zero.
    */
  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    return mod(a, b, "SafeMath: modulo by zero");
  }

  /**
    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
    * Reverts with custom message when dividing by zero.
    *
    * Counterpart to Solidity's `%` operator. This function uses a `revert`
    * opcode (which leaves remaining gas untouched) while Solidity uses an
    * invalid opcode to revert (consuming all remaining gas).
    *
    * Requirements:
    *
    * - The divisor cannot be zero.
    */
  function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    require(b != 0, errorMessage);
    return a % b;
  }
}


abstract contract EIP712Base {
  struct EIP712Domain {
    string name;
    string version;
    uint256 chainId;
    address verifyingContract;
  }

  bytes32 public constant EIP712_DOMAIN_TYPEHASH = keccak256(
    bytes(
      "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
    )
  );
  bytes32 internal domainSeperator;
  bytes32 internal workerDomainSeperator;

  constructor(
      string memory name,
      string memory version
  ) {
    domainSeperator = encodeDomainSeperator(name, version);
    workerDomainSeperator = encodeWorkerDomainSeperator(name, version);
  }

  function getChainId() public pure returns (uint256) {
    uint256 id;
    assembly {
      id := chainid()
    }
    return id;
  }

  function getDomainSeperator() public view returns (bytes32) {
    return domainSeperator;
  }

  function getWorkerDomainSeperator() public view returns (bytes32) {
    return workerDomainSeperator;
  }

  function encodeDomainSeperator(string memory name, string memory version) public view returns (bytes32) {
    uint chainId = getChainId();
    require(chainId != 0, "chain ID must not be zero");
    return keccak256(
      abi.encode(
        EIP712_DOMAIN_TYPEHASH,
        keccak256(bytes(name)),
        keccak256(bytes(version)),
        chainId,
        address(this)
      )
    );
  }

  // This encodes the domain separator to the root chain, rather than the main chain.
  function encodeWorkerDomainSeperator(string memory name, string memory version) public view returns (bytes32) {
    uint chainId = getChainId();

    // 1 == truffle test; 1 == Ethereum
    // 137 == matic mainnet; 1 == Ethereum
    // 80001 == matic mumbai; 5 == Goerli
    chainId = chainId == 137 || chainId == 1 ? 1 : chainId == 80001 ? 5 : 0;
    require(chainId != 0, "chain ID must not be zero");
    return keccak256(
      abi.encode(
        EIP712_DOMAIN_TYPEHASH,
        keccak256(bytes(name)),
        keccak256(bytes(version)),
        chainId,
        address(this)
      )
    );
  }

  /**
    * Accept message hash and returns hash message in EIP712 compatible form
    * So that it can be used to recover signer from signature signed using EIP712 formatted data
    * https://eips.ethereum.org/EIPS/eip-712
    * "\\x19" makes the encoding deterministic
    * "\\x01" is the version byte to make it compatible to EIP-191
    */
  function toTypedMessageHash(bytes32 messageHash)
    internal
    view
    returns (bytes32)
  {
    return
      keccak256(
        abi.encodePacked("\x19\x01", getDomainSeperator(), messageHash)
      );
  }
}


/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {

  function _msgSender()
    internal
    virtual
    view
    returns (address payable sender)
  {
    if (msg.sender == address(this)) {
      bytes memory array = msg.data;
      uint256 index = msg.data.length;
      assembly {
        // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
        sender := and(
            mload(add(array, index)),
            0xffffffffffffffffffffffffffffffffffffffff
        )
      }
    } else {
      sender = msg.sender;
    }
    return sender;
  }

  function _msgData() internal view virtual returns (bytes memory) {
    this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
    return msg.data;
  }
}



/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface iERC20 {
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
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

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
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}



/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin guidelines: functions revert instead
 * of returning `false` on failure. This behavior is nonetheless conventional
 * and does not conflict with the expectations of ERC20 applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */
abstract contract ERC20 is Context, iERC20 {
  using SafeMath for uint256;
  using Address for address;

  mapping (address => uint256) internal _balances;

  mapping (address => mapping (address => uint256)) private _allowances;

  uint256 private _totalSupply;

  string private _name;
  string private _symbol;
  uint8 private _decimals;

  /**
    * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
    * a default value of 18.
    *
    * To select a different value for {decimals}, use {_setupDecimals}.
    *
    * All three of these values are immutable: they can only be set once during
    * construction.
    */
  constructor (string memory name, string memory symbol) {
    _name = name;
    _symbol = symbol;
    _decimals = 18;
  }

  /**
    * @dev Returns the name of the token.
    */
  function name() public view returns (string memory) {
    return _name;
  }

  /**
    * @dev Returns the symbol of the token, usually a shorter version of the
    * name.
    */
  function symbol() public view returns (string memory) {
    return _symbol;
  }

  /**
    * @dev Returns the number of decimals used to get its user representation.
    * For example, if `decimals` equals `2`, a balance of `505` tokens should
    * be displayed to a user as `5,05` (`505 / 10 ** 2`).
    *
    * Tokens usually opt for a value of 18, imitating the relationship between
    * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
    * called.
    *
    * NOTE: This information is only used for _display_ purposes: it in
    * no way affects any of the arithmetic of the contract, including
    * {IERC20-balanceOf} and {IERC20-transfer}.
    */
  function decimals() public view returns (uint8) {
    return _decimals;
  }

  /**
    * @dev See {IERC20-totalSupply}.
    */
  function totalSupply() public view override returns (uint256) {
    return _totalSupply;
  }

  /**
    * @dev See {IERC20-balanceOf}.
    */
  function balanceOf(address account) public view override returns (uint256) {
    return _balances[account];
  }

  /**
    * @dev See {IERC20-transfer}.
    *
    * Requirements:
    *
    * - `recipient` cannot be the zero address.
    * - the caller must have a balance of at least `amount`.
    */
  function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
    _transfer(_msgSender(), recipient, amount);
    return true;
  }

  /**
    * @dev See {IERC20-allowance}.
    */
  function allowance(address owner, address spender) public view virtual override returns (uint256) {
    return _allowances[owner][spender];
  }

  /**
    * @dev See {IERC20-approve}.
    *
    * Requirements:
    *
    * - `spender` cannot be the zero address.
    */
  function approve(address spender, uint256 amount) public virtual override returns (bool) {
    _approve(_msgSender(), spender, amount);
    return true;
  }

  /**
    * @dev See {IERC20-transferFrom}.
    *
    * Emits an {Approval} event indicating the updated allowance. This is not
    * required by the EIP. See the note at the beginning of {ERC20};
    *
    * Requirements:
    * - `sender` and `recipient` cannot be the zero address.
    * - `sender` must have a balance of at least `amount`.
    * - the caller must have allowance for ``sender``'s tokens of at least
    * `amount`.
    */
  function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
    _transfer(sender, recipient, amount);
    _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
    return true;
  }

  /**
    * @dev Atomically increases the allowance granted to `spender` by the caller.
    *
    * This is an alternative to {approve} that can be used as a mitigation for
    * problems described in {IERC20-approve}.
    *
    * Emits an {Approval} event indicating the updated allowance.
    *
    * Requirements:
    *
    * - `spender` cannot be the zero address.
    */
  function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
    _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
    return true;
  }

  /**
    * @dev Atomically decreases the allowance granted to `spender` by the caller.
    *
    * This is an alternative to {approve} that can be used as a mitigation for
    * problems described in {IERC20-approve}.
    *
    * Emits an {Approval} event indicating the updated allowance.
    *
    * Requirements:
    *
    * - `spender` cannot be the zero address.
    * - `spender` must have allowance for the caller of at least
    * `subtractedValue`.
    */
  function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
    _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
    return true;
  }

  /**
    * @dev Moves tokens `amount` from `sender` to `recipient`.
    *
    * This is internal function is equivalent to {transfer}, and can be used to
    * e.g. implement automatic token fees, slashing mechanisms, etc.
    *
    * Emits a {Transfer} event.
    *
    * Requirements:
    *
    * - `sender` cannot be the zero address.
    * - `recipient` cannot be the zero address.
    * - `sender` must have a balance of at least `amount`.
    */
  function _transfer(address sender, address recipient, uint256 amount) internal virtual {
    require(sender != address(0), "ERC20: transfer from the zero address");
    require(recipient != address(0), "ERC20: transfer to the zero address");

    _beforeTokenTransfer(sender, recipient, amount);

    _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
    _balances[recipient] = _balances[recipient].add(amount);
    emit Transfer(sender, recipient, amount);
  }

  /** @dev Creates `amount` tokens and assigns them to `account`, increasing
    * the total supply.
    *
    * Emits a {Transfer} event with `from` set to the zero address.
    *
    * Requirements
    *
    * - `to` cannot be the zero address.
    */
  function _mint(address account, uint256 amount) internal virtual {
    require(account != address(0), "ERC20: mint to the zero address");

    _beforeTokenTransfer(address(0), account, amount);

    _totalSupply = _totalSupply.add(amount);
    _balances[account] = _balances[account].add(amount);
    emit Transfer(address(0), account, amount);
  }

  /**
    * @dev Destroys `amount` tokens from `account`, reducing the
    * total supply.
    *
    * Emits a {Transfer} event with `to` set to the zero address.
    *
    * Requirements
    *
    * - `account` cannot be the zero address.
    * - `account` must have at least `amount` tokens.
    */
  function _burn(address account, uint256 amount) internal virtual {
    require(account != address(0), "ERC20: burn from the zero address");

    _beforeTokenTransfer(account, address(0), amount);

    _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
    _totalSupply = _totalSupply.sub(amount);
    emit Transfer(account, address(0), amount);
  }

  /**
    * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
    *
    * This internal function is equivalent to `approve`, and can be used to
    * e.g. set automatic allowances for certain subsystems, etc.
    *
    * Emits an {Approval} event.
    *
    * Requirements:
    *
    * - `owner` cannot be the zero address.
    * - `spender` cannot be the zero address.
    */
  function _approve(address owner, address spender, uint256 amount) internal virtual {
    require(owner != address(0), "ERC20: approve from the zero address");
    require(spender != address(0), "ERC20: approve to the zero address");

    _allowances[owner][spender] = amount;
    emit Approval(owner, spender, amount);
  }

  /**
    * @dev Sets {decimals} to a value other than the default one of 18.
    *
    * WARNING: This function should only be called from the constructor. Most
    * applications that interact with token contracts will not expect
    * {decimals} to ever change, and may work incorrectly if it does.
    */
  function _setupDecimals(uint8 decimals_) internal {
    _decimals = decimals_;
  }

  /**
    * @dev Hook that is called before any transfer of tokens. This includes
    * minting and burning.
    *
    * Calling conditions:
    *
    * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
    * will be to transferred to `to`.
    * - when `from` is zero, `amount` tokens will be minted for `to`.
    * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
    * - `from` and `to` are never both zero.
    *
    * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
    */
  function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
}



interface iChildToken {
    function deposit(address user, bytes calldata depositData) external;
}



abstract contract NetworkAgnostic is EIP712Base, Context {
  using SafeMath for uint256;
  bytes32 internal constant META_TRANSACTION_TYPEHASH = keccak256(
    bytes(
      "MetaTransaction(uint256 nonce,address from,bytes functionSignature)"
    )
  );
  event MetaTransactionExecuted(
    address userAddress,
    address payable relayerAddress,
    bytes functionSignature
  );
  mapping(address => uint256) nonces;

  /*
    * Meta transaction structure.
    * No point of including value field here as if user is doing value transfer then he has the funds to pay for gas
    * He should call the desired function directly in that case.
    */
  struct MetaTransaction {
    uint256 nonce;
    address from;
    bytes functionSignature;
  }

  constructor(
    string memory name,
    string memory version
  ) EIP712Base(name, version) {}

  function executeMetaTransaction(
    address userAddress,
    bytes memory functionSignature,
    bytes32 sigR,
    bytes32 sigS,
    uint8 sigV
  ) public payable returns (bytes memory) {
    MetaTransaction memory metaTx = MetaTransaction({
      nonce: nonces[userAddress],
      from: userAddress,
      functionSignature: functionSignature
    });

    require(
      verify(userAddress, metaTx, sigR, sigS, sigV),
      "Signer and signature do not match"
    );

    // increase nonce for user (to avoid re-use)
    nonces[userAddress] = nonces[userAddress].add(1);

    emit MetaTransactionExecuted(
      userAddress,
      msg.sender,
      functionSignature
    );

    // Append userAddress and relayer address at the end to extract it from calling context
    (bool success, bytes memory returnData) = address(this).call(
      abi.encodePacked(functionSignature, userAddress)
    );
    require(success, "Function call not successful");

    return returnData;
  }

  function hashMetaTransaction(MetaTransaction memory metaTx)
    internal
    pure
    returns (bytes32)
  {
    return
      keccak256(
        abi.encode(
          META_TRANSACTION_TYPEHASH,
          metaTx.nonce,
          metaTx.from,
          keccak256(metaTx.functionSignature)
        )
      );
  }

  function getNonce(address user) public view returns (uint256 nonce) {
    nonce = nonces[user];
  }

  function verify(
    address signer,
    MetaTransaction memory metaTx,
    bytes32 sigR,
    bytes32 sigS,
    uint8 sigV
  ) internal view returns (bool) {
    return
      signer != address(0) && signer ==
      ecrecover(
        toTypedMessageHash(hashMetaTransaction(metaTx)),
        sigV,
        sigR,
        sigS
      );
  }
}




// @title iLocalContract
// @dev The interface for the main Token Manager contract
//  Only methods required for calling by sibling contracts are required here
// @author GAME Credits (gamecredits.org)
// (c) 2020 GAME Credits All Rights Reserved. This code is not open source.

abstract contract iLocalContract {

  function updateLocalContract(address contract_, bool isLocal_) virtual external;

  function metaTxSenderIsWorkerOrMinion() internal virtual returns (bool);

  function isLocalContract()
    external
    virtual
    pure
  returns(bool) {
    return true;
  }
}

abstract contract WorkerMetaTransactions is NetworkAgnostic, iLocalContract {
  using SafeMath for uint256;
  bytes32 private constant WORKER_META_TRANSACTION_TYPEHASH = keccak256(
    bytes(
      "WorkerMetaTransaction(bytes32 replayPrevention,address from,bytes functionSignature)"
    )
  );

  // This mapping records all meta-transactions that have been played.
  // It costs more than the nonce method, but this is permissioned, so it's more reliable.
  mapping(address => mapping(bytes32 => bool)) playedTransactions;

  /*
    * Meta transaction structure.
    * No point of including value field here as a user who is doing value transfer has the funds to pay for gas
    *   and should call the desired function directly in that case.
    */
  struct WorkerMetaTransaction {
    bytes32 replayPrevention;
    address from;
    bytes functionSignature;
  }

  function workerExecuteMetaTransaction(
    address userAddress_,
    bytes32 replayPrevention_,
    bytes memory functionSignature_,
    bytes32 sigR_,
    bytes32 sigS_,
    uint8 sigV_
  )
    public
    payable
  returns (bytes memory) {
    require(metaTxSenderIsWorkerOrMinion(), "Worker Meta-Transaction sent by account other than a worker/minion");
    WorkerMetaTransaction memory metaTx = WorkerMetaTransaction({
      replayPrevention: replayPrevention_,
      from: userAddress_,
      functionSignature: functionSignature_
    });

    require(
      workerVerify(userAddress_, metaTx, sigR_, sigS_, sigV_),
      "Signer and signature do not match"
    );

    require(playedTransactions[userAddress_][replayPrevention_] == false, "REPLAY of a previous transaction");
    playedTransactions[userAddress_][replayPrevention_] = true;

    emit MetaTransactionExecuted(
      userAddress_,
      msg.sender,
      functionSignature_
    );

    // Append userAddress and relayer address at the end to extract it from calling context
    (bool success, bytes memory returnData) = address(this).call(
      abi.encodePacked(functionSignature_, userAddress_)
    );
    require(success, "Function call not successful");

    return returnData;
  }

  function hashWorkerMetaTransaction(WorkerMetaTransaction memory metaTx_)
    internal
    pure
  returns (bytes32) {
    return
      keccak256(
        abi.encode(
          WORKER_META_TRANSACTION_TYPEHASH,
          metaTx_.replayPrevention,
          metaTx_.from,
          keccak256(metaTx_.functionSignature)
        )
      );
  }

  function workerVerify(
    address signer_,
    WorkerMetaTransaction memory metaTx_,
    bytes32 sigR_,
    bytes32 sigS_,
    uint8 sigV_
  ) 
    internal
    view
  returns (bool) {
    return
      signer_ != address(0) && signer_ ==
      ecrecover(
        toWorkerTypedMessageHash(hashWorkerMetaTransaction(metaTx_)),
        sigV_,
        sigR_,
        sigS_
      );
  }

  /**
    * Accept message hash and returns hash message in EIP712 compatible form
    * So that it can be used to recover signer from signature signed using EIP712 formatted data
    * https://eips.ethereum.org/EIPS/eip-712
    * "\\x19" makes the encoding deterministic
    * "\\x01" is the version byte to make it compatible to EIP-191
    */
  function toWorkerTypedMessageHash(bytes32 messageHash_)
    internal
    view
    returns (bytes32)
  {
    return
      keccak256(
        abi.encodePacked("\x19\x01", getWorkerDomainSeperator(), messageHash_)
      );
  }
}



abstract contract ChildERC20 is ERC20, iChildToken, WorkerMetaTransactions {

  address public depositor;

  constructor(
    string memory name_,
    string memory symbol_,
    uint8 decimals_,
    address depositor_
  ) ERC20(name_, symbol_) {
    _setupDecimals(decimals_);
    depositor = depositor_;
  }

  modifier onlyDepositor() {
    require(_msgSender() == depositor, "ChildERC20: INSUFFICIENT_PERMISSIONS");
    _;
  }

  function _setDepositor(address _depositor)
    internal
  {
    depositor = _depositor;
  }

  /**
    * @notice called when token is deposited on root chain
    * @dev Should be callable only by ChildChainManager
    * Should handle deposit by minting the required amount for user
    * Make sure minting is done only by this function
    * @param user user address for whom deposit is being done
    * @param depositData abi encoded amount
    */
  function deposit(address user, bytes calldata depositData)
    external
    override
    onlyDepositor
  {
    uint256 amount = abi.decode(depositData, (uint256));
    _mint(user, amount);
  }

  /**
    * @notice called when user wants to withdraw tokens back to root chain
    * @dev Should burn user's tokens. This transaction will be verified when exiting on root chain
    * @param amount amount of tokens to withdraw
    */
  function withdraw(uint256 amount) external {
    _burn(_msgSender(), amount);
  }

  // To recieve ether in contract
  receive() external payable {}
}



// @title iGAME_Game
// @dev The interface for the GAME Credits Game Data contract
//  Only methods required for calling by sibling contracts are required here
// @author GAME Credits (gamecredits.org)
// (c) 2020 GAME Credits All Rights Reserved. This code is not open source.

abstract contract iGAME_Game {
  mapping(uint => mapping(address => bool)) public gameAdmins;
  mapping(uint => mapping(address => bool)) public gameOperators;

  function getCardPrice(uint game_, uint set_, uint card_) virtual external view returns(uint256);
  function getCardLoyaltyPrice(uint game_, uint set_, uint card_) virtual external view returns(uint256);
  function isGameAdmin(uint game_, address admin_) virtual external view returns(bool);
  function linkContracts(address erc721Contract_, address erc20Contract_) virtual external;
  function isOperatorOrMinion(uint game_, address sender_) virtual external returns(bool);
  function isValidCaller(address account_, bool isMinion_, uint game_) virtual external view returns(bool isValid);
  function burnToken(uint tokenId_) virtual external;
  function createTokenFromCard(uint game_, uint set_, uint card_) virtual external returns(uint tokenId, uint tradeLockTime, uint fixedXp);
}



// @title iGAME_Master
// @dev The interface for the Master contract
//  Only methods required for calling by sibling contracts are required here
// @author GAME Credits (gamecredits.org)
// (c) 2020 GAME Credits All Rights Reserved. This code is not open source.

abstract contract iGAME_Master {
  function isOwner(address owner_) virtual external view returns (bool);
  function isCFO(address cfo_) virtual external view returns (bool);
  function isCOO(address coo_) virtual external view returns (bool);
  function isWorker(address account_) virtual external view returns (bool);
  function isWorkerOrMinion(address account_) virtual external view returns (bool);
  function makeFundedCall(address account_) virtual external returns (bool);
  function updateCollectibleSaleStatus(uint game_, uint card_, bool isOnSale_) virtual external;

  function isMaster()
    external
    pure
  returns(bool) {
    return true;
  }
}



// @title iGAME_ERC721
// @dev The interface for the main Token Manager contract
//  Only methods required for calling by sibling contracts are required here
// @author GAME Credits (gamecredits.org)
// (c) 2020 GAME Credits All Rights Reserved. This code is not open source.

abstract contract iGAME_ERC721 {

  function auctionTransfer(address from_, address to_, uint tokenId_) virtual external;

  function inGameOwnerOf(uint tokenId_) virtual external view returns (bytes32 owner_);

  function revokeToken(uint game_, uint tokenId_, bytes32 purchaseId_)
    virtual external returns (bool _isRevoked);

  function transferNewToken(bytes32 recipient_, uint tokenId_, uint tradeLockTime_)
    virtual external;

  function getCryptoAccount(uint game_, bytes32 inGameAccount_)
    virtual public view returns(address cryptoAccount);

  function getValidCryptoAccount(uint game_, bytes32 inGameAccount_)
    virtual public view returns(address cryptoAccount);

  function getInGameAccount(uint game_, address cryptoAccount_)
    virtual public view returns(bytes32 inGameAccount);

  function getValidInGameAccount(uint game_, address cryptoAccount_)
    virtual public view returns(bytes32 inGameAccount);

  function getOrCreateInGameAccount(uint game_, address cryptoAccount_)
    virtual external returns(bytes32 inGameAccount);

  function linkContracts(address gameContract_, address erc20Contract_) virtual external;

  function generateCollectible(uint tokenId_, uint xp_, uint xpPerHour_, uint creationTime_) virtual external;
}



// @title iGAME_ERC20
// @dev The interface for the Auction & ERC-20 contract
//  Only methods required for calling by sibling contracts are required here
// @author GAME Credits (gamecredits.org)
// (c) 2020 GAME Credits All Rights Reserved. This code is not open source.

abstract contract iGAME_ERC20 {

  function cancelAuctionByManager(uint tokenId_) virtual external;

  function transferByContract(address from_, address to_, uint256 value_) virtual external;

  function linkContracts(address gameContract_, address erc721Contract_) virtual external;

  function getGameBalance(uint game_) virtual public view returns(uint balance);

  function getLoyaltyPointsGranted(uint game_, address account_) virtual public view returns(uint currentPoints);

  function getLoyaltyPointSpends(uint game_, address account_) virtual public view returns(uint currentPoints);

  function getLoyaltyPointsTotal(uint game_, address account_) virtual public view returns(uint currentPoints);

  function thirdPartySpendLoyaltyPoints(uint game_, address account_, uint pointsToSpend_) virtual external;
}


// @title ERC20 Sidechain manager imlpementation
// @dev Utility contract that manages Ethereum and ERC-20 tokens transferred in from the main chain
// @dev Can manage any number of tokens
// @author GAME Credits (gamecredits.org)
// (c) 2020 GAME Credits All Rights Reserved. This code is not open source.

abstract contract GAME_ERC20Access is iGAME_ERC20, ChildERC20 {
  using SafeMath for uint256;

  event Balance(address account, uint256 value);

  iGAME_Master public masterContract;
  iGAME_Game public gameContract;
  iGAME_ERC721 public erc721Contract;
  mapping(address => bool) public localContracts;

  // Tracks contracts that are allowed to spend Loyalty Points
  mapping(address => bool) public approvedLoyaltySpenders;

  event ThirdPartyRewwardsSpender(address indexed spenderContract, bool isSpender);

  constructor(address masterContract_)
  {
    masterContract = iGAME_Master(masterContract_);
    localContracts[masterContract_] = true;
  }


  modifier workerOrMinion() {
    require(masterContract.makeFundedCall(_msgSender()), "must be called by a worker or minion");
    _;
  }

  modifier onlyCFO() {
    require(masterContract.isCFO(_msgSender()), "sender must be the cfo");
    _;
  }

  modifier onlyOwner() {
    require(masterContract.isOwner(_msgSender()), "sender must be the owner");
    _;
  }

  modifier onlyGameAdmin(uint game_) {
    require(gameContract.isGameAdmin(game_, _msgSender()), "sender must be a game admin");
    _;
  }

  modifier onlyLocalContract() {
    // Cannot be called using native meta-transactions
    require(localContracts[msg.sender], "must be called by a local contract");
    _;
  }

  function updateLocalContract(address contract_, bool isLocal_)
    external
    override
    onlyLocalContract
  {
    require(contract_ != address(masterContract), "can't reset the master contract");
    require(contract_ != address(erc721Contract), "can't reset the erc721 contract");
    require(contract_ != address(0), "can't be the zero address");
    localContracts[contract_] = isLocal_;
  }

  function linkContracts(address gameContract_, address erc721Contract_)
    external
    override
    onlyLocalContract
  {
    require(address(gameContract) == address(0), "token contract must be blank");
    require(address(erc721Contract) == address(0), "token contract must be blank");
    gameContract = iGAME_Game(gameContract_);
    erc721Contract = iGAME_ERC721(erc721Contract_);

    approvedLoyaltySpenders[gameContract_] = true;
    emit ThirdPartyRewwardsSpender(gameContract_, true);
    approvedLoyaltySpenders[erc721Contract_] = true;
    emit ThirdPartyRewwardsSpender(erc721Contract_, true);
    approvedLoyaltySpenders[address(masterContract)] = true;
    emit ThirdPartyRewwardsSpender(address(masterContract), true);
  }

  function setDepositor(address depositor_)
    external
    onlyOwner
  {
    _setDepositor(depositor_);
  }

  function transferByContract(address from_, address to_, uint256 value_)
    external
    override
    onlyLocalContract
  {
    _transfer(from_, to_, value_);
  }

  function metaTxSenderIsWorkerOrMinion()
    internal
    override
  returns (bool) {
    return masterContract.makeFundedCall(msg.sender);
  }
}

// @author GAME Credits (gamecredits.org)
// (c) 2020 GAME Credits All Rights Reserved. This code is not open source.

abstract contract GAME_ERC20Loyalty is GAME_ERC20Access {
  using SafeMath for uint256;

  // Emitted whenever a user's stake is increased or decreased.
  event LoyaltyPointsChange(
    uint indexed game,
    address indexed account,
    uint indexed week,
    uint currentStake,
    uint totalGranted,
    uint totalSpent
  );
  event LoyaltyPointsGranted(uint indexed game, address indexed account, uint pointsGrant);
  event LoyaltyPointsRemoved(uint indexed game, address indexed account, uint pointsRemoved);
  event LoyaltyPartnerSet(uint indexed game, address indexed account, uint week);

  // GAME stake needed to gain one Loyalty Point, per week (10 ** 18 is 1 GAME)
  uint public gcPerLoyaltyPoint = 10 ** 18;

  uint public constant WEEK_ZERO_START = 1538352000; // 10/1/2018 @ 00:00:00
  uint public constant SECONDS_PER_WEEK = 604800;

  // Granted by the account stake amount; can also be granted
  mapping(uint => mapping (address => uint)) public gameAccountLoyaltyPoints;

  // Tracks the user's spending of Loyalty Points.
  mapping(uint => mapping (address => uint)) public gameAccountPointsSpent;

  // Used to manage updates to gameAccountStaked and gameStake;
  mapping(uint => mapping (address => uint)) public gameAccountStakeWeek;

  // Tracks the user's current stake
  mapping(uint => mapping (address => uint)) public gameAccountStaked;

  mapping(address => uint) public loyaltyPartners;

  // Tracks the current
  mapping(address => uint) public loyaltyWeeks;

  function getCurrentWeek()
    public
    view
  returns(uint) {
    return (block.timestamp - WEEK_ZERO_START) / SECONDS_PER_WEEK;
  }

  function workerGrantLoyaltyPoints(uint game_, address account_, uint pointsGrant_)
    external
    workerOrMinion
  {
    emit LoyaltyPointsGranted(game_, account_, pointsGrant_);
    _addLoyaltyPoints(game_, account_, pointsGrant_);
  }

  function _addLoyaltyPoints(uint game_, address account_, uint pointsGrant_)
    internal
  {
    gameAccountLoyaltyPoints[game_][account_] = gameAccountLoyaltyPoints[game_][account_].add(pointsGrant_);

    uint newBalance = getLoyaltyPointsGranted(game_, account_);

    emit LoyaltyPointsChange(
      game_,
      account_,
      getCurrentWeek(),
      gameAccountStaked[game_][account_],
      newBalance,
      gameAccountPointsSpent[game_][account_]);
  }

  function workerRemoveLoyaltyPoints(uint game_, address account_, uint pointsToRemove_)
    external
    workerOrMinion
  {
    gameAccountLoyaltyPoints[game_][account_] = gameAccountLoyaltyPoints[game_][account_].sub(pointsToRemove_);

    uint newBalance = getLoyaltyPointsGranted(game_, account_);

    emit LoyaltyPointsRemoved(game_, account_, pointsToRemove_);
    emit LoyaltyPointsChange(
      game_,
      account_,
      getCurrentWeek(),
      gameAccountStaked[game_][account_],
      newBalance,
      gameAccountPointsSpent[game_][account_]);
  }

  function approveThirdPartyLoyaltySpender(address contract_, bool isSpender_)
    external
    onlyCFO
  {
    if(isSpender_) {
      require(!approvedLoyaltySpenders[contract_], "Contract is already a spender");
    } else {
      require(approvedLoyaltySpenders[contract_], "Contract isn't an existing spender");
    }
    approvedLoyaltySpenders[contract_] = isSpender_;
    emit ThirdPartyRewwardsSpender(contract_, isSpender_);
  }

  function thirdPartySpendLoyaltyPoints(uint game_, address account_, uint pointsToSpend_)
    external
    override
  {
    // Cannot be called using native meta-transactions
    require(approvedLoyaltySpenders[msg.sender], "must be an approved Loyalty Points spender contract");
    _spendLoyaltyPoints(game_, account_, pointsToSpend_);
  }

  function workerSpendLoyaltyPoints(uint game_, address account_, uint pointsToSpend_)
    external
    workerOrMinion
  {
    _spendLoyaltyPoints(game_, account_, pointsToSpend_);
  }

  function _spendLoyaltyPoints(uint game_, address account_, uint pointsToSpend_)
    internal
  {
    uint currentPoints = getLoyaltyPointsGranted(game_, account_);
    // Ensure balance is sufficient
    uint newSpend = gameAccountPointsSpent[game_][account_].add(pointsToSpend_);
    require(currentPoints >= newSpend, "spent more Loyalty Points than current balance");
    gameAccountPointsSpent[game_][account_] = newSpend;
    emit LoyaltyPointsChange(game_, account_, getCurrentWeek(), gameAccountStaked[game_][account_], currentPoints, newSpend);
  }

  // What happens if we spend during an update; we don't want to update the actual balance, just calculate it.
  function getLoyaltyPointsGranted(uint game_, address account_)
    public
    override
    view
  returns(uint currentPoints)
  {
    uint stakeWeek = gameAccountStakeWeek[game_][account_];
    uint _currentWeek = getCurrentWeek();
    uint currentStake = gameAccountStaked[game_][account_];


    currentPoints = gameAccountLoyaltyPoints[game_][account_]
      .add((_currentWeek.sub(stakeWeek)).mul(currentStake.div(gcPerLoyaltyPoint)));
    // add their outstanding balance LP 

    uint currentPartner = loyaltyPartners[account_]; 
    if(currentPartner == game_ && game_ != 0) {
      uint loyaltyWeek = loyaltyWeeks[account_];
      if(loyaltyWeek < _currentWeek) {
        uint balance = _balances[account_];
        uint pointsToAdd = balance.div(gcPerLoyaltyPoint).mul(_currentWeek.sub(loyaltyWeek));
        currentPoints = currentPoints.add(pointsToAdd);
      }
    }
  }

  function getLoyaltyPointSpends(uint game_, address account_)
    public
    override
    view
  returns(uint totalSpend)
  {
    totalSpend = gameAccountPointsSpent[game_][account_];
  }

  function getLoyaltyPointsTotal(uint game_, address account_)
    public
    override
    view
  returns(uint totalRemaining)
  {
    uint points = getLoyaltyPointsGranted(game_, account_);
    uint spent = getLoyaltyPointSpends(game_, account_);
    if(points <= spent) {
      totalRemaining = 0;
    } else {
      totalRemaining = points.sub(spent);
    }
  }

  // Internal transfer of ERC20 tokens to complete payment of an auction.
  // @param from_ The address which you want to send tokens from
  // @param to_ The address which you want to transfer to
  // @param value_ The amout of tokens to be transferred
  function _beforeTokenTransfer(address from_, address to_, uint256 value_)
    internal
    override
  {
    if(from_ != address(0)) {
      emit Balance(from_, _balances[from_].sub(value_));
      _updateLoyalty(from_);
    }
    if(to_ != address(0)) {
      emit Balance(to_, _balances[to_].add(value_));
      _updateLoyalty(to_);
    }
  }

  function selectLoyaltyPartner(uint partnerId_)
    external
  {
    _setLoyaltyPartner(_msgSender(), partnerId_);
  }

  function workerSelectLoyaltyPartner(address account_, uint partnerId_)
    external
    workerOrMinion
  {
    _setLoyaltyPartner(account_, partnerId_);
  }


  // When a user picks a game,
  // if the user has a game picked and their last update week is last week or before
  // then grant N weeks of LP based on their prior balance
  // and update their last update week to this week
  function _setLoyaltyPartner(address account_, uint partnerId_)
    internal
  {
    _updateLoyalty(account_);
    uint currentPartner = loyaltyPartners[account_];
    loyaltyPartners[account_] = partnerId_;
    uint loyaltyWeek = loyaltyWeeks[account_];
    uint currentWeek = getCurrentWeek();
    if(loyaltyWeek == 0) {
      loyaltyWeeks[account_] = currentWeek;
    }
    if(currentPartner != partnerId_) {
      emit LoyaltyPartnerSet(partnerId_, account_, currentWeek);
    }
  }

  // handle loyalty points here
  // if the user has a game picked and their last update week is last week or before
  // then grant N weeks of LP based on their prior balance
  // and update their last update week to this week
  function _updateLoyalty(address account_)
    internal
  {
    uint currentPartner = loyaltyPartners[account_]; 
    if(currentPartner != 0) {
      uint loyaltyWeek = loyaltyWeeks[account_];
      uint currentWeek = getCurrentWeek();
      if(loyaltyWeek < currentWeek) {
        uint balance = _balances[account_];
        uint pointsToAdd = balance.div(gcPerLoyaltyPoint).mul(currentWeek.sub(loyaltyWeek));
        _addLoyaltyPoints(currentPartner, account_, pointsToAdd);
        loyaltyWeeks[account_] = currentWeek;
      }
    }
  }
}

// @author GAME Credits (gamecredits.org)
// (c) 2020 GAME Credits All Rights Reserved. This code is not open source.

abstract contract GAME_ERC20Staking is GAME_ERC20Loyalty {
  using SafeMath for uint256;

  event OracleTransaction(bytes32 indexed txHash);

  uint[] public gameStakeLevelCaps = [1, 2, 3, 4, 5, 6, 100000000000];

  uint public gameLevelPoints = 50;
  uint public auctionSitePoints = 100;
  uint public totalFeePoints = 400;


  // Tracks the current stake of each game.
  mapping(uint => uint) public gameStaked;
  // Stake
  uint public totalStaked;


  mapping(bytes32 => bool) public updateStakesOracleHashes;

  function setGameLevelPoints(uint points_)
    external
    onlyCFO
  {
    require(points_ <= 100, "must be less than or equal to 1%");
    gameLevelPoints = points_;
    totalFeePoints = auctionSitePoints.add(points_.mul(6));
  }

  function setAuctionSitePoints(uint points_)
    external
    onlyCFO
  {
    require(points_ <= 500, "must be less than or equal to 5%");
    auctionSitePoints = points_;
    totalFeePoints = points_.add(gameLevelPoints.mul(6));
  }

  function setGameStakeLevelCaps(uint[7] calldata caps_)
    external
    onlyCFO
  {
    uint previousData = 0;
    uint cap = 0;
    for(uint i = 0; i < 7; i++) {
      cap = caps_[i];
      require(cap > previousData, "caps must be ascending and non-zero");
      gameStakeLevelCaps[i] = cap;
      previousData = cap;
    }
    require(cap == 100000000000, "highest cap must be 100 billion");
  }

  function getGameStakeLevel(uint game_)
    public
    view
  returns (uint level) {
    uint gameStake = gameStaked[game_];
    for(level = 0; level < 7; level++) {
      if(gameStake < gameStakeLevelCaps[level]) {
        return level;
      }
    }
  }

  function getGameBalance(uint game_)
    public
    override
    view
  returns(uint balance) {
    balance = _balances[game_ == 0 ? address(this) : address(game_)];
  }

  // @dev Internal function to calculate the game, account, and total stakes on a stake change
  // @param week_ - the week we're updating (must be current or past)
  // @param game_ - the game to be staked on
  // @param staker_ - the account doing the staking
  // @param newStake_ - the newly updated stake of the staker on that game
  function oracleUpdateStakes(bytes32 txHash_, uint week_, uint game_, address staker_, uint newStake_)
    external
    workerOrMinion
  {
    if(updateStakesOracleHashes[txHash_]) {
      return;
    }
    updateStakesOracleHashes[txHash_] = true;
    emit OracleTransaction(txHash_);

    uint _currentWeek = getCurrentWeek();
    require(week_ <= _currentWeek, "requested week must be now or in the past");
    require(newStake_ <= 10 ** 29, "account stake underflow - must be <100Bn");

    // Check if the week is (a) less (do nothing), (b) equal (diff the stake), (c) greater (update everything)
    uint stakeWeek = gameAccountStakeWeek[game_][staker_];

    // If this is data for a previous week, ignore it
    // (we could adjust based on complex logic, but ignore is safer)
    require(stakeWeek <= week_, "requested week must be equal or later than stake week");

    uint playerStake = gameAccountStaked[game_][staker_];
    bool isStakeIncrease = newStake_ > playerStake ? true : false;
    uint stakeChange = isStakeIncrease ? newStake_ - playerStake : playerStake - newStake_;
    // update gameAccountStaked to the new stake amount
    // update gameStake based on the diff
    // update totalStake based on the diff
    gameAccountStakeWeek[game_][staker_] = week_;
    gameAccountStaked[game_][staker_] = newStake_;
    gameStaked[game_] = isStakeIncrease
      ? gameStaked[game_] + stakeChange
      : gameStaked[game_] - stakeChange;
    require(gameStaked[game_] <= 10 ** 29, "game stake underflow");
    totalStaked = isStakeIncrease
      ? totalStaked + stakeChange
      : totalStaked - stakeChange;
    require(totalStaked <= 10 ** 29, "total stake underflow");

    uint weeksToPay = (stakeWeek >= _currentWeek || stakeWeek >= week_ || stakeWeek == 0)
      ? 0
      : week_ - stakeWeek;
    uint pointsSpent = gameAccountPointsSpent[game_][staker_];
    // Update the Loyalty Points with the change
    gameAccountLoyaltyPoints[game_][staker_] = gameAccountLoyaltyPoints[game_][staker_].add(weeksToPay.mul(playerStake.div(gcPerLoyaltyPoint)));
    // If the last edit was made more than a week ago, collect Loyalty Points for the intervening weeks.

    // The current points is "what the points would be if you
    uint grantedPoints = getLoyaltyPointsGranted(game_, staker_);

    emit LoyaltyPointsChange(
      game_,
      staker_,
      week_,
      newStake_,
      grantedPoints,
      pointsSpent);
  }
}


// @title Auction Base
// @dev Contains models, variables, and internal methods for the auction.
// @notice We omit a fallback function to prevent accidental sends to this contract.
// @author GAME Credits (gamecredits.org)
// (c) 2020 GAME Credits All Rights Reserved. This code is not open source.

abstract contract AuctionBase is GAME_ERC20Staking {
  using SafeMath for uint256;

  // @dev Map from tokenId to their corresponding auction data.
  // @notice We use two uints here because it's much more efficient than a struct
  mapping (uint => uint) public auctionIdToMetadata;
  mapping (uint => uint) public auctionIdToPrices;

  event AuctionCreated(
    address indexed seller,
    uint indexed tokenId,
    uint startingPrice,
    uint endingPrice,
    uint startTime,
    uint duration
  );

  event AuctionSuccessful(
    address indexed seller,
    address indexed buyer,
    uint indexed tokenId,
    uint totalPrice
  );

  event AuctionCancelled(address indexed seller, uint indexed tokenId);

  // @dev Adds an auction to the list of open auctions. Also fires the
  //  AuctionCreated event.
  // @param tokenId_ The Id of the token to be put on auction.
  // @param startingPrice - the start price of the Auction to add.
  // @param endingPrice - the end price of the Auction to add.
  // @param duration - the length of the Auction in seconds.
  // @param seller - the seller of the token.
  function _addAuction(
    uint tokenId_,
    uint startingPrice_,
    uint endingPrice_,
    uint duration_,
    address seller_
  )
    internal
  {
    require(duration_ == uint(uint48(duration_)), "add auction: duration must be a uint48");
    require(startingPrice_ == uint(uint128(startingPrice_)), "add auction: start price must be a uint128");
    require(endingPrice_ == uint(uint128(endingPrice_)), "add auction: end price must be a uint128");
    require(startingPrice_ > 0, "starting price must be non-zero");
    require(endingPrice_ > 0, "ending price must be non-zero");
    // Require that all auctions have a duration of
    // at least one minute. (Keeps our math from getting hairy!)
    require(duration_ >= 1 minutes, "auctions must be 1 minute long or more");

    uint auctionMetadata = uint(seller_)|duration_<<160|uint(uint48(block.timestamp))<<208;
    uint auctionPrices = endingPrice_|startingPrice_<<128;
    auctionIdToMetadata[tokenId_] = auctionMetadata;
    auctionIdToPrices[tokenId_] = auctionPrices;

    emit AuctionCreated(
      seller_,
      uint(tokenId_),
      uint(startingPrice_),
      uint(endingPrice_),
      uint(block.timestamp),
      uint(duration_)
    );
  }

  // @dev Cancels an auction unconditionally.
  // @param tokenId_ The Id of the token to cancelled.
  // @param seller_ - the seller of the token.
  function _cancelAuction(uint tokenId_, address seller_)
    internal
  {
    _removeAuction(tokenId_);
    erc721Contract.auctionTransfer(address(this), seller_, tokenId_);
    emit AuctionCancelled(seller_, tokenId_);
  }

  // @dev Retrieves the auction details for the requested auction
  // @param tokenId_ The Id of the token to be bid on.
  function _getAuction(uint tokenId_)
    internal
    view
    returns
  (
    address seller,
    uint startingPrice,
    uint endingPrice,
    uint duration,
    uint startedAt
  )
  {
    uint auctionMetadata = auctionIdToMetadata[tokenId_];
    uint auctionPrices = auctionIdToPrices[tokenId_];
    seller = address(auctionMetadata);
    duration = uint(uint48(auctionMetadata>>160));
    startedAt = uint(uint48(auctionMetadata>>208));
    startingPrice = uint(uint128(auctionPrices>>128));
    endingPrice = uint(uint128(auctionPrices));
  }

  // @dev Removes an auction from the list of open auctions.
  // @param tokenId_ - Id of NFT on auction.
  function _removeAuction(uint tokenId_)
    internal
  {
    delete auctionIdToMetadata[tokenId_];
    delete auctionIdToPrices[tokenId_];
  }

  // @dev Returns true if the NFT is on auction.
  // @param startedAt - the start time of the Auction to check.
  function _isOnAuction(uint startedAt_)
    internal
    pure
  returns (bool) {
    return (startedAt_ > 0);
  }

  // @dev Returns current price of an NFT on auction. Broken into two
  //  functions (this one, that computes the duration from the auction
  //  structure, and the other that does the price computation) so we
  //  can easily test that the price computation works correctly.
  function _auctionCurrentPrice(uint startingPrice_, uint endingPrice_, uint duration_, uint startedAt_)
    internal
    view
    returns (uint)
  {
    require(_isOnAuction(startedAt_), "must be on auction");
    uint secondsPassed = 0;

    // A bit of insurance against negative values (or wraparound).
    // Probably not necessary (since Ethereum guarnatees that the
    // now variable doesn't ever go backwards).
    if (block.timestamp > startedAt_) {
      secondsPassed = block.timestamp.sub(startedAt_);
    }

    return _computeAuctionCurrentPrice(
      startingPrice_,
      endingPrice_,
      duration_,
      secondsPassed
    );
  }

  // @dev Computes the current price of an auction. Factored out
  //  from _currentPrice so we can run extensive unit tests.
  //  When testing, make this function public and turn on
  //  `Current price computation` test suite.
  function _computeAuctionCurrentPrice(
    uint startingPrice_,
    uint endingPrice_,
    uint duration_,
    uint secondsPassed_
  )
    internal
    pure
    returns (uint)
  {
    // NOTE: We don't use SafeMath (or similar) in this function because
    //  all of our public functions cap the maximum values for
    //  time (at 48-bits) and currency (at 128-bits). duration_ is
    //  also known to be non-zero (see the require() statement in
    //  _addAuction())
    if (secondsPassed_ >= duration_) {
      // We've reached the end of the dynamic pricing portion
      // of the auction, just return the end price.
      return endingPrice_;
    } else {
      // Starting price can be higher than ending price (and often is!), so
      // this delta can be negative.
      int256 totalPriceChange = int256(endingPrice_) - int256(startingPrice_);

      // This multiplication can't overflow, secondsPassed_ will easily fit within
      // 48-bits, and totalPriceChange will easily fit within 128-bits, their product
      // will always fit within 256-bits.
      int256 currentPriceChange = totalPriceChange * int256(secondsPassed_) / int256(duration_);

      // currentPriceChange can be negative, but if so, will have a magnitude
      // less that startingPrice_. Thus, this result will always end up positive.
      int256 currentPrice = int256(startingPrice_) + currentPriceChange;

      return uint(currentPrice);
    }
  }

  function _payForAuction(uint game_, uint price_, address auctionSite_, address seller_, address buyer_)
    internal
  {
    uint totalFee = price_.mul(totalFeePoints).div(10000);
    uint level = getGameStakeLevel(game_);
    uint auctioneerFee = auctionSite_ == address(0) ? 0 : price_.mul(auctionSitePoints).div(10000);
    uint gameFee = price_.mul(level).mul(gameLevelPoints).div(10000);
    uint systemFee = totalFee.sub(auctioneerFee).sub(gameFee);

    // Transfer payment to the seller, then from the seller to the fee takers.
    _transfer(buyer_, seller_, price_);
    _transfer(seller_, address(this), systemFee);
    _transfer(seller_, game_ == 0 ? address(this) : address(game_), gameFee);
    if(auctioneerFee > 0) {
      _transfer(seller_, auctionSite_, auctioneerFee);
    }
  }
}



// @title ERC-721 Non-Fungible Token Standard
// @dev Interface for contracts conforming to ERC-721: Non-Fungible Tokens
// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
//  Note: the ERC-165 identifier for this interface is 0x80ac58cd

interface iERC721 {

  // @notice Count all NFTs assigned to an owner
  // @dev NFTs assigned to the zero address are considered invalid, and this
  //  function throws for queries about the zero address.
  // @param owner_ An address for whom to query the balance
  // @return The number of NFTs owned by `owner_`, possibly zero
  function balanceOf(address owner_) external view returns (uint);

  // @notice Find the owner of an NFT
  // @param tokenId_ The identifier for an NFT
  // @dev NFTs assigned to zero address are considered invalid, and queries
  //  about them do throw.
  // @return The address of the owner of the NFT
  function ownerOf(uint tokenId_) external view returns (address);

  // @notice Transfers the ownership of an NFT from one address to another address
  // @dev Throws unless `msg.sender` is the current owner, an authorized
  //  operator, or the approved address for this NFT. Throws if `from_` is
  //  not the current owner. Throws if `to_` is the zero address. Throws if
  //  `tokenId_` is not a valid NFT. When transfer is complete, this function
  //  checks if `to_` is a smart contract (code size > 0). If so, it calls
  //  `onERC721Received` on `to_` and throws if the return value is not
  //  `bytes4(keccak256("onERC721Received(address,address,uint,bytes)"))`.
  // @param from_ The current owner of the NFT
  // @param to_ The new owner
  // @param tokenId_ The NFT to transfer
  // @param data Additional data with no specified format, sent in call to `to_`
  function safeTransferFrom(address from_, address to_, uint tokenId_, bytes calldata data_) external;

  // @notice Transfers the ownership of an NFT from one address to another address
  // @dev This works identically to the other function with an extra data parameter,
  //  except this function just sets data to ""
  // @param from_ The current owner of the NFT
  // @param to_ The new owner
  // @param tokenId_ The NFT to transfer
  function safeTransferFrom(address from_, address to_, uint tokenId_) external;

  // @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
  //  TO CONFIRM THAT `to_` IS CAPABLE OF RECEIVING NFTS OR ELSE
  //  THEY MAY BE PERMANENTLY LOST
  // @dev Throws unless `msg.sender` is the current owner, an authorized
  //  operator, or the approved address for this NFT. Throws if `from_` is
  //  not the current owner. Throws if `to_` is the zero address. Throws if
  //  `tokenId_` is not a valid NFT.
  // @param from_ The current owner of the NFT
  // @param to_ The new owner
  // @param tokenId_ The NFT to transfer
  function transferFrom(address from_, address to_, uint tokenId_) external;

  // @notice Set or reaffirm the approved address for an NFT
  // @dev The zero address indicates there is no approved address.
  // @dev Throws unless `msg.sender` is the current NFT owner, or an authorized
  //  operator of the current owner.
  // @param approved_ The new approved NFT controller
  // @param tokenId_ The NFT to approve
  function approve(address approved_, uint tokenId_) external;

  // @notice Enable or disable approval for a third party ("operator") to manage
  //  all your assets.
  // @dev Throws unless `msg.sender` is the current NFT owner.
  // @dev Emits the ApprovalForAll event
  // @param operator_ Address to add to the set of authorized operators.
  // @param approved_ True if the operators is approved, false to revoke approval
  function setApprovalForAll(address operator_, bool approved_) external;

  // @notice Get the approved address for a single NFT
  // @dev Throws if `tokenId_` is not a valid NFT
  // @param tokenId_ The NFT to find the approved address for
  // @return The approved address for this NFT, or the zero address if there is none
  function getApproved(uint tokenId_) external view returns (address);

  // @notice Query if an address is an authorized operator for another address
  // @param owner_ The address that owns the NFTs
  // @param operator_ The address that acts on behalf of the owner
  // @return True if `operator_` is an approved operator for `owner_`, false otherwise
  function isApprovedForAll(address owner_, address operator_) external view returns (bool);
}


// @title AuctionContract
// @dev Clock auction designed for sale of tokens
// @author GAME Credits (gamecredits.org)
// (c) 2020 GAME Credits All Rights Reserved. This code is not open source.

abstract contract AuctionExternal is AuctionBase {

  // @dev Returns auction info for an NFT on auction.
  // @param tokenId_ - Id of NFT on auction.
  function getExistingAuction(uint tokenId_)
    external
    view
    returns
  (
    address seller,
    uint startingPrice,
    uint endingPrice,
    uint duration,
    uint startedAt
  )
  {
    (seller, startingPrice, endingPrice, duration, startedAt) = _getAuction(tokenId_);

    require(_isOnAuction(startedAt), "must be on auction");
  }

  // @dev Returns the current price of an auction.
  // @param tokenId_ - Id of the token price we are checking.
  function getAuctionCurrentPrice(uint tokenId_)
    external
    view
  returns (uint) {
    address seller;
    uint startingPrice;
    uint endingPrice;
    uint duration;
    uint startedAt;
    (seller, startingPrice, endingPrice, duration, startedAt) = _getAuction(tokenId_);
    return _auctionCurrentPrice(startingPrice, endingPrice, duration, startedAt);
  }

  // @dev Put a token up for auction. Does some ownership trickery to create auctions in one tx.
  //   Also fires the AuctionCreated event.
  // @param tokenId_ The Id of the token to be put on auction.
  // @param startingPrice_ - the start price of the Auction to add.
  // @param endingPrice_ - the end price of the Auction to add.
  // @param duration_ - the length of the Auction in seconds.
  function createAuction(
    uint tokenId_,
    uint startingPrice_,
    uint endingPrice_,
    uint duration_
  )
    external
  {
    // Sanity check that no inputs overflow how many bits we've allocated
    // to store them in the auction struct.
    require(startingPrice_ == uint(uint128(startingPrice_)), "starting price under/overflow");
    require(endingPrice_ == uint(uint128(endingPrice_)), "ending price under/overflow");
    require(duration_ == uint(uint48(duration_)), "duration under/overflow");

    // Our auctions are only Dutch or fixed price.
    require(startingPrice_ >= endingPrice_, "starting price must be >= ending price");

    // Auctions can be no more than 7 days, and no less than 10 minutes
    require(duration_ <= 7 days, "duration must be <= 7 days");
    require(duration_ >= 10 minutes, "duration must be >= 10 minutes");

    address sender = _msgSender();
    // This checks "can transfer"
    erc721Contract.auctionTransfer(sender, address(this), tokenId_);
    // Auction throws if inputs are invalid and clears transfer of the token.

    _addAuction(tokenId_, startingPrice_, endingPrice_, duration_, sender);
  }

  // @dev Bids on an open auction, completing the auction and transferring
  //  ownership of the NFT if enough Ether is supplied.
  // @param tokenId_ - Id of token to bid on.
  // @param bidAmount_ - The amount of the bid (for safety, to ensure people don't pay too much)
  // @param auctioneer_ - The account that will receive 1% of the auction proceeds
  //   Usually, an exchange website will put its own address in as auctioneer_, so it can
  //   earn revenue for the public-facing portion of sales.
  function bidOnAuction(uint tokenId_, uint bidAmount_, address auctioneer_)
    external
  {
    address seller;
    uint startingPrice;
    uint endingPrice;
    uint duration;
    uint startedAt;
    (seller, startingPrice, endingPrice, duration, startedAt) = _getAuction(tokenId_);

    // This contract must own the on sale token
    require(iERC721(address(erc721Contract)).ownerOf(tokenId_) == address(this), "contract must own on-sale token");

    // Explicitly check that this auction is currently live.
    require(_isOnAuction(startedAt), "auction must be live");

    // Check that the bid is greater than or equal to the current price
    uint price = _auctionCurrentPrice(startingPrice, endingPrice, duration, startedAt);
    require(bidAmount_ >= price, "bid must be greater than or equal to price");

    // The bid is good! Remove the auction before sending the fees
    // so we can't have a reentrancy attack.
    _removeAuction(tokenId_);

    uint game = uint256(uint64(tokenId_));
    address sender = _msgSender();

    // Transfer the payment from the buyer to the seller, and the fees to the game, system, and auctioneer
    _payForAuction(game, price, auctioneer_, seller, sender);

    // Tell the world!
    emit AuctionSuccessful(seller, sender, tokenId_, price);

    // Reassign ownership (also clears pending approvals and emits Transfer event).
    erc721Contract.auctionTransfer(address(this), sender, tokenId_);
  }

  // @dev Cancels an auction that hasn't been won yet.
  //  Returns the NFT to original owner.
  // @param tokenId_ - Id of token on auction
  function cancelAuction(uint tokenId_)
    external
  {
    uint auctionMetadata = auctionIdToMetadata[tokenId_];
    address seller = address(auctionMetadata);
    uint startedAt = uint(uint48(auctionMetadata>>208));

    require(_isOnAuction(startedAt), "token must be on auction");
    require(_msgSender() == seller, "token seller must be sender");
    _cancelAuction(tokenId_, seller);
  }

  // @dev Cancels an auction.
  //  Only the manager may do this, and NFTs are returned to
  //  the seller. This should only be used in emergencies.
  // @param tokenId_ - Id of the NFT on auction to cancel.
  function cancelAuctionByManager(uint tokenId_)
    external
    override
    onlyLocalContract
  {
    uint auctionMetadata = auctionIdToMetadata[tokenId_];
    address seller = address(auctionMetadata);
    uint startedAt = uint(uint48(auctionMetadata>>208));
    require(_isOnAuction(startedAt), "token must be on auction");
    _cancelAuction(tokenId_, seller);
  }
}


// @title GAME Credits ERC20 contract
// @dev ERC20 management contract, designed to make using ERC-20 tokens easier
// @author GAME Credits (gamecredits.org)
// (c) 2020 GAME Credits All Rights Reserved. This code is not open source.

contract GAME_ERC20 is AuctionExternal {
  using SafeMath for uint256;

  string constant public CONTRACT_ERC712_VERSION = "1";
  string constant public CONTRACT_ERC712_NAME = "GAME Credits Sidechain ERC20 Contract";

  // @dev Constructor creates a reference to the master contract
  //  and the ERC20 depositor contract.
  // @param masterContract_ - address of the master contract
  // @param depositor_ - address of the erc20 depositor contract
  // @param rootChainId_ - ID of the chain the contract is deployed on
  constructor(address masterContract_, address depositor_)
    GAME_ERC20Access(masterContract_)
    ChildERC20("GAME Credits", "GAME", 18, depositor_)
    NetworkAgnostic(CONTRACT_ERC712_NAME, CONTRACT_ERC712_VERSION)
  {
  }

  // @dev Withdraws the whole balance of a game to an admin account.
  // @param uint game_ The game Id of the game for which sender is an admin
  function withdrawGameBalance(uint game_)
    external
    onlyGameAdmin(game_)
  {
    require(game_ > 0, "can't withdraw from the zero address");
    _transfer(address(game_), _msgSender(), _balances[address(game_)]);
  }

  // @dev Withdraws the whole balance of the system to an admin account.
  // @param uint game_ The game Id of the game for which sender is an admin
  function withdrawSystemBalance()
    external
    onlyCFO
  {
    _transfer(address(this), _msgSender(), _balances[address(this)]);
  }
}