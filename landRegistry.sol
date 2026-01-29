// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LandRegistry {

    struct Land {
        uint256 landId;
        string ownerName;
        string location;
        uint256 price;
        address owner;
        bool exists;
    }

    mapping(uint256 => Land) public lands;
    uint256[] public landIds;   // ✅ NEW

    event LandRegistered(
        uint256 landId,
        string ownerName,
        string location,
        uint256 price,
        address owner
    );

    event OwnershipTransferred(
        uint256 landId,
        address oldOwner,
        address newOwner,
        string newOwnerName
    );

    function registerLand(
        uint256 _landId,
        string memory _ownerName,
        string memory _location,
        uint256 _price
    ) public {
        require(!lands[_landId].exists, "Land ID already exists");

        lands[_landId] = Land(
            _landId,
            _ownerName,
            _location,
            _price,
            msg.sender,
            true
        );

        landIds.push(_landId); // ✅ STORE ID

        emit LandRegistered(_landId, _ownerName, _location, _price, msg.sender);
    }

    function transferLand(
        uint256 _landId,
        address _newOwner,
        string memory _newOwnerName
    ) public {
        require(lands[_landId].exists, "Land not found");
        require(msg.sender == lands[_landId].owner, "Only owner can transfer");

        address oldOwner = lands[_landId].owner;
        lands[_landId].owner = _newOwner;
        lands[_landId].ownerName = _newOwnerName;

        emit OwnershipTransferred(_landId, oldOwner, _newOwner, _newOwnerName);
    }

    function getLand(uint256 _landId)
        public
        view
        returns (
            uint256,
            string memory,
            string memory,
            uint256,
            address
        )
    {
        require(lands[_landId].exists, "Land not found");
        Land memory land = lands[_landId];
        return (
            land.landId,
            land.ownerName,
            land.location,
            land.price,
            land.owner
        );
    }

    // ✅ NEW: GET ALL LAND IDS
    function getAllLandIds() public view returns (uint256[] memory) {
        return landIds;
    }
}
