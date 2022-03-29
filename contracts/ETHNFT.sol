// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

contract ETHNFT is ERC721URIStorage {
    //provided by OpenZeppelin to help us keep track of tokenIds.
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string baseSvg =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

  string[] firstWords = ["Purple", "French", "Faceoff", "Cut", "Classic", "Citrus", "Lemon", "Grass", "Indigo", "Wave", "Blue", "Shiny", "Pineapple"];
  string[] secondWords = ["Chloroform", "Liftoff", "Goo", "Chem", "Funk", "Rapture", "Gruesome", "Highlighter", "YourMomma's", "Toe", "Stank", "Burnt", "Crunchy"];
  string[] thirdWords = ["Kush", "Thai", "Crystal", "Berry", "..huh?", "WildRide", "RockCandy", "Cheese", "Killah", "Cream", "Ice", "Cake", "Rust"];

    // Pass the name of NFT and symbol
    constructor() ERC721("ItHappenedNFT", "HAPPN") {
        console.log("This is the beginning of the end!"); 
    }

  // I create a function to randomly pick a word from each array.
  function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
    // I seed the random generator. More on this in the lesson. 
    uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
    // Squash the # between 0 and the length of the array to avoid going out of bounds.
    rand = rand % firstWords.length;
    return firstWords[rand];
  }

  function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
    rand = rand % secondWords.length;
    return secondWords[rand];
  }

  function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
    rand = rand % thirdWords.length;
    return thirdWords[rand];
  }

  function random(string memory input) internal pure returns (uint256) {
      return uint256(keccak256(abi.encodePacked(input)));
  }

    // function to call for user to create NFT
    function makeNFT() public {
    uint256 newItemId = _tokenIds.current();

    // We go and randomly grab one word from each of the three arrays.
    string memory first = pickRandomFirstWord(newItemId);
    string memory second = pickRandomSecondWord(newItemId);
    string memory third = pickRandomThirdWord(newItemId);

    // I concatenate it all together, and then close the <text> and <svg> tags.
    string memory finalSvg = string(abi.encodePacked(baseSvg, first, second, third, "</text></svg>"));
    console.log("\n--------------------");
    console.log(finalSvg);
    console.log("--------------------\n");

        //mint the NFT to sender
        _safeMint(msg.sender, newItemId);

        //set NFT data
        _setTokenURI(
            newItemId,
            "http://www.quickmeme.com/img/91/9165875ed9f158247a63dacee09dcd186210265e6e46e13dd3ab2d2a2f92f821.jpg"
        );

        // Increment counter when next NFT is minted, unqiue id for each NFT minted
        _tokenIds.increment();
        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

    }
}
