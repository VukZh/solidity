const main = async () => {
  const [deployer] = await ethers.getSigners();
  console.log("deployer address: ", await deployer.getAddress());
  const hhToken = await ethers.deployContract("V1_ERC20_Token");
  console.log("token address: ", await hhToken.getAddress());
};

main()
  .then(() => process.exit(0))
  .catch((e) => {
    console.error(e);
    process.exit(0);
  });
