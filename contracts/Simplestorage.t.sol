// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;
import "ds-test/test.sol";
import "./Simplestorage.sol";
contract SimplestorageTest is DSTest {
    Simstorage simstorage;
function setUp() public {
        simstorage = new Simstorage();
    }
function testGetInitialValue() public {
        assertTrue(simstorage.get() == 0);
    }
function testSetValue() public {
        uint x = 300;
        simstorage.set(x);
        assertTrue(simstorage.get() == 300);
    }
}