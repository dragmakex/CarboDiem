//SPDX-License-Identifier: UNLICENSED

// Solidity files have to start with this pragma.
// It will be used by the Solidity compiler to validate its version.
pragma solidity ^0.8.20;
 
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CarbonCreditToken is ERC20, Ownable {
    uint8 public weightPercentage;

    event WeightAdjustment(address indexed weightAdjuster, uint8 percentage);

    constructor(uint256 initialSupply, string memory name, string memory symbol) ERC20(name, symbol){ 
        weightPercentage = 100;
        _mint(msg.sender, initialSupply*(10**uint256(decimals())));
    }

    function retire(uint256 amount) public {
        require(balanceOf(msg.sender) >= amount);
        _burn(msg.sender, amount);
    }

    function adjustWeight(uint8 percent) public onlyOwner{
        require(percent >= 0, "percentage out of range");
        weightPercentage = percent;
        emit WeightAdjustment(msg.sender, percent)
    }
}
