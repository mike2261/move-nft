/*
/// Module: move_102
module move_102::move_102;
*/

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions


module move_102::my_nft;

use std::string;
use sui::package;
use sui::display;

public struct MyNFT has key, store {
    id: UID,
    name: string::String,
    description: string::String,
    image_url: string::String,
}

public struct Registry has key, store {
    id: object::UID,
    nfts: vector<object::ID>,
}

fun init(ctx: &mut TxContext) {
    let registry = Registry {
        id: object::new(ctx),
        nfts: vector::empty<object::ID>(),
    };
    transfer::transfer(registry, tx_context::sender(ctx));
}
    
public fun mint(
    registry: &mut Registry,
    name: string::String,
    url: string::String,
    ctx: &mut TxContext
) {
    let nft = MyNFT {
        id: object::new(ctx),
        name,
        description,
        image_url,
    };
    let nft_id = object::id(&nft);
    vector::push_back(&mut registry.nfts, nft_id);
    transfer::transfer(nft, tx_context::sender(ctx));
}

public fun create_display(ctx: &mut TxContext) {
    display::new_display<MyNFT>(
        ctx,
        vector[
            (string::utf8(b"name"), string::utf8(b"{name}")),
            (string::utf8(b"description"), string::utf8(b"{description}")),
            (string::utf8(b"image_url"), string::utf8(b"{image_url}")),
        ]
    );
}