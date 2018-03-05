var assertRevert = require("../utils/assertRevert.js");

var Taxable = artifacts.require('Taxable');

contract('Taxable', function (accounts) {

  let taxable;
  const owner = accounts[0];
  const anotherAccount = accounts[1];

  beforeEach(async function () {
    taxable = await Taxable.new({from: owner});
  });

  it('should start with the correct state variables', async function () {
    let canChangePercentage = await taxable.canChangePercentage();
    let canChangeMinimunFee = await taxable.canChangeMinimunFee();
    assert(canChangePercentage);
    assert(canChangeMinimunFee);
  });

  it('changePercentage should revert if it is not called from owner', async function () {
    await assertRevert(taxable.changePercentage(10,{from : anotherAccount}))
  });

  it('changeMinimunFee should revert if it is not called from owner', async function () {
    await assertRevert(taxable.changeMinimunFee(100,{from : anotherAccount}))
  });

  it('changePercentage should revert if the new percentage is 100 or higher', async function () {
    await assertRevert(taxable.changePercentage(100,{from : owner}))
    await assertRevert(taxable.changePercentage(101,{from : owner}))
  });

  it('stopChangePercentage should revert if it is not called from owner', async function () {
    await assertRevert(taxable.stopChangePercentage({from : anotherAccount}))
  });

  it('stopChangeMinimunFee should revert if it is not called from owner', async function () {
    await assertRevert(taxable.stopChangeMinimunFee({from : anotherAccount}))
  });

  it('should not be able to stop change percentage twice', async function () {
    await taxable.stopChangePercentage({from : owner});
    await assertRevert(taxable.stopChangePercentage({from : owner}))
  });

  it('should not be able to stop change minimun fee twice', async function () {
    await taxable.stopChangeMinimunFee({from : owner});
    await assertRevert(taxable.stopChangeMinimunFee({from : owner}))
  });

  it('should not be able to change minimun fee after it stop change minimun fee', async function () {
    await taxable.stopChangeMinimunFee({from : owner});
    await assertRevert(taxable.changeMinimunFee(10,{from : owner}))
  });

  it('should not be able to change percentage after it stop change percentage', async function () {
    await taxable.stopChangePercentage({from : owner});
    await assertRevert(taxable.changePercentage(10,{from : owner}))
  });

  it('should be able to change percentage', async function () {
    await taxable.changePercentage(10,{from : owner});
    let percentage = await taxable.percentage();
    assert.equal(percentage,10);
  });

  it('should be able to change the minimun fee', async function () {
    await taxable.changeMinimunFee(10,{from : owner});
    let fee = await taxable.minimunFee();
    assert.equal(fee,10);
  });

  it('changeMinimunFee should return true', async function () {
    let result = await taxable.changeMinimunFee(10,{from : owner});
    assert(result);
  });

  it('changePercentage should return true', async function () {
    let result = await taxable.changePercentage(10,{from : owner});
    assert(result);
  });

  it('stopChangePercentage should return true', async function () {
    let result = await taxable.stopChangePercentage({from : owner});
    assert(result);
  });

  it('stopChangeMinimunFee should return true', async function () {
    let result = await taxable.stopChangeMinimunFee({from : owner});
    assert(result);
  });
});