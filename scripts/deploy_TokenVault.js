const hre = require("hardhat");

async function main() {
    const TokenVault = await hre.ethers.getContractFactory("TokenVault");
    const tokenVault = await TokenVault.deploy("0x392C03945A0D8809Ccc50656a4fA694C67162786");
    await tokenVault.waitForDeployment();

    console.log("TokenVault deployed to:", await tokenVault.getAddress());
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });