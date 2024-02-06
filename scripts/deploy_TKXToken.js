const hre = require("hardhat");

async function main() {
    const Token = await hre.ethers.getContractFactory("TKXToken");
    const [owner] = await hre.ethers.getSigners();
    const token = await Token.deploy(owner.address);
    await token.waitForDeployment();

    console.log("Token deployed", await token.getAddress());
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });