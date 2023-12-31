/** 
 *  SourceUnit: contracts/Token.sol
*/
            
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

abstract contract Ownable {
    address public owner;
    address public newOwner;
    event OwnershipChanged(address indexed from, address indexed to);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only for Owner");
        _;
    }

    function giveOwnership(address user) external onlyOwner {
        require(user != address(0x0), "Renounce instead");
        newOwner = user;
    }

    function acceptOwnership() external {
        require(
            newOwner != address(0x0) && msg.sender == newOwner,
            "Only newOwner can accept"
        );
        emit OwnershipChanged(owner, newOwner);
        owner = newOwner;
        newOwner = address(0x0);
    }

    function renounceOwnership() external onlyOwner {
        emit OwnershipChanged(owner, address(0x0));
        owner = address(0x0);
    }
}




/** 
 *  SourceUnit: contracts/Token.sol
*/
            
////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT

pragma solidity ^0.8.0;

interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
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
     * ////////IMPORTANT: Beware that changing an allowance with this method brings the risk
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
 *  SourceUnit: contracts/Token.sol
*/
            
////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
// based on https://github.com/CoinbaseStablecoin/eip-3009

pragma solidity ^0.8.0;

abstract contract EIP712Domain {
    /**
     * @dev EIP712 Domain Separator
     */
    bytes32 public DOMAIN_SEPARATOR;
    uint256 public CHAINID;
    bytes32 public EIP712_DOMAIN_TYPEHASH;
}

/**
 * @title ECRecover
 * @notice A library that provides a safe ECDSA recovery function
 */
library ECRecover {
    /**
     * @notice Recover signer's address from a signed message
     * @dev Adapted from: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/65e4ffde586ec89af3b7e9140bdc9235d1254853/contracts/cryptography/ECDSA.sol
     * Modifications: Accept v, r, and s as separate arguments
     * @param digest    Keccak-256 hash digest of the signed message
     * @param v         v of the signature
     * @param r         r of the signature
     * @param s         s of the signature
     * @return Signer address
     */
    function recover(
        bytes32 digest,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal pure returns (address) {
        // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
        // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
        // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
        // signatures from current libraries generate a unique signature with an s-value in the lower half order.
        //
        // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
        // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
        // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
        // these malleable signatures as well.
        if (
            uint256(s) >
            0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0
        ) {
            revert("ECRecover: invalid signature 's' value");
        }

        if (v != 27 && v != 28) {
            revert("ECRecover: invalid signature 'v' value");
        }

        // If the signature is valid (and not malleable), return the signer address
        address signer = ecrecover(digest, v, r, s);
        require(signer != address(0), "ECRecover: invalid signature");

        return signer;
    }
}

/**
 * @title EIP712
 * @notice A library that provides EIP712 helper functions
 */
library EIP712 {
    // keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)")
    bytes32 public constant EIP712_DOMAIN_TYPEHASH =
        0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f;

    /**
     * @notice Make EIP712 domain separator
     * @param name      Contract name
     * @param version   Contract version
     * @return Domain separator
     */
    function makeDomainSeparator(
        string memory name,
        string memory version,
        uint256 chainId
    ) internal view returns (bytes32) {
        return
            keccak256(
                abi.encode(
                    EIP712_DOMAIN_TYPEHASH,
                    keccak256(bytes(name)),
                    keccak256(bytes(version)),
                    chainId,
                    address(this)
                )
            );
    }

    /**
     * @notice Recover signer's address from a EIP712 signature
     * @param domainSeparator   Domain separator
     * @param v                 v of the signature
     * @param r                 r of the signature
     * @param s                 s of the signature
     * @param typeHashAndData   Type hash concatenated with data
     * @return Signer's address
     */
    function recover(
        bytes32 domainSeparator,
        uint8 v,
        bytes32 r,
        bytes32 s,
        bytes memory typeHashAndData
    ) internal pure returns (address) {
        bytes32 digest = keccak256(
            abi.encodePacked(
                "\x19\x01",
                domainSeparator,
                keccak256(typeHashAndData)
            )
        );
        return ECRecover.recover(digest, v, r, s);
    }
}




/** 
 *  SourceUnit: contracts/Token.sol
*/
            
////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT

pragma solidity ^0.8.0;

abstract contract ERC20Internal {
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual;

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual;
}




/** 
 *  SourceUnit: contracts/Token.sol
*/
            
////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT

pragma solidity ^0.8.0;

////import "./IERC20.sol";
////import "./Ownable.sol";

abstract contract Recoverable is Ownable {
    string constant ERR_NOTHING = "Nothing to recover";

    /**
        Recover ETH send to contract address
     */
    function recoverEth() external onlyOwner {
        uint256 amount = address(this).balance;
        require(amount > 0, ERR_NOTHING);
        payable(owner).transfer(amount);
    }

    /**
        Recover any ERC20 token send to contract address
     */
    function recoverErc20(address token, uint256 amount)
        external
        virtual
        onlyOwner
    {
        IERC20 t = IERC20(token);
        uint256 balance = t.balanceOf(address(this));
        require(balance > 0, ERR_NOTHING);
        // handle "pay fee" tokens
        if (amount > 0 && balance > amount) {
            balance = amount;
        }
        t.transfer(owner, balance);
    }
}




/** 
 *  SourceUnit: contracts/Token.sol
*/
            
////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
// Following https://eips.ethereum.org/EIPS/eip-3009
// based on https://github.com/CoinbaseStablecoin/eip-3009

pragma solidity ^0.8.0;

////import "./ERC20Internal.sol";
////import "./EIP712.sol";

abstract contract ERC3009 is ERC20Internal, EIP712Domain {
    // events
    event AuthorizationUsed(address indexed authorizer, bytes32 indexed nonce);
    event AuthorizationCanceled(
        address indexed authorizer,
        bytes32 indexed nonce
    );

    // constant typehashes
    // keccak256("TransferWithAuthorization(address from,address to,uint256 value,uint256 validAfter,uint256 validBefore,bytes32 nonce)")
    bytes32 public constant TRANSFER_WITH_AUTHORIZATION_TYPEHASH =
        0x7c7c6cdb67a18743f49ec6fa9b35f50d52ed05cbed4cc592e13b44501c1a2267;

    // keccak256("ReceiveWithAuthorization(address from,address to,uint256 value,uint256 validAfter,uint256 validBefore,bytes32 nonce)")
    bytes32 public constant RECEIVE_WITH_AUTHORIZATION_TYPEHASH =
        0xd099cc98ef71107a616c4f0f941f04c322d8e254fe26b3c6668db87aae413de8;

    // keccak256("CancelAuthorization(address authorizer,bytes32 nonce)")
    bytes32 public constant CANCEL_AUTHORIZATION_TYPEHASH =
        0x158b0a9edf7a828aad02f63cd515c68ef2f50ba807396f6d12842833a1597429;

    // data store

    string constant ERR_REUSED = "EIP3009: Authorization reused";
    string constant ERR_SIGNATURE = "EIP3009: Invalid signature";

    /**
     * @dev authorizer address => nonce => state (true = used / false = unused)
     */
    mapping(address => mapping(bytes32 => bool)) internal _authorizationStates;

    // viewers

    /**
     * @notice Returns the state of an authorization
     * @dev Nonces are randomly generated 32-byte data unique to the authorizer's
     * address
     * @param authorizer    Authorizer's address
     * @param nonce         Nonce of the authorization
     * @return True if the nonce is used
     */
    function authorizationState(address authorizer, bytes32 nonce)
        external
        view
        returns (bool)
    {
        return _authorizationStates[authorizer][nonce];
    }

    // functions

    /**
     * @notice Execute a transfer with a signed authorization
     * @param from          Payer's address (Authorizer)
     * @param to            Payee's address
     * @param value         Amount to be transferred
     * @param validAfter    The time after which this is valid (unix time)
     * @param validBefore   The time before which this is valid (unix time)
     * @param nonce         Unique nonce
     * @param v             v of the signature
     * @param r             r of the signature
     * @param s             s of the signature
     */
    function transferWithAuthorization(
        address from,
        address to,
        uint256 value,
        uint256 validAfter,
        uint256 validBefore,
        bytes32 nonce,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        _transferWithAuthorization(
            TRANSFER_WITH_AUTHORIZATION_TYPEHASH,
            from,
            to,
            value,
            validAfter,
            validBefore,
            nonce,
            v,
            r,
            s
        );
    }

    /**
     * @notice Receive a transfer with a signed authorization from the payer
     * @dev This has an additional check to ensure that the payee's address matches
     * the caller of this function to prevent front-running attacks. (See security
     * considerations)
     * @param from          Payer's address (Authorizer)
     * @param to            Payee's address
     * @param value         Amount to be transferred
     * @param validAfter    The time after which this is valid (unix time)
     * @param validBefore   The time before which this is valid (unix time)
     * @param nonce         Unique nonce
     * @param v             v of the signature
     * @param r             r of the signature
     * @param s             s of the signature
     */
    function receiveWithAuthorization(
        address from,
        address to,
        uint256 value,
        uint256 validAfter,
        uint256 validBefore,
        bytes32 nonce,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        require(to == msg.sender, "EIP3009: caller must be the payee");

        _transferWithAuthorization(
            RECEIVE_WITH_AUTHORIZATION_TYPEHASH,
            from,
            to,
            value,
            validAfter,
            validBefore,
            nonce,
            v,
            r,
            s
        );
    }

    function _transferWithAuthorization(
        bytes32 typeHash,
        address from,
        address to,
        uint256 value,
        uint256 validAfter,
        uint256 validBefore,
        bytes32 nonce,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal {
        uint256 timeNow = block.timestamp;
        require(
            timeNow > validAfter,
            "EIP3009: authorization is not yet valid"
        );
        require(timeNow < validBefore, "EIP3009: authorization is expired");
        require(!_authorizationStates[from][nonce], ERR_REUSED);

        bytes memory data = abi.encode(
            typeHash,
            from,
            to,
            value,
            validAfter,
            validBefore,
            nonce
        );
        require(
            EIP712.recover(DOMAIN_SEPARATOR, v, r, s, data) == from,
            ERR_SIGNATURE
        );

        _authorizationStates[from][nonce] = true;
        emit AuthorizationUsed(from, nonce);

        _transfer(from, to, value);
    }

    /**
     * @notice Attempt to cancel an authorization
     * @param authorizer    Authorizer's address
     * @param nonce         Nonce of the authorization
     * @param v             v of the signature
     * @param r             r of the signature
     * @param s             s of the signature
     */
    function cancelAuthorization(
        address authorizer,
        bytes32 nonce,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        require(!_authorizationStates[authorizer][nonce], ERR_REUSED);

        bytes memory data = abi.encode(
            CANCEL_AUTHORIZATION_TYPEHASH,
            authorizer,
            nonce
        );
        require(
            EIP712.recover(DOMAIN_SEPARATOR, v, r, s, data) == authorizer,
            ERR_SIGNATURE
        );

        _authorizationStates[authorizer][nonce] = true;
        emit AuthorizationCanceled(authorizer, nonce);
    }
}




/** 
 *  SourceUnit: contracts/Token.sol
*/
            
////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
// Following https://eips.ethereum.org/EIPS/eip-2612
// based on https://github.com/CoinbaseStablecoin/eip-3009

pragma solidity ^0.8.0;

////import "./ERC20Internal.sol";
////import "./EIP712.sol";

abstract contract ERC2612 is ERC20Internal, EIP712Domain {
    // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)")
    bytes32 public constant PERMIT_TYPEHASH =
        0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;

    mapping(address => uint256) internal _nonces;

    /**
     * @notice Nonces for permit
     * @param owner Token owner's address
     * @return Next nonce
     */
    function nonces(address owner) external view returns (uint256) {
        return _nonces[owner];
    }

    /**
     * @notice update allowance with a signed permit
     * @param owner     Token owner's address (Authorizer)
     * @param spender   Spender's address
     * @param value     Amount of allowance
     * @param deadline  The time at which this expires (unix time)
     * @param v         v of the signature
     * @param r         r of the signature
     * @param s         s of the signature
     */
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        require(deadline >= block.timestamp, "EIP2612: permit is expired");

        bytes memory data = abi.encode(
            PERMIT_TYPEHASH,
            owner,
            spender,
            value,
            _nonces[owner]++,
            deadline
        );
        require(
            EIP712.recover(DOMAIN_SEPARATOR, v, r, s, data) == owner,
            "EIP2612: invalid signature"
        );

        _approve(owner, spender, value);
    }
}




/** 
 *  SourceUnit: contracts/Token.sol
*/
            
////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT

pragma solidity ^0.8.0;

////import "./IERC20.sol";
////import "./ERC20Internal.sol";

abstract contract ERC20 is IERC20, ERC20Internal {
    // ERC20 data store

    string internal _name;
    string internal _symbol;
    uint256 internal _supply;
    mapping(address => uint256) _balances;
    mapping(address => mapping(address => uint256)) _allowances;

    /**
        Token constructor
        @param name_ token name
        @param symbol_ token symbol
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    // modifiers
    modifier notZeroAddress(address user) {
        require(user != address(0x0), "Address 0x0 is prohibited");
        _;
    }

    // readers
    function name() external view override returns (string memory) {
        return _name;
    }

    function symbol() external view override returns (string memory) {
        return _symbol;
    }

    function decimals() external pure override returns (uint8) {
        return 18;
    }

    function totalSupply() external view override returns (uint256) {
        return _supply;
    }

    function balanceOf(address user) external view override returns (uint256) {
        return _balances[user];
    }

    function allowance(address user, address spender)
        external
        view
        returns (uint256)
    {
        return _allowances[user][spender];
    }

    // external functions

    function transfer(address to, uint256 amount)
        external
        override
        returns (bool)
    {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount)
        external
        override
        returns (bool)
    {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal override {
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external override returns (bool) {
        uint256 currentAllowance = _allowances[from][msg.sender];
        require(currentAllowance >= amount, "ERC20: allowance to low");
        if (currentAllowance < type(uint256).max) {
            unchecked {
                _allowances[from][msg.sender] = currentAllowance - amount;
            }
        }
        _transfer(from, to, amount);
        return true;
    }

    function burn(uint256 amount) external returns (bool) {
        _burn(msg.sender, amount);
        return true;
    }

    function burnFrom(address user, uint256 amount) external returns (bool) {
        uint256 currentAllowance = _allowances[user][msg.sender];
        require(currentAllowance >= amount, "BurnFrom: allowance to low");
        unchecked {
            _allowances[user][msg.sender] = currentAllowance - amount;
        }
        _burn(user, amount);
        return true;
    }

    // internal functions
    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal override notZeroAddress(to) {
        uint256 balance = _balances[from];
        require(balance >= amount, "ERC20: balance to low");
        unchecked {
            _balances[from] = balance - amount;
            _balances[to] += amount;
        }
        emit Transfer(from, to, amount);
    }

    function _burn(address from, uint256 amount) internal {
        uint256 currentBalance = _balances[from];
        require(currentBalance >= amount, "Burn: insufficient balance");
        unchecked {
            _balances[from] = currentBalance - amount;
            _supply -= amount;
        }
        emit Transfer(from, address(0x0), amount);
    }
}


/** 
 *  SourceUnit: contracts/Token.sol
*/

////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT

pragma solidity ^0.8.10;

////import "./ERC20.sol";
////import "./ERC2612.sol";
////import "./ERC3009.sol";
////import "./Recover.sol";

contract Token is ERC20, Recoverable, ERC3009, ERC2612 {
    // constructor
    /**
        Contract constructor
        @param tokenName token name
        @param tokenSymbol token symbol
        @param contractVersion contract version
        @param totalMaxSupply maximum token supply
     */
    constructor(
        string memory tokenName,
        string memory tokenSymbol,
        string memory contractVersion,
        uint256 totalMaxSupply
    ) ERC20(tokenName, tokenSymbol) {
        uint256 chainId = block.chainid;
        DOMAIN_SEPARATOR = EIP712.makeDomainSeparator(
            tokenName,
            contractVersion,
            chainId
        );
        CHAINID = chainId;
        maxSupply = totalMaxSupply;
        EIP712_DOMAIN_TYPEHASH = EIP712.EIP712_DOMAIN_TYPEHASH;
    }

    // Owner only
    /// Flag for end ////import from platform
    bool private _importCompleted;
    /// Maximum token supply
    uint256 public immutable maxSupply;

    /**
        Reader for ////import complete
        @return bool true if all tokens are imported
     */
    function importCompleted() external view returns (bool) {
        return _importCompleted;
    }

    /**
        Mass ////import user token balances, can be call more than once.
        Number of tokens are limited to maxSupply
        @param user[] list of user addresses
        @param balance[] list of corresponding user balances
     */
    function massImport(address[] calldata user, uint256[] calldata balance)
        external
        onlyOwner
    {
        require(!_importCompleted, "Import ended");
        uint256 len = user.length;
        require(len == balance.length, "Data size mismatch");
        uint256 currentSupply = _supply;
        uint256 i;
        for (i; i < len; i++) {
            address addr = user[i];
            uint256 b = balance[i];
            _balances[addr] += b;
            currentSupply += b;
            emit Transfer(address(0x0), addr, b);
        }
        require(currentSupply <= maxSupply, "maxSupply exceeded");
        _supply = currentSupply;
    }

    /**
        End token balances ////import, send rest of tokens to owner.
     */
    function endImport() external onlyOwner {
        _importCompleted = true;
        uint256 ownerSupply = maxSupply - _supply;
        if (ownerSupply > 0) {
            _balances[owner] += ownerSupply;
            _supply += ownerSupply;
            emit Transfer(address(0x0), owner, ownerSupply);
        }
    }
}