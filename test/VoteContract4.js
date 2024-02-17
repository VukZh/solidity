const { expect } = require("chai");

describe("test vote contract 4", () => {
  it("test initial state", async () => {
    const vc = await ethers.deployContract("VoteContract4_yul");
    const arrOfVoters = await vc.getArrayOfVoters();
    expect(await vc.TotalVoters([...arrOfVoters])).to.equal(0);
  });
  it("test make a vote", async () => {
    const vc = await ethers.deployContract("VoteContract4_yul");
    const [addr1, addr2, addr3] = await ethers.getSigners();
    await vc.makeAVote(addr1.address, "Yes");
    await vc.makeAVote(addr2.address, "Yes");
    await vc.makeAVote(addr3.address, "No");
    const arrOfVoters = await vc.getArrayOfVoters();
    expect(await vc.TotalVoters([...arrOfVoters])).to.equal(3);
    expect(await vc.TotalPositiveVoters([...arrOfVoters])).to.equal(2);
    expect(await vc.TotalNegativeVoters([...arrOfVoters])).to.equal(BigInt(1n));
    expect(await vc.PositiveVSNegative([...arrOfVoters])).to.equal(true);
  });
  it("test make an incorrect vote", async () => {
    const vc = await ethers.deployContract("VoteContract4_yul");
    const [addr1, addr2, addr3] = await ethers.getSigners();
    await vc.makeAVote(addr1.address, "Yes");
    await vc.makeAVote(addr2.address, "No");
    await vc.makeAVote(addr3.address, "No");
    const arrOfVoters = await vc.getArrayOfVoters();
    expect(await vc.TotalVoters([...arrOfVoters])).to.equal(3);
    expect(await vc.TotalPositiveVoters([...arrOfVoters])).to.equal(1);
    expect(await vc.TotalNegativeVoters([...arrOfVoters])).to.equal(BigInt(2));
    expect(await vc.PositiveVSNegative([...arrOfVoters])).to.equal(false);
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
    const vc = await ethers.deployContract("VoteContract4_yul");
    const [addr1, addr2] = await ethers.getSigners();
    await vc.makeAVote(addr1.address, "Yes");
    const arrOfVoters = await vc.getArrayOfVoters();
    expect(await vc.IsVoted(addr1.address, [...arrOfVoters])).to.equal(true);
    expect(await vc.IsVoted(addr2.address, [...arrOfVoters])).to.equal(false);
  });
  it("test", async () => {
    const vc = await ethers.deployContract("VoteContract4_yul");
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
    const arrOfVoters = await vc.getArrayOfVoters();

    expect(await vc.TotalVoters([...arrOfVoters])).to.equal(13);
    expect(await vc.TotalPositiveVoters([...arrOfVoters])).to.equal(7);
    expect(await vc.TotalNegativeVoters([...arrOfVoters])).to.equal(6);
  });
});
