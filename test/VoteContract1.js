const { expect } = require("chai");

describe("test vote contract 1", () => {
  it("test initial state", async () => {
    const vc = await ethers.deployContract("VoteContract1_storage");
    expect(await vc.TotalVoters()).to.equal(0);
  });
  it("test make a vote", async () => {
    const vc = await ethers.deployContract("VoteContract1_storage");
    const [addr1, addr2, addr3] = await ethers.getSigners();
    await vc.makeAVote(addr1.address, "Yes");
    await vc.makeAVote(addr2.address, "Yes");
    await vc.makeAVote(addr3.address, "No");
    expect(await vc.TotalVoters()).to.equal(3);
    expect(await vc.TotalPositiveVoters()).to.equal(2);
    expect(await vc.TotalNegativeVoters()).to.equal(1);
    expect(await vc.PositiveVSNegative()).to.equal(true);
  });
  it("test make an incorrect vote", async () => {
    const vc = await ethers.deployContract("VoteContract1_storage");
    const [addr1, addr2, addr3] = await ethers.getSigners();
    await vc.makeAVote(addr1.address, "Yes");
    await vc.makeAVote(addr2.address, "No");
    await vc.makeAVote(addr3.address, "No");
    expect(await vc.TotalVoters()).to.equal(3);
    expect(await vc.TotalPositiveVoters()).to.equal(1);
    expect(await vc.TotalNegativeVoters()).to.equal(2);
    expect(await vc.PositiveVSNegative()).to.equal(false);
    expect(vc.makeAVote(addr3.address, "Yes"))
      .to.be.revertedWithCustomError(vc, "AlreadyVotedError")
      .withArgs(addr3.address, "Yes");
    expect(vc.makeAVote(addr3.address, "Yep"))
      .to.be.revertedWithCustomError(vc, "InvalidResult")
      .withArgs(addr3.address);
    expect(vc.makeAVote(addr1.address, "No"))
      .to.be.revertedWithCustomError(vc, "InvalidResult")
      .withArgs(addr1.address);
  });
  it("test is voted", async () => {
    const vc = await ethers.deployContract("VoteContract1_storage");
    const [addr1, addr2] = await ethers.getSigners();
    await vc.makeAVote(addr1.address, "Yes");
    expect(await vc.IsVoted(addr1.address)).to.equal(true);
    expect(await vc.IsVoted(addr2.address)).to.equal(false);
  });
  it("test", async () => {
    const vc = await ethers.deployContract("VoteContract1_storage");
    const [
      addr1,
      addr2,
      addr3,
      addr4,
      addr5,
      addr6,
      addr7,
      addr8,
      addr9,
      addr10,
      addr11,
      addr12,
      addr13,
    ] = await ethers.getSigners();
    await vc.makeAVote(addr1.address, "Yes");
    await vc.makeAVote(addr2.address, "Yes");
    await vc.makeAVote(addr3.address, "Yes");
    await vc.makeAVote(addr4.address, "Yes");
    await vc.makeAVote(addr5.address, "Yes");
    await vc.makeAVote(addr6.address, "No");
    await vc.makeAVote(addr7.address, "No");
    await vc.makeAVote(addr8.address, "No");
    await vc.makeAVote(addr9.address, "No");
    await vc.makeAVote(addr10.address, "No");
    await vc.makeAVote(addr11.address, "No");
    await vc.makeAVote(addr12.address, "Yes");
    await vc.makeAVote(addr13.address, "Yes");

    expect(await vc.TotalVoters()).to.equal(13);
    expect(await vc.TotalPositiveVoters()).to.equal(7);
    expect(await vc.TotalNegativeVoters()).to.equal(6);
  });
});
