// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;
import "ds-test/test.sol";
import "./PrivateSale.sol";
contract PrivateSaletest is DSTest {
    PrivateSale privateSale;
function setUp() public {
        privateSale = new PrivateSale();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }


}