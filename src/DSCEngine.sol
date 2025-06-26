// SPDX-License-Identifier: MIT
 
// This is considered an Exogenous, Decentralized, Anchored (pegged), Crypto Collateralized low volitility coin
 
// Layout of Contract:
// version
// imports
// interfaces, libraries, contracts
// errors
// Type declarations
// State variables
// Events
// Modifiers
// Functions
 
// Layout of Functions:
// constructor 
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions   
pragma solidity ^0.8.0;

import {DecentralizedStableCoin} from "./DecentralizedStableCoin.sol";
//This system is designed to be as minimal as possible, and have tokens maintain a 1 token == $1 peg.
/*  Our DSC system should be awlays overcollateralised. At no point, should the value of all collateral <= the $ bakced value of all DSC
*This stablecoin has the properties:
* - Exogenous Collateral
* - Dollar Pegged
* - Algorithmically Stable 
* It is similar to DAI if DAI had no governance, no fees, and was only backed by wETH and wBTC
*/
contract DSCEngine{
///////////////// 
/// ERRORS /// 
//////////////// 
error DSCEngine__NeedsMoreThanZero();
error DSCEngine__TokenadressesAndPricefeedAddressesMustBeSameLength();
error DSCEngine__NotAllowedToken();
///////////////// 
/// State Variables /// 
//////////////// 
mapping(address token => address priceFeed) private s_priceFeeds;
mapping(address user => mapping(address token => uint256 amount)) private s_collateralDeposited;


DecentralizedStableCoin private immutable i_dsc;

///////////////// 
/// EVENTS /// 
////////////////
event collateralDeposited(address indexed user, address indexed token, uint256 amount);
///////////////// 
/// MODIFIERS ///  
//////////////// 
modifier moreThanZero(uint256 amount) {
    if (amount == 0){
revert DSCEngine__NeedsMoreThanZero();
    }
    _;
}

modifier isAllowedToken(address token) {
if(s_priceFeeds[token] == address(0)){
    revert DSCEngine__NotAllowedToken();
}
    _;
}

///////////////// 
/// FUNCTIONS /// 
//////////////// 

constructor(address[] memory tokenAddresses, address[] memory priceFeedAddresses, address dscAddress ) {
    if(tokenAddresses.length != priceFeedAddresses.length){
        revert DSCEngine__TokenadressesAndPricefeedAddressesMustBeSameLength();
    }
    for (uint256 i=0; i<tokenAddresses.length; i++){
        s_priceFeeds[tokenAddresses[i]] = priceFeedAddresses[i];
    }
    i_dsc = DecentralizedStableCoin(dscAddress);
}

///////////////// 
/// EXTERNAL FUNCTIONS /// 
//////////////// 

    function depositCollateralAndMintDSC() external {}

// @param tokenCollateralAddress is the address of the token to deposit as collateral
// @param amountCollateral is the amount of collateral to deposit 
    function depositCollateral(address tokenCollateralAddress, uint256 amountCollateral) external moreThanZero(amountCollateral) isAllowedToken(tokenCollateralAddress){
        s_collateralDeposited[msg.sender][tokenCollateralAddress] +=amountCollateral;
        emit collateralDeposited(msg.sender, tokenCollateralAddress,amountCollateral);
    } 

    function redeemCollateralForDSC() external {}

    function redeemCollateral() external {}

    function mintDSC() external {}

    function burnDSC() external {}

    function liquidate() external {}

    function getHealthFactor() external view {}
}