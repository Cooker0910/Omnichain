// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8;

import "../ONFT721.sol";

/// @title Interface of the UniversalONFT standard
contract OmniSticks is ONFT721 {
    uint public nextMintId;
    uint public maxMintId;
    uint public mintPrice;

    /// @notice Constructor for the UniversalONFT
    /// @param _name the name of the token
    /// @param _symbol the token symbol
    /// @param _layerZeroEndpoint handles message transmission across chains
    /// @param _startMintId the starting mint number on this chain
    /// @param _endMintId the max number of mints on this chain
    constructor(string memory _name, string memory _symbol, address _layerZeroEndpoint, uint _startMintId, uint _endMintId) ONFT721(_name, _symbol, _layerZeroEndpoint) {
        nextMintId = _startMintId;
        maxMintId = _endMintId;
        mintPrice = 1;
    }

    function _baseURI() internal pure override returns (string memory) {
        return 'https://gateway.pinata.cloud/ipfs/QmcV6GKttyjpqWoMhbC7Jn5XYhx6Gwj8vFejzwv1pffwu5/';
    }

    function setMinPrice(uint _price) external onlyOwner {
        mintPrice = _price;
    }

    /// @notice Mint your ONFT
    function mint() external payable {
        require(nextMintId <= maxMintId, "UniversalONFT721: max mint limit reached");
        require(msg.value >= mintPrice, "Not enough tokens sent");

        uint newId = nextMintId;
        nextMintId++;

        _safeMint(msg.sender, newId);
    }

    function withdraw() public onlyOwner {
        (bool success, ) = payable(owner()).call{value: address(this).balance}("");
        require(success);
    }
}
