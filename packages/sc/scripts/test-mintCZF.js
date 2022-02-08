const hre = require("hardhat");

const {
    ethers
} = hre;
const {
    parseEther
} = ethers.utils;

//set CHRONOPOOL=XXXXXXXXXXXXXX
//set MINTFOR=XXXXXXXXXXXXXXXXXXXXXXXXXx
//npx hardhat run --network bscTestnet scripts/test-mintCZF.js
async function main() {

    if (undefined == process.env.CZFARM)
        throw new Error('env CZFARM is needed');

    if (undefined == process.env.MINTFOR)
        throw new Error('env MINTFOR is needed');
    
    const czfToken = await ethers.getContractAt("CZFarm", process.env.CZFARM);

    console.log(`starting .. will take some time ... mintFor = ${process.env.MINTFOR}   czfToken : ${czfToken.address}`);

    await czfToken.mint(process.env.MINTFOR,parseEther("2000000000"));
    
    console.log("mint complete");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });