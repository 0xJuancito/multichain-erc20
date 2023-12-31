//SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

interface IERC20 {
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
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

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
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

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
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
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
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
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
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
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
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            codehash := extcodehash(account)
        }
        return (codehash != accountHash && codehash != 0x0);
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
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-block.timestamp/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(
            address(this).balance >= amount,
            "Address: insufficient balance"
        );

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{value: amount}("");
        require(
            success,
            "Address: unable to send value, recipient may have reverted"
        );
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
    function functionCall(address target, bytes memory data)
        internal
        returns (bytes memory)
    {
        return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
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
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return
            functionCallWithValue(
                target,
                data,
                value,
                "Address: low-level call with value failed"
            );
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(
            address(this).balance >= value,
            "Address: insufficient balance for call"
        );
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(
        address target,
        bytes memory data,
        uint256 weiValue,
        string memory errorMessage
    ) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{value: weiValue}(
            data
        );
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
contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
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
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

interface IUniswapV2Factory {
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint256
    );

    function feeTo() external view returns (address);

    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB)
        external
        view
        returns (address pair);

    function allPairs(uint256) external view returns (address pair);

    function allPairsLength() external view returns (uint256);

    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);

    function setFeeTo(address) external;

    function setFeeToSetter(address) external;
}

interface IUniswapV2Pair {
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Transfer(address indexed from, address indexed to, uint256 value);

    function name() external pure returns (string memory);

    function symbol() external pure returns (string memory);

    function decimals() external pure returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint256);

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    event Mint(address indexed sender, uint256 amount0, uint256 amount1);
    event Burn(
        address indexed sender,
        uint256 amount0,
        uint256 amount1,
        address indexed to
    );
    event Swap(
        address indexed sender,
        uint256 amount0In,
        uint256 amount1In,
        uint256 amount0Out,
        uint256 amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint256);

    function factory() external view returns (address);

    function token0() external view returns (address);

    function token1() external view returns (address);

    function getReserves()
        external
        view
        returns (
            uint112 reserve0,
            uint112 reserve1,
            uint32 blockTimestampLast
        );

    function price0CumulativeLast() external view returns (uint256);

    function price1CumulativeLast() external view returns (uint256);

    function kLast() external view returns (uint256);

    function mint(address to) external returns (uint256 liquidity);

    function burn(address to)
        external
        returns (uint256 amount0, uint256 amount1);

    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata data
    ) external;

    function skim(address to) external;

    function sync() external;

    function initialize(address, address) external;
}

interface IUniswapV2Router01 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETH(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountToken, uint256 amountETH);

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETHWithPermit(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountToken, uint256 amountETH);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external pure returns (uint256 amountB);

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountOut);

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountIn);

    function getAmountsOut(uint256 amountIn, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);

    function getAmountsIn(uint256 amountOut, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}

/**
  
    BEP20 standard token with custom features:

    - Reflection Rewards - 3% tokens distributed to token holders;
    - Lock liquidity - guard against rug-pool attacks;
    - NFT holders reward keeper - The other 3% will be redistributed to Mavatrix NFT owners;
    - Lock Stages - There are 4 different lock stages that'll inhibit `_transfer()` and `_approve()` functions;

*/
contract MvvToken is Context, IERC20, Ownable {
    using SafeMath for uint256;
    using Address for address;

    mapping(address => uint256) private _rOwned;
    mapping(address => uint256) private _tOwned;
    mapping(address => mapping(address => uint256)) private _allowances;

    mapping(address => bool) private _isExcludedFromFee;

    mapping(address => bool) public unlock_01; // can't send tokens before due date
    mapping(address => bool) public unlock_02;
    mapping(address => bool) public unlock_03;
    mapping(address => bool) public unlock_04;
    mapping(address => bool) public unlock_05;
    mapping(address => bool) public unlock_06;
    mapping(address => bool) public unlock_07;
    mapping(address => bool) public unlock_08;
    mapping(address => bool) public unlock_09;
    mapping(address => bool) public unlock_10;
    mapping(address => bool) public unlock_11;
    mapping(address => bool) public unlock_12;

    mapping(address => bool) private _isExcluded;
    address[] private _excluded;

    uint256 private constant MAX = ~uint256(0);
    uint256 private constant _tTotal = 7000000 * 10**6 * 10**8; // Total supply 7.000.000.000.000
    uint256 private _rTotal = (MAX - (MAX % _tTotal));
    uint256 private _tFeeTotal;

    string private constant _name = "Mavaverse";
    string private constant _symbol = "MVX";
    uint8 private constant _decimals = 8;

    uint256 public _taxFee = 3;
    uint256 private _previousTaxFee = _taxFee;

    uint256 public _keeperFee = 3;
    uint256 private _previousKeeperFee = _keeperFee;

    uint256 private constant MAX_TAX_FEE = 3;
    uint256 private constant MAX_KEEPER_FEE = 3;

    IUniswapV2Router02 public immutable uniswapV2Router;
    address public immutable uniswapV2Pair;

    address public rewardKeeper;

    bool public _finalized;

    uint256 public _maxTxAmount = 7000 * 10**6 * 10**8; // 0.1% total supply

    uint256 public constant UNLOCK01 = 1661990400; // Thu Sep 01 2022 00:00:00 GMT+0000
    uint256 public constant UNLOCK02 = 1667264400; // Tue Nov 01 2022 01:00:00 GMT+0000

    uint256 public constant UNLOCK03 = 1672534800; // Sun Jan 01 2023 01:00:00 GMT+0000
    uint256 public constant UNLOCK04 = 1677632400; // Wed Mar 01 2023 01:00:00 GMT+0000
    uint256 public constant UNLOCK05 = 1682899200; // Mon May 01 2023 00:00:00 GMT+0000
    uint256 public constant UNLOCK06 = 1688169600; // Sat Jul 01 2023 00:00:00 GMT+0000
    uint256 public constant UNLOCK07 = 1693526400; // Fri Sep 01 2023 00:00:00 GMT+0000
    uint256 public constant UNLOCK08 = 1698800400; // Wed Nov 01 2023 01:00:00 GMT+0000

    uint256 public constant UNLOCK09 = 1704070800; // Mon Jan 01 2024 01:00:00 GMT+0000
    uint256 public constant UNLOCK10 = 1709254800; // Fri Mar 01 2024 01:00:00 GMT+0000
    uint256 public constant UNLOCK11 = 1714521600; // Wed May 01 2024 00:00:00 GMT+0000
    uint256 public constant UNLOCK12 = 1719792000; // Mon Jul 01 2024 00:00:00 GMT+0000

    event LockAddressFinalized();
    event KeeperUpdated(address newKeeper);
    event ExcludedFromReward(address indexed owner);
    event IncludedInReward(address owner);
    event ExcludedFromFee(address owner);
    event IncludedInFee(address owner);
    event ExcludedLockStage(address owner);
    event IncludedLockStage(address[] owners);

    modifier inhibitFunctionality(address holder) {
        require(
            canTransfer(holder),
            "Transfer and Approve are locked for this address"
        );
        _;
    }

    modifier notFinalized() {
        require(
            !_finalized,
            "The lock is finalized, you can't call this function"
        );
        _;
    }

    constructor(address keeper) {
        _rOwned[_msgSender()] = _rTotal;

        // PancakeSwap RouterV2
        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
            0x10ED43C718714eb63d5aA57B78B54704E256024E
        );
        // Create a uniswap pair for this new token
        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
            .createPair(address(this), _uniswapV2Router.WETH());

        // set the rest of the contract variables
        uniswapV2Router = _uniswapV2Router;

        // set initial rewardKeeper
        rewardKeeper = keeper;
        _finalized = false;

        //exclude owner, keeper and this contract from fee
        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[address(this)] = true;
        _isExcludedFromFee[keeper] = true;

        excludeFromReward(rewardKeeper); // exclude keeper from reward

        emit Transfer(address(0), _msgSender(), _tTotal);
    }

    /**
     * @dev Check timing and spend allowance for locked accounts
     */
    function canTransfer(address _holder) public view returns (bool) {
        if (unlock_01[_holder] && block.timestamp < UNLOCK01)
            revert(
                "You aren't allowed to call this function until UNLOCK01 stage"
            );
        else if (unlock_02[_holder] && block.timestamp < UNLOCK02)
            revert(
                "You aren't allowed to call this function until UNLOCK02 stage"
            );
        else if (unlock_03[_holder] && block.timestamp < UNLOCK03)
            revert(
                "You aren't allowed to call this function until UNLOCK03 stage"
            );
        else if (unlock_04[_holder] && block.timestamp < UNLOCK04)
            revert(
                "You aren't allowed to call this function until UNLOCK04 stage"
            );
        else if (unlock_05[_holder] && block.timestamp < UNLOCK05)
            revert(
                "You aren't allowed to call this function until UNLOCK05 stage"
            );
        else if (unlock_06[_holder] && block.timestamp < UNLOCK06)
            revert(
                "You aren't allowed to call this function until UNLOCK06 stage"
            );
        else if (unlock_07[_holder] && block.timestamp < UNLOCK07)
            revert(
                "You aren't allowed to call this function until UNLOCK07 stage"
            );
        else if (unlock_08[_holder] && block.timestamp < UNLOCK08)
            revert(
                "You aren't allowed to call this function until UNLOCK08 stage"
            );
        else if (unlock_09[_holder] && block.timestamp < UNLOCK09)
            revert(
                "You aren't allowed to call this function until UNLOCK09 stage"
            );
        else if (unlock_10[_holder] && block.timestamp < UNLOCK10)
            revert(
                "You aren't allowed to call this function until UNLOCK10 stage"
            );
        else if (unlock_11[_holder] && block.timestamp < UNLOCK11)
            revert(
                "You aren't allowed to call this function until UNLOCK11 stage"
            );
        else if (unlock_12[_holder] && block.timestamp < UNLOCK12)
            revert(
                "You aren't allowed to call this function until UNLOCK12 stage"
            );
        return true;
    }

    function name() public pure returns (string memory) {
        return _name;
    }

    function symbol() public pure returns (string memory) {
        return _symbol;
    }

    function decimals() public pure returns (uint8) {
        return _decimals;
    }

    function totalSupply() public pure override returns (uint256) {
        return _tTotal;
    }

    function currentKeeper() public view returns (address) {
        return rewardKeeper;
    }

    /**
     * @dev Update reward keeper address, onlyOwner rules applied.
     */
    function updateKeeper(address newKeeper) public onlyOwner returns (bool) {
        require(newKeeper != address(0), "Not a valid address inserted");
        rewardKeeper = newKeeper;
        _isExcludedFromFee[rewardKeeper] = true; // No reward/fees for keeper contract
        excludeFromReward(rewardKeeper);
        emit KeeperUpdated(newKeeper);
        return true;
    }

    /**
     * @return true when finalized, false otherwise.
     */
    function finalized() public view returns (bool) {
        return _finalized;
    }

    function balanceOf(address account) public view override returns (uint256) {
        if (_isExcluded[account]) return _tOwned[account];
        return tokenFromReflection(_rOwned[account]);
    }

    function transfer(address recipient, uint256 amount)
        public
        override
        returns (bool)
    {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender)
        public
        view
        override
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount)
        public
        override
        returns (bool)
    {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            _msgSender(),
            _allowances[sender][_msgSender()].sub(
                amount,
                "ERC20: transfer amount exceeds allowance"
            )
        );
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue)
        public
        virtual
        returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].add(addedValue)
        );
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        virtual
        returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].sub(
                subtractedValue,
                "ERC20: decreased allowance below zero"
            )
        );
        return true;
    }

    function isExcludedFromReward(address account) public view returns (bool) {
        return _isExcluded[account];
    }

    function totalFees() public view returns (uint256) {
        return _tFeeTotal;
    }

    function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
        public
        view
        returns (uint256)
    {
        require(tAmount <= _tTotal, "Amount must be less than supply");
        if (!deductTransferFee) {
            (uint256 rAmount, , , , , ) = _getValues(tAmount);
            return rAmount;
        } else {
            (, uint256 rTransferAmount, , , , ) = _getValues(tAmount);
            return rTransferAmount;
        }
    }

    function tokenFromReflection(uint256 rAmount)
        public
        view
        returns (uint256)
    {
        require(
            rAmount <= _rTotal,
            "Amount must be less than total reflections"
        );
        uint256 currentRate = _getRate();
        return rAmount.div(currentRate);
    }

    function excludeFromReward(address account) public onlyOwner {
        require(!_isExcluded[account], "Account is already excluded");
        if (_rOwned[account] > 0) {
            _tOwned[account] = tokenFromReflection(_rOwned[account]);
        }
        _isExcluded[account] = true;
        emit ExcludedFromReward(account);
        _excluded.push(account);
    }

    function includeInReward(address account) external onlyOwner {
        require(_isExcluded[account], "Account is not excluded");
        for (uint256 i = 0; i < _excluded.length; i++) {
            if (_excluded[i] == account) {
                _excluded[i] = _excluded[_excluded.length - 1];
                uint256 currentRate = _getRate();
                _rOwned[account] = _tOwned[account].mul(currentRate);
                _tOwned[account] = 0;
                _isExcluded[account] = false;
                emit IncludedInReward(account);
                _excluded.pop();
                break;
            }
        }
    }

    function _transferBothExcluded(
        address sender,
        address recipient,
        uint256 tAmount
    ) private {
        (
            uint256 rAmount,
            uint256 rTransferAmount,
            uint256 rFee,
            uint256 tTransferAmount,
            uint256 tFee,
            uint256 tLiquidity
        ) = _getValues(tAmount);
        _tOwned[sender] = _tOwned[sender].sub(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
        _takeRewardNFT(tLiquidity);
        _reflectFee(rFee, tFee);
        emit Transfer(sender, recipient, tTransferAmount);
    }

    function excludeFromFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = true;
        emit ExcludedFromFee(account);
    }

    function includeInFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = false;
        emit IncludedInFee(account);
    }

    /**
     * @dev Include an address to locked list.
     * Can only be called by the current operator. There are currently 12 lock stages
     */
    function include01Unlock(address[] memory _accounts)
        public
        notFinalized
        onlyOwner
    {
        require(
            _accounts.length <= 5,
            "Lock Management: max lock amount per tx exceeded"
        );
        for (uint256 i = 0; i < _accounts.length; i++) {
            unlock_01[_accounts[i]] = true;
        }
        emit IncludedLockStage(_accounts);
    }   

    function exclude01Unlock(address _account) public notFinalized onlyOwner {
        require(
            unlock_01[_account],
            "Account is already excluded from lock timing!"
        );
        unlock_01[_account] = false;
        emit ExcludedLockStage(_account);
    }

    function include02Unlock(address[] memory _accounts)
        public
        notFinalized
        onlyOwner
    {
        require(
            _accounts.length <= 5,
            "Lock Management: max lock amount per tx exceeded"
        );
        for (uint256 i = 0; i < _accounts.length; i++) {
            unlock_02[_accounts[i]] = true;
        }
                emit IncludedLockStage(_accounts);

    }

    function exclude02Unlock(address _account) public notFinalized onlyOwner {
        require(
            unlock_02[_account],
            "Account is already excluded from lock timing!"
        );
        unlock_02[_account] = false;
         emit ExcludedLockStage(_account);
    }

    function include03Unlock(address[] memory _accounts)
        public
        notFinalized
        onlyOwner
    {
        require(
            _accounts.length <= 5,
            "Lock Management: max lock amount per tx exceeded"
        );
        for (uint256 i = 0; i < _accounts.length; i++) {
            unlock_03[_accounts[i]] = true;
        }
                emit IncludedLockStage(_accounts);
                

    }

    function exclude03Unlock(address _account) public notFinalized onlyOwner {
        require(
            unlock_03[_account],
            "Account is already excluded from lock timing!"
        );
        unlock_03[_account] = false;
         emit ExcludedLockStage(_account);
    }

    function include04Unlock(address[] memory _accounts)
        public
        notFinalized
        onlyOwner
    {
        require(
            _accounts.length <= 5,
            "Lock Management: max lock amount per tx exceeded"
        );
        for (uint256 i = 0; i < _accounts.length; i++) {
            unlock_04[_accounts[i]] = true;
        }
                emit IncludedLockStage(_accounts);

    }

    function exclude04Unlock(address _account) public notFinalized onlyOwner {
        require(
            unlock_04[_account],
            "Account is already excluded from lock timing!"
        );
        unlock_04[_account] = false;
         emit ExcludedLockStage(_account);
    }

    function include05Unlock(address[] memory _accounts)
        public
        notFinalized
        onlyOwner
    {
        require(
            _accounts.length <= 5,
            "Lock Management: max lock amount per tx exceeded"
        );
        for (uint256 i = 0; i < _accounts.length; i++) {
            unlock_05[_accounts[i]] = true;
        }
                emit IncludedLockStage(_accounts);

    }

    function exclude05Unlock(address _account) public notFinalized onlyOwner {
        require(
            unlock_05[_account],
            "Account is already excluded from lock timing!"
        );
        unlock_05[_account] = false;
         emit ExcludedLockStage(_account);
    }

    function include06Unlock(address[] memory _accounts)
        public
        notFinalized
        onlyOwner
    {
        require(
            _accounts.length <= 5,
            "Lock Management: max lock amount per tx exceeded"
        );
        for (uint256 i = 0; i < _accounts.length; i++) {
            unlock_06[_accounts[i]] = true;
        }
                emit IncludedLockStage(_accounts);

    }

    function exclude06Unlock(address _account) public notFinalized onlyOwner {
        require(
            unlock_06[_account],
            "Account is already excluded from lock timing!"
        );
        unlock_06[_account] = false;
         emit ExcludedLockStage(_account);
    }

    function include07Unlock(address[] memory _accounts)
        public
        notFinalized
        onlyOwner
    {
        require(
            _accounts.length <= 5,
            "Lock Management: max lock amount per tx exceeded"
        );
        for (uint256 i = 0; i < _accounts.length; i++) {
            unlock_07[_accounts[i]] = true;
        }
                emit IncludedLockStage(_accounts);

    }

    function exclude07Unlock(address _account) public notFinalized onlyOwner {
        require(
            unlock_07[_account],
            "Account is already excluded from lock timing!"
        );
        unlock_07[_account] = false;
         emit ExcludedLockStage(_account);
    }

    function include08Unlock(address[] memory _accounts)
        public
        notFinalized
        onlyOwner
    {
        require(
            _accounts.length <= 5,
            "Lock Management: max lock amount per tx exceeded"
        );
        for (uint256 i = 0; i < _accounts.length; i++) {
            unlock_08[_accounts[i]] = true;
        }
                emit IncludedLockStage(_accounts);

    }

    function exclude08Unlock(address _account) public notFinalized onlyOwner {
        require(
            unlock_08[_account],
            "Account is already excluded from lock timing!"
        );
        unlock_08[_account] = false;
         emit ExcludedLockStage(_account);
    }

    function include09Unlock(address[] memory _accounts)
        public
        notFinalized
        onlyOwner
    {
        require(
            _accounts.length <= 5,
            "Lock Management: max lock amount per tx exceeded"
        );
        for (uint256 i = 0; i < _accounts.length; i++) {
            unlock_09[_accounts[i]] = true;
        }
                emit IncludedLockStage(_accounts);

    }

    function exclude09Unlock(address _account) public notFinalized onlyOwner {
        require(
            unlock_09[_account],
            "Account is already excluded from lock timing!"
        );
        unlock_09[_account] = false;
         emit ExcludedLockStage(_account);
    }

    function include10Unlock(address[] memory _accounts)
        public
        notFinalized
        onlyOwner
    {
        require(
            _accounts.length <= 5,
            "Lock Management: max lock amount per tx exceeded"
        );
        for (uint256 i = 0; i < _accounts.length; i++) {
            unlock_10[_accounts[i]] = true;
        }
                emit IncludedLockStage(_accounts);

    }

    function exclude10Unlock(address _account) public notFinalized onlyOwner {
        require(
            unlock_10[_account],
            "Account is already excluded from lock timing!"
        );
        unlock_10[_account] = false;
         emit ExcludedLockStage(_account);
    }

    function include11Unlock(address[] memory _accounts)
        public
        notFinalized
        onlyOwner
    {
        require(
            _accounts.length <= 5,
            "Lock Management: max lock amount per tx exceeded"
        );
        for (uint256 i = 0; i < _accounts.length; i++) {
            unlock_11[_accounts[i]] = true;
        }
                emit IncludedLockStage(_accounts);

    }

    function exclude11Unlock(address _account) public notFinalized onlyOwner {
        require(
            unlock_11[_account],
            "Account is already excluded from lock timing!"
        );
        unlock_11[_account] = false;
         emit ExcludedLockStage(_account);
    }

    function include12Unlock(address[] memory _accounts)
        public
        notFinalized
        onlyOwner
    {
        require(
            _accounts.length <= 5,
            "Lock Management: max lock amount per tx exceeded"
        );
        for (uint256 i = 0; i < _accounts.length; i++) {
            unlock_12[_accounts[i]] = true;
        }
                emit IncludedLockStage(_accounts);

    }

    function exclude12Unlock(address _account) public notFinalized onlyOwner {
        require(
            unlock_12[_account],
            "Account is already excluded from lock timing!"
        );
        unlock_12[_account] = false;
         emit ExcludedLockStage(_account);
    }

    /**
     * @dev Must be called before public sale starts and after including locked addresses.
     * Then will be impossible to call lock functions
     * {includeFirstStageUnlock(), includeSecondStageUnlock(), includeThirdStageUnlock(), includeFourthStageUnlock()}
     */
    function finalizeLock() public onlyOwner {
        require(!_finalized, "Contract already locked!");
        _finalized = true;
        emit LockAddressFinalized();
    }

    function setTaxFeePercent(uint256 taxFee) external onlyOwner {
        require(
            taxFee <= MAX_TAX_FEE,
            "Tax fee exceeds the maximum accepted value!"
        );
        _taxFee = taxFee;
    }

    function setKeeperFeePercent(uint256 keeperFee) external onlyOwner {
        require(
            keeperFee <= MAX_KEEPER_FEE,
            "Keeper fee exceeds the maximum accepted value!"
        );
        _keeperFee = keeperFee;
    }

    function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner {
        require(
            maxTxPercent > 0,
            "Can't set max transaction amount multiplier to zero!"
        );
        _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
    }

    receive() external payable {}

    function _reflectFee(uint256 rFee, uint256 tFee) private {
        _rTotal = _rTotal.sub(rFee);
        _tFeeTotal = _tFeeTotal.add(tFee);
    }

    function _getValues(uint256 tAmount)
        private
        view
        returns (
            uint256,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256
        )
    {
        (
            uint256 tTransferAmount,
            uint256 tFee,
            uint256 tLiquidity
        ) = _getTValues(tAmount);
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
            tAmount,
            tFee,
            tLiquidity,
            _getRate()
        );
        return (
            rAmount,
            rTransferAmount,
            rFee,
            tTransferAmount,
            tFee,
            tLiquidity
        );
    }

    function _getTValues(uint256 tAmount)
        private
        view
        returns (
            uint256,
            uint256,
            uint256
        )
    {
        uint256 tFee = calculateTaxFee(tAmount);
        uint256 tLiquidity = calculateLiquidityFee(tAmount);
        uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
        return (tTransferAmount, tFee, tLiquidity);
    }

    function _getRValues(
        uint256 tAmount,
        uint256 tFee,
        uint256 tLiquidity,
        uint256 currentRate
    )
        private
        pure
        returns (
            uint256,
            uint256,
            uint256
        )
    {
        uint256 rAmount = tAmount.mul(currentRate);
        uint256 rFee = tFee.mul(currentRate);
        uint256 rLiquidity = tLiquidity.mul(currentRate);
        uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
        return (rAmount, rTransferAmount, rFee);
    }

    function _getRate() private view returns (uint256) {
        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
        return rSupply.div(tSupply);
    }

    function _getCurrentSupply() private view returns (uint256, uint256) {
        uint256 rSupply = _rTotal;
        uint256 tSupply = _tTotal;
        for (uint256 i = 0; i < _excluded.length; i++) {
            if (
                _rOwned[_excluded[i]] > rSupply ||
                _tOwned[_excluded[i]] > tSupply
            ) return (_rTotal, _tTotal);
            rSupply = rSupply.sub(_rOwned[_excluded[i]]);
            tSupply = tSupply.sub(_tOwned[_excluded[i]]);
        }
        if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
        return (rSupply, tSupply);
    }

    /**
     * @dev take liquidity and forward it to the keeper account
     */
    function _takeRewardNFT(uint256 tLiquidity) private {
        uint256 currentRate = _getRate();
        uint256 rLiquidity = tLiquidity.mul(currentRate);
        _rOwned[rewardKeeper] = _rOwned[rewardKeeper].add(rLiquidity);
        if (_isExcluded[rewardKeeper])
            _tOwned[rewardKeeper] = _tOwned[rewardKeeper].add(tLiquidity);
    }

    function calculateTaxFee(uint256 _amount) private view returns (uint256) {
        return _amount.mul(_taxFee).div(10**2);
    }

    function calculateLiquidityFee(uint256 _amount)
        private
        view
        returns (uint256)
    {
        return _amount.mul(_keeperFee).div(10**2);
    }

    function removeAllFee() private {
        if (_taxFee == 0 && _keeperFee == 0) return;

        _previousTaxFee = _taxFee;
        _previousKeeperFee = _keeperFee;

        _taxFee = 0;
        _keeperFee = 0;
    }

    function restoreAllFee() private {
        _taxFee = _previousTaxFee;
        _keeperFee = _previousKeeperFee;
    }

    function isExcludedFromFee(address account) public view returns (bool) {
        return _isExcludedFromFee[account];
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) private inhibitFunctionality(owner) {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private inhibitFunctionality(from) {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");
        if (from != owner() && to != owner())
            require(
                amount <= _maxTxAmount,
                "Transfer amount exceeds the maxTxAmount."
            );

        //indicates when fee should be deducted from transfer
        bool takeFee = true;

        //if any account belongs to _isExcludedFromFee account then remove the fee
        if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
            takeFee = false;
        }

        //transfer amount, it will take tax, burn, liquidity fee
        _tokenTransfer(from, to, amount, takeFee);
    }

    /**
     * @dev Takes fee, if takeFee is true
     */
    function _tokenTransfer(
        address sender,
        address recipient,
        uint256 amount,
        bool takeFee
    ) private {
        if (!takeFee) removeAllFee();

        if (_isExcluded[sender] && !_isExcluded[recipient]) {
            _transferFromExcluded(sender, recipient, amount);
        } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
            _transferToExcluded(sender, recipient, amount);
        } else if (_isExcluded[sender] && _isExcluded[recipient]) {
            _transferBothExcluded(sender, recipient, amount);
        } else {
            _transferStandard(sender, recipient, amount);
        }

        if (!takeFee) restoreAllFee();
    }

    function _transferStandard(
        address sender,
        address recipient,
        uint256 tAmount
    ) private {
        (
            uint256 rAmount,
            uint256 rTransferAmount,
            uint256 rFee,
            uint256 tTransferAmount,
            uint256 tFee,
            uint256 tLiquidity
        ) = _getValues(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
        _takeRewardNFT(tLiquidity);
        _reflectFee(rFee, tFee);
        emit Transfer(sender, recipient, tTransferAmount);
    }

    function _transferToExcluded(
        address sender,
        address recipient,
        uint256 tAmount
    ) private {
        (
            uint256 rAmount,
            uint256 rTransferAmount,
            uint256 rFee,
            uint256 tTransferAmount,
            uint256 tFee,
            uint256 tLiquidity
        ) = _getValues(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
        _takeRewardNFT(tLiquidity);
        _reflectFee(rFee, tFee);
        emit Transfer(sender, recipient, tTransferAmount);
    }

    function _transferFromExcluded(
        address sender,
        address recipient,
        uint256 tAmount
    ) private {
        (
            uint256 rAmount,
            uint256 rTransferAmount,
            uint256 rFee,
            uint256 tTransferAmount,
            uint256 tFee,
            uint256 tLiquidity
        ) = _getValues(tAmount);
        _tOwned[sender] = _tOwned[sender].sub(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
        _takeRewardNFT(tLiquidity);
        _reflectFee(rFee, tFee);
        emit Transfer(sender, recipient, tTransferAmount);
    }
}