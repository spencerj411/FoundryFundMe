// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {FundMeInterface} from "../src/FundMeInterface.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMeInterface fundMeContractInterface;
    address immutable owner;
    address testSender = makeAddr("testSender");
    uint256 testStartingFunds = 20 ether;
    uint256 constant FUND_AMOUNT = 1e18; // 1 ETH

    constructor() {
        console.log("---FundMeTest");
        console.log(address(this));
        console.log("---");
        owner = msg.sender;
    }

    // this function runs before each test.
    function setUp() external {
        // create the fund me contract using the code in the DeployFundMe script!
        FundMe fundMeContract = (new DeployFundMe()).run();
        fundMeContractInterface = FundMeInterface(address(fundMeContract));
        vm.deal(testSender, testStartingFunds);
    }

    function testCorrectOwner() external {
        assertEq(fundMeContractInterface.i_owner(), owner);
    }

    function testGetVersion() external {
        uint256 version = fundMeContractInterface.getVersion();
        assertEq(version, 4);
    }

    // unit tests for fund() function

    modifier funded() {
        vm.prank(testSender); // run next line with testSender as its msg.sender
        // this contract calls fund and sends 1 ETH to contract
        fundMeContractInterface.fund{value: FUND_AMOUNT}();
        _;
    }

    function testMinimumFund() external {
        vm.expectRevert();
        // call fund() without any ETH
        fundMeContractInterface.fund();
    }

    function testCorrectFund() external funded {
        assertEq(
            fundMeContractInterface.getAmountFunded(testSender),
            FUND_AMOUNT
        );
    }

    function testFundersList() external funded {
        assertEq(fundMeContractInterface.getFunder(0), testSender);
    }

    function testOwnerCanOnlyWithdraw() external funded {
        // 1. try to withdraw as not the owner. expect revert
        vm.expectRevert();
        vm.prank(testSender); // run next line with testSender as its msg.sender
        fundMeContractInterface.withdraw();
        // 2. try to withdraw as the owner. expect balance of owner to increase by same amount in contract; contract to have 0 balance
        uint256 originalOwnerBalance = fundMeContractInterface
            .i_owner()
            .balance;
        uint256 originalContractBalance = address(fundMeContractInterface)
            .balance;
        vm.prank(fundMeContractInterface.i_owner());
        fundMeContractInterface.withdraw();
        uint256 newOwnerBalance = fundMeContractInterface.i_owner().balance;
        uint256 newContractBalance = address(fundMeContractInterface).balance;
        assertEq(
            originalOwnerBalance + originalContractBalance,
            newOwnerBalance
        );
        assertEq(newContractBalance, 0);
    }

    function testWithdrawWithMultipleFunders() external funded {
        uint256 originalContractBalance = address(fundMeContractInterface)
            .balance;
        // 1. fund the contract with multiple users
        address testSender2 = makeAddr("testSender2");
        address testSender3 = makeAddr("testSender3");
        address[3] memory testSenders = [testSender, testSender2, testSender3];
        // for each test sender, give them starting funds and make each fund the contract
        for (uint8 i = 0; i < testSenders.length; i++) {
            address sender = testSenders[i];
            vm.deal(sender, testStartingFunds);
            vm.prank(sender);
            fundMeContractInterface.fund{value: FUND_AMOUNT}();
        }
        // 2. check that new balance - old balance = sum of what was funded by all users
        uint256 newContractBalance = address(fundMeContractInterface).balance;
        assertEq(
            newContractBalance - originalContractBalance,
            FUND_AMOUNT * testSenders.length
        );
        //
        vm.prank(fundMeContractInterface.i_owner());
        fundMeContractInterface.withdraw();
        // for each test sender, check getAmountFunded and funders
        for (uint8 i = 0; i < testSenders.length; i++) {
            address sender = testSenders[i];
            assertEq(fundMeContractInterface.getAmountFunded(sender), 0);
        }
        newContractBalance = address(fundMeContractInterface).balance;
        assertEq(newContractBalance, 0);
    }

    function testWithdrawWithMultipleFundersCheaper() external funded {
        uint256 originalContractBalance = address(fundMeContractInterface)
            .balance;
        // 1. fund the contract with multiple users
        address testSender2 = makeAddr("testSender2");
        address testSender3 = makeAddr("testSender3");
        address[3] memory testSenders = [testSender, testSender2, testSender3];
        // for each test sender, give them starting funds and make each fund the contract
        for (uint8 i = 0; i < testSenders.length; i++) {
            address sender = testSenders[i];
            vm.deal(sender, testStartingFunds);
            vm.prank(sender);
            fundMeContractInterface.fund{value: FUND_AMOUNT}();
        }
        // 2. check that new balance - old balance = sum of what was funded by all users
        uint256 newContractBalance = address(fundMeContractInterface).balance;
        assertEq(
            newContractBalance - originalContractBalance,
            FUND_AMOUNT * testSenders.length
        );
        //
        vm.prank(fundMeContractInterface.i_owner());
        fundMeContractInterface.cheaperWithdraw();
        // for each test sender, check getAmountFunded and funders
        for (uint8 i = 0; i < testSenders.length; i++) {
            address sender = testSenders[i];
            assertEq(fundMeContractInterface.getAmountFunded(sender), 0);
        }
        newContractBalance = address(fundMeContractInterface).balance;
        assertEq(newContractBalance, 0);
    }
}
