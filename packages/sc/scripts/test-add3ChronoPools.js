const hre = require("hardhat");

const {
    ethers
} = hre;
const {
    parseEther
} = ethers.utils;

//set CHRONOPOOL=XXXXXXXXXXXXXX
//npx hardhat run --network bscTestnet scripts/test-add3ChronoPools.js
async function main() {

    if (undefined == process.env.CHRONOPOOL)
        throw new Error('env CHRONOPOOL is needed');

    const chronoPoolServiceAddress = process.env.CHRONOPOOL;
    const chronoPoolService = await ethers.getContractAt("ChronoPoolService", chronoPoolServiceAddress);

    console.log(`starting .. will take some time.. chronoPoolService : ${chronoPoolService.address}`);

    let vestPeriod = 86400 * 7; // 7 days
    let ffBasis = 100; // 1%
    let aprBasis = 2 * 10000; // 2 000%

    await chronoPoolService.addChronoPool(
        ffBasis,
        vestPeriod,
        aprBasis
    );

    vestPeriod = 86400 * 30; // 30 days
    ffBasis = 300; // 3%
    aprBasis = 5 * 10000; // 5000%

    await chronoPoolService.addChronoPool(
        ffBasis,
        vestPeriod,
        aprBasis
    );

    vestPeriod = 31557600; // 1 year
    ffBasis = 500; // 5%
    aprBasis = 10 * 10000; // 10000%

    await chronoPoolService.addChronoPool(
        ffBasis,
        vestPeriod,
        aprBasis
    );

    console.log("added 3 pools");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });