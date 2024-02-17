// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

/**
 * @title V1Token
 * @dev bank implementation
 * @custom:dev-run-script scripts/deploy_with_ethers.ts
 */

contract VoteContract3_calldata {
    event Voted(address indexed voting, string res);

    error InvalidResult(string res);
    error InsufficientAddress();
    error AlreadyVotedError(address voting);

    mapping(address voting => bool voted) public isVoted;
    mapping(address voting => bool res) public votingResult;
    string y = "Yes";
    string n = "No";
    address[] public arrayOfVoters;

    function makeAVote(address voting, string calldata res) public {
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
        } else {
            votingResult[voting] = false;
        }
        isVoted[voting] = true;
        arrayOfVoters.push(voting);
        emit Voted(voting, res);
    }

    function TotalVoters(address[] calldata arrayOfVotersC) public pure returns (uint256) {
        return arrayOfVotersC.length;
    }

    function TotalPositiveVoters(address[] calldata arrayOfVotersC) public view returns (uint256) {
        uint256 res;
        for (uint256 i = 0; i < arrayOfVotersC.length; i++) {
            if (votingResult[arrayOfVotersC[i]]) {
                res++;
            }
        }
        return res;
    }

    function TotalNegativeVoters(address[] calldata arrayOfVotersC) public view returns (uint256) {
        uint256 res;
        for (uint256 i = 0; i < arrayOfVotersC.length; i++) {
            if (!votingResult[arrayOfVotersC[i]]) {
                res++;
            }
        }
        return res;
    }

    function PositiveVSNegative(address[] calldata arrayOfVotersC) public view returns (bool) {
        uint256 positiveResult;
        uint256 negativeResult;
        for (uint256 i = 0; i < arrayOfVotersC.length; i++) {
            if (votingResult[arrayOfVotersC[i]]) {
                positiveResult++;
            } else {
                negativeResult++;
            }
        }
        return positiveResult >= negativeResult;
    }

    function IsVoted(address who, address[] calldata arrayOfVotersC) public view returns (bool) {
        bool res = false;
        for (uint256 i = 0; i < arrayOfVotersC.length; i++) {
            if (arrayOfVoters[i] == who) {
                res = true;
            }
        }
        return res;
    }

    function getArrayOfVoters() external view returns (address[] memory) {
        return arrayOfVoters;
    }

}
