module test_usdc::Test_USDC;

use sui::coin;
use sui::url;

const SUPPLY: u64 = 100000000;

public struct TEST_USDC has drop {}

fun init(witness: TEST_USDC, ctx: &mut TxContext) {
    let (mut treasury, metadata) = coin::create_currency(
        witness,
        6,
        b"TUSDC",
        b"Test USDC",
        b"Test USDC Token on Sui",
        option::some(url::new_unsafe_from_bytes(b"https://pngimg.com/d/coin_PNG36871.png")),
        ctx,
    );
    transfer::public_freeze_object(metadata);
    coin::mint_and_transfer(&mut treasury, SUPPLY * 10u64.pow(6), tx_context::sender(ctx), ctx);
    transfer::public_transfer(treasury, tx_context::sender(ctx))
}
