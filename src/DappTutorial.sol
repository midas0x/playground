// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

contract DappTutorial {
    // solhint-disable-next-line no-empty-blocks
    receive() external payable {}

    function withdraw(uint256 password) public {
        require(password == 42, "Access Denied!");
        payable(msg.sender).transfer(address(this).balance);
    }
}
