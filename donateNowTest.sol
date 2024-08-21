// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract donateNow{

    //this contract provides a bassic structure of my Platform DonateNow.
    //copyright Anoop Singh.

    //constants
    address private Owner;

    //variables
    mapping(address=>uint256) public organisations;
    address[] orgArr;

    //modifiers
    modifier onlyOwner{
        require(msg.sender==Owner);_;
    }

    modifier onlyOrganisation{
        require(organisations[msg.sender]!=0);_;
    }

    modifier onlyDonor{
        require(organisations[msg.sender]==0 && msg.sender!=Owner);_;
    }


    //constructor
    constructor(address _Owner){
        Owner = _Owner;
    }

    //functions

    //create calculateRating and Normalization functions, along with  updating rating functio.

    function addOrganisation(address _organisation) public onlyOwner{
        organisations[_organisation] = 1;//instead of 1 calculate rating will be called here.
        orgArr.push(_organisation);
    }

    function updateRating(address _organisation, uint256 _rating) public onlyOwner{
        organisations[_organisation] = _rating*1/100;
    }

    function removeOrganisation(address _organisation) public onlyOwner{
        organisations[_organisation] = 0;
    }

    function sendFunds() public onlyOwner payable {
        uint256 x = (address(this).balance);
        payable (Owner).transfer(x*1/10);
        for(uint i = 0;i<orgArr.length;i++){
            payable (orgArr[i]).transfer(organisations[orgArr[i]]*x*9/10);
        }
    }

    function makeDonation() public onlyDonor payable{
    }




}
