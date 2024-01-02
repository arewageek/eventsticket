import { ethers } from "hardhat";

async function main(){
  const creator = ethers.getAddress[0]
  const cost = 2000
  const totalMints = 30;
  const eventTickets = ethers.deployContract(cost, totalMints)

  await eventTickets.waitForDeployment();
  console.log("EventTickets Contract has been deployed")
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});


