// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.7;

interface IFxStateRootTunnel {
	function latestData() external view returns (bytes memory);

	function setFxChildTunnel(address _fxChildTunnel) external;

	function sendMessageToChild(bytes memory message) external;

	function setMaticX(address _maticX) external;
}
