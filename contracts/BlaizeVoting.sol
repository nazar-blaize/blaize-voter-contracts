pragma solidity ^0.8.7;

import "./BlaizePassport.sol";

contract BlaizeVoting {
    struct VoteOption {
        string name;
    }

    struct Vote {
        string name;
        string[] options;
    }

    struct VotePersonItem {
        uint256 voteOptionId;
        bool isValue;
    }

    struct VoteOuctome {
        mapping(address => VotePersonItem) personVotes;
    }

    uint256 public lastVote = 0;
    address public owner;
    Vote[] votes;
    mapping(uint256 => VoteOuctome) voteOuctomes;

    function getVoteName(uint256 index) public view returns (string memory) {
        require(index >= 0 && index <= votes.length, "Vote not exist");

        return votes[index].name;
    }

    function getVoteOptions(uint256 index) public view returns (string[] memory) {
        require(index >= 0 && index <= votes.length, "Vote not exist");

        return votes[index].options;
    }

    function vote(uint256 voteIndex, uint256 optionIndex) public onlyPassportVerified {
        require(voteIndex >= 0 && voteIndex <= votes.length, "Vote not exist");
        require(optionIndex >= 0 && optionIndex <= votes[voteIndex].options.length, "VoteOption not exist");

        require(!voteOuctomes[voteIndex].personVotes[msg.sender].isValue, "You already vote");

        voteOuctomes[voteIndex].personVotes[msg.sender] = VotePersonItem(optionIndex, true); // ??
    }

    // function getVoters(uint256 voteIndex, uint256 optionIndex) {

    // }


    function create(string memory name, string[] memory options) public onlyPassportVerified returns (uint256) {
        Vote memory createdVote = Vote(name, options);
        votes.push(createdVote);
        lastVote += 1;

        return lastVote - 1;
    }


    modifier onlyPassportVerified() {
        BlaizePassport.Person memory verification = BlaizePassport(0xa1f7871654cCa35E23135c22F12Ef85361a31493).getPerson(msg.sender);
        require(verification.isValue, "Person not registered");
        require(verification.verified, "Person not verified");
        _;
    }
}

