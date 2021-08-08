// SPDX-License-Identifier: ISC
pragma solidity ^0.8.2;

contract PrivateSale {

    /* State variables */

    uint256 public constant TICKET_PRICE = 0.1 ether;

    /// @notice Number of tickets sold for each buyer.
    mapping(address => uint256) private purchasedTickets;

    /* Custom errors & function modifiers */

    /// @notice Not enough funds were sent to buy tickets.
    error NotEnoughFundsSent();
    modifier enoughFundsSent(uint256 ticketQuantity) {
        if (msg.value < ticketQuantity * TICKET_PRICE) {
            revert NotEnoughFundsSent();
        }
        _;
    }

    /// @notice The quantity of tickets to be refunded exceeds the purchased quantity.
    error TicketsWereNotBought();
    modifier ticketsWereBought(uint256 ticketQuantity) {
        if (purchasedTickets[msg.sender] < ticketQuantity) {
            revert TicketsWereNotBought();
        }
        _;
    }

    /* Functions */

    /// @notice Allows the user to buy tickets for the event.
    function buyTickets(uint256 quantity)
        external
        payable
        enoughFundsSent(quantity)
    {
        purchasedTickets[msg.sender] += quantity;
    }

    /// @notice Allows a buyer to get a refund for the tickets he bought. This
    /// function is vulnerable to a reentrancy attack.
    function getRefund(uint256 quantity)
        external
        payable
        ticketsWereBought(quantity)
    {
        // If the address that calls this function is a smart contract, then
        // sending it Ether will execute its `receive' function which can
        // immediately call this function again. As the number of tickets sold
        // to the buyer has not yet been updated, the `ticketsWereBought' check
        // will pass, and more Ether will be sent to the malicious contract.
        (bool refunded, ) = msg.sender.call{value: quantity * TICKET_PRICE}("");
        require(refunded, "Ticket refund failed");

  
        unchecked {
            purchasedTickets[msg.sender] -= quantity;
        }
    }

    receive() external payable {}
}
