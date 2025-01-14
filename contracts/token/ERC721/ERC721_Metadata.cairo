%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import HashBuiltin, SignatureBuiltin
from starkware.cairo.common.uint256 import Uint256

from openzeppelin.token.erc721.library import ERC721

from openzeppelin.introspection.erc165.library import ERC165

//
// Storage
//

@storage_var
func ERC721_metadata(token_id: Uint256, index: felt) -> (res: felt) {
}

@storage_var
func ERC721_metadata_len(token_id: Uint256) -> (res: felt) {
}

//
// Constructor
//

func ERC721_Metadata_initializer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) {
    // register IERC721_Metadata
    ERC165.register_interface(0x5b5e139f);
    return ();
}

func ERC721_Metadata_tokenURI{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    token_id: Uint256
) -> (token_uri_len: felt, token_uri: felt*) {
    alloc_locals;

    let (local token_uri) = alloc();
    let (local token_uri_len) = ERC721_metadata_len.read(token_id=token_id);

    _ERC721_Metadata_TokenURI(token_id, token_uri_len, token_uri);

    return (token_uri_len=token_uri_len, token_uri=token_uri);
}

func _ERC721_Metadata_TokenURI{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    token_id: Uint256, token_uri_len: felt, token_uri: felt*
) {
    if (token_uri_len == 0) {
        return ();
    }
    let (base) = ERC721_metadata.read(token_id, token_uri_len);
    assert [token_uri] = base;
    _ERC721_Metadata_TokenURI(
        token_id=token_id, token_uri_len=token_uri_len - 1, token_uri=token_uri + 1
    );
    return ();
}

func ERC721_Metadata_setTokenURI{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    token_id: Uint256, token_uri_len: felt, token_uri: felt*
) {
    _ERC721_Metadata_setTokenURI(token_id, token_uri_len, token_uri);
    ERC721_metadata_len.write(token_id, token_uri_len);
    return ();
}

func _ERC721_Metadata_setTokenURI{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    token_id: Uint256, token_uri_len: felt, token_uri: felt*
) {
    if (token_uri_len == 0) {
        return ();
    }
    ERC721_metadata.write(token_id, token_uri_len, [token_uri]);
    _ERC721_Metadata_setTokenURI(
        token_id, token_uri_len=token_uri_len - 1, token_uri=token_uri + 1
    );
    return ();
}
