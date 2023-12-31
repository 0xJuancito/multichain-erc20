// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IR91UpgradeableToken.sol";

/**
 * @dev Interface for the optional metadata functions from the ERC20 standard.
 *
 */
interface IR91MetadataUpgradeable is IR91UpgradeableToken {
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