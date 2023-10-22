// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../contracts/CarbonCreditToken.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EscrowContract is Ownable {
    struct LockedCredit {
        CarbonCreditToken token;
        uint256 emissionRate;
    }
    struct LockedStablecoin {
        IERC20 token;
        uint256 emissionRate;
    }

    LockedCredit public carbonCredits;
    LockedStablecoin public stablecoins;

    address public creditProducer;
    address public creditRecipient;

    uint256 public maturationTime;  // number of seconds until all tokens emitted
    uint256 public maturationDate;  // future point in time where contract is fulfilled
    uint256 public emissionRate;    // number of tokens released per second


    event TokensDeposited(uint256 amountA, uint256 amountB);
    event TokensReleased(uint256 amountA, uint256 amountB);
    event DestroyContract(address indexed _from, uint256 amountStables);

    constructor(
        address _CCtoken,
        address _stablecoin,
        address _payeeCCproducer,
        address _payeeCCconsumer,
        uint256 _maturationTime
    ) {
        carbonCredits = LockedCredit({
            token : CarbonCreditToken(_CCtoken),
            emissionRate : 0
        });
        stablecoins = LockedStablecoin({
            token : IERC20(_stablecoin),
            emissionRate : 0
        });
        creditProducer  = _payeeCCproducer;
        creditRecipient = _payeeCCconsumer;
        maturationTime  = _maturationTime;
    }

    function depositTokens(uint256 amountCarbonCredits, uint256 amountStablecoin) public payable onlyOwner {
        require(maturationDate == 0, "Tokens already deposited.");
        require(carbonCredits.token.transferFrom(msg.sender, address(this), amountCarbonCredits), "Transfer of carbon credits failed.");
        require(stablecoins.token.transferFrom(msg.sender, address(this), amountStablecoin), "Transfer of stablecoin failed.");
        maturationDate = block.timestamp + maturationTime;
        carbonCredits.emissionRate = amountCarbonCredits / maturationTime
        stablecoins.emissionRate = amountStablecoin / maturationTime;
        emit TokensDeposited(amountCarbonCredits, amountStablecoin);
    }

    function releaseTokens() external {
        require(maturationTime > 0, "All tokens already emitted");
        uint256 timePassed;
        if(maturationDate - block.timestamp > 0) {
            timePassed = maturationTime - (maturationDate - block.timestamp); // time passed since contract inception or last withdrawal
        }
        else{
            timePassed = maturationTime
        }
        uint256 claimedCarbonCredits = timePassed * carbonCredits.emissionRate;
        uint256 claimedStablecoins  = timePassed * stablecoins.emissionRate;
        maturationTime -= timePassed;
        require(carbonCredits.token.transfer(creditRecipient, claimedCarbonCredits), "Carbon credits transfer failed.");
        require(stablecoins.token.transfer(creditProducer, claimedStablecoins), "Stablecoin transfer failed.");
        emit TokensReleased(claimedCarbonCredits, claimedStablecoins);
    }

    function revertContract() external onlyOwner {
        carbonCredits.token._burn(address(this),carbonCredits.token.balanceOf(address(this)));
        uint256 remainingBalance = stablecoins.token.balanceOf(address(this));
        stablecoins.token.transfer(creditRecipient,remainingBalance);
        renounceOwnership();
        emit(msg.sender, remainingBalance);
    }
}
