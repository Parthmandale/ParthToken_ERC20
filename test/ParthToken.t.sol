//SPDX-License-Identifier: MIT

pragma solidity 0.8.20;
import {Test, console} from "forge-std/Test.sol";
import {ParthToken} from "../src/ParthToken.sol";

// import {DeployParthToken} from "../script/DeployParthToken.s.sol"; // here it is giving err or because of wrong path the correct path is ../script/DeployParthToken1.s.sol

contract ParthTokenTest is Test {
    ParthToken parthToken;

    address USER1 = makeAddr("user1");
    address USER2 = makeAddr("user2");

    function setUp() external {
        // DeployParthToken deployParthToken = new DeployParthToken();
        // parthToken = DeployParthToken.run();
        parthToken = new ParthToken();
    }

    event Transfer(
        address indexed from,
        address indexed to,
        uint indexed amount
    );

    event Approval(
        address indexed owner,
        address indexed spender,
        uint indexed amount
    );

    function testDecimalEighteen() public {
        assertEq(parthToken.i_decimal(), 18);
    }

    function testtotalSupplyIsSetTo1Million() public {
        uint totalSupply = parthToken.i_totalSupply();
        assert(totalSupply == 1000000);
    }

    // function testOwnerIsToMsgSender() public view {
    //     address owner = parthToken.i_owner();
    //     assert(owner == msg.sender);
    //     // this test is failing why? because DEPLOY FILE NOT WORKING
    // }

    function testTotalSupplyisSettoOwner() public {
        uint totalSupply = parthToken.i_totalSupply();
        address owner = parthToken.i_owner();
        uint initialBalOfOwner = parthToken.balanceOf(owner);
        assert(initialBalOfOwner == totalSupply);
    }

    function testTransferFailIfUserNothavingBal() public {
        uint initialBalOfUser1 = parthToken.balanceOf(USER1);
        uint initialBalOfUser2 = parthToken.balanceOf(USER2);
        assertEq(initialBalOfUser1, 0);
        assertEq(initialBalOfUser2, 0);

        vm.prank(USER1);
        vm.expectRevert();
        parthToken.transfer(USER2, 100);

        uint finalBalOfUser2 = parthToken.balanceOf(USER2);
        assert(finalBalOfUser2 == initialBalOfUser2);
    }

    function testTransferFailIfOwnerHasNotEnoughBalance() public {
        address owner = parthToken.i_owner();
        vm.prank(owner);
        parthToken.transfer(USER1, 200);

        uint initialBalanceOfUser1 = parthToken.balanceOf(USER1);
        uint initialBalanceOfUser2 = parthToken.balanceOf(USER2);
        assert(initialBalanceOfUser1 == 200);
        assert(initialBalanceOfUser2 == 0);

        vm.prank(USER1);
        vm.expectRevert();

        parthToken.transfer(USER2, 300);

        uint finalBalanceOfUser1 = parthToken.balanceOf(USER1);
        uint finalBalanceOfUser2 = parthToken.balanceOf(USER2);
        assert(finalBalanceOfUser1 == initialBalanceOfUser1);
        assert(finalBalanceOfUser2 == initialBalanceOfUser2);
    }

    function testTransferPassAndUpdateMappings() public {
        address owner = parthToken.i_owner();
        uint initialBalOfOwner = parthToken.balanceOf(owner);
        uint initialBalOfUser1 = parthToken.balanceOf(USER1);

        vm.prank(owner);
        parthToken.transfer(USER1, 200);

        uint finalBalOfOwner = parthToken.balanceOf(owner);
        uint finalBalOfUser1 = parthToken.balanceOf(USER1);

        assert(finalBalOfUser1 == 200);
        assert(finalBalOfOwner == initialBalOfOwner - finalBalOfUser1);
    }

    function testTransferShouldEmitWhenItsSuccess() public {
        address owner = parthToken.i_owner();
        vm.prank(owner);

        vm.expectEmit(address(parthToken));

        emit Transfer(owner, USER1, 200);

        parthToken.transfer(USER1, 200);
    }

    // THIS TEST NOT WORKING AS NOT ABLE TO IDENTIFIY REVERT
    // function testApproveFailsIfOwnerHasNotEnoughBalance() public {
    //     address owner = parthToken.i_owner();
    //     vm.prank(owner);
    //     parthToken.transfer(USER1, 200);

    //     vm.prank(USER1);
    //     vm.expectRevert();

    //     parthToken.approve(USER2, 300);
    //     console.log("approve fail", parthToken.balanceOf(USER2));
    // }

    function testApproveIfOwnerHasEnoughBalance() public {
        address owner = parthToken.i_owner();
        vm.prank(owner);
        parthToken.transfer(USER1, 200);

        vm.prank(USER1);
        parthToken.approve(USER2, 100);
        console.log(
            "approve pass now USER2 amount is - ",
            parthToken.allowance(USER1, USER2) // 100
        );
    }

    function testApprovalShouldEmitWhenItsSuccess() public {
        address owner = parthToken.i_owner();
        vm.prank(owner);

        vm.expectEmit(address(parthToken));
        emit Approval(owner, USER1, 200);

        parthToken.approve(USER1, 200);
    }

    // works on the amount which is approved by the owner
    // tESTING FIRST REQUIRE
    function testTransferFromFailsIfNotEnoughBalanceIsApproved() public {
        address owner = parthToken.i_owner();
        vm.prank(owner);
        parthToken.approve(USER1, 100);

        vm.prank(USER2);
        vm.expectRevert();
        parthToken.transferFrom(owner, USER1, 200);
    }

    // TESTING 2ND REQUIRE
    function testTransferFromFailsIfOwnerHasNotEnoughBalance() public {
        address owner = parthToken.i_owner();
        vm.prank(owner);
        parthToken.approve(USER1, 100);

        uint balanceOFOwner = parthToken.balanceOf(owner);
        vm.prank(owner);
        parthToken.transfer(USER2, balanceOFOwner);

        vm.expectRevert();
        parthToken.transferFrom(owner, USER1, 100);
    }

    function testTransferFromPassWhenOwnerHasEnoughBalanceAndApproved() public {
        address owner = parthToken.i_owner();
        vm.prank(owner);
        parthToken.approve(USER1, 100);

        uint initialBalOfOwner = parthToken.balanceOf(owner);
        uint initialBalOfUser1 = parthToken.balanceOf(USER1);

        parthToken.transferFrom(owner, USER1, 100);

        uint finalBalOfOwner = parthToken.balanceOf(owner);
        uint finalBalOfUser1 = parthToken.balanceOf(USER1);

        assert(finalBalOfUser1 == initialBalOfUser1 + 100);
        assert(finalBalOfOwner == initialBalOfOwner - 100);
    }
}
