import workshop_ofac.aleo;
import private_token_workshop.aleo;
program test_token.aleo;

function test_mint_private:
    call private_token_workshop.aleo/mint_private aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px 50u64 into r0 r1;
    assert.eq r0.owner aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px;
    assert.eq r0.amount 50u64;

function test_transfer_private:
    call private_token_workshop.aleo/mint_private aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px 150u64 into r0 r1;
    call private_token_workshop.aleo/transfer_private r0 aleo1s3ws5tra87fjycnjrwsjcrnw2qxr8jfqqdugnf0xzqqw29q9m5pqem2u4t 60u64 into r2 r3 r4;
    assert.eq r2.owner aleo1s3ws5tra87fjycnjrwsjcrnw2qxr8jfqqdugnf0xzqqw29q9m5pqem2u4t;
    assert.eq r2.amount 60u64;
    assert.eq r3.owner aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px;
    assert.eq r3.amount 90u64;

function test_chain_transfer_private:
    call private_token_workshop.aleo/mint_private aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px 300u64 into r0 r1;
    call private_token_workshop.aleo/transfer_private r0 aleo1s3ws5tra87fjycnjrwsjcrnw2qxr8jfqqdugnf0xzqqw29q9m5pqem2u4t 100u64 into r2 r3 r4;
    assert.eq r2.owner aleo1s3ws5tra87fjycnjrwsjcrnw2qxr8jfqqdugnf0xzqqw29q9m5pqem2u4t;
    assert.eq r2.amount 100u64;
    assert.eq r3.amount 200u64;
    call private_token_workshop.aleo/transfer_private r2 aleo1fxs9s0w97lmkwlcmgn0z3nuxufdee5yck9wqrs0umevp7qs0sg9q5xxxzh 50u64 into r5 r6 r7;
    assert.eq r5.owner aleo1fxs9s0w97lmkwlcmgn0z3nuxufdee5yck9wqrs0umevp7qs0sg9q5xxxzh;
    assert.eq r5.amount 50u64;
    assert.eq r6.owner aleo1s3ws5tra87fjycnjrwsjcrnw2qxr8jfqqdugnf0xzqqw29q9m5pqem2u4t;
    assert.eq r6.amount 50u64;

function test_transfer_all_private:
    call private_token_workshop.aleo/mint_private aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px 100u64 into r0 r1;
    call private_token_workshop.aleo/transfer_private r0 aleo1s3ws5tra87fjycnjrwsjcrnw2qxr8jfqqdugnf0xzqqw29q9m5pqem2u4t 100u64 into r2 r3 r4;
    assert.eq r2.owner aleo1s3ws5tra87fjycnjrwsjcrnw2qxr8jfqqdugnf0xzqqw29q9m5pqem2u4t;
    assert.eq r2.amount 100u64;
    assert.eq r3.owner aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px;
    assert.eq r3.amount 0u64;

constructor:
    assert.eq edition 0u16;
