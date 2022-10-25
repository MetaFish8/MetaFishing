// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.7.0;

import "@openzeppelin/contracts/token/ERC20/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

contract DGC is ERC20Burnable, Ownable {
    using SafeMath for uint256;
    uint256 public constant maxSupply = 120000000 * 1e18;

    constructor() public ERC20("Digital Gold Coins", "DGC") {}

    function mint(address _to, uint256 _amount)
    public
    onlyOwner
    returns (bool)
    {
        if (_amount.add(totalSupply()) > maxSupply) {
            return false;
        }
        _mint(_to, _amount);
        return true;
    }
}
