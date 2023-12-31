// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

contract Deri {

    event ChangeController(address oldController, address newController);

    event Approval(address indexed owner, address indexed spender, uint256 amount);

    event Transfer(address indexed from, address indexed to, uint256 amount);

    string public constant name = 'Deri';

    string public constant symbol = 'DERI';

    uint8 public constant decimals = 18;

    uint256 public totalSupply;

    address public controller;

    mapping (address => uint256) internal balances;

    mapping (address => mapping (address => uint256)) internal allowances;

    modifier _controller_() {
        require(msg.sender == controller, 'Deri._controller_: can only be called by controller');
        _;
    }

    constructor () {
        controller = msg.sender;
        emit ChangeController(address(0), controller);
    }

    function setController(address newController) public _controller_ {
        require(newController != address(0), 'Deri.setController: to 0 address');
        emit ChangeController(controller, newController);
        controller = newController;
    }

    function balanceOf(address account) public view returns (uint256) {
        return balances[account];
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        require(spender != address(0), 'Deri.approve: to 0 address');
        allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        require(to != address(0), 'Deri.transfer: to 0 address');
        _transfer(msg.sender, to, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        require(to != address(0), 'Deri.transferFrom: to 0 address');

        uint256 oldAllowance = allowances[from][msg.sender];
        if (msg.sender != from && oldAllowance != type(uint256).max) {
            require(oldAllowance >= amount, 'Deri.transferFrom: amount exceeds allowance');
            uint256 newAllowance = oldAllowance - amount;
            allowances[from][msg.sender] = newAllowance;
            emit Approval(from, msg.sender, newAllowance);
        }

        _transfer(from, to, amount);
        return true;
    }

    function mint(address account, uint256 amount) public _controller_ {
        totalSupply += amount;
        balances[account] += amount;
        emit Transfer(address(0), account, amount);
    }

    function burn(address account, uint256 amount) public _controller_ {
        require(balances[account] >= amount, 'Deri.burn: amount exceeds balance');
        balances[account] -= amount;
        totalSupply -= amount;
        emit Transfer(account, address(0), amount);
    }

    function _transfer(address from, address to, uint256 amount) internal {
        require(balances[from] >= amount, 'Deri._transfer: amount exceeds balance');
        balances[from] -= amount;
        balances[to] += amount;
        emit Transfer(from, to, amount);
    }

}
