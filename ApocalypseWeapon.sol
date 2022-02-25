// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;


/** LIBRARY **/

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
     *
     * [IMPORTANT]
     * ====
     * You shouldn't rely on `isContract` to protect against flash loan attacks!
     *
     * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
     * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
     * constructor.
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for contracts in construction, since the code is only stored at the end
        // of the constructor execution.

        return account.code.length > 0;
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

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
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
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
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
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

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
 * @dev String operations.
 */
library Strings {
    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";

    /**
     * @dev Converts a `uint256` to its ASCII `string` decimal representation.
     */
    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
     */
    function toHexString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0x00";
        }
        uint256 temp = value;
        uint256 length = 0;
        while (temp != 0) {
            length++;
            temp >>= 8;
        }
        return toHexString(value, length);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
     */
    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _HEX_SYMBOLS[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }
}

/**
 * @title Counters
 * @author Matt Condon (@shrugs)
 * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
 * of elements in a mapping, issuing ERC721 ids, or counting request ids.
 *
 * Include with `using Counters for Counters.Counter;`
 */
library Counters {
    struct Counter {
        // This variable should never be directly accessed by users of the library: interactions must be restricted to
        // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
        // this feature: see https://github.com/ethereum/solidity/issues/4637
        uint256 _value; // default: 0
    }

    function current(Counter storage counter) internal view returns (uint256) {
        return counter._value;
    }

    function increment(Counter storage counter) internal {
        unchecked {
            counter._value += 1;
        }
    }

    function decrement(Counter storage counter) internal {
        uint256 value = counter._value;
        require(value > 0, "Counter: decrement overflow");
        unchecked {
            counter._value = value - 1;
        }
    }

    function reset(Counter storage counter) internal {
        counter._value = 0;
    }
}

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

    function _msgValue() internal view virtual returns (uint256) {
        return msg.value;
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
abstract contract Auth is Context {
    

    /** DATA **/
    address private _owner;
    
    mapping(address => bool) internal authorizations;

    
    /** CONSTRUCTOR **/

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _owner = _msgSender();
        authorizations[_msgSender()] = true;
    }

    /** FUNCTION **/

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Throws if called by any account other authorized accounts.
     */
    modifier authorized() {
        require(isAuthorized(_msgSender()), "Ownable: caller is not an authorized account");
        _;
    }

    /**
     * @dev Authorize address. Owner only
     */
    function authorize(address adr) public onlyOwner {
        authorizations[adr] = true;
    }

    /**
     * @dev Remove address' authorization. Owner only
     */
    function unauthorize(address adr) public onlyOwner {
        authorizations[adr] = false;
    }

    /**
     * @dev Check if address is owner
     */
    function isOwner(address adr) public view returns (bool) {
        return adr == owner();
    }

    /**
     * @dev Return address' authorization status
     */
    function isAuthorized(address adr) public view returns (bool) {
        return authorizations[adr];
    }
}

/**
 * @dev Contract module which allows children to implement an emergency stop
 * mechanism that can be triggered by an authorized account.
 *
 * This module is used through inheritance. It will make available the
 * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
 * the functions of your contract. Note that they will not be pausable by
 * simply including this module, only once the modifiers are put in place.
 */
abstract contract Pausable is Context {
    /**
     * @dev Emitted when the pause is triggered by `account`.
     */
    event Paused(address account);

    /**
     * @dev Emitted when the pause is lifted by `account`.
     */
    event Unpaused(address account);

    bool private _paused;

    /**
     * @dev Initializes the contract in unpaused state.
     */
    constructor() {
        _paused = false;
    }

    /**
     * @dev Returns true if the contract is paused, and false otherwise.
     */
    function paused() public view virtual returns (bool) {
        return _paused;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    modifier whenNotPaused() {
        require(!paused(), "Pausable: paused");
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    modifier whenPaused() {
        require(paused(), "Pausable: not paused");
        _;
    }

    /**
     * @dev Triggers stopped state.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    function _pause() internal virtual whenNotPaused {
        _paused = true;
        emit Paused(_msgSender());
    }

    /**
     * @dev Returns to normal state.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    function _unpause() internal virtual whenPaused {
        _paused = false;
        emit Unpaused(_msgSender());
    }
}

/** ERC STANDARD **/

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IERC721 is IERC165 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool _approved) external;

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;
}

/**
 * @title ERC721 token receiver interface
 * @dev Interface for any contract that wants to support safeTransfers
 * from ERC721 asset contracts.
 */
interface IERC721Receiver {
    /**
     * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
     * by `operator` from `from`, this function is called.
     *
     * It must return its Solidity selector to confirm the token transfer.
     * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
     *
     * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
     */
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}

/**
 * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
 * @dev See https://eips.ethereum.org/EIPS/eip-721
 */
interface IERC721Metadata is IERC721 {
    /**
     * @dev Returns the token collection name.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the token collection symbol.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
     */
    function tokenURI(uint256 tokenId) external view returns (string memory);
}

/**
 * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
 * @dev See https://eips.ethereum.org/EIPS/eip-721
 */
interface IERC721Enumerable is IERC721 {
    /**
     * @dev Returns the total amount of tokens stored by the contract.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
     * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
     */
    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);

    /**
     * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
     * Use along with {totalSupply} to enumerate all tokens.
     */
    function tokenByIndex(uint256 index) external view returns (uint256);
}

/**
 * @dev Implementation of the {IERC165} interface.
 *
 * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
 * for the additional interface id that will be supported. For example:
 *
 * ```solidity
 * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
 *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
 * }
 * ```
 *
 * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
 */
abstract contract ERC165 is IERC165 {
    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}

/**
 * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
 * the Metadata extension, but not including the Enumerable extension, which is available separately as
 * {ERC721Enumerable}.
 */
contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {

    using Address for address;
    using Strings for uint256;

    // Token name
    string private _name;

    // Token symbol
    string private _symbol;

    // Mapping from token ID to owner address
    mapping(uint256 => address) private _owners;

    // Mapping owner address to token count
    mapping(address => uint256) private _balances;

    // Mapping from token ID to approved address
    mapping(uint256 => address) private _tokenApprovals;

    // Mapping from owner to operator approvals
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    /**
     * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    /**
     * @dev See {IERC721-balanceOf}.
     */
    function balanceOf(address owner) public view virtual override returns (uint256) {
        require(owner != address(0), "ERC721: balance query for the zero address");
        return _balances[owner];
    }

    /**
     * @dev See {IERC721-ownerOf}.
     */
    function ownerOf(uint256 tokenId) public view virtual override returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "ERC721: owner query for nonexistent token");
        return owner;
    }

    /**
     * @dev See {IERC721Metadata-name}.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev See {IERC721Metadata-symbol}.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
    }

    /**
     * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
     * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
     * by default, can be overridden in child contracts.
     */
    function _baseURI() internal view virtual returns (string memory) {
        return "";
    }

    /**
     * @dev See {IERC721-approve}.
     */
    function approve(address to, uint256 tokenId) public virtual override {
        address owner = ERC721.ownerOf(tokenId);
        require(to != owner, "ERC721: approval to current owner");

        require(
            _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
            "ERC721: approve caller is not owner nor approved for all"
        );

        _approve(to, tokenId);
    }

    /**
     * @dev See {IERC721-getApproved}.
     */
    function getApproved(uint256 tokenId) public view virtual override returns (address) {
        require(_exists(tokenId), "ERC721: approved query for nonexistent token");

        return _tokenApprovals[tokenId];
    }

    /**
     * @dev See {IERC721-setApprovalForAll}.
     */
    function setApprovalForAll(address operator, bool approved) public virtual override {
        _setApprovalForAll(_msgSender(), operator, approved);
    }

    /**
     * @dev See {IERC721-isApprovedForAll}.
     */
    function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    /**
     * @dev See {IERC721-transferFrom}.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        //solhint-disable-next-line max-line-length
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");

        _transfer(from, to, tokenId);
    }

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        safeTransferFrom(from, to, tokenId, "");
    }

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public virtual override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
        _safeTransfer(from, to, tokenId, _data);
    }

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * `_data` is additional data, it has no specified format and it is sent in call to `to`.
     *
     * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
     * implement alternative mechanisms to perform token transfer, such as signature-based.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function _safeTransfer(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) internal virtual {
        _transfer(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    }

    /**
     * @dev Returns whether `tokenId` exists.
     *
     * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
     *
     * Tokens start existing when they are minted (`_mint`),
     * and stop existing when they are burned (`_burn`).
     */
    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _owners[tokenId] != address(0);
    }

    /**
     * @dev Returns whether `spender` is allowed to manage `tokenId`.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
        require(_exists(tokenId), "ERC721: operator query for nonexistent token");
        address owner = ERC721.ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    }

    /**
     * @dev Safely mints `tokenId` and transfers it to `to`.
     *
     * Requirements:
     *
     * - `tokenId` must not exist.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function _safeMint(address to, uint256 tokenId) internal virtual {
        _safeMint(to, tokenId, "");
    }

    /**
     * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
     * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
     */
    function _safeMint(
        address to,
        uint256 tokenId,
        bytes memory _data
    ) internal virtual {
        _mint(to, tokenId);
        require(
            _checkOnERC721Received(address(0), to, tokenId, _data),
            "ERC721: transfer to non ERC721Receiver implementer"
        );
    }

    /**
     * @dev Mints `tokenId` and transfers it to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
     *
     * Requirements:
     *
     * - `tokenId` must not exist.
     * - `to` cannot be the zero address.
     *
     * Emits a {Transfer} event.
     */
    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");

        _beforeTokenTransfer(address(0), to, tokenId);

        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(address(0), to, tokenId);

        _afterTokenTransfer(address(0), to, tokenId);
    }

    /**
     * @dev Destroys `tokenId`.
     * The approval is cleared when the token is burned.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     *
     * Emits a {Transfer} event.
     */
    function _burn(uint256 tokenId) internal virtual {
        address owner = ERC721.ownerOf(tokenId);

        _beforeTokenTransfer(owner, address(0), tokenId);

        // Clear approvals
        _approve(address(0), tokenId);

        _balances[owner] -= 1;
        delete _owners[tokenId];

        emit Transfer(owner, address(0), tokenId);

        _afterTokenTransfer(owner, address(0), tokenId);
    }

    /**
     * @dev Transfers `tokenId` from `from` to `to`.
     *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     *
     * Emits a {Transfer} event.
     */
    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {
        require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
        require(to != address(0), "ERC721: transfer to the zero address");

        _beforeTokenTransfer(from, to, tokenId);

        // Clear approvals from the previous owner
        _approve(address(0), tokenId);

        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);

        _afterTokenTransfer(from, to, tokenId);
    }

    /**
     * @dev Approve `to` to operate on `tokenId`
     *
     * Emits a {Approval} event.
     */
    function _approve(address to, uint256 tokenId) internal virtual {
        _tokenApprovals[tokenId] = to;
        emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
    }

    /**
     * @dev Approve `operator` to operate on all of `owner` tokens
     *
     * Emits a {ApprovalForAll} event.
     */
    function _setApprovalForAll(
        address owner,
        address operator,
        bool approved
    ) internal virtual {
        require(owner != operator, "ERC721: approve to caller");
        _operatorApprovals[owner][operator] = approved;
        emit ApprovalForAll(owner, operator, approved);
    }

    /**
     * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
     * The call is not executed if the target address is not a contract.
     *
     * @param from address representing the previous owner of the given token ID
     * @param to target address that will receive the tokens
     * @param tokenId uint256 ID of the token to be transferred
     * @param _data bytes optional data to send along with the call
     * @return bool whether the call correctly returned the expected magic value
     */
    function _checkOnERC721Received(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) private returns (bool) {
        if (to.isContract()) {
            try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
                return retval == IERC721Receiver.onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("ERC721: transfer to non ERC721Receiver implementer");
                } else {
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }

    /**
     * @dev Hook that is called before any token transfer. This includes minting
     * and burning.
     *
     * Calling conditions:
     *
     * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
     * transferred to `to`.
     * - When `from` is zero, `tokenId` will be minted for `to`.
     * - When `to` is zero, ``from``'s `tokenId` will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {}

    /**
     * @dev Hook that is called after any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {}
}

/**
 * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
 * enumerability of all the token ids in the contract as well as all token ids owned by each
 * account.
 */
abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
    // Mapping from owner to list of owned token IDs
    mapping(address => mapping(uint256 => uint256)) private _ownedTokens;

    // Mapping from token ID to index of the owner tokens list
    mapping(uint256 => uint256) private _ownedTokensIndex;

    // Array with all token ids, used for enumeration
    uint256[] private _allTokens;

    // Mapping from token id to position in the allTokens array
    mapping(uint256 => uint256) private _allTokensIndex;

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
        return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
    }

    /**
     * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
     */
    function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
        require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
        return _ownedTokens[owner][index];
    }

    /**
     * @dev See {IERC721Enumerable-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _allTokens.length;
    }

    /**
     * @dev See {IERC721Enumerable-tokenByIndex}.
     */
    function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
        require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
        return _allTokens[index];
    }

    /**
     * @dev Hook that is called before any token transfer. This includes minting
     * and burning.
     *
     * Calling conditions:
     *
     * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
     * transferred to `to`.
     * - When `from` is zero, `tokenId` will be minted for `to`.
     * - When `to` is zero, ``from``'s `tokenId` will be burned.
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override {
        super._beforeTokenTransfer(from, to, tokenId);

        if (from == address(0)) {
            _addTokenToAllTokensEnumeration(tokenId);
        } else if (from != to) {
            _removeTokenFromOwnerEnumeration(from, tokenId);
        }
        if (to == address(0)) {
            _removeTokenFromAllTokensEnumeration(tokenId);
        } else if (to != from) {
            _addTokenToOwnerEnumeration(to, tokenId);
        }
    }

    /**
     * @dev Private function to add a token to this extension's ownership-tracking data structures.
     * @param to address representing the new owner of the given token ID
     * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
     */
    function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
        uint256 length = ERC721.balanceOf(to);
        _ownedTokens[to][length] = tokenId;
        _ownedTokensIndex[tokenId] = length;
    }

    /**
     * @dev Private function to add a token to this extension's token tracking data structures.
     * @param tokenId uint256 ID of the token to be added to the tokens list
     */
    function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }

    /**
     * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
     * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
     * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
     * This has O(1) time complexity, but alters the order of the _ownedTokens array.
     * @param from address representing the previous owner of the given token ID
     * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
     */
    function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
        // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
        // then delete the last slot (swap and pop).

        uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
        uint256 tokenIndex = _ownedTokensIndex[tokenId];

        // When the token to delete is the last token, the swap operation is unnecessary
        if (tokenIndex != lastTokenIndex) {
            uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];

            _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
            _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
        }

        // This also deletes the contents at the last position of the array
        delete _ownedTokensIndex[tokenId];
        delete _ownedTokens[from][lastTokenIndex];
    }

    /**
     * @dev Private function to remove a token from this extension's token tracking data structures.
     * This has O(1) time complexity, but alters the order of the _allTokens array.
     * @param tokenId uint256 ID of the token to be removed from the tokens list
     */
    function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
        // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
        // then delete the last slot (swap and pop).

        uint256 lastTokenIndex = _allTokens.length - 1;
        uint256 tokenIndex = _allTokensIndex[tokenId];

        // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
        // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
        // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
        uint256 lastTokenId = _allTokens[lastTokenIndex];

        _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
        _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index

        // This also deletes the contents at the last position of the array
        delete _allTokensIndex[tokenId];
        _allTokens.pop();
    }
}

/**
 * @title ERC721 Burnable Token
 * @dev ERC721 Token that can be irreversibly burned (destroyed).
 */
abstract contract ERC721Burnable is Context, ERC721 {
    /**
     * @dev Burns `tokenId`. See {ERC721-_burn}.
     *
     * Requirements:
     *
     * - The caller must own `tokenId` or be an approved operator.
     */
    function burn(uint256 tokenId) public virtual {
        //solhint-disable-next-line max-line-length
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
        _burn(tokenId);
    }
}


/** APOCALYPSE WEAPON **/

contract ApocalypseRandomizer {


    /** DATA **/
    
    uint256 internal constant maskLast8Bits = uint256(0xff);
    uint256 internal constant maskFirst248Bits = type(uint256).max;

    /** FUNCTION **/
       
    function sliceNumber(uint256 _n, uint256 _base, uint256 _index, uint256 _offset) public pure returns (uint256) {
        return _sliceNumber(_n, _base, _index, _offset);
    }

    /**
     * @dev Given a number get a slice of any bits, at certain offset.
     * 
     * @param _n a number to be sliced
     * @param _base base number
     * @param _index how many bits long is the new number
     * @param _offset how many bits to skip
     */
    function _sliceNumber(uint256 _n, uint256 _base, uint256 _index, uint256 _offset) internal pure returns (uint256) {
        uint256 mask = uint256((_base**_index) - 1) << _offset;
        return uint256((_n & mask) >> _offset);
    }

    function randomNGenerator(uint256 _param1, uint256 _param2, uint256 _targetBlock) public view returns (uint256) {
        return _randomNGenerator(_param1, _param2, _targetBlock);
    }

    /**
     * @dev Generate random number from the hash of the "target block".
     */
    function _randomNGenerator(uint256 _param1, uint256 _param2, uint256 _targetBlock) internal view returns (uint256) {
        uint256 randomN = uint256(blockhash(_targetBlock));
        
        if (randomN == 0) {
            _targetBlock = (block.number & maskFirst248Bits) + (_targetBlock & maskLast8Bits);
        
            if (_targetBlock >= block.number) {
                _targetBlock -= 256;
            }
            
            randomN = uint256(blockhash(_targetBlock));
        }

        randomN = uint256(keccak256(abi.encodePacked(randomN, _param1, _param2, _targetBlock)));

        return randomN;
    }

}

contract ApocalypseWeapon is ERC721, ERC721Enumerable, Pausable, Auth, ERC721Burnable {
    

    /** LIBRARY **/
    using Counters for Counters.Counter;
    using Strings for string;


    /** DATA **/
    string public URI;
    string private IPFS;
    string private cid;
    
    struct Weapon {
        uint256 tokenID;
        uint256[2] weaponIndex;
        bool weaponEquip;
        uint256 weaponStatus;
        uint256 weaponType;
        uint256 weaponLevel;
        uint256 weaponEndurance;
        uint256 baseAttack;
    }

    uint256 public maxLevel;
    uint256 public maxUpgradeStatus;

    uint256[] public weaponStatus;
    uint256[] public weaponType;
    uint256[] public weaponAttack;    
    uint256[] public weaponUpChance;
    uint256[] public weaponDepletion;

    uint256[] public commonWeaponEndurance;
    uint256[] public upgradeWeaponEndurance;
    uint256[] public rareWeaponEndurance;

    uint256[2] public upgradePercentage;
    uint256[2] public rarePercentage;
    uint256[2] public commonBaseStat;
    uint256[2] public upgradeBaseStat;
    uint256[2] public rareBaseStat;

    uint256 public commonCurrentSupply;
    uint256 public upgradeCurrentSupply;
    uint256 public rareCurrentSupply;
    uint256 public totalMaxSupply;

    Weapon[] public apocWeapon;

    ApocalypseRandomizer private randomizer;
    Counters.Counter private _tokenIdCounter;

    mapping(uint256 => uint256) public maxCommonWeaponSupply;
    mapping(uint256 => uint256) public maxRareWeaponSupply;
    mapping(uint256 => uint256) public maxWeaponSupply;
    mapping(uint256 => uint256) currentCommonWeaponSupply;
    mapping(uint256 => uint256) currentRareWeaponSupply;
    mapping(uint256 => mapping(uint256 => uint256)) public currentSpecificUpgradeWeaponSupply;
    

    /** CONSTRUCTOR **/
    constructor(
        string memory _name,
        string memory _symbol,
        string memory _URI,
        string memory _IPFS,
        string memory _cid,
        ApocalypseRandomizer _randomizer
    ) ERC721(_name, _symbol) {
        randomizer = _randomizer;
        URI = _URI;
        IPFS = _IPFS;
        cid = _cid;

        weaponStatus = [0,1];
        weaponType = [1,2,3,4,5];
        weaponAttack = [3,6,10,15,20,30,50,70,100,120];
        weaponUpChance = [40,38,35,32,28,23,20,15,10,5];
        weaponDepletion = [0,0,0,0,20,30,40,60,100,100];
        commonWeaponEndurance = [1000,1500,2000,2500,3000,3500,4000,4500,5000,10000];

        maxLevel = 10;

        commonBaseStat = [500, 1];
        rareBaseStat = [10000, 100];
        
        rarePercentage = [5, 4];

        addSpecificMaxWeaponSupply(0, 1, 2); // 2 rare fencing
        addSpecificMaxWeaponSupply(0, 2, 2); // 2 rare axe
        addSpecificMaxWeaponSupply(0, 3, 2); // 2 rare bow
        addSpecificMaxWeaponSupply(0, 4, 2); // 2 rare sword
        addSpecificMaxWeaponSupply(0, 5, 2); // 2 rare hammer

        addSpecificMaxWeaponSupply(1, 1, 100000); // 100,000 fencing
        addSpecificMaxWeaponSupply(1, 2, 100000); // 100,000 axe
        addSpecificMaxWeaponSupply(1, 3, 100000); // 100,000 bow
        addSpecificMaxWeaponSupply(1, 4, 100000); // 100,000 sword
        addSpecificMaxWeaponSupply(1, 5, 100000); // 100,000 hammer

        _createWeapon(
            [uint256(0),uint256(0)],
            0,
            0,
            0,
            commonBaseStat[0],
            commonBaseStat[1]
        );

        _safeMint(_msgSender());

    }

    
    /** EVENT **/

    event MintNewWeapon(address _tokenOwner, uint256 _tokenID);
    event AddWeaponSupply(uint256 _maxWeaponSupply);


    /** FUNCTION **/

    /* General functions */

    function pause() public whenNotPaused authorized {
        _pause();
    }

    function unpause() public whenPaused onlyOwner {
        _unpause();
    }
    
    function setCID(string memory _cid) public onlyOwner {
        cid = _cid;
    }

    function setIPFS(string memory _IPFS) public onlyOwner {
        IPFS = _IPFS;
    }

    function setBaseURI(string memory _URI) public onlyOwner {
        URI = _URI;
    }

    function _baseURI() internal view override returns (string memory) {
        return URI;
    }

    /* Randomizer functions */

    function setApocalypseRandomizer(ApocalypseRandomizer _randomizer) public onlyOwner {
        randomizer = _randomizer;
    }

    function ApocRandomizer() public view returns (ApocalypseRandomizer) {
        return randomizer;
    }

    /* Supply functions */

    function addSpecificMaxWeaponSupply(
        uint256 _weaponStatus,
        uint256 _weaponType,
        uint256 _maxWeaponSupply
    ) public authorized {
        if (_weaponStatus == 0) {
            maxRareWeaponSupply[_weaponType] += _maxWeaponSupply;
            _addTotalMaxWeaponSupply(_weaponStatus, _maxWeaponSupply);
        } else if (_weaponStatus == 1) {
            maxCommonWeaponSupply[_weaponType] += _maxWeaponSupply;
            _addTotalMaxWeaponSupply(_weaponStatus, _maxWeaponSupply);
        } else {
            _addTotalMaxWeaponSupply(_weaponStatus, _maxWeaponSupply);
        }
    }

    function _addTotalMaxWeaponSupply(uint256 _weaponStatus, uint256 _maxWeaponSupply) internal {
        maxWeaponSupply[_weaponStatus] += _maxWeaponSupply;
        totalMaxSupply += _maxWeaponSupply;

        emit AddWeaponSupply(_maxWeaponSupply);
    }

    /* Default stats functions */

    function setUpgradePercentage(uint256 _upgradeNumerator, uint256 _upgradePower) public authorized {
        require(_upgradeNumerator > 0 && _upgradePower > 0);
        upgradePercentage = [_upgradeNumerator, _upgradePower];
    }

    function setRarePercentage(uint256 _rareNumerator, uint256 _rarePower) public authorized {
        require(_rareNumerator > 0 && _rarePower > 0);
        rarePercentage = [_rareNumerator, _rarePower];
    }

    function setDefaultInfo(uint256 _maxLevel, uint256 _maxUpgradeStatus) public authorized {
        require(_maxLevel > 0);
        maxLevel = _maxLevel;
        maxUpgradeStatus = _maxUpgradeStatus;
    }
    
    function addCommonWeaponEndurance(uint256[] memory _commonWeaponEndurance) public authorized {
        for(uint256 i = 0; i < _commonWeaponEndurance.length; i++){
            commonWeaponEndurance.push(_commonWeaponEndurance[i]);
        }
    }
    
    function addUpgradeWeaponEndurance(uint256[] memory _upgradeWeaponEndurance) public authorized {
        for(uint256 i = 0; i < _upgradeWeaponEndurance.length; i++){
            upgradeWeaponEndurance.push(_upgradeWeaponEndurance[i]);
        }
    }
    
    function addRareWeaponEndurance(uint256[] memory _rareWeaponEndurance) public authorized {
        for(uint256 i = 0; i < _rareWeaponEndurance.length; i++){
            rareWeaponEndurance.push(_rareWeaponEndurance[i]);
        }
    }
    
    function addWeaponAttack(uint256[] memory _weaponAttack) public authorized {
        for(uint256 i = 0; i < _weaponAttack.length; i++){
            weaponAttack.push(_weaponAttack[i]);
        }
    }
    
    function addWeaponUpChance(uint256[] memory _weaponUpChance) public authorized {
        for(uint256 i = 0; i < _weaponUpChance.length; i++){
            weaponUpChance.push(_weaponUpChance[i]);
        }
    }
    
    function addWeaponDepletion(uint256[] memory _weaponDepletion) public authorized {
        for(uint256 i = 0; i < _weaponDepletion.length; i++){
            weaponDepletion.push(_weaponDepletion[i]);
        }
    }
    
    function updateCommonWeaponEndurance(uint256 _weaponLevel, uint256 _commonWeaponEndurance) public authorized {
        require(_weaponLevel != 0 && _weaponLevel < commonWeaponEndurance.length && _commonWeaponEndurance > 0);
        commonWeaponEndurance[_weaponLevel - 1] = _commonWeaponEndurance;
    }
    
    function updateUpgradeWeaponEndurance(uint256 _weaponLevel, uint256 _upgradeWeaponEndurance) public authorized {
        require(_weaponLevel != 0 && _weaponLevel < upgradeWeaponEndurance.length && _upgradeWeaponEndurance > 0);
        upgradeWeaponEndurance[_weaponLevel - 1] = _upgradeWeaponEndurance;
    }
    
    function updateRareWeaponEndurance(uint256 _weaponLevel, uint256 _rareWeaponEndurance) public authorized {
        require(_weaponLevel != 0 && _weaponLevel < rareWeaponEndurance.length && _rareWeaponEndurance > 0);
        rareWeaponEndurance[_weaponLevel - 1] = _rareWeaponEndurance;
    }
    
    function updateWeaponAttack(uint256 _weaponLevel, uint256 _weaponAttack) public authorized {
        require(_weaponLevel != 0 && _weaponLevel < weaponAttack.length && _weaponAttack > 0);
        weaponAttack[_weaponLevel - 1] = _weaponAttack;
    }
    
    function updateWeaponUpChance(uint256 _weaponLevel, uint256 _weaponUpChance) public authorized {
        require(_weaponLevel < weaponUpChance.length && _weaponUpChance > 0);
        weaponUpChance[_weaponLevel] = _weaponUpChance;
    }
    
    function updateWeaponDepletion(uint256 _weaponLevel, uint256 _weaponDepletion) public authorized {
        require(_weaponLevel < weaponDepletion.length && _weaponDepletion >= 0);
        weaponDepletion[_weaponLevel] = _weaponDepletion;
    }

    function setCommonBaseStat(uint256 _baseEndurance, uint256 _baseAttack) public authorized {
        require(_baseEndurance > 0 && _baseAttack > 0);
        commonBaseStat = [_baseEndurance, _baseAttack];
    }

    function setUpgradeBaseStat(uint256 _baseEndurance, uint256 _baseAttack) public authorized {
        require(_baseEndurance > 0 && _baseAttack > 0);
        upgradeBaseStat = [_baseEndurance, _baseAttack];
    }

    function setRareBaseStat(uint256 _baseEndurance, uint256 _baseAttack) public authorized {
        require(_baseEndurance > 0 && _baseAttack > 0);
        rareBaseStat = [_baseEndurance, _baseAttack];
    }

    function addWeaponStatus(uint256[] memory _statusID) public authorized {
        for(uint256 i = 0; i < _statusID.length; i++){
            weaponStatus.push(_statusID[i]);
        }
    }

    function addWeaponType(uint256[] memory _typeID) public authorized {
        for(uint256 i = 0; i < _typeID.length; i++){
            weaponType.push(_typeID[i]);
        }
    }

    /* Weapon attributes functions */

    // Setter

    function updateWeaponEquip(uint256 _tokenID, bool _equip) external whenNotPaused authorized {
        require(apocWeapon[_tokenID].weaponEquip != _equip);
        apocWeapon[_tokenID].weaponEquip = _equip;
    }

    function levelUp(uint256 _tokenID) external whenNotPaused authorized {
        require(apocWeapon[_tokenID].weaponLevel < maxLevel);
        apocWeapon[_tokenID].weaponLevel += 1;
    }

    function reduceEndurance(uint256 _tokenID, uint256 _reduceEndurance) external whenNotPaused authorized {
        require (apocWeapon[_tokenID].weaponEndurance > 0);
        if (apocWeapon[_tokenID].weaponEndurance <= _reduceEndurance) {
            apocWeapon[_tokenID].weaponEndurance = 0;
        } else {
            apocWeapon[_tokenID].weaponEndurance -= _reduceEndurance;
        }
    }

    function recoverEndurance(uint256 _tokenID, uint256 _recoverEndurance) external whenNotPaused authorized {
        if (apocWeapon[_tokenID].weaponStatus == 0 && apocWeapon[_tokenID].weaponLevel == 0) {
            require (apocWeapon[_tokenID].weaponEndurance < rareBaseStat[0]);
        } else if (apocWeapon[_tokenID].weaponStatus == 0 && apocWeapon[_tokenID].weaponLevel > 0) {
            require (apocWeapon[_tokenID].weaponEndurance < rareWeaponEndurance[apocWeapon[_tokenID].weaponLevel - 1]);
        } else if (apocWeapon[_tokenID].weaponStatus == 1 && apocWeapon[_tokenID].weaponLevel == 0) {
            require (apocWeapon[_tokenID].weaponEndurance < commonBaseStat[0]);
        } else if (apocWeapon[_tokenID].weaponStatus == 1 && apocWeapon[_tokenID].weaponLevel > 0) {
            require (apocWeapon[_tokenID].weaponEndurance < commonWeaponEndurance[apocWeapon[_tokenID].weaponLevel - 1]);
        } else if (apocWeapon[_tokenID].weaponStatus > 1 && apocWeapon[_tokenID].weaponLevel == 0) {
            require (apocWeapon[_tokenID].weaponEndurance < upgradeBaseStat[0]);
        } else if (apocWeapon[_tokenID].weaponStatus > 1 && apocWeapon[_tokenID].weaponLevel > 0) {
            require (apocWeapon[_tokenID].weaponEndurance < upgradeWeaponEndurance[apocWeapon[_tokenID].weaponLevel - 1]);
        }

        if (apocWeapon[_tokenID].weaponStatus == 0 && apocWeapon[_tokenID].weaponLevel == 0 && apocWeapon[_tokenID].weaponEndurance + _recoverEndurance >= rareBaseStat[0]) {
            apocWeapon[_tokenID].weaponEndurance = rareBaseStat[0];
        } else if (apocWeapon[_tokenID].weaponStatus == 0 && apocWeapon[_tokenID].weaponLevel > 0 && apocWeapon[_tokenID].weaponEndurance + _recoverEndurance >= rareWeaponEndurance[apocWeapon[_tokenID].weaponLevel - 1]) {
            apocWeapon[_tokenID].weaponEndurance = rareWeaponEndurance[apocWeapon[_tokenID].weaponLevel - 1];
        } else if (apocWeapon[_tokenID].weaponStatus == 1 && apocWeapon[_tokenID].weaponLevel == 0 && apocWeapon[_tokenID].weaponEndurance + _recoverEndurance >= commonBaseStat[0]) {
            apocWeapon[_tokenID].weaponEndurance = commonBaseStat[0];
        } else if (apocWeapon[_tokenID].weaponStatus == 1 && apocWeapon[_tokenID].weaponLevel > 0 && apocWeapon[_tokenID].weaponEndurance + _recoverEndurance >= commonWeaponEndurance[apocWeapon[_tokenID].weaponLevel - 1]) {
            apocWeapon[_tokenID].weaponEndurance = commonWeaponEndurance[apocWeapon[_tokenID].weaponLevel - 1];
        } else if (apocWeapon[_tokenID].weaponStatus > 1 && apocWeapon[_tokenID].weaponLevel == 0 && apocWeapon[_tokenID].weaponEndurance + _recoverEndurance >= upgradeBaseStat[0]) {
            apocWeapon[_tokenID].weaponEndurance = upgradeBaseStat[0];
        } else if (apocWeapon[_tokenID].weaponStatus > 1 && apocWeapon[_tokenID].weaponLevel > 0 && apocWeapon[_tokenID].weaponEndurance + _recoverEndurance >= upgradeWeaponEndurance[apocWeapon[_tokenID].weaponLevel - 1]) {
            apocWeapon[_tokenID].weaponEndurance = upgradeWeaponEndurance[apocWeapon[_tokenID].weaponLevel - 1];
        } else {
            apocWeapon[_tokenID].weaponEndurance += _recoverEndurance;
        }
    }

    // Getter

    function getWeaponIndex(uint256 _tokenID) public view returns(uint256[2] memory) {
        return apocWeapon[_tokenID].weaponIndex;
    }

    function getWeaponEquip(uint256 _tokenID) public view returns(bool) {
        return apocWeapon[_tokenID].weaponEquip;
    }

    function getWeaponStatus(uint256 _tokenID) public view returns(uint256) {
        return apocWeapon[_tokenID].weaponStatus;
    }

    function getWeaponType(uint256 _tokenID) public view returns(uint256) {
        return apocWeapon[_tokenID].weaponType;
    }

    function getWeaponLevel(uint256 _tokenID) public view returns(uint256) {
        return apocWeapon[_tokenID].weaponLevel;
    }

    function getWeaponEndurance(uint256 _tokenID) public view returns(uint256) {
        return apocWeapon[_tokenID].weaponEndurance;
    }

    function getBaseAttack(uint256 _tokenID) public view returns(uint256) {
        return apocWeapon[_tokenID].baseAttack;
    }

    function getWeaponImage(uint256 _tokenID) public view returns (string memory) {
        string memory _weaponStatus = Strings.toString(apocWeapon[_tokenID].weaponStatus);
        string memory _weaponType = Strings.toString(apocWeapon[_tokenID].weaponType);
        string memory _weaponLevel = Strings.toString(apocWeapon[_tokenID].weaponLevel);
        string memory imgURI;

        if (_tokenID == 0) {
            imgURI = string(abi.encodePacked(IPFS, "/", cid, "/weapon/0.png"));
        } else {
            imgURI = string(abi.encodePacked(IPFS, "/", cid, "/weapon/", _weaponStatus, "/", _weaponType, "/", _weaponLevel, ".png"));
        }

        return imgURI;
    }

    /* NFT general logic functions */

    function _mixer(address _owner) internal view returns (uint256){
        uint256 userAddress = uint256(uint160(_owner));
        uint256 random = randomizer.randomNGenerator(userAddress, block.timestamp, block.number);

        uint256 _weaponType = randomizer.sliceNumber(random, weaponType.length, 1, weaponType.length);

        return _weaponType;
    }

    function _createWeapon(
        uint256[2] memory _currentSupplyInfo,
        uint256 _weaponStatus,
        uint256 _weaponType,
        uint256 _weaponLevel,
        uint256 _weaponEndurance,
        uint256 _baseAttack
    ) internal {
        Weapon memory _apocWeapon = Weapon({
            tokenID: _tokenIdCounter.current(),
            weaponIndex: _currentSupplyInfo,
            weaponEquip: false,
            weaponStatus: _weaponStatus,
            weaponType: _weaponType,
            weaponLevel: _weaponLevel,
            weaponEndurance: _weaponEndurance,
            baseAttack: _baseAttack
        });
        
        apocWeapon.push(_apocWeapon);
    }

    function _safeMint(address to) internal {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);

        emit MintNewWeapon(to, tokenId);
    }

    /* NFT upgrade logic functions */

    function _burnUpgrade(uint256 _tokenID) internal {
        _burn(_tokenID);

        if (apocWeapon[_tokenID].weaponStatus == 0) {
            rareCurrentSupply -= 1;
            currentRareWeaponSupply[apocWeapon[_tokenID].weaponType] -= 1;
        } else if (apocWeapon[_tokenID].weaponStatus == 1) {
            commonCurrentSupply -= 1;
            currentCommonWeaponSupply[apocWeapon[_tokenID].weaponType] -= 1;
        } else {
            upgradeCurrentSupply -= 1;
            currentSpecificUpgradeWeaponSupply[apocWeapon[_tokenID].weaponStatus][apocWeapon[_tokenID].weaponType] -= 1;
        }

    }

    function upgradeWeapon(address _owner, uint256 _tokenID1, uint256 _tokenID2, uint256 _nextStatus) external whenNotPaused authorized returns (bool, uint256) {
        require(
            apocWeapon[_tokenID1].weaponStatus <= maxUpgradeStatus &&
            apocWeapon[_tokenID2].weaponStatus <= maxUpgradeStatus &&
            apocWeapon[_tokenID1].weaponType == apocWeapon[_tokenID2].weaponType
        );

        uint256 _weaponType = apocWeapon[_tokenID1].weaponType;

        uint256 userAddress = uint256(uint160(_msgSender()));
        uint256 targetBlock = block.number + (upgradePercentage[1]/upgradePercentage[0]);
        uint256 random = randomizer.randomNGenerator(userAddress, block.timestamp, targetBlock);
        uint256 upgradeCheck = randomizer.sliceNumber(random, 10, upgradePercentage[1], upgradePercentage[1]/upgradePercentage[0]);

        if (upgradeCheck <= upgradePercentage[0]) {

            uint256[2] memory _currentSupplyInfo = [upgradeCurrentSupply + 1, currentSpecificUpgradeWeaponSupply[_nextStatus][_weaponType] + 1];

            _createWeapon(
                _currentSupplyInfo,
                _nextStatus,
                _weaponType,
                0,
                upgradeBaseStat[0],
                upgradeBaseStat[1]
            );

            upgradeCurrentSupply += 1;
            currentSpecificUpgradeWeaponSupply[_nextStatus][_weaponType] += 1;

            uint256 tokenID = _tokenIdCounter.current();
            _safeMint(_owner);

            _burnUpgrade(_tokenID1);
            _burnUpgrade(_tokenID2);

            return (true, tokenID);
        }

        _burnUpgrade(_tokenID1);
        _burnUpgrade(_tokenID2);

        return (false, 0);

    }

    /* NFT mint logic functions */

    function mintNewWeapon(address _owner) external whenNotPaused authorized returns (uint256){

        require(totalSupply() < totalMaxSupply);

        if (commonCurrentSupply == maxWeaponSupply[1] && rareCurrentSupply < maxWeaponSupply[0]) {
            return _mintRare(_owner);
        } else if (commonCurrentSupply < maxWeaponSupply[1] && rareCurrentSupply < maxWeaponSupply[0]) {
            uint256 userAddress = uint256(uint160(_owner));
            uint256 weaponMixer = weaponStatus.length + weaponType.length;
            uint256 targetBlock = block.number + weaponMixer;
            uint256 random = randomizer.randomNGenerator(userAddress, block.timestamp, targetBlock);

            uint256 rareCheck = randomizer.sliceNumber(random, 10, rarePercentage[1], weaponMixer);

            if (rareCheck <= rarePercentage[0]) {
                return _mintRare(_owner);
            } else {
                return _mintCommon(_owner);
            }
        } else {
                return _mintCommon(_owner);
        }

    }

    function _mintRare(address _owner) internal returns (uint256) {
        require(rareCurrentSupply < maxWeaponSupply[0]);

        uint256 mixer = _mixer(_owner);
        
        uint256 typeIterations = 0;

        while(currentRareWeaponSupply[mixer] == maxRareWeaponSupply[mixer]) {
            require(typeIterations < weaponType.length);
            mixer += 1;
            if(mixer > weaponType.length) {
                mixer -= weaponType.length;
            }

            typeIterations += 1;
        }
        
        if (typeIterations >= weaponType.length) {
            return (0);
        }

        uint256[2] memory _currentSupplyInfo = [rareCurrentSupply + 1, currentRareWeaponSupply[mixer] + 1];

        _createWeapon(
            _currentSupplyInfo,
            0,
            mixer,
            0,
            rareBaseStat[0],
            rareBaseStat[1]
        );

        rareCurrentSupply += 1;
        currentRareWeaponSupply[mixer] += 1;

        uint256 tokenID = _tokenIdCounter.current();
        _safeMint(_owner);

        return (tokenID);
    }

    function _mintCommon(address _owner) internal returns (uint256) {
        require(commonCurrentSupply < maxWeaponSupply[1]);

        uint256 mixer = _mixer(_owner);
        
        uint256 typeIterations = 0;

        while(currentCommonWeaponSupply[mixer] == maxCommonWeaponSupply[mixer]) {
            require(typeIterations < weaponType.length);
            mixer += 1;
            if(mixer > weaponType.length) {
                mixer -= weaponType.length;
            }

            typeIterations += 1;
        }
        
        if (typeIterations >= weaponType.length) {
            return (0);
        }

        uint256[2] memory _currentSupplyInfo = [commonCurrentSupply + 1, currentCommonWeaponSupply[mixer] + 1];

        _createWeapon(
            _currentSupplyInfo,
            1,
            mixer,
            0,
            commonBaseStat[0],
            commonBaseStat[1]
        );

        commonCurrentSupply += 1;
        currentCommonWeaponSupply[mixer] += 1;

        uint256 tokenID = _tokenIdCounter.current();
        _safeMint(_owner);

        return (tokenID);

    }

    /* NFT drop logic functions */

    function dropSpecific(
        address _owner,
        uint256 _weaponStatus,
        uint256 _weaponType
    ) external whenNotPaused onlyOwner {
        
        uint256 _weaponStatusIndex;
        uint256 _weaponTypeIndex;
        uint256 _baseEndurance;
        uint256 _baseAttack;

        addSpecificMaxWeaponSupply(_weaponStatus, _weaponType, 1);

        if (_weaponStatus == 0) {
            _weaponStatusIndex = rareCurrentSupply + 1;
            _weaponTypeIndex = currentRareWeaponSupply[_weaponType] + 1;
            _baseEndurance = rareBaseStat[0];
            _baseAttack = rareBaseStat[1];
        } else if (_weaponStatus == 1) {
            _weaponStatusIndex = commonCurrentSupply + 1;
            _weaponTypeIndex = currentCommonWeaponSupply[_weaponType] + 1;
            _baseEndurance = commonBaseStat[0];
            _baseAttack = commonBaseStat[1];
        } else {
            _weaponStatusIndex = upgradeCurrentSupply + 1;
            _weaponTypeIndex = currentSpecificUpgradeWeaponSupply[_weaponStatus][_weaponType] + 1;
            _baseEndurance = upgradeBaseStat[0];
            _baseAttack = upgradeBaseStat[1];
        }

        uint256[2] memory _currentSupplyInfo = [_weaponStatusIndex, _weaponTypeIndex];

        _createWeapon(
            _currentSupplyInfo,
            _weaponStatus,
            _weaponType,
            0,
            _baseEndurance,
            _baseAttack
        );

        if (_weaponStatus == 0) {
            rareCurrentSupply += 1;
            currentRareWeaponSupply[_weaponType] += 1;
        } else if (_weaponStatus == 1) {
            commonCurrentSupply += 1;
            currentCommonWeaponSupply[_weaponType] += 1;
        } else {
            upgradeCurrentSupply += 1;
            currentSpecificUpgradeWeaponSupply[_weaponStatus][_weaponType] += 1;
        }

        _safeMint(_owner);
    }

    function dropRandom(
        address[] memory _owner
    ) external whenNotPaused onlyOwner {
        for(uint256 i = 0; i < _owner.length; i++) {
            uint256 userAddress = uint256(uint160(_owner[i]));
            uint256 weaponMixer = weaponStatus.length + weaponType.length;
            uint256 targetBlock = block.number + weaponMixer;
            uint256 random = randomizer.randomNGenerator(userAddress, block.timestamp, targetBlock);

            uint256 rareCheck = randomizer.sliceNumber(random, 10, rarePercentage[1], weaponMixer);

            if (rareCheck <= rarePercentage[0]) {
                _mintRareDrop(_owner[i]);
            } else {
                _mintCommonDrop(_owner[i]);
            }
        }

    }

    function mobDropRare(
        address _owner
    ) external whenNotPaused authorized returns (uint256) {
        return _mintRareDrop(_owner);
    }

    function _mintRareDrop(address _owner) internal returns (uint256) {
        require(rareCurrentSupply < maxWeaponSupply[0]);

        uint256 mixer = _mixer(_owner);

        addSpecificMaxWeaponSupply(0, mixer, 1);

        uint256[2] memory _currentSupplyInfo = [rareCurrentSupply + 1, currentRareWeaponSupply[mixer] + 1];

        _createWeapon(
            _currentSupplyInfo,
            0,
            mixer,
            0,
            rareBaseStat[0],
            rareBaseStat[1]
        );

        rareCurrentSupply += 1;
        currentRareWeaponSupply[mixer] += 1;

        uint256 tokenID = _tokenIdCounter.current();
        _safeMint(_owner);

        return tokenID;
    }

    function _mintCommonDrop(address _owner) internal returns (uint256) {
        require(commonCurrentSupply < maxWeaponSupply[1]);

        uint256 mixer = _mixer(_owner);

        addSpecificMaxWeaponSupply(1, mixer, 1);

        uint256[2] memory _currentSupplyInfo = [commonCurrentSupply + 1, currentCommonWeaponSupply[mixer] + 1];

        _createWeapon(
            _currentSupplyInfo,
            1,
            mixer,
            0,
            commonBaseStat[0],
            commonBaseStat[1]
        );

        commonCurrentSupply += 1;
        currentCommonWeaponSupply[mixer] += 1;

        uint256 tokenID = _tokenIdCounter.current();
        _safeMint(_owner);

        return tokenID;
    }

    /* NFT ERC logic functions */

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        whenNotPaused
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

}
