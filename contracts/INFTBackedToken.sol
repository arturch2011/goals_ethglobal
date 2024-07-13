pragma solidity >=0.4.22 <0.9.0;

interface INFTBackedToken {
    function deposit(uint256[] calldata tokenIds) external returns (uint256);
    function redeem(uint256[] calldata tokenIds) external returns (uint256);
    function swap(uint256[] calldata tokensIn, uint256[] calldata tokensOut) external;
}

