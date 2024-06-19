// SPDX-License-Identifier: MIT

pragma solidity 0.8.22;

import {Test} from "forge-std/Test.sol";
import {DeployBox} from "../script/DeployBox.s.sol";
import {UpgradeBox} from "../script/UpgradeBox.s.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {BoxV2} from "../src/BoxV2.sol";

contract DeployAndUpgradeTest is Test {
    DeployBox public deployer;
    UpgradeBox public upgrader;

    address public proxy;

    address public OWNER = makeAddr("owner");

    function setUp() public {
        deployer = new DeployBox();
        upgrader = new UpgradeBox();
        proxy = deployer.run();
    }

    function testProxyStartsAsBoxV1() public view {
        uint256 expectedVersion = 1;

        uint256 version = BoxV1(proxy).version();

        assertEq(version, expectedVersion);
    }

    function testUpgrades() public {
        BoxV2 newBox = new BoxV2();
        upgrader.upgradeBox(proxy, address(newBox));

        uint256 expectedVersion = 2;

        uint256 version = BoxV2(proxy).version();

        assertEq(version, expectedVersion);

        BoxV2(proxy).setNumber(42);
        assertEq(BoxV2(proxy).getNumber(), 42);
    }
}
