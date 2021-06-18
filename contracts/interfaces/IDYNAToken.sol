// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

interface IDYNAToken {
  function presale(address to, uint256 value) external;
  function balanceOf(address account) external view returns (uint256);
}
