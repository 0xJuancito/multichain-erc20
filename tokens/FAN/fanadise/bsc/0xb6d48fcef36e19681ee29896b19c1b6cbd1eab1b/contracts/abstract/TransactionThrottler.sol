// SPDX-License-Identifier: MIT

pragma solidity 0.8.6;

import { Ownable } from "./Ownable.sol";

abstract contract TransactionThrottler is Ownable {
    bool private _restrictionActive;
    uint256 private _tradingStart;
    uint256 private _maxTransferAmount;
    uint256 private constant _delayBetweenTx = 30;
    mapping(address => bool) private _isWhitelisted;
    mapping(address => bool) private _isUnthrottled;
    mapping(address => uint256) private _previousTx;

    event TradingTimeChanged(uint256 tradingTime);
    event RestrictionActiveChanged(bool active);
    event MaxTransferAmountChanged(uint256 maxTransferAmount);
    event MarkedWhitelisted(address indexed account, bool isWhitelisted);
    event MarkedUnthrottled(address indexed account, bool isUnthrottled);

    constructor() {
        _tradingStart = block.timestamp + 3 days;
        _restrictionActive = true;
    }

    function setTradingStart(uint256 _time) external onlyOwner() {
        require(_tradingStart > block.timestamp, "Protection: To late");
        _tradingStart = _time;
        emit TradingTimeChanged(_tradingStart);
    }

    function setMaxTransferAmount(uint256 _amount) external onlyOwner() {
        _maxTransferAmount = _amount;
        emit MaxTransferAmountChanged(_maxTransferAmount);
    }

    function setRestrictionActive(bool _active) external onlyOwner() {
        _restrictionActive = _active;
        emit RestrictionActiveChanged(_restrictionActive);
    }

    function unthrottleAccount(address _account, bool _unthrottled) external onlyOwner() {
        require(_account != address(0), "Zero address");
        _isUnthrottled[_account] = _unthrottled;
        emit MarkedUnthrottled(_account, _unthrottled);
    }

    function isUnthrottled(address account) external view returns (bool) {
        return _isUnthrottled[account];
    }

    function whitelistAccount(address _account, bool _whitelisted) external onlyOwner() {
        require(_account != address(0), "Zero address");
        _isWhitelisted[_account] = _whitelisted;
        emit MarkedWhitelisted(_account, _whitelisted);
    }

    function isWhitelisted(address account) external view returns (bool) {
        return _isWhitelisted[account];
    }

    modifier transactionThrottler(
        address sender,
        address recipient,
        uint256 amount
    ) {
        if (_restrictionActive && !_isUnthrottled[recipient] && !_isUnthrottled[sender]) {
            if (_tradingStart > block.timestamp) {
                require(sender == owner || recipient == owner, "Protection: Transfers disabled");
            } else {
                if (_maxTransferAmount > 0) {
                    require(amount <= _maxTransferAmount, "Protection: Limit exceeded");
                }

                if (!_isWhitelisted[recipient]) {
                    require(_previousTx[recipient] + _delayBetweenTx <= block.timestamp, "Protection: 1 tx/min allowed");
                    _previousTx[recipient] = block.timestamp;
                }

                if (!_isWhitelisted[sender]) {
                    require(_previousTx[sender] + _delayBetweenTx <= block.timestamp, "Protection: 1 tx/min allowed");
                    _previousTx[sender] = block.timestamp;
                }
            }
        }
        _;
    }
}
