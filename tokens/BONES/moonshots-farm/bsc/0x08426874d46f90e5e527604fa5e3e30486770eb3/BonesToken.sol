pragma solidity 0.5.8;

/**
 *
 * https://moonshots.farm
 * 
 * Want to own the next 1000x SHIB/DOGE/HEX token? Farm a new/trending moonshot every other day, automagically!
 *
 */


interface ERC20 {
  function totalSupply() external view returns (uint256);
  function balanceOf(address who) external view returns (uint256);
  function allowance(address owner, address spender) external view returns (uint256);
  function transfer(address to, uint256 value) external returns (bool);
  function approve(address spender, uint256 value) external returns (bool);
  function approveAndCall(address spender, uint tokens, bytes calldata data) external returns (bool success);
  function transferFrom(address from, address to, uint256 value) external returns (bool);

  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}


contract BonesToken is ERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private balances;
    mapping (address => mapping (address => uint256)) private allowed;
    string public constant name  = "Moonshots Farm";
    string public constant symbol = "BONES";
    uint8 public constant decimals = 18;

    uint256 totalBones = 420000 * (10 ** 18);
    uint256 constant MAX_SUPPLY = 6900000 * (10 ** 18);
    bool public emissionEnded;
    address public currentGovernance = address(0x7cE91cEa92e6934ec2AAA577C94a13E27c8a4F21);

    constructor() public {
        address liquidityDrive = address(0x509967E6083A099ACA68b98bF6f272C1A631544E);
        balances[liquidityDrive] = totalBones;
        emit Transfer(address(0), liquidityDrive, totalBones);
    }

    function totalSupply() public view returns (uint256) {
        return totalBones;
    }

    function balanceOf(address player) public view returns (uint256) {
        return balances[player];
    }

    function allowance(address player, address spender) public view returns (uint256) {
        return allowed[player][spender];
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        require(to != address(0));
        transferInternal(msg.sender, to, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        require(to != address(0));
        allowed[from][msg.sender] = allowed[from][msg.sender].sub(amount);
        transferInternal(from, to, amount);
        return true;
    }

    function transferInternal(address from, address to, uint256 amount) internal {
        uint256 tokenBurn = amount.div(100); // 1% burn
        uint256 tokensToTransfer = amount.sub(tokenBurn);

        balances[from] = balances[from].sub(amount);
        balances[to] = balances[to].add(tokensToTransfer);
        totalBones = totalBones.sub(tokenBurn);
        emit Transfer(from, address(0), tokenBurn);
        emit Transfer(from, to, tokensToTransfer);
    }

    function approve(address spender, uint256 value) public returns (bool) {
        require(spender != address(0));
        allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function approveAndCall(address spender, uint256 tokens, bytes calldata data) external returns (bool) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
        return true;
    }

    function updateGovernance(address newGovernance) external {
        require(msg.sender == currentGovernance);
        currentGovernance = newGovernance;
    }
    
    // For yield farms (only currentGovernance contract can mint)
    function mint(uint256 amount, address recipient) external {
        require(msg.sender == currentGovernance);
        require(!emissionEnded);

        uint256 minted = amount;
        if (totalBones.add(amount) >= MAX_SUPPLY) {
            minted = MAX_SUPPLY.sub(totalBones);
            emissionEnded = true;
        }

        balances[recipient] = balances[recipient].add(minted);
        totalBones = totalBones.add(minted);
        emit Transfer(address(0), recipient, minted);
    }

    function burn(uint256 amount) external {
        if (amount > 0) {
            totalBones = totalBones.sub(amount);
            balances[msg.sender] = balances[msg.sender].sub(amount);
            emit Transfer(msg.sender, address(0), amount);
        }
    }
}

interface ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokens, address token, bytes calldata data) external;
}


library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    require(c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a / b;
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a);
    return c;
  }

  function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
    uint256 c = add(a,m);
    uint256 d = sub(c,1);
    return mul(div(d,m),m);
  }
}