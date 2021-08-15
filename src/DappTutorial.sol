// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

contract DappTutorial {
    receive() external payable {}

    function withdraw(uint password) public {
        require (password == 42, "Access Denied!");
        payable(msg.sender).transfer(address(this).balance);
    }
}
