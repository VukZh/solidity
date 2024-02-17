// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

/**
 * @title V1Token
 * @dev bank implementation
 * @custom:dev-run-script scripts/deploy_with_ethers.ts
 */

contract VoteContract5_optimize {
    event Voted(address indexed voting, string res);

    error InvalidResult(string res);
    error InsufficientAddress();
    error AlreadyVotedError(address voting);

    bytes3 y = "Yes";
    bytes3 n = "No";
    uint32 public TotalPositiveVoters;
    uint32 public TotalNegativeVoters;
    address[] public arrayOfVoters;
    mapping(address voting => bool voted) public isVoted;
    mapping(address voting => bool res) public votingResult;

    function makeAVote(address voting, string calldata res) external {
        if (isVoted[voting]) {
            revert AlreadyVotedError(voting);
        }
        if ((keccak256(abi.encodePacked(res)) != keccak256(abi.encodePacked("Yes"))) && (keccak256(abi.encodePacked(res)) != keccak256(abi.encodePacked("No")))
        ) {revert InvalidResult(res);}
        if (
            keccak256(abi.encodePacked(res)) ==
            keccak256(abi.encodePacked(y))
        ) {
            votingResult[voting] = true;
            TotalPositiveVoters++;
        } else {
            votingResult[voting] = false;
            TotalNegativeVoters++;
        }
        isVoted[voting] = true;
        arrayOfVoters.push(voting);
        emit Voted(voting, res);
    }

    function TotalVoters() public view returns (uint32) {
        return TotalPositiveVoters + TotalNegativeVoters;
    }


    function PositiveVSNegative() external view returns (bool) {
        return TotalPositiveVoters >= TotalNegativeVoters;
    }

    function IsVoted(address who) external view returns (bool) {
        bool res = false;
        address[] memory arrayOfVotersM = arrayOfVoters;
        uint256 length = arrayOfVotersM.length;
        for (uint256 i = 0; i < length; i++) {
            if (arrayOfVotersM[i] == who) {
                res = true;
            }
        }
        return res;
    }

}
