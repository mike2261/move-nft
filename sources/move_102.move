module move_102::my_nft {

    use std::string::{Self, String};
    use std::vector;
    use sui::object;
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;

    /// NFT struct
    public struct NFT has key, store {
        id: object::UID,
        name: String,
        description: String,
        image_url: String,
    }

    /// Template struct used to define NFT samples
    public struct NFTTemplate has store {
        name: String,
        description: String,
        image_url: String,
    }

    /// Registry struct to store templates
    public struct Registry has key, store {
        id: object::UID,
        templates: vector<NFTTemplate>,
    }

    /// Initialize: create an empty registry and give it to sender
    fun init(ctx: &mut TxContext) {
        let registry = Registry {
            id: object::new(ctx),
            templates: vector::empty<NFTTemplate>(),
        };
        transfer::public_transfer(registry, tx_context::sender(ctx));
    }

    /// Add a new NFT template to registry
    public fun add_template(
        registry: &mut Registry,
        name: String,
        description: String,
        image_url: String,
        _ctx: &mut TxContext,
    ) {
        let template = NFTTemplate { name, description, image_url };
        vector::push_back(&mut registry.templates, template);
    }

    /// Mint NFT from an existing template
    public fun mint_from_template(
        registry: &Registry,
        index: u64,
        ctx: &mut TxContext,
    ) {
        let tpl = vector::borrow(&registry.templates, index);
        let nft = NFT {
            id: object::new(ctx),
            name: tpl.name,
            description: tpl.description,
            image_url: tpl.image_url,
        };
        transfer::public_transfer(nft, tx_context::sender(ctx));
    }

    //TODO: add functions to display NFT info
}
