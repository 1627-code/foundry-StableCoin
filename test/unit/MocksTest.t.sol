// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {MockFailedMintDSC} from "../mocks/MockFailedMintDSC.sol";
import {MockFailedTransfer} from "../mocks/MockFailedTransfer.sol";
import {MockFailedTransferFrom} from "../mocks/MockFailedTransferFrom.sol";
import {MockMoreDebtDSC} from "../mocks/MockMoreDebtDSC.sol";
import {MockV3Aggregator} from "../mocks/MockV3Aggregator.sol";
import {ERC20Mock} from "../mocks/ERC20Mocks.sol";


contract MocksTest is Test {
    MockFailedMintDSC mockMintFail;
    MockFailedTransfer mockTransferFail;
    MockFailedTransferFrom mockTransferFromFail;
    MockMoreDebtDSC mockMoreDebt;
    MockV3Aggregator mockAggregator;
    ERC20Mock erc20Mock;

    uint256 public constant ZERO_AMOUNT = 0 ether;
    uint256 amountToMint = 100 ether;
    uint256 amountToBurn = 50 ether;
    uint256 amountToTransfer = 1e18;
    uint8 constant DECIMALS = 8;
    int256 constant INITIAL_ANSWER = 1000e8;
    address owner = makeAddr("owner");
    address user = makeAddr("user");


    function setUp() public {
        vm.startPrank(owner);
        mockMintFail = new MockFailedMintDSC();
        mockTransferFail = new MockFailedTransfer();
        mockTransferFromFail = new MockFailedTransferFrom();
        mockMoreDebt = new MockMoreDebtDSC(address(mockAggregator));
        mockAggregator = new MockV3Aggregator(DECIMALS, INITIAL_ANSWER);
        erc20Mock = new ERC20Mock("Mock Token", "MTK", msg.sender, uint256(INITIAL_ANSWER));
        vm.stopPrank();
        
    }

    // MockFailedMintDSC tests
    function test_MockFailedMintFails() public {
        vm.expectRevert();
        mockMintFail.mint(msg.sender, amountToTransfer);
    }

    function test_MockFailedMintRevertIfAmountISZero() public {
        vm.startPrank(owner);
        vm.expectRevert(MockFailedMintDSC.DecentralizedStableCoin__AmountMustBeMoreThanZero.selector);
        mockMintFail.mint(owner, ZERO_AMOUNT);
    }

    function test_MockFailedMintRevertsIfAddressIsZero() public {
        vm.startPrank(owner);
        vm.expectRevert(MockFailedMintDSC.DecentralizedStableCoin__NotZeroAddress.selector);
        mockMintFail.mint(address(0), amountToTransfer);
    }

    function testMockFailedMintFailsIfNotOwner() public {
        vm.startPrank(user);
        vm.expectRevert("Ownable: caller is not the owner");
        mockMintFail.mint(owner, amountToMint);
        vm.stopPrank();
    }

    function testMockFailedMintsuccessfullyIfAllParametersAreGiven() public {
        vm.startPrank(owner);
        mockTransferFail.mint(owner, amountToMint);
        uint256 afterBalance = mockTransferFail.balanceOf(owner);
        assert(afterBalance > ZERO_AMOUNT);
    }
    
    function testMockFailedBurnRevertsIfAmountPassedIsZero() public {
        vm.startPrank(owner);
        vm.expectRevert(MockFailedTransfer.DecentralizedStableCoin__AmountMustBeMoreThanZero.selector);
        mockMintFail.burn(ZERO_AMOUNT);
        vm.stopPrank();
    }
    // Test: Reverts if balance < amount
    function testMockFailedBurnRevertsIfBalanceIsLessThanAmount() public {
        vm.startPrank(owner);
        // Owner balance is 0 initially
        vm.expectRevert(MockFailedTransfer.DecentralizedStableCoin__BurnAmountExceedsBalance.selector);
        mockMintFail.burn(amountToBurn); // Attempt to burn more than balance
        vm.stopPrank();
    }
    function testMockFailedBurnFailsIfNotOwner() public {
        vm.startPrank(user);
        vm.expectRevert("Ownable: caller is not the owner");
        mockMintFail.burn(amountToBurn);
        vm.stopPrank();
    }



    // mockFailedTransfer test
    function test_MockFailedTransferFails() public {
        vm.expectRevert(MockFailedTransfer.DSCEngine__TransferFailed.selector);
        mockTransferFail.transfer(owner, amountToTransfer);
    }

    function testBurnFunctionOfTransFerFailsIfAmountPassedIsZero() public {
        vm.startPrank(owner);
        vm.expectRevert(MockFailedTransfer.DecentralizedStableCoin__AmountMustBeMoreThanZero.selector);
        mockTransferFail.burn(ZERO_AMOUNT);
        vm.stopPrank();
    }
    // Test: Reverts if balance < amount
    function testtransFerFailsBurnRevertsIfBalanceIsLessThanAmount() public {
        vm.startPrank(owner);
        // Owner balance is 0 initially
        vm.expectRevert(MockFailedTransfer.DecentralizedStableCoin__BurnAmountExceedsBalance.selector);
        mockTransferFail.burn(amountToBurn); // Attempt to burn more than balance
        vm.stopPrank();
    }

    // Test: Burns successfully when caller has enough balance
    function testtransferFailsBurnSuccessWhenBalanceIsEnough() public {
        vm.startPrank(owner);
        mockTransferFail.mint(owner, amountToMint);
        uint256 beforeBalance = mockTransferFail.balanceOf(owner);
        console.log("beforeBalance: ", beforeBalance);
        mockTransferFail.burn(amountToBurn);
        uint256 afterBalance = mockTransferFail.balanceOf(owner);
        console.log("afterBalance: ", afterBalance);
        vm.stopPrank();

        assertEq(afterBalance, beforeBalance - amountToBurn, "Burn did not reduce balance correctly");
    }

    function testtrasferBurnFailsIfNotOwner() public {
        vm.startPrank(user);
        vm.expectRevert("Ownable: caller is not the owner");
        mockTransferFail.burn(amountToBurn);
        vm.stopPrank();
    }


    // transFrom Functions
    function test_MockFailedTransferFromFails() public {
        vm.expectRevert(MockFailedTransferFrom.DSCEngine__TransferFailed.selector);
        mockTransferFromFail.transferFrom(msg.sender, address(1), amountToTransfer);
    }

    function testBurnFunctionOfTransFerFromFailsIfAmountPassedIsZero() public {
        vm.startPrank(owner);
        vm.expectRevert(MockFailedTransferFrom.DecentralizedStableCoin__AmountMustBeMoreThanZero.selector);
        mockTransferFromFail.burn(ZERO_AMOUNT);
        vm.stopPrank();
    }
    // Test: Reverts if balance < amount
    function testtransFerFromFailsBurnRevertsIfBalanceIsLessThanAmount() public {
        vm.startPrank(owner);
        // Owner balance is 0 initially
        vm.expectRevert(MockFailedTransferFrom.DecentralizedStableCoin__BurnAmountExceedsBalance.selector);
        mockTransferFromFail.burn(amountToBurn); // Attempt to burn more than balance
        vm.stopPrank();
    }

    // Test: Burns successfully when caller has enough balance
    function testtransferFromFailsBurnSuccessWhenBalanceIsEnough() public {
        vm.startPrank(owner);
        mockTransferFromFail.mint(owner, amountToMint);
        uint256 beforeBalance = mockTransferFromFail.balanceOf(owner);
        mockTransferFromFail.burn( amountToBurn);
        uint256 afterBalance = mockTransferFromFail.balanceOf(owner);
        vm.stopPrank();

        assertEq(afterBalance, beforeBalance - amountToBurn, "Burn did not reduce balance correctly");
    }



    // MockMoreDebt Tests
    function test_MockMoreDebtDSCAlwaysFailsIfOverDebt() public {
        // assuming this mock simulates over-debt minting
        vm.expectRevert();
        mockMoreDebt.mint(msg.sender, amountToMint);
    }

    function test_MockMoreDebtFailedMintRevertIfAmountISZero() public {
        vm.startPrank(owner);
        vm.expectRevert(MockMoreDebtDSC.DecentralizedStableCoin__AmountMustBeMoreThanZero.selector);
        mockMoreDebt.mint(owner, ZERO_AMOUNT);
    }

    function test_MockMoreDebtFailedMintRevertsIfAddressIsZero() public {
        vm.startPrank(owner);
        vm.expectRevert(MockMoreDebtDSC.DecentralizedStableCoin__NotZeroAddress.selector);
        mockMoreDebt.mint(address(0), amountToTransfer);
    }

    function testMockMoreDebtFailedMintFailsIfNotOwner() public {
        vm.startPrank(user);
        vm.expectRevert("Ownable: caller is not the owner");
        mockMoreDebt.mint(owner, amountToMint);
        vm.stopPrank();
    }

    function testMockMoreDebtFailedMintsuccessfullyIfAllParametersAreGiven() public {
        vm.startPrank(owner);
        mockMoreDebt.mint(owner, amountToMint);
        uint256 afterBalance = mockMoreDebt.balanceOf(owner);
        assert(afterBalance > ZERO_AMOUNT);
    }
    
    function testMockMoreDebtFailedBurnRevertsIfAmountPassedIsZero() public {
        vm.startPrank(owner);
        vm.expectRevert();
        mockMoreDebt.burn(ZERO_AMOUNT);
        vm.stopPrank();
    }
    // Test: Reverts if balance < amount
    function testMockMoreDebtFailedBurnRevertsIfBalanceIsLessThanAmount() public {
        vm.startPrank(owner);
        // Owner balance is 0 initially
        vm.expectRevert();
        mockMoreDebt.burn(amountToBurn); // Attempt to burn more than balance
        vm.stopPrank();
    }
    function testMockMoreDebtFailedBurnFailsIfNotOwner() public {
        vm.startPrank(user);
        vm.expectRevert("Ownable: caller is not the owner");
        mockMoreDebt.burn(amountToBurn);
        vm.stopPrank();
    }


    function test_ERC20MockMintAndBalance() public {
        uint256 balanceBeforeMint = erc20Mock.balanceOf(address(owner));
        erc20Mock.mint(owner, amountToMint);
        uint256 balanceAfterMint = erc20Mock.balanceOf(address(owner));
        assertEq(balanceBeforeMint, ZERO_AMOUNT);
        assert(balanceBeforeMint != balanceAfterMint);
        assertEq(balanceAfterMint, amountToMint);     
    }

    function testErc20MockBurnSuccessWhenBalanceIsEnough() public {
        vm.startPrank(owner);
        erc20Mock.mint(owner, amountToMint);
        uint256 beforeBalance = erc20Mock.balanceOf(owner);
        erc20Mock.burn(owner, amountToBurn);
        uint256 afterBalance = erc20Mock.balanceOf(owner);
        vm.stopPrank();

        assertEq(afterBalance, beforeBalance - amountToBurn, "Burn did not reduce balance correctly");
    }


    function test_MockAggregatorReturnsLatestRound() public {
        (, int256 answer,,,) = mockAggregator.latestRoundData();
        assertEq(answer, 1000e8);
    }


    function testConstructorInitializesCorrectly() public {
        assertEq(mockAggregator.decimals(), DECIMALS);
        assertEq(mockAggregator.latestAnswer(), INITIAL_ANSWER);
        assertEq(mockAggregator.version(), 0);
        assertEq(mockAggregator.latestRound(), 1, "Should start at round 1");
    }

    // ✅ 2. Test updateAnswer() updates values properly
    function testUpdateAnswerWorks() public {
        int256 newAnswer = 2000e8;
        mockAggregator.updateAnswer(newAnswer);

        (, int256 answer,, uint256 updatedAt, uint80 answeredInRound) = mockAggregator.latestRoundData();

        assertEq(answer, newAnswer);
        assertEq(answeredInRound, uint80(mockAggregator.latestRound()));
        assertEq(mockAggregator.getAnswer(mockAggregator.latestRound()), newAnswer);
        assertGe(updatedAt, block.timestamp - 1, "Timestamp should be recent");
    }

    // ✅ 3. Test multiple updates increment the round number
    function testMultipleUpdatesIncrementRoundNumber() public {
        uint256 startRound = mockAggregator.latestRound();
        mockAggregator.updateAnswer(1500e8);
        mockAggregator.updateAnswer(1600e8);
        mockAggregator.updateAnswer(1700e8);

        uint256 endRound = mockAggregator.latestRound();
        assertEq(endRound, startRound + 3, "Round number should increase after each update");
    }

    // ✅ 4. Test updateRoundData sets the correct round info
    function testUpdateRoundDataWorks() public {
        uint80 roundId = 10;
        int256 answer = 2500e8;
        uint256 timestamp = block.timestamp + 100;
        uint256 startedAt = block.timestamp + 50;

        mockAggregator.updateRoundData(roundId, answer, timestamp, startedAt);

        (
            uint80 returnedRoundId,
            int256 returnedAnswer,
            uint256 returnedStartedAt,
            uint256 returnedUpdatedAt,
            uint80 answeredInRound
        ) = mockAggregator.getRoundData(roundId);

        assertEq(returnedRoundId, roundId);
        assertEq(returnedAnswer, answer);
        assertEq(returnedStartedAt, startedAt);
        assertEq(returnedUpdatedAt, timestamp);
        assertEq(answeredInRound, roundId);
    }

    // ✅ 5. Test description() returns the right string
    function testDescriptionIsCorrect() public {
        string memory desc = mockAggregator.description();
        assertEq(desc, "v0.6/tests/MockV3Aggregator.sol");
    }

    // ✅ 6. Test latestRoundData returns correct recent values
    function testLatestRoundDataReflectsMostRecentRound() public {
        mockAggregator.updateAnswer(999e8);
        mockAggregator.updateAnswer(888e8);

        (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        ) = mockAggregator.latestRoundData();

        assertEq(answer, 888e8);
        assertEq(roundId, answeredInRound);
        assertEq(updatedAt, mockAggregator.getTimestamp(roundId));
        assertEq(startedAt, mockAggregator.getTimestamp(roundId)); // startedAt mirrors timestamp in updateAnswer()
    }

}
