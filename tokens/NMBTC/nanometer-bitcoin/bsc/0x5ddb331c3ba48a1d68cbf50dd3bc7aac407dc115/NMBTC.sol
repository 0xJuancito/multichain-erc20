/**
 *NMBTC
*/

/**

   #BEE

   #LIQ+#RFI+#SHIB+#DOGE = #BEE

   #SAFEMOON features:
   3% fee auto add to the liquidity pool to locked forever when selling
   2% fee auto distribute to all holders
   I created a black hole so #Bee token will deflate itself in supply with every transaction
   50% Supply is burned at start.


 */

pragma solidity ^0.6.12;
// SPDX-License-Identifier: Unlicensed
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

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
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
        assembly { codehash := extcodehash(account) }
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
    address private _previousOwner;
    uint256 private _lockTime;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
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
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }

    function geUnlockTime() public view returns (uint256) {
        return _lockTime;
    }

    //Locks the contract for owner for the amount of time provided
    function lock(uint256 time) public virtual onlyOwner {
        _previousOwner = _owner;
        _owner = address(0);
        _lockTime = now + time;
        emit OwnershipTransferred(_owner, address(0));
    }

    //Unlocks the contract for owner when _lockTime is exceeds
    function unlock() public virtual {
        require(_previousOwner == msg.sender, "You don't have permission to unlock");
        require(now > _lockTime , "Contract is locked until 7 days");
        emit OwnershipTransferred(_owner, _previousOwner);
        _owner = _previousOwner;
    }
}

// pragma solidity >=0.5.0;

interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}


// pragma solidity >=0.5.0;

interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}

// pragma solidity >=0.6.2;

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
    external
    payable
    returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
    external
    returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
    external
    returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
    external
    payable
    returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

// pragma solidity >=0.6.2;

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

contract ForwardAccount {
	constructor (address spender, address token) public {
		IERC20(token).approve(spender, uint256(-1));			
	}	
}

contract NMBTC is Context, IERC20, Ownable {
    using SafeMath for uint256;
    using Address for address;

    mapping (address => uint256) private _rOwned;
    mapping (address => uint256) private _tOwned;
    mapping (address => mapping (address => uint256)) private _allowances;

    mapping (address => bool) private _isExcludedFromFee;

    mapping (address => bool) private _isExcluded;
    address[] private _excluded;

    uint256 private constant MAX = ~uint256(0);
    uint256 private _tTotal = 42000000 * 10**6 * 10**9;
    uint256 private _rTotal = (MAX - (MAX % _tTotal));
    uint256 private _tFeeTotal;

    string private _name = "NMBTC Token";
    string private _symbol = "NMBTC";
    uint8 private _decimals = 9;

    uint256 public _taxFee = 5;
    uint256 private _previousTaxFee = _taxFee;

    uint256 public _taxFeeContract = 12;
    uint256 public _liquidityFeeContract = 6;
    
    uint256 public _liquidityFee = 6;
    uint256 private _previousLiquidityFee = _liquidityFee;

    uint256 public weeklyRewardRate = 8;
    uint256 public burnRate = 16;
    uint256 public playerRewardRate = 40;
	uint256 public fomoRate = 20;
	
	bool public weeklyRewardEnabled = true;	
    uint256 public lastWeeklyRewardTime;
    uint256 public prevWeeklyRewardTime;
    uint256 public rewardInterval = 7 days;
    //uint256 public rewardInterval = 30 minutes;    
    uint256 public maxRewardNum = 32;
    address public weeklyRewardWallet = 0x9999999999999999999999999999999999999999;
    address public burnWallet = 0x6666666666666666666666666666666666666666;
	address public USDT = 0x55d398326f99059fF775485246999027B3197955;
	address public router = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
	address public forwardAccount;

    IUniswapV2Router02 public immutable uniswapV2Router;
    address public uniswapV2Pair;

    address public fomoAdmin = 0x8888888888888888888888888888888888888888;
    address public _lastBuyAddress;
    uint256 public _lastBuyTime;  
    uint256 public openTimeFoMo;  
    uint256 public fomoInterval = 14400;	//4h
    uint256 public _minFoMoBalance = 10000000 * 10**9; 
    
    address[] public fomoAddress;
    
    bool inSwapAndLiquify;
    bool public swapAndLiquifyEnabled = true;
    bool public pauseTransfer = false;
    bool public pauseContractTransfer = false;

    uint256 public _maxTxAmount = 420000 * 10**6 * 10**9;			//1% max
    uint256 public numTokensSellToAddToLiquidity = 210000 * 10**6 * 10**9;		//0.5%
    uint256 public minReferAmount = 1000000 * 10**9;
    
    address [] public topPlayers;
    mapping (address => address) private _plyr;
    mapping (address => Player) private _plyrInfo;
    struct Player {
        address addr;
        uint256 count;
        uint256 amount;
    }
    mapping (address => uint256) public topPlayersAmounts;
    uint256 public topPlayerTip;
    mapping (address => bool) public _isExcludedTopPlayer;
    
    struct PlayerBalance {
    	uint256 totalAmountOut;
    	uint256 totalAmountIn;
    	uint256 lastUpdateTime;
    }
    mapping (address=>PlayerBalance) private _plyrBalance;
    
    uint256 public playerHoldingRatio = 10;
    uint256 public maxPlayerLevel = 1;
    uint256[] public playerRewardRatio = [1000];

    event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
    event SwapAndLiquifyEnabledUpdated(bool enabled);
    event SwapAndLiquify(
        uint256 tokensSwapped,
        uint256 ethReceived,
        uint256 tokensIntoLiqudity
    );
	event WeeklyReward(uint256 amount, uint256 count);

    modifier lockTheSwap {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }

    constructor () public {
        _rOwned[_msgSender()] = _rTotal;

        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);

        // set the rest of the contract variables
        uniswapV2Router = _uniswapV2Router;

        //exclude owner and this contract from fee
        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[address(this)] = true;
        _isExcludedFromFee[burnWallet] = true;

		_isExcludedTopPlayer[owner()] = true;
		_isExcludedTopPlayer[address(this)] = true;
		_isExcludedTopPlayer[weeklyRewardWallet] = true;
		_isExcludedTopPlayer[burnWallet] = true;
		
        lastWeeklyRewardTime = now + rewardInterval;
      	prevWeeklyRewardTime = now;
      	
      	openTimeFoMo = now + fomoInterval;
      	_lastBuyAddress = _msgSender();
      	
        emit Transfer(address(0), _msgSender(), _tTotal);
    }

    function setFomoAdmin(address _fomoAdmin) public onlyOwner {
        fomoAdmin = _fomoAdmin;
    }

	function setfomoInterval(uint256 _interval) public onlyOwner {
	    fomoInterval = _interval;
	}

	function setMinFoMoBalance(uint256 _minAmount) public onlyOwner {
	    _minFoMoBalance = _minAmount;
	}

	function getFomoAddress() public view returns (address[] memory) {
	    return fomoAddress;
	}

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _tTotal;
    }

    function balanceOf(address account) public view override returns (uint256) {
        if (_isExcluded[account]) return _tOwned[account];
        return tokenFromReflection(_rOwned[account]);
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    function getTopPlayers() view public returns(address[] memory, uint256[] memory){
        uint256[] memory amounts = new uint256[](topPlayers.length);
        for(uint256 i = 0; i < topPlayers.length; i++){
           amounts[i] = topPlayersAmounts[topPlayers[i]];
        }
        return (topPlayers, amounts);        
    }
    
    function getTipTopPlayer() view public returns(address, uint256) {
    	if(topPlayers.length ==0){
    		return (address(0), 0);
    	}
    	address addr = topPlayers[topPlayerTip];
    	uint256 amount = tokenFromReflection(topPlayersAmounts[addr]);
    	
    	return (addr, amount);
    }
    
    function getPlayerAddr(address addr) view public returns(address) {
    	return _plyr[addr];
    }
    
    function getPlayerInfo(address addr) view public returns(uint256, uint256) {
    	if (_plyrInfo[addr].addr == address(0)){
    		return (0, 0);
    	}
    	return (_plyrInfo[addr].count, _plyrInfo[addr].amount);
    }
    
    function isExcludedFromReward(address account) public view returns (bool) {
        return _isExcluded[account];
    }

    function totalFees() public view returns (uint256) {
        return _tFeeTotal;
    }

    function deliver(uint256 tAmount) public {
        address sender = _msgSender();
        require(!_isExcluded[sender], "Excluded addresses cannot call this function");
        (uint256 rAmount,,,,,) = _getValues(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rTotal = _rTotal.sub(rAmount);
        _tFeeTotal = _tFeeTotal.add(tAmount);
    }

    function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
        require(tAmount <= _tTotal, "Amount must be less than supply");
        if (!deductTransferFee) {
            (uint256 rAmount,,,,,) = _getValues(tAmount);
            return rAmount;
        } else {
            (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
            return rTransferAmount;
        }
    }

    function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
        require(rAmount <= _rTotal, "Amount must be less than total reflections");
        uint256 currentRate =  _getRate();
        return rAmount.div(currentRate);
    }

    function excludeFromReward(address account) public onlyOwner() {
        // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
        require(!_isExcluded[account], "Account is already excluded");
        if(_rOwned[account] > 0) {
            _tOwned[account] = tokenFromReflection(_rOwned[account]);
        }
        _isExcluded[account] = true;
        _excluded.push(account);
    }

    function includeInReward(address account) external onlyOwner() {
        require(_isExcluded[account], "Account is already excluded");
        for (uint256 i = 0; i < _excluded.length; i++) {
            if (_excluded[i] == account) {
                _excluded[i] = _excluded[_excluded.length - 1];
                _tOwned[account] = 0;
                _isExcluded[account] = false;
                _excluded.pop();
                break;
            }
        }
    }
    function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
        _tOwned[sender] = _tOwned[sender].sub(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
        _takeLiquidity(tLiquidity);
        _reflectFee(recipient, rFee, tFee);
        emit Transfer(sender, recipient, tTransferAmount);
    }

    function excludeFromFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = true;
    }

    function includeInFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = false;
    }

	function setPauseTransfer(bool paused) public onlyOwner {
		pauseTransfer = paused;
	}

	function setPauseContractTransfer(bool paused) public onlyOwner {
        pauseContractTransfer = paused;
	}
	
	function setMaxRewardNum(uint256 num) public onlyOwner {
		maxRewardNum = num;
	}

	function setRewardInterval(uint256 _interval) public onlyOwner {
		rewardInterval = _interval;
	}	
	
	function setMaxPlayerLevel(uint256 maxLevel) public onlyOwner {
		maxPlayerLevel = maxLevel;
	}
	
    function setPlayerRewardRatio(uint256[] calldata ratio) external onlyOwner() {
		require(maxPlayerLevel == ratio.length, "Length mismatch");
		
		uint256 total;
		for (uint256 i = 0; i < ratio.length; i++){
			require(ratio[i] > 0, "Ratio zero");
			total += ratio[i];
		}
    	require(total == 1000, "Invalid ratio");
    	playerRewardRatio = ratio;
    	if (playerRewardRatio.length < maxPlayerLevel){
    		maxPlayerLevel = playerRewardRatio.length;
    	}
    }
		
    function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
        _taxFee = taxFee;
    }

    function setContractFeePercent(uint256 fee) external onlyOwner() {
        _taxFeeContract = fee;
    }

    function setWeeklyRewardPercent(uint256 rate) external onlyOwner() {
        require(rate <= 100,"rate overflow");
        weeklyRewardRate = rate;
    }

    function setWeeklyRewardEnabled(bool _enabled) external onlyOwner() {
        weeklyRewardEnabled = _enabled;
    }
 
    function setBurnPercent(uint256 rate) external onlyOwner() {
        require(rate <= 100,"rate overflow");
        burnRate = rate;
    }

    function setPlayerRewardPercent(uint256 rate) external onlyOwner() {
        require(rate <= 100,"rate overflow");
        playerRewardRate = rate;
    }

    function setFomoPercent(uint256 rate) external onlyOwner() {
        require(rate <= 100,"rate overflow");
        fomoRate = rate;
    }
    
    function createPair() external onlyOwner() {
        // Create a uniswap pair for this new token
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory())
        .createPair(address(this), USDT);
        
        forwardAccount = address(new ForwardAccount(address(this), USDT));
    }

    function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
        _liquidityFee = liquidityFee;
    }

    function setLiquidityFeeContractPercent(uint256 liquidityFeeConract) external onlyOwner() {
        _liquidityFeeContract = liquidityFeeConract;
    }

	function setplayerHoldingRatio(uint256 ratio) external onlyOwner(){
		playerHoldingRatio = ratio;
	}

	function setMinReferAmount(uint256 amount) external onlyOwner(){
		minReferAmount = amount;
	}
				
    function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
        _maxTxAmount = _tTotal.mul(maxTxPercent).div(
            10**2
        );
    }

    function setNumTokensSellToAddToLiquidity(uint256 num) external onlyOwner {
        numTokensSellToAddToLiquidity = num;
    }

    function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
        swapAndLiquifyEnabled = _enabled;
        emit SwapAndLiquifyEnabledUpdated(_enabled);
    }
    
    //to recieve ETH from uniswapV2Router when swaping
    receive() external payable {}

    function _checkPlayerBalanceLimit(address addr) view private returns(bool) {
        if (balanceOf(addr) < _tTotal.div(1000000).mul(playerHoldingRatio)){
            return false;
        }
        return true;
    }

    function _playerRewardHandle(address addr, uint256 rPlayer, uint256 tPlayer, uint256 rRemaining, uint256 tRemaining, uint256 level) private returns(uint256, uint256){
        require(level < playerRewardRatio.length, "Out of player level");
        uint256 rReward = rPlayer.mul(playerRewardRatio[level]).div(1000);
        uint256 tReward = tPlayer.mul(playerRewardRatio[level]).div(1000);
				
		if (rReward > rRemaining){		//Never happan
			rReward = rRemaining;
		}
		rRemaining = rRemaining.sub(rReward);	
		
		if (tReward > tRemaining){
			tReward = tRemaining;
		}
		tRemaining = tRemaining.sub(tReward);
								
        _rOwned[addr] = _rOwned[addr].add(rReward);

		emit Transfer(_msgSender(), addr, tReward);
				
        return (rRemaining, tRemaining);
    }

    function _playerReward(address recipient, uint256 rPlayer, uint256 tPlayer) private returns(uint256, uint256){   
        if (_plyr[recipient] == address(0) || rPlayer == 0){
            return (rPlayer, tPlayer);
        }

		//remaming
        uint256 rReward = rPlayer;
        uint256 tReward = tPlayer;

		address addr = _plyr[recipient];
        for (uint i = 0; i < maxPlayerLevel; i++){
            if (_checkPlayerBalanceLimit(addr) == false){
                continue;
            }
            (rReward, tReward) = _playerRewardHandle(addr, rPlayer, tPlayer, rReward, tReward, i);

            if (tReward == 0 || _plyr[addr] == address(0)){
                break;
            }
            addr = _plyr[addr];
        }
        return (rReward, tReward);
    }

    function _reflectFee(address recipient, uint256 rFee, uint256 tFee) private {
    	if(tFee == 0){
    		return;
    	}
    	
        uint rReward = rFee.div(100).mul(weeklyRewardRate);
        uint tReward = tFee.div(100).mul(weeklyRewardRate);

        uint rBurn = rFee.div(100).mul(burnRate);
        uint tBurn = tFee.div(100).mul(burnRate);
        
        uint rFomo = rFee.div(100).mul(fomoRate);
        uint tFomo = tFee.div(100).mul(fomoRate);
                
        uint rPlayer = rFee.div(100).mul(playerRewardRate);
        uint tPlayer = tFee.div(100).mul(playerRewardRate);
        (uint rRemaining, ) = _playerReward(recipient, rPlayer, tPlayer);

        //rBurn = rBurn.add(rRemaining);
        //tBurn = tBurn.add(tRemaining);

        _rOwned[weeklyRewardWallet] = _rOwned[weeklyRewardWallet].add(rReward);
        _rOwned[fomoAdmin] = _rOwned[fomoAdmin].add(rFomo);
        _rOwned[burnWallet] = _rOwned[burnWallet].add(rBurn).add(rRemaining);
		
		uint rAmount = rReward.add(rBurn).add(rPlayer);
		uint tAmount = tReward.add(tBurn).add(tPlayer);
		
		rAmount.add(rFomo);
		tAmount.add(tFomo);
			
        _rTotal = _rTotal.sub(rFee.sub(rAmount));
        _tFeeTotal = _tFeeTotal.add(tFee.sub(tAmount));
        
        emit Transfer(_msgSender(), fomoAdmin, tFomo);
        emit Transfer(_msgSender(), burnWallet, tBurn);    
    }

    function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
        (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
        return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
    }

    function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
        uint256 tFee = calculateTaxFee(tAmount);
        uint256 tLiquidity = calculateLiquidityFee(tAmount);
        uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
        return (tTransferAmount, tFee, tLiquidity);
    }

    function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
        uint256 rAmount = tAmount.mul(currentRate);
        uint256 rFee = tFee.mul(currentRate);
        uint256 rLiquidity = tLiquidity.mul(currentRate);
        uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
        return (rAmount, rTransferAmount, rFee);
    }

    function _getRate() private view returns(uint256) {
        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
        return rSupply.div(tSupply);
    }

    function _getCurrentSupply() private view returns(uint256, uint256) {
        uint256 rSupply = _rTotal;
        uint256 tSupply = _tTotal;
        for (uint256 i = 0; i < _excluded.length; i++) {
            if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
            rSupply = rSupply.sub(_rOwned[_excluded[i]]);
            tSupply = tSupply.sub(_tOwned[_excluded[i]]);
        }
        if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
        return (rSupply, tSupply);
    }

    function _takeLiquidity(uint256 tLiquidity) private {
        uint256 currentRate =  _getRate();
        uint256 rLiquidity = tLiquidity.mul(currentRate);
        _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
        if(_isExcluded[address(this)])
            _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
    }

    function calculateTaxFee(uint256 _amount) private view returns (uint256) {
        return _amount.mul(_taxFee).div(
            10**2
        );
    }

    function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
        return _amount.mul(_liquidityFee).div(
            10**2
        );
    }

    function removeAllFee() private {
        if(_taxFee == 0 && _liquidityFee == 0) return;

        _previousTaxFee = _taxFee;
        _previousLiquidityFee = _liquidityFee;

        _taxFee = 0;
        _liquidityFee = 0;
    }

    function restoreAllFee() private {
        _taxFee = _previousTaxFee;
        _liquidityFee = _previousLiquidityFee;
    }

    function isExcludedFromFee(address account) public view returns(bool) {
        return _isExcludedFromFee[account];
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");
        if(from != owner() && to != owner()){
                if (_isContractTransaction(from, to) == true) {
        		require(pauseContractTransfer == false, "ContractTransfer pause");
                }else{
        		require(pauseTransfer == false, "Transfer pause");
                }
                require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
            }

        // is the token balance of this contract address over the min number of
        // tokens that we need to initiate a swap + liquidity lock?
        // also, don't get caught in a circular liquidity event.
        // also, don't swap & liquify if sender is uniswap pair.
        uint256 contractTokenBalance = balanceOf(address(this));

        if(contractTokenBalance >= _maxTxAmount)
        {
            contractTokenBalance = _maxTxAmount;
        }

        bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
        if (
            overMinTokenBalance &&
            !inSwapAndLiquify &&
            from != uniswapV2Pair &&
            swapAndLiquifyEnabled
        ) {
            contractTokenBalance = numTokensSellToAddToLiquidity;
            //add liquidity
            swapAndLiquify(contractTokenBalance);
        }

        //indicates if fee should be deducted from transfer
        bool takeFee = true;

        //if any account belongs to _isExcludedFromFee account then remove the fee
        if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
            takeFee = false;
        }

        //transfer amount, it will take tax, burn, liquidity fee
        _tokenTransfer(from,to,amount,takeFee);
        
		if (from == uniswapV2Pair && to != router && from != router) {
			_awardsFoMo(amount,to);
		}
                    
        // reward top players
        _rewardTopPlayers(from,to);
    }

	function _awardsFoMo(uint256 amount,address _user) private {
		if (amount >= _minFoMoBalance ){
			if (block.timestamp > openTimeFoMo){
				fomoAddress.push(_lastBuyAddress);
				_tokenTransfer(fomoAdmin, _lastBuyAddress, balanceOf(fomoAdmin), false);
			}
			_lastBuyAddress = _user;
			_lastBuyTime = now;
			openTimeFoMo = block.timestamp + fomoInterval; 			
		}
	}

    function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
        // split the contract balance into halves
        uint256 half = contractTokenBalance.div(2);
        uint256 otherHalf = contractTokenBalance.sub(half);

        // capture the contract's current USDT balance.
        // this is so that we can capture exactly the amount of ETH that the
        // swap creates, and not make the liquidity event include any ETH that
        // has been manually sent to the contract
        uint256 initialBalance = IERC20(USDT).balanceOf(address(this));

        // swap tokens for USDT
        swapTokensForUsdt(half); // <- this breaks the USDT -> SOLT swap when swap+liquify is triggered

        // how much USDT did we just swap into?
        uint256 newBalance = IERC20(USDT).balanceOf(address(this)).sub(initialBalance);
				
        // add liquidity to uniswap
        addLiquidity(otherHalf, newBalance);

        emit SwapAndLiquify(half, newBalance, otherHalf);
    }

    function swapTokensForUsdt(uint256 tokenAmount) private {
        // generate the uniswap pair path of token -> weth
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = USDT;

        _approve(address(this), address(uniswapV2Router), tokenAmount);

        // make the swap
        uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // accept any amount of USDT
            path,
            forwardAccount,
            block.timestamp
        );
        
        uint256 usdtAmount = IERC20(USDT).balanceOf(forwardAccount);
		IERC20(USDT).transferFrom(forwardAccount, address(this), usdtAmount);
    }

    function addLiquidity(uint256 tokenAmount, uint256 usdtAmount) private {
        // approve token transfer to cover all possible scenarios
        _approve(address(this), address(uniswapV2Router), tokenAmount);
		IERC20(USDT).approve(address(uniswapV2Router), usdtAmount);
		
        // add the liquidity
        uniswapV2Router.addLiquidity(
            address(this),
            USDT,
            tokenAmount,
            usdtAmount,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            owner(),
            block.timestamp
        );
    }

    function _bindRefer(address sender, address recipient, uint256 amount) private {
    	// check amount
        if (amount < minReferAmount){
            return;
        }
        if (_plyr[recipient] != address(0) || _plyrInfo[recipient].count > 0){
            return;
        }
        if(_checkPlayerBalanceLimit(sender) == false){
        	return;
        }
        
        //bind
        _plyr[recipient] = sender;
        
        if (_plyrInfo[sender].addr == address(0)){
        	_plyrInfo[sender].addr = sender;            	
        }
        _plyrInfo[sender].count++;
    }
	
	function _isContractTransaction(address sender, address recipient) view private returns(bool){
	    if(recipient.isContract() || sender.isContract()){
	        return true;
	    }
	    return false;
	}	
	
    //this method is responsible for taking all fee, if takeFee is true
    function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
        if(!takeFee){
            removeAllFee();
        }else if(_isContractTransaction(sender, recipient) == true){
            _previousTaxFee = _taxFee;
            _previousLiquidityFee = _liquidityFee;
            _taxFee = _taxFeeContract;
            _liquidityFee = _liquidityFeeContract;
        }

        if (_isContractTransaction(sender, recipient) == false){
            _bindRefer(sender, recipient, amount);
        }

        if (_isExcluded[sender] && !_isExcluded[recipient]) {
            _transferFromExcluded(sender, recipient, amount);
        } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
            _transferToExcluded(sender, recipient, amount);
        } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
            _transferStandard(sender, recipient, amount);
        } else if (_isExcluded[sender] && _isExcluded[recipient]) {
            _transferBothExcluded(sender, recipient, amount);
        } else {
            _transferStandard(sender, recipient, amount);
        }

        if(!takeFee){
            restoreAllFee();
        }else if(_isContractTransaction(sender, recipient) == true){
            _taxFee = _previousTaxFee;
            _liquidityFee = _previousLiquidityFee;
        }
    }

    function _transferStandard(address sender, address recipient, uint256 tAmount) private {
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);  
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
        _takeLiquidity(tLiquidity);
        _reflectFee(recipient, rFee, tFee);
        _updateTopPlayers(sender,recipient,rAmount,rTransferAmount);
        emit Transfer(sender, recipient, tTransferAmount);
    }

    function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
        _takeLiquidity(tLiquidity);
        _reflectFee(recipient, rFee, tFee);
        _updateTopPlayers(sender,recipient,rAmount,rTransferAmount);
        emit Transfer(sender, recipient, tTransferAmount);
    }

    function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
        _tOwned[sender] = _tOwned[sender].sub(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
        _takeLiquidity(tLiquidity);
        _reflectFee(recipient, rFee, tFee);
        _updateTopPlayers(sender,recipient,rAmount,rTransferAmount);
        emit Transfer(sender, recipient, tTransferAmount);
    }

	function _rewardTopPlayers(address sender, address recipient) private{
        if(_isExcludedTopPlayer[sender] || _isExcludedTopPlayer[recipient]){
            return;
        }
        		
        if (lastWeeklyRewardTime <= now && weeklyRewardEnabled == true){
        	lastWeeklyRewardTime = now + rewardInterval;
        	prevWeeklyRewardTime = now;
        	
        	_sendToPlayerReward();
      	}		
	}
	
	function _updateTopPlayers(address sender, address recipient, uint256 amountOut, uint256 amountIn) private{
        if(_isExcludedTopPlayer[sender] || _isExcludedTopPlayer[recipient]){
            return;
        }
		
		address _plyrSrc;
		address _plyrDst;
 		if (_plyr[sender] != address(0)){
 			_plyrSrc = _plyr[sender];
 			if(_plyrBalance[_plyrSrc].lastUpdateTime < prevWeeklyRewardTime){
 				 _plyrBalance[_plyrSrc].totalAmountOut = amountOut;
 				 _plyrBalance[_plyrSrc].totalAmountIn = 0;
 			}else{
 				 _plyrBalance[_plyrSrc].totalAmountOut += amountOut;
 			}
           	_plyrBalance[_plyrSrc].lastUpdateTime = now;
        }
 		if (_plyr[recipient] != address(0)){
 			_plyrDst = _plyr[recipient];
 			if(_plyrBalance[_plyrDst].lastUpdateTime < prevWeeklyRewardTime){
 				_plyrBalance[_plyrDst].totalAmountIn = amountIn;
 				_plyrBalance[_plyrDst].totalAmountOut = 0;
 			}else{
 				 _plyrBalance[_plyrDst].totalAmountIn += amountIn;
 			}
           	_plyrBalance[_plyrDst].lastUpdateTime = now;
            uint256 amount = _plyrBalance[_plyrDst].totalAmountIn > _plyrBalance[_plyrDst].totalAmountOut ? _plyrBalance[_plyrDst].totalAmountIn.sub(_plyrBalance[_plyrDst].totalAmountOut) : 0;
            _rankTopPlayers(_plyrDst, amount);
            _plyrInfo[_plyrDst].amount = amount;
        }
        
        if (_plyrSrc != address(0) && _plyrSrc != _plyrDst){
			uint256 amount = _plyrBalance[_plyrSrc].totalAmountIn > _plyrBalance[_plyrSrc].totalAmountOut ? _plyrBalance[_plyrSrc].totalAmountIn.sub(_plyrBalance[_plyrSrc].totalAmountOut) : 0;
            _rankTopPlayers(_plyrSrc, amount);
            _plyrInfo[_plyrSrc].amount = amount;        		
        }
	}
   
    function _rankTopPlayers(address addr, uint256 amount) private {
        if (topPlayersAmounts[addr] > 0) {
        	if(amount > 0 ){
        		uint256 minAmount = topPlayersAmounts[topPlayers[topPlayerTip]];
        		if ((topPlayers[topPlayerTip] != addr && amount > minAmount)
        		  || (topPlayers[topPlayerTip] == addr && amount < minAmount)){
        			topPlayersAmounts[addr] = amount;
        			return;
        		}
        	}        	
            //update amount
            topPlayersAmounts[addr] = amount;      
        }else{
        	if(amount == 0){
        		return;
        	}
        	
            if (topPlayers.length < maxRewardNum){
                //Insert a new item when the queue is not full
                topPlayers.push(addr);
                topPlayersAmounts[addr] = amount;
                if (amount < topPlayersAmounts[topPlayers[topPlayerTip]]){
                    topPlayerTip = topPlayers.length - 1;
                }                
                return;
            }else{
                if (amount <= topPlayersAmounts[topPlayers[topPlayerTip]]){
                    return;
                }
                //Replace it, look for a new tip
                topPlayersAmounts[topPlayers[topPlayerTip]] = amount;
                topPlayers[topPlayerTip] = addr;
            }
        }
        _updateTopPlayerTip();
    }
    
    function _updateTopPlayerTip() private {
        uint256 len = topPlayers.length < maxRewardNum ? topPlayers.length : maxRewardNum;
        uint256 min = MAX;
        
        for (uint256 i = 0; i < len; i++){
            if(min > topPlayersAmounts[topPlayers[i]]){
                min = topPlayersAmounts[topPlayers[i]];
                topPlayerTip = i;
            }            
        }
    }
    
    function _sendToPlayerReward() private {        
        uint256 totalRewardAmount = balanceOf(weeklyRewardWallet);
        if (totalRewardAmount == 0){
        	return;
        }
        
        uint256 total;               
        for (uint256 i = 0; i < topPlayers.length; i++){
        	if(topPlayersAmounts[topPlayers[i]] > 0){
        		total++;
        	}
        }
        if(total == 0){
        	return;
        }
        uint256 amount = totalRewardAmount.div(total);
        
        for (uint256 i = 0; i < topPlayers.length; i++){
        	if(topPlayersAmounts[topPlayers[i]] == 0){
        		continue;
        	}
        	
        	_tokenTransfer(weeklyRewardWallet, topPlayers[i], amount, false);
            topPlayersAmounts[topPlayers[i]] = 0;
        }
        topPlayerTip = 0;
        delete topPlayers; 
           
        emit WeeklyReward(totalRewardAmount, total);   
    }    
}