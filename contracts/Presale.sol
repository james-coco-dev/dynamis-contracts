// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/utils/math/SafeMath.sol';

import './interfaces/IDYNAToken.sol';
import './utils/IBEP20.sol';

contract TokenPresale is Ownable {
    using SafeMath for uint256;

    event Deposited(address indexed user, uint256 amount);
    event Recovered(address token, uint256 amount);

    uint256 public constant MAX_PRESALE_COUNT_PER_USER = 600 * 1e18;
    IDYNAToken public token;

    address payable public withdrawAddress;
    address public busdAddress;

    uint256 public totalDepositedFunds;
    uint256 public presalePrice = 1150000000000000000;  // 1.15 busd
    mapping(address => uint256) public deposits;

    constructor(IDYNAToken _token, address _busdAddress, address payable _withdrawAddress) public {
        token = _token;
        busdAddress = _busdAddress;
        withdrawAddress = _withdrawAddress;
    }

    // receive() payable external {
    //     deposit();
    // } // That should be used for receiving the coins

    function balanceOf(address account) public view returns (uint256) {
        return token.balanceOf(account);
    }

    function deposit(uint256 _amount) public {
        uint256 busdAllownance = IBEP20(busdAddress).allowance(msg.sender, address(this));
        require(busdAllownance >= _amount.mul(presalePrice).div(1e18), 'insufficient funds');
        require(deposits[msg.sender].add(_amount) <= MAX_PRESALE_COUNT_PER_USER, 'amount exeeded');

        IBEP20(busdAddress).transferFrom(msg.sender, address(this), _amount.mul(presalePrice).div(1e18));
        token.presale(msg.sender, _amount);

        totalDepositedFunds = totalDepositedFunds.add(_amount.mul(presalePrice).div(1e18));
        deposits[msg.sender] = deposits[msg.sender].add(_amount);
        emit Deposited(msg.sender, _amount);
    }

    function releaseFunds() external onlyOwner {
        uint256 balance = IBEP20(busdAddress).balanceOf(address(this));
        IBEP20(busdAddress).transfer(withdrawAddress, balance);
        totalDepositedFunds = totalDepositedFunds.sub(balance);
    }

    function recoverBEP20(address tokenAddress, uint256 tokenAmount) external onlyOwner {
        IBEP20(tokenAddress).transfer(this.owner(), tokenAmount);
        emit Recovered(tokenAddress, tokenAmount);
    }

    function setWithdrawAddress(address payable _address) external onlyOwner {
        withdrawAddress = _address;
    }
    
    function getDepositedFunds() public view returns (uint256) {
        return totalDepositedFunds;
    }
}
