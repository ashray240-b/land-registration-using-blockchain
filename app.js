let provider;
let signer;
let contract;

const CONTRACT_ADDRESS = "0x5FbDB2315678afecb367f032d93F642f64180aa3";

const ABI = [
  "function registerLand(uint256,string,uint256) public",
  "function getLand(uint256) public view returns(address,string,uint256,bool)"
];

async function connectWallet() {
  if (!window.ethereum) {
    alert("MetaMask not installed");
    return;
  }

  provider = new ethers.providers.Web3Provider(window.ethereum);
  await provider.send("eth_requestAccounts", []);

  signer = provider.getSigner();
  const address = await signer.getAddress();

  document.getElementById("wallet").innerText =
    "Connected: " + address;

  contract = new ethers.Contract(CONTRACT_ADDRESS, ABI, signer);
}

async function registerLand() {
  const id = document.getElementById("landId").value;
  const loc = document.getElementById("location").value;
  const price = document.getElementById("price").value;

  const tx = await contract.registerLand(
    id,
    loc,
    ethers.utils.parseEther(price)
  );

  await tx.wait();
  alert("Land registered");
}

async function searchLand() {
  const id = document.getElementById("searchId").value;
  const land = await contract.getLand(id);

  document.getElementById("result").innerText =
    `Owner: ${land[0]}
Location: ${land[1]}
Price: ${ethers.utils.formatEther(land[2])} ETH
For Sale: ${land[3]}`;
}

