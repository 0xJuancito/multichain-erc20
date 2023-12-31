// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

import {IERC20} from '../../../@openzeppelin/contracts/token/ERC20/IERC20.sol';
import {ISynthereumDeployment} from '../../common/interfaces/IDeployment.sol';
import {
  SynthereumPoolMigrationFrom
} from '../../synthereum-pool/common/migration/PoolMigrationFrom.sol';

/**
 * @title Provides interface with functions of Synthereum deployer
 */
interface ISynthereumDeployer {
  /**
   * @notice Deploy a new pool
   * @param poolVersion Version of the pool contract
   * @param poolParamsData Input params of pool constructor
   * @return pool Pool contract deployed
   */
  function deployPool(uint8 poolVersion, bytes calldata poolParamsData)
    external
    returns (ISynthereumDeployment pool);

  /**
   * @notice Migrate storage of an existing pool to e new deployed one
   * @param migrationPool Pool from which migrate storage
   * @param poolVersion Version of the pool contract to create
   * @param migrationParamsData Input params of migration (if needed)
   * @return pool Pool contract deployed
   */
  function migratePool(
    SynthereumPoolMigrationFrom migrationPool,
    uint8 poolVersion,
    bytes calldata migrationParamsData
  ) external returns (ISynthereumDeployment pool);

  /**
   * @notice Deploy a new self minting derivative contract
   * @param selfMintingDerVersion Version of the self minting derivative contract
   * @param selfMintingDerParamsData Input params of self minting derivative constructor
   * @return selfMintingDerivative Self minting derivative contract deployed
   */
  function deploySelfMintingDerivative(
    uint8 selfMintingDerVersion,
    bytes calldata selfMintingDerParamsData
  ) external returns (ISynthereumDeployment selfMintingDerivative);

  /**
   * @notice Deploy a new fixed rate wrapper contract
   * @param fixedRateVersion Version of the fixed rate wrapper contract
   * @param fixedRateParamsData Input params of fixed rate wrapper constructor
   * @return fixedRate Fixed rate wrapper contract deployed
   */
  function deployFixedRate(
    uint8 fixedRateVersion,
    bytes calldata fixedRateParamsData
  ) external returns (ISynthereumDeployment fixedRate);
}
