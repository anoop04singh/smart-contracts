// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract auction1{

    //constants

    address public manager;
    string public desc;
    uint256 public startTime;
    uint256 public endTime;

    //stateVariables
    address highestBidder;
    uint256 highestBid;
    mapping(address=>bool) private  bidders; 
    mapping(address=>uint256) public bidderList;
    enum AuctionState{notStarted,running,ended}
    AuctionState public auctionState;

    //modifiers
    modifier onlyManager{
        require(msg.sender==manager,"Only for Mamnger");_;
    }
    modifier isRunning{
        require(auctionState == AuctionState.running,"Auction is not Running");_;
    }
    modifier onlyBidder{
        require(bidders[msg.sender]); _;
    }

    //constructor
    constructor(address _manager, string memory _desc){
        manager = _manager;
        desc = _desc;
        auctionState = AuctionState.notStarted;

    }

    //functions

    function startAuction(uint256 _endTime) public onlyManager {
        startTime = block.timestamp;
        endTime = _endTime;
        auctionState = AuctionState.running;
    }

    function registerBidder(address _bidder)public isRunning {
        bidders[_bidder] = true;
    }

    function placeBid() public onlyBidder isRunning payable {
        require(msg.value>highestBid);
        if(highestBid>0){
        payable (highestBidder).transfer(highestBid);
        }
        highestBid = msg.value;
        highestBidder = msg.sender;
        bidderList[msg.sender] += msg.value;
    }
    function endAuction() public onlyManager isRunning{
        auctionState = AuctionState.ended;
        payable (manager).transfer(highestBid);
    }


}