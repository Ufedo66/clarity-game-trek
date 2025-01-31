import { Clarinet, Tx, Chain, Account, types } from 'https://deno.land/x/clarinet@v0.14.0/index.ts';
import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';

Clarinet.test({
  name: "Battle system executes combat and updates stats correctly",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const wallet_1 = accounts.get("wallet_1")!;
    
    // Create character first
    let block = chain.mineBlock([
      Tx.contractCall(
        "character",
        "create-character",
        [types.utf8("Hero")],
        wallet_1.address
      )
    ]);
    
    assertEquals(block.receipts[0].result.expectOk(), "u1");
    
    // Battle monster
    block = chain.mineBlock([
      Tx.contractCall(
        "battle",
        "battle-monster",
        [types.uint(1), types.uint(1)],
        wallet_1.address
      )
    ]);
    
    const battleResult = block.receipts[0].result.expectOk().expectTuple();
    assertEquals(battleResult['damage-dealt'], types.uint(7));
    assertEquals(battleResult['damage-taken'], types.uint(5));
    assertEquals(battleResult['exp-gained'], types.uint(10));
  },
});
