//SPDX-License-Identifier: Unlicense

// contracts/BuyMeACoffee.sol
pragma solidity ^0.8.0;

// Switch this to your own contract address once deployed, for bookkeeping!
// Contract Address on Goerli: 0x5FbDB2315678afecb367f032d93F642f64180aa3

contract BuyMeACoffee {
    // Event to emit when a Memo is created.
    event NewMemo(
        address indexed from,
        uint256 timestamp,
        string name,
        string message
    );
    
    // Memo struct.
    struct Memo {
        address from;
        uint256 timestamp;
        string name;
        string message;
    }
    
    // Address of contract deployer. Marked payable so that
    // we can withdraw to this address later.
    address payable owner;

    // List of all memos received from coffee purchases.
    Memo[] memos;

    constructor(0xc84842dbB807CD7591D16Fc6Cf06E07FF5f0d349) {
        // Store the address of the deployer as a payable address.
        // When we withdraw funds, we'll withdraw here.
        owner = payable(msg.sender);
    }

    /**
     * @dev fetches all stored memos
     */
    function getMemos() public view returns (Memo[] memory) {
        return memos;
    }

    /**
     * @dev buy a coffee for owner (sends an ETH tip and leaves a memo)
     * @param _name name of the coffee purchaser
     * @param _message a nice message from the purchaser
     */
    function buyCoffee(string memory _name, string memory _message) public payable {
        // Must accept more than 0 ETH for a coffee.
        require(msg.value > 0, "can't buy coffee for free!");

        // Add the memo to storage!
        memos.push(Memo(
            msg.sender,
            block.timestamp,
            _name,
            _message
        ));

        // Emit a NewMemo event with details about the memo.
        emit NewMemo(
            msg.sender,
            block.timestamp,
            _name,
            _message
        );
    }

    /**
     * @dev send the entire balance stored in this contract to the owner
     */
    function withdrawTips() public {
        require(owner.send(address(this).balance));
    }
}