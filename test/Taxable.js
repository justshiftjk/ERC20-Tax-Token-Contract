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
    let cansetPercentage = await taxable.cansetPercentage();
    let canChangeMinimunFee = await taxable.canChangeMinimunFee();
    assert(cansetPercentage);
    assert(canChangeMinimunFee);
  });

  it('setPercentage should revert if it is not called from owner', async function () {
    await assertRevert(taxable.setPercentage(10,{from : anotherAccount}))
  });

  it('setMinimunFee should revert if it is not called from owner', async function () {
    await assertRevert(taxable.setMinimunFee(100,{from : anotherAccount}))
  });

  it('setPercentage should revert if the new percentage is 100 or higher', async function () {
    await assertRevert(taxable.setPercentage(100,{from : owner}))
    await assertRevert(taxable.setPercentage(101,{from : owner}))
  });

  it('stopSetPercentage should revert if it is not called from owner', async function () {
    await assertRevert(taxable.stopSetPercentage({from : anotherAccount}))
  });

  it('stopSetMinimunFee should revert if it is not called from owner', async function () {
    await assertRevert(taxable.stopSetMinimunFee({from : anotherAccount}))
  });

  it('should not be able to stop change percentage twice', async function () {
    await taxable.stopSetPercentage({from : owner});
    await assertRevert(taxable.stopSetPercentage({from : owner}))
  });

  it('should not be able to stop change minimun fee twice', async function () {
    await taxable.stopSetMinimunFee({from : owner});
    await assertRevert(taxable.stopSetMinimunFee({from : owner}))
  });

  it('should not be able to change minimun fee after it stop change minimun fee', async function () {
    await taxable.stopSetMinimunFee({from : owner});
    await assertRevert(taxable.setMinimunFee(10,{from : owner}))
  });

  it('should not be able to change percentage after it stop change percentage', async function () {
    await taxable.stopSetPercentage({from : owner});
    await assertRevert(taxable.setPercentage(10,{from : owner}))
  });

  it('should be able to change percentage', async function () {
    await taxable.setPercentage(10,{from : owner});
    let percentage = await taxable.percentage();
    assert.equal(percentage,10);
  });

  it('should be able to change the minimun fee', async function () {
    await taxable.setMinimunFee(10,{from : owner});
    let fee = await taxable.minimunFee();
    assert.equal(fee,10);
  });

  it('setMinimunFee should return true', async function () {
    let result = await taxable.setMinimunFee(10,{from : owner});
    assert(result);
  });

  it('setPercentage should return true', async function () {
    let result = await taxable.setPercentage(10,{from : owner});
    assert(result);
  });

  it('stopSetPercentage should return true', async function () {
    let result = await taxable.stopSetPercentage({from : owner});
    assert(result);
  });

  it('stopSetMinimunFee should return true', async function () {
    let result = await taxable.stopSetMinimunFee({from : owner});
    assert(result);
  });
});