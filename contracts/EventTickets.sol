// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

contract EventTickets {
    uint8 numberOfTickets;
    uint256 ticketPrice;
    uint256 ticketAmount;
    uint256 availableForMint;
    uint256 startAt;
    uint256 endAt;

    address projectOwner;
    address staff;

    struct Tickets {
        uint256 ticketId;
        uint256 regDate;
        uint256 amountPaid;
        address ticketOwner;
    }

    modifier ownerOnly {
        require(msg.sender == projectOwner, "Only the owner of project can do this");
        _;
    }
    
    modifier ticketStillValid {
        require(endAt > block.timestamp, "Ticket minting has ended");
        _;
    }

    modifier staffOnly {
        require(msg.sender == projectOwner, "Only admin or staff can make this request");
        require(msg.sender == staff, "Only admin or staff can make this request");
        _;
    }

    mapping(uint8 => Tickets) public tickets;

    constructor(uint cost, uint totalReservation){
        projectOwner = payable(msg.sender);
        ticketPrice = cost;
        ticketAmount = totalReservation;
    }

    // admin functions

    function addStaff (address _staff) public ownerOnly{
        staff = _staff;
    }

    function changePrice (uint256 _newPrice) public ownerOnly {
        ticketPrice = _newPrice;
    }

    function _mint (uint qtty) public ownerOnly {
        ticketAmount += qtty;
        availableForMint += qtty;
    }

    function _burn(uint qtty) public ownerOnly{
        require(availableForMint != qtty, "Not enough tickets to burn");
        ticketAmount -= qtty;
        availableForMint -= qtty;
    }

    function changeEndDate(uint256 newDate) public ownerOnly{
        require(endAt > newDate, "Invalid date entered");
        endAt = newDate;
    }

    // clients functions
    function buy (uint256 qtty) public ticketStillValid {
        numberOfTickets ++;
        
        uint256 mintDate = block.timestamp;
        uint256 amountPaid = qtty * ticketPrice;
        uint8 ticketId = numberOfTickets;

        availableForMint = ticketAmount - qtty;

        tickets[ticketId] = Tickets(
            ticketId, 
            mintDate,
            amountPaid,
            msg.sender
        );
    }

    // function scanTicket (uint8 id, address owner) public staffOnly {
    //     require(tickets[id] != Tickets(id, , , msg.sender),"Invalid ticket ID");
    // }
}