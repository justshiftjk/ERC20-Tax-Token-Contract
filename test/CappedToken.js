var assertRevert = require("../utils/assertRevert.js");

var CappedToken = artifacts.require('TaxableTokenMock');

contract('Capped', function (accounts) {
  const cap = 1000;

  let token;

  beforeEach(async function () {
    token = await CappedToken.new(cap,10,10);
  });

  it('should start with the correct cap', async function () {
    let _cap = await token.cap();

    assert.equal(cap,_cap);
  });

  it('should mint when amount is less than cap', async function () {
    await token.burn(100,{from : accounts[0]})
    const result = await token.mint(accounts[0], 100);
    assert.equal(result.logs[0].event, 'Mint');
  });

  it('should fail to mint if the ammount exceeds the cap', async function () {
    await token.burn(cap,{from : accounts[0]})
    await token.mint(accounts[0], cap - 1);
    await assertRevert(token.mint(accounts[0], 100));
  });

  it('should fail to mint after cap is reached', async function () {
    await token.burn(cap,{from : accounts[0]})
    await token.mint(accounts[0], cap);
    await assertRevert(token.mint(accounts[0], 1));
  });
});