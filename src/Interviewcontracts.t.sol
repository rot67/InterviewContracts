// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;

import "ds-test/test.sol";

import "./Interviewcontracts.sol";

contract InterviewcontractsTest is DSTest {
    Interviewcontracts interviewcontracts;

    function setUp() public {
        interviewcontracts = new Interviewcontracts();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
