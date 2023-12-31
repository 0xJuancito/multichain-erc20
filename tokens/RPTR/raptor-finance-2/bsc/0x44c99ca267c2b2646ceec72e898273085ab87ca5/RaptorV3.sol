pragma solidity ^0.7.0;
// SPDX-License-Identifier: MIT
// Solidity contract made by Yanis (@ygboucherk on instagram, telegram)
// Raptor is an ecological cryptocurrency (Raptor Forest) that also provides a DEX (RaptorSwap) and some farming (RaptorFarm).


//      __
//    _   ____    Dinos agree RaptorSwap will be a success
//   |     ___\ /
//    \   ____/
//     | |


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

library Math {
	function sum(uint256[] memory numbers) internal pure returns (uint256 _sum) {
		uint256 i = 0;
		while (i < numbers.length) {
			_sum += numbers[i];
			i += 1;
		}
	}
	
	function min(uint256[] memory numbers) internal pure returns (uint256 _min) {
		uint256 i = 0;
		_min = numbers[0];
		while (i < numbers.length) {
			if (_min > numbers[i]) {
				_min = numbers[i];
			}
			i += 1;
		}
	}
	
	function max(uint256[] memory numbers) internal pure returns (uint256 _max) {
		uint256 i = 0;
		_max = numbers[0];
		while (i < numbers.length) {
			if (_max < numbers[i]) {
				_max = numbers[i];
			}
			i += 1;
		}
	}
}

interface ERC20Interface {
    function totalSupply() external view returns (uint);
    function balanceOf(address tokenOwner) external view returns (uint balance);
    function allowance(address tokenOwner, address spender) external view returns (uint remaining);
    function transfer(address to, uint tokens) external returns (bool success);
    function approve(address spender, uint tokens) external returns (bool success);
    function transferFrom(address from, address to, uint tokens) external returns (bool success);
}

interface ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokens, address token, bytes calldata data) external;
	function onTransferReceived(address operator, address from, uint256 value, bytes calldata data) external returns (bytes4);
}

contract Owned {
    address public owner;
    address public newOwner;

    event OwnershipTransferred(address indexed _from, address indexed _to);
	event OwnershipRenounced();

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }
	
	function _chainId() internal pure returns (uint256) {
		uint256 id;
		assembly {
			id := chainid()
		}
		return id;
	}
	
    function acceptOwnership() public {
        require(msg.sender == newOwner);
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
    }
	
	function renounceOwnership() public onlyOwner {
		owner = address(0);
		newOwner = address(0);
		emit OwnershipRenounced();
	}
}

contract masterChefStuff is Owned {
	address public masterChef;
	event MasterChefChanged(address indexed oldMasterchef, address indexed newMasterchef);
	function setMasterChef(address _address) public onlyOwner {
		emit MasterChefChanged(masterChef, _address);
		masterChef = _address;
	}
	
	modifier onlyMasterChef() {
		require(msg.sender == masterChef, "MasterChef : beep ?");
		_;
	}
}

contract RaptorV3 is Owned, masterChefStuff {
	using SafeMath for uint256;
	uint256 public _totalSupply;
	string public name;
	string public symbol;
	uint8 public decimals = 18;
	mapping (address => uint256) public balances;
	mapping (address => mapping (address => uint256)) allowances;
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
	event EnabledSwapToNew();
	event DisabledSwapToNew();
	ERC20Interface public oldRaptor;
	
	constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 initialSupply, ERC20Interface _oldRaptor) {
		name = _name;
		symbol = _symbol;
		decimals = _decimals;
		_totalSupply = initialSupply;
		balances[msg.sender] = initialSupply;
		oldRaptor = _oldRaptor;
	}
	
	function _swapToNewRaptor(uint256 tokens, address from) internal {
		oldRaptor.transferFrom(from, address(this), tokens);
		uint256 _tokens = tokens.mul(1000); // decimals will fix stuff
		balances[from] = balances[from].add(_tokens);
		_totalSupply = _totalSupply.add(_tokens);
		emit Transfer(address(0), from, _tokens);
	}
	
	function swapToNewRaptor(uint256 tokens) public {
		_swapToNewRaptor(tokens, msg.sender);
	}
	
	function mintTo(address to, uint256 tokens) public onlyMasterChef {
		_totalSupply = _totalSupply.add(tokens);
		balances[to] = balances[to].add(tokens);
		emit Transfer(address(0), to, tokens);
	}
	
	function balanceOf(address guy) public view returns (uint256) {
		if ((guy == address(0)) || (guy == address(1)) || (guy == address(0xdead))) {
			return 0;
		}
		else {
			return balances[guy];
		}
	}
	
	function totalSupply() public view returns (uint256) {
		return _totalSupply.sub(balances[address(0)]).sub(balances[address(0xdead)]).sub(balances[address(1)]);
	}
	
	function approve(address spender, uint256 tokens) public {
		allowances[msg.sender][spender] = tokens;
		emit Approval(msg.sender, spender, tokens);
	}
	
	function _transfer(address from, address to, uint256 tokens) internal {
		balances[from] = balances[from].sub(tokens, "RaptorTokenError: unsufficient balance");
		balances[to] = balances[to].add(tokens);
		emit Transfer(from, to, tokens);
	}
	
	function transfer(address to, uint256 tokens) public returns (bool) {
		_transfer(msg.sender, to, tokens);
		return true;
	}
	
	function transferFrom(address from, address to, uint256 tokens) public returns (bool) {
		allowances[from][msg.sender] = allowances[from][msg.sender].sub(tokens, "RaptorTokenError: Unsufficient allowance");
		_transfer(from, to, tokens);
		return true;
	}
	
	function allowance(address owner, address spender) public view returns (uint256) {
		return allowances[owner][spender];
	}
	
	function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public {
		require(msg.sender == address(oldRaptor), "Only for migration");
		_swapToNewRaptor(tokens, from);
	}
	
    function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
		approve(spender, tokens);
        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
		return true;
    }
}