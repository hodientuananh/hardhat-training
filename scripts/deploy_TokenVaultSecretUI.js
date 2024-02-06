const hre = require("hardhat");

async function main() {
    const TokenVault = await hre.ethers.getContractFactory("TokenVaultSecretUI");
    const tokenVault = await TokenVault.deploy();
    await tokenVault.waitForDeployment();

    console.log("TokenVault Secret deployed to:", await tokenVault.getAddress());
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });