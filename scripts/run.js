async function main() {
    const [owner, randoPerson] = await hre.ethers.getSigners();
    const startupContractFactory = await hre.ethers.getContractFactory("StartupPortal");
    const startupContract = await startupContractFactory.deploy({value: hre.ethers.utils.parseEther("0.005")});
    await startupContract.deployed();
    console.log("Contract deployed to: ", startupContract.address);
    console.log("Contract deployed by: ", owner.address);

    let contractBalance = await hre.ethers.provider.getBalance(startupContract.address)
    console.log("Contract balance:", hre.ethers.utils.formatEther(contractBalance))

    let ideaTxn = await startupContract.idea("This is a message 1!")
    await ideaTxn.wait()

    ideaTxn = await startupContract.idea("This is a message 2!")
    await ideaTxn.wait()

    contractBalance = await hre.ethers.provider.getBalance(startupContract.address)
    console.log("Contract balance:", hre.ethers.utils.formatEther(contractBalance))

    let allIdeas = await startupContract.getAllIdeas();
    console.log(allIdeas);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    })