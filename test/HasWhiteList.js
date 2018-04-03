var assertRevert = require("../utils/assertRevert.js");

var HasWhiteList = artifacts.require('HasWhiteList');

contract('HasWhiteList', function (accounts) {

  let contract;
  const owner = accounts[0];
  const anotherAccount = accounts[1];

  beforeEach(async function () {
    contract = await HasWhiteList.new({from: owner});
  });

  it("should't add an account if sender is not the owner",async function(){
    await assertRevert(contract.addWhitelistedAccount(owner,10,10,{from : anotherAccount}));
  })

  it("should't remove an account if it's not in the whitelists",async function(){
    await assertRevert(contract.deleteWhitelistedAccount(owner,{from : owner}));
  })

  it("shouldn't remove an account if sender is not the owner",async function(){
    await contract.addWhitelistedAccount(owner,10,10,{from : owner});
    await assertRevert(contract.deleteWhitelistedAccount(owner,{from : anotherAccount}));
  })

  it("shouldn't add an account if that account already exist",async function(){
    await contract.addWhitelistedAccount(owner,10,10,{from : owner});
    await assertRevert(contract.addWhitelistedAccount(owner,10,10,{from : owner}));
  })
  
  it("shouldn't add an account if that account is 0x0",async function(){
    await assertRevert(contract.addWhitelistedAccount('0x0',10,10,{from : owner}));
  })
  
  it("should add an account and delete an account",async function(){
    await contract.addWhitelistedAccount(owner,10,15,{from : owner});
    let isIn = await contract.isInTheWhiteList(owner);
    let minimunFee = await contract.getWhitelistedMinimunFee(owner);
    let percentage = await contract.getWhitelistedPercentage(owner);
    assert(isIn);
    assert.equal(minimunFee,15);
    assert.equal(percentage,10);
    await contract.deleteWhitelistedAccount(owner,{from : owner});
    isIn = await contract.isInTheWhiteList(owner);
    minimunFee = await contract.getWhitelistedMinimunFee(owner);
    percentage = await contract.getWhitelistedPercentage(owner);
    assert(!isIn);
    assert.equal(percentage,0);
    assert.equal(minimunFee,0);
  })

  it("shouldn't modify minimunFee if the sender is not the ownner",async function(){
    await contract.addWhitelistedAccount(owner,10,10,{from : owner});
    await assertRevert(contract.changeWhitelistedMinimunFee(owner,20,{from : anotherAccount}));
  })

  it("shouldn't modify percentage if the sender is not the ownner",async function(){
    await contract.addWhitelistedAccount(owner,10,10,{from : owner});
    await assertRevert(contract.changeWhitelistedPercentage(owner,20,{from : anotherAccount}));
  })

  it("shouldn't modify minimunFee if the account isn't in whitelist",async function(){
    await assertRevert(contract.changeWhitelistedMinimunFee(owner,20,{from : owner}));
  })

  it("shouldn't modify percentage if the account isn't in whitelist",async function(){
    await assertRevert(contract.changeWhitelistedPercentage(owner,20,{from : owner}));
  })

  it("shouldn't modify percentage if the new percentage is 100 or higher",async function(){
    await contract.addWhitelistedAccount(owner,10,10,{from : owner});    
    await assertRevert(contract.changeWhitelistedPercentage(owner,100,{from : owner}));
    await assertRevert(contract.changeWhitelistedPercentage(owner,101,{from : owner}));
  })

  it("shouldn't modify percentage if the new percentage is equal to the old one",async function(){
    await contract.addWhitelistedAccount(owner,0,0,{from : owner});    
    await contract.changeWhitelistedPercentage(owner,10,{from : owner});
    await assertRevert(contract.changeWhitelistedPercentage(owner,10,{from : owner}));
  })

  it("shouldn't modify minimunFee if the new fee is equal to the old one",async function(){
    await contract.addWhitelistedAccount(owner,0,0,{from : owner});    
    await contract.changeWhitelistedMinimunFee(owner,10,{from : owner});
    await assertRevert(contract.changeWhitelistedMinimunFee(owner,10,{from : owner}));
  })

  it("should modify percentage and minimunFee",async function(){
    await contract.addWhitelistedAccount(owner,0,0,{from : owner});    
    await contract.changeWhitelistedPercentage(owner,10,{from : owner});
    let result = await contract.getWhitelistedPercentage(owner);
    assert.equal(result,10);
    await contract.changeWhitelistedMinimunFee(owner,10,{from : owner});
    result = await contract.getWhitelistedMinimunFee(owner);
    assert.equal(result,10);
  })
});