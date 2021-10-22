// SPDX-License-Identifier: GPL-3.0
// Authored by Plastic Digits
// Credit to Olympus DAO
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "./CZFarm.sol";

contract CZFarmV2 is Ownable {
    using SafeERC20 for IERC20;
    CZFarm czf;
    IERC20 asset;

    mapping(address => uint256) depositorAsset;
    uint256 totalAsset;
    uint256 maxAsset;
    uint256 czfPerAsset;

    uint256 openEpoch;
    uint256 closeEpoch;
    uint256 vestEpoch;

    constructor(
        CZFarm _czf,
        IERC20 _asset,
        uint256 _czfPerAsset,
        uint256 _maxAsset,
        uint256 _openEpoch,
        uint256 _closeEpoch,
        uint256 _vestEpoch
    ) Ownable() {
        czf = _czf;
        asset = _asset;
        setCzfPerAsset(_czfPerAsset);
        setMaxAsset(_maxAsset);
        setOpenEpoch(_openEpoch);
        setCloseEpoch(_closeEpoch);
        setVestEpoch(_vestEpoch);
    }

    //Returns true if the farm is open to deposits.
    function isOpen() public view returns (bool) {
        return block.timestamp >= openEpoch && block.timestamp <= closeEpoch;
    }

    //Returns true if the farm is vested.
    function isVested() public view returns (bool) {
        return block.timestamp >= vestEpoch;
    }

    //Contract must be approved for asset
    function deposit(uint256 _wad, address _to) external {
        require(isOpen(), "CZFarmV2: Deposit not open");
        depositorAsset[_to] += _wad;
        totalAsset += _wad;
        require(totalAsset <= maxAsset, "CZFarmV2: Maximum assets deposited");
        asset.transferFrom(msg.sender, address(this), _wad);
    }

    //_for's asset must be over 0.
    function claim(address _for) external {
        require(isVested(), "CZFarmV2: Vesting not begun");
        require(depositorAsset[_for] > 0, "CZFarmV2: Depositor has no asset");
        uint256 czfToIssue = (depositorAsset[_for] * czfPerAsset) / 1 ether;
        depositorAsset[_for] = 0;
        czf.mint(_for, czfToIssue);
    }

    function recoverERC20(address tokenAddress) external onlyOwner {
        IERC20(tokenAddress).safeTransfer(
            _msgSender(),
            IERC20(tokenAddress).balanceOf(address(this))
        );
    }

    function setCzfPerAsset(uint256 _to) public onlyOwner {
        czfPerAsset = _to;
    }

    function setMaxAsset(uint256 _to) public onlyOwner {
        maxAsset = _to;
    }

    function setOpenEpoch(uint256 _to) public onlyOwner {
        openEpoch = _to;
    }

    function setCloseEpoch(uint256 _to) public onlyOwner {
        closeEpoch = _to;
    }

    function setVestEpoch(uint256 _to) public onlyOwner {
        vestEpoch = _to;
    }
}
