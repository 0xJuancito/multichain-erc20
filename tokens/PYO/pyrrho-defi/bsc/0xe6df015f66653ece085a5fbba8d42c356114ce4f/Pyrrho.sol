// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

/*

Contract owned and operated by Pyrrho LLC.
https://www.pyrrhodefi.com

*/

abstract contract Context {
    function _msgSender() internal view returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

interface IERC20 {
  /**
   * @dev Returns the amount of tokens in existence.
   */
  function totalSupply() external view returns (uint256);

  /**
   * @dev Returns the token decimals.
   */
  function decimals() external view returns (uint8);

  /**
   * @dev Returns the token symbol.
   */
  function symbol() external view returns (string memory);

  /**
  * @dev Returns the token name.
  */
  function name() external view returns (string memory);

  /**
   * @dev Returns the bep token owner.
   */
  function getOwner() external view returns (address);

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
  function allowance(address _owner, address spender) external view returns (uint256);

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

interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);
    function getPair(address tokenA, address tokenB) external view returns (address lpPair);
    function createPair(address tokenA, address tokenB) external returns (address lpPair);
}

interface IUniswapV2Pair {
    function factory() external view returns (address);
}

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
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

contract Pyrrho is Context, IERC20 {
    // Ownership moved to in-contract for customizability.
    address private _owner;

    mapping (address => uint256) private _tOwned;
    mapping (address => bool) private lpPairs;
    uint256 private timeSinceLastPair = 0;
    mapping (address => mapping (address => uint256)) private _allowances;

    mapping (address => bool) private _isExcludedFromFees;
    mapping (address => bool) private _isExcludedFromWalletSize;
    mapping (address => bool) private _isExcludedFromSellLimits;

    mapping (address => bool) private presaleAddresses;
    bool private allowedPresaleExclusion = true;
    mapping (address => bool) private _liquidityHolders;

    uint256 constant private startingSupply = 5_000_000_000;

    string constant private _name = "Pyrrho";
    string constant private _symbol = "PYO";

    struct Fees {
        uint16 buyFee;
        uint16 sellFee;
    }

    struct StaticValues {
        uint16 maxBuyTaxes;
        uint16 maxSellTaxes;
        uint16 masterTaxDivisor;
    }

    struct Ratios {
        uint16 tokens;
        uint16 bnb;
        uint16 busd;
        uint16 total;
    }

    Fees public _taxRates = Fees({
        buyFee: 200,
        sellFee: 400
        });

    Ratios public _ratios = Ratios({
        tokens: 33,
        bnb: 33,
        busd: 33,
        total: 99
        });

    StaticValues public staticVals = StaticValues({
        maxBuyTaxes: 500,
        maxSellTaxes: 500,
        masterTaxDivisor: 10000
        });

    uint256 private constant MAX = ~uint256(0);
    uint8 constant private _decimals = 18;
    uint256 constant private _tTotal = startingSupply * 10**_decimals;

    IUniswapV2Router02 public dexRouter;
    address public lpPair;
    address public BNB;
    address public BUSD = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56;
    IERC20 public BUSD_ERC20 = IERC20(BUSD);

    // PCS ROUTER
    address constant private _routerAddress = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    address constant public DEAD = 0x000000000000000000000000000000000000dEaD;

    struct TaxWallets {
        address payable address1;
        address payable address2;
    }

    TaxWallets public taxWallets = TaxWallets({
        address1: payable(0x6CCa33Fe8375D6e4b9F56e0FbE0158302887f2B8),
        address2: payable(0xfB829826AE68ae72191bcAfcd79Cc4cFaab7E18e)
        });
    
    bool private inSwap;
    bool public contractSwapEnabled = false;

    uint256 private maxWalletPercent = 5;
    uint256 private maxWalletDivisor = 1000;
    uint256 private _maxWalletSize = (_tTotal * maxWalletPercent) / maxWalletDivisor;
    uint256 public maxWalletSizeUI = (startingSupply * maxWalletPercent) / maxWalletDivisor;

    uint256 public _maxSellPercent = 50;

    uint256 private swapThreshold = (_tTotal * 5) / 10000;
    uint256 private swapAmount = (_tTotal * 5) / 1000;

    bool public _hasLiqBeenAdded = false;

    struct SellLimits {
        uint256 userSellTime;
        uint256 userSoldAmt;
        uint256 userSoldAmtLimit;
    }

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
    event ContractSwapEnabledUpdated(bool enabled);
    event SwapAndLiquify(
        uint256 tokensSwapped,
        uint256 ethReceived,
        uint256 tokensIntoLiqudity
    );
    
    modifier lockTheSwap {
        inSwap = true;
        _;
        inSwap = false;
    }

    modifier onlyOwner() {
        require(_owner == _msgSender(), "Caller =/= owner.");
        _;
    }
    
    constructor () payable {
        _tOwned[_msgSender()] = _tTotal;

        // Set the owner.
        _owner = msg.sender;

        dexRouter = IUniswapV2Router02(_routerAddress);
        lpPair = IUniswapV2Factory(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
        lpPairs[lpPair] = true;
        BNB = dexRouter.WETH();

        _approve(address(this), _routerAddress, type(uint256).max);

        _isExcludedFromFees[owner()] = true;
        _isExcludedFromFees[address(this)] = true;
        _isExcludedFromFees[DEAD] = true;
        _isExcludedFromSellLimits[owner()] = true;
        _isExcludedFromSellLimits[address(this)] = true;
        _isExcludedFromSellLimits[DEAD] = true;
        _liquidityHolders[owner()] = true;

        emit Transfer(address(0), _msgSender(), _tTotal);
    }

    receive() external payable {}

//===============================================================================================================
//===============================================================================================================
//===============================================================================================================
    // Ownable removed as a lib and added here to allow for custom transfers and renouncements.
    // This allows for removal of ownership privileges from the owner once renounced or transferred.
    function owner() public view returns (address) {
        return _owner;
    }

    function transferOwner(address newOwner) external onlyOwner() {
        require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
        require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
        setExcludedFromFees(_owner, false);
        setExcludedFromFees(newOwner, true);
        
        if(balanceOf(_owner) > 0) {
            _transfer(_owner, newOwner, balanceOf(_owner));
        }
        
        _owner = newOwner;
        emit OwnershipTransferred(_owner, newOwner);
        
    }

    function renounceOwnership() public virtual onlyOwner() {
        setExcludedFromFees(_owner, false);
        _owner = address(0);
        emit OwnershipTransferred(_owner, address(0));
    }
//===============================================================================================================
//===============================================================================================================
//===============================================================================================================

    function totalSupply() external pure override returns (uint256) { return _tTotal; }
    function decimals() external pure override returns (uint8) { return _decimals; }
    function symbol() external pure override returns (string memory) { return _symbol; }
    function name() external pure override returns (string memory) { return _name; }
    function getOwner() external view override returns (address) { return owner(); }
    function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }

    function balanceOf(address account) public view override returns (uint256) {
        return _tOwned[account];
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function _approve(address sender, address spender, uint256 amount) private {
        require(sender != address(0), "ERC20: Zero Address");
        require(spender != address(0), "ERC20: Zero Address");

        _allowances[sender][spender] = amount;
        emit Approval(sender, spender, amount);
    }

    function approveContractContingency() public onlyOwner returns (bool) {
        _approve(address(this), address(dexRouter), type(uint256).max);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        if (_allowances[sender][msg.sender] != type(uint256).max) {
            _allowances[sender][msg.sender] -= amount;
        }

        return _transfer(sender, recipient, amount);
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
        return true;
    }

    function getCirculatingSupply() public view returns (uint256) {
        return (_tTotal - (balanceOf(DEAD) + balanceOf(address(0))));
    }

    function setNewRouter(address newRouter) public onlyOwner() {
        IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter);
        address get_pair = IUniswapV2Factory(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
        if (get_pair == address(0)) {
            lpPair = IUniswapV2Factory(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
        }
        else {
            lpPair = get_pair;
        }
        dexRouter = _newRouter;
        _approve(address(this), address(dexRouter), type(uint256).max);
    }

    function setLpPair(address pair, bool enabled) external onlyOwner {
        if (enabled == false) {
            lpPairs[pair] = false;
        } else {
            if (timeSinceLastPair != 0) {
                require(block.timestamp - timeSinceLastPair > 3 days, "Cannot set a new pair this week!");
            }
            lpPairs[pair] = true;
            timeSinceLastPair = block.timestamp;
        }
    }

    function isExcludedFromFees(address account) public view returns(bool) {
        return _isExcludedFromFees[account];
    }

    function setExcludedFromFees(address account, bool enabled) public onlyOwner {
        _isExcludedFromFees[account] = enabled;
    }

    function isExcludedFromWalletSize(address account) public view returns(bool) {
        return _isExcludedFromWalletSize[account];
    }

    function setExcludedFromWalletSize(address account, bool enabled) public onlyOwner {
        _isExcludedFromWalletSize[account] = enabled;
    }

    function isExcludedFromSellLimits(address account) public view returns(bool) {
        return _isExcludedFromSellLimits[account];
    }

    function setExcludedFromSellLimits(address account, bool enabled) public onlyOwner {
        _isExcludedFromSellLimits[account] = enabled;
    }

    function setTaxes(uint16 buyFee, uint16 sellFee) external onlyOwner {
        require(buyFee <= staticVals.maxBuyTaxes
                && sellFee <= staticVals.maxSellTaxes,
                "Cannot exceed maximums.");
        _taxRates.buyFee = buyFee;
        _taxRates.sellFee = sellFee;
    }

    function setRatios(uint16 tokens, uint16 bnb, uint16 busd) external onlyOwner {
        _ratios.tokens = tokens;
        _ratios.bnb = bnb;
        _ratios.busd = busd;
        _ratios.total = tokens + bnb + busd;
    }

    function setMaxWalletSell(uint256 percent) external onlyOwner {
        require(percent >= 10, "Cannot set below 10%");
        _maxSellPercent = percent;
    }

    function setWallets(address payable address1, address payable address2) external onlyOwner {
        taxWallets.address1 = payable(address1);
        taxWallets.address2 = payable(address2);
    }

    function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
        swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
        swapAmount = (_tTotal * amountPercent) / amountDivisor;
    }

    function setContractSwapEnabled(bool _enabled) public onlyOwner {
        contractSwapEnabled = _enabled;
        emit ContractSwapEnabledUpdated(_enabled);
    }

    function excludePresaleAddresses(address router, address presale) external onlyOwner {
        require(allowedPresaleExclusion, "Function already used.");
        if (router == presale) {
            _liquidityHolders[presale] = true;
            presaleAddresses[presale] = true;
            setExcludedFromFees(presale, true);
        } else {
            _liquidityHolders[router] = true;
            _liquidityHolders[presale] = true;
            presaleAddresses[router] = true;
            presaleAddresses[presale] = true;
            setExcludedFromFees(router, true);
            setExcludedFromFees(presale, true);
        }
    }

    function _hasLimits(address from, address to) private view returns (bool) {
        return from != owner()
            && to != owner()
            && !_liquidityHolders[to]
            && !_liquidityHolders[from]
            && to != DEAD
            && to != address(0)
            && from != address(this);
    }

    function _transfer(address from, address to, uint256 amount) internal returns (bool) {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");
        if(_hasLimits(from, to)) {
            if(to != _routerAddress && !lpPairs[to] && !isExcludedFromWalletSize(to)) {
                require(balanceOf(to) + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
            }
        }

        if (lpPairs[to] && balanceOf(from) > getCirculatingSupply() / 1000 && !isExcludedFromSellLimits(from)) {
            uint256 limit = (balanceOf(from) * _maxSellPercent) / 100;
            require(amount <= limit, "Selling too much within the time limit!");
        }

        bool takeFee = true;
        if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){
            takeFee = false;
        }

        if (lpPairs[to]) {
            if (!inSwap
                && contractSwapEnabled
                && !presaleAddresses[to]
                && !presaleAddresses[from]
            ) {
                uint256 contractTokenBalance = balanceOf(address(this));
                if (contractTokenBalance >= swapThreshold) {
                    if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
                    contractSwap(contractTokenBalance);
                }
            }      
        } 
        return _finalizeTransfer(from, to, amount, takeFee);
    }

    function contractSwap(uint256 contractTokenBalance) private lockTheSwap {
        if (_ratios.total == 0)
            return;

        if(_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
            _allowances[address(this)][address(dexRouter)] = type(uint256).max;
        }

        uint256 tokensAmt = (contractTokenBalance * _ratios.tokens) / _ratios.total;
        uint256 BNBAmt = (contractTokenBalance * _ratios.bnb) / _ratios.total;
        uint256 BUSDAmt = contractTokenBalance - (tokensAmt + BNBAmt);

        if (tokensAmt > 0) {
            _transfer(address(this), taxWallets.address1, tokensAmt / 2);
            _transfer(address(this), taxWallets.address2, tokensAmt - (tokensAmt / 2));
        }

        if (BNBAmt > 0 || BUSDAmt > 0) {
            address[] memory path = new address[](2);
            path[0] = address(this);
            path[1] = BNB;

            dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
                BNBAmt + BUSDAmt,
                0,
                path,
                address(this),
                block.timestamp
            );

            uint256 swappedBNB = address(this).balance;

            if (BNBAmt > 0) {
                taxWallets.address1.transfer(((swappedBNB * _ratios.bnb) / (_ratios.bnb + _ratios.busd)) / 2);
                taxWallets.address2.transfer(((swappedBNB * _ratios.bnb) / (_ratios.bnb + _ratios.busd)) / 2);
            }

            if (BUSDAmt > 0) {
                path = new address[](2);
                path[0] = BNB;
                path[1] = BUSD;

                dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens {value: address(this).balance} (
                    0,
                    path,
                    address(this),
                    block.timestamp
                );

                BUSD_ERC20.transfer(taxWallets.address1, BUSD_ERC20.balanceOf(address(this)) / 2);
                BUSD_ERC20.transfer(taxWallets.address2, BUSD_ERC20.balanceOf(address(this)));
            }
        }
    }

    function _checkLiquidityAdd(address from, address to) private {
        require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
        if (!_hasLimits(from, to) && to == lpPair) {
            _liquidityHolders[from] = true;
            _hasLiqBeenAdded = true;
            contractSwapEnabled = true;
            emit ContractSwapEnabledUpdated(true);
        }
    }

    function sweepContingency() external onlyOwner {
        require(!_hasLiqBeenAdded, "Cannot call after liquidity.");
        payable(owner()).transfer(address(this).balance);
    }

    function _finalizeTransfer(address from, address to, uint256 amount, bool takeFee) private returns (bool) {
        if (!_hasLiqBeenAdded) {
            _checkLiquidityAdd(from, to);
            if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
                revert("Only owner can transfer at this time.");
            }
        }

        _tOwned[from] -= amount;
        uint256 amountReceived = (takeFee) ? takeTaxes(from, to, amount) : amount;
        _tOwned[to] += amountReceived;

        emit Transfer(from, to, amountReceived);
        return true;
    }

    function takeTaxes(address from, address to, uint256 amount) internal returns (uint256) {
        uint256 currentFee;
        if (lpPairs[from]) {
            currentFee = _taxRates.buyFee;
        } else {
            currentFee = _taxRates.sellFee;
        }

        uint256 feeAmount = amount * currentFee / staticVals.masterTaxDivisor;

        _tOwned[address(this)] += feeAmount;
        emit Transfer(from, address(this), feeAmount);

        return amount - feeAmount;
    }
}