// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.7.0;

import "@openzeppelin/contracts/token/ERC20/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/EnumerableSet.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

contract DGC is ERC20Burnable, Ownable {
    using SafeMath for uint256;
    using EnumerableSet for EnumerableSet.AddressSet;

    EnumerableSet.AddressSet private _minters;

    uint256 public constant maxSupply = 120000000 * 1e18;
    uint256 private _openSwapTimestamp = 1696776074;
    mapping(address => bool) private _whiteList;

    constructor() public ERC20("Digital Gold Coins", "DGC") {
        _whiteList[msg.sender] = true;
        _whiteList[address(this)] = true;
    }

    function mint(address _to, uint256 _amount)
    public
    onlyMinter
    returns (bool)
    {
        if (_amount.add(totalSupply()) > maxSupply) {
            return false;
        }
        _mint(_to, _amount);
        return true;
    }

    function addMinter(address _addMinter) public onlyOwner returns (bool) {
        require(_addMinter != address(0), "addMinter invalid");
        return EnumerableSet.add(_minters, _addMinter);
    }

    function delMinter(address _delMinter) public onlyOwner returns (bool) {
        require(_delMinter != address(0), "delMinter invalid");
        return EnumerableSet.remove(_minters, _delMinter);
    }

    function _isMinter(address account) internal view returns (bool) {
        return EnumerableSet.contains(_minters, account);
    }

    function setDGCOpenSwapTimestamp(uint256 openTransferTimestamp)
    external
    onlyOwner
    {
        require(_openSwapTimestamp != 0, "open time invalid");
        _openSwapTimestamp = openTransferTimestamp;
    }

    function setDGCAccountFromFee(address[] memory accounts, bool status)
    external
    onlyOwner
    {
        for(uint i = 0; i < accounts.length; i++) {
            _whiteList[accounts[i]] = status;
        }
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual override {
        if (!_whiteList[sender] && !_whiteList[recipient]) {
            require(
                block.timestamp >= _openSwapTimestamp &&
                _openSwapTimestamp > 0,
                "invalid"
            );
        }
        super._transfer(sender, recipient, amount);
    }

    modifier onlyMinter() {
        require(_isMinter(msg.sender), "caller is not the minter");
        _;
    }
}
