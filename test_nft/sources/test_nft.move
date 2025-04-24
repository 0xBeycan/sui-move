#[allow(lint(custom_state_change))]

module test_nft::Test_NFT;

use std::string;
use sui::event;
use sui::url::{Self, Url};

/// An example NFT that can be minted by anybody
public struct TEST_NFT has key, store {
    id: UID,
    /// Name for the token
    name: string::String,
    /// Description of the token
    description: string::String,
    /// URL for the token
    url: Url,
}

// ===== Events =====

public struct NFTMinted has copy, drop {
    // The Object ID of the NFT
    object_id: ID,
    // The creator of the NFT
    creator: address,
    // The name of the NFT
    name: string::String,
}

// ===== Public view functions =====

public fun name(nft: &TEST_NFT): &string::String {
    &nft.name
}

public fun symbol(): string::String {
    string::utf8(b"TNFT")
}

public fun description(nft: &TEST_NFT): &string::String {
    &nft.description
}

public fun url(nft: &TEST_NFT): &Url {
    &nft.url
}

// ===== Entrypoints =====

/// Create a new devnet_nft
public entry fun mint_to_sender(
    name: vector<u8>,
    description: vector<u8>,
    url: vector<u8>,
    ctx: &mut TxContext,
) {
    let sender = tx_context::sender(ctx);
    let nft = TEST_NFT {
        id: object::new(ctx),
        name: string::utf8(name),
        description: string::utf8(description),
        url: url::new_unsafe_from_bytes(url),
    };

    event::emit(NFTMinted {
        object_id: object::id(&nft),
        creator: sender,
        name: nft.name,
    });

    transfer::transfer(nft, sender);
}

public entry fun transfer(nft: TEST_NFT, recipient: address, _: &mut TxContext) {
    transfer::transfer(nft, recipient)
}

public entry fun update_description(
    nft: &mut TEST_NFT,
    new_description: vector<u8>,
    _: &mut TxContext,
) {
    nft.description = string::utf8(new_description)
}

public entry fun burn(nft: TEST_NFT, _: &mut TxContext) {
    let TEST_NFT { id, name: _, description: _, url: _ } = nft;
    object::delete(id)
}
