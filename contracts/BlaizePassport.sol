pragma solidity ^0.8.7;


contract BlaizePassport {

    struct Person {
        string firstName;
        string secondName;
        string governmentId;
        bool verified;
        bool isValue;
    }

    address public owner;

    mapping(address => Person) public persons;
    mapping(address => bool) public verifiers;
    
    event UserRegistred(address userAddr);
    event UserVerified(address userAddr, address verifierAddr);

    constructor() {
        owner = msg.sender; 
        verifiers[msg.sender] = true;
    }

    function register(string memory firstName, string memory secondName, string memory governmentId) public {
        require(!persons[msg.sender].isValue, "user already exist");
        
        persons[msg.sender] = Person(firstName, secondName, governmentId, false, true);
        emit UserRegistred(msg.sender);
    }

    function getPerson(address _addr) public view returns (Person memory) {
        return persons[_addr];
    }

    function markVerified(address _addr) public onlyVerifier {
        if (!persons[_addr].isValue) {
            revert("Person not registered");
        }
        persons[_addr].verified = true;
        emit UserVerified(_addr, msg.sender);
    }

    function addVerifier(address _addr) public onlyOwner {
        verifiers[_addr] = true;
    }


    modifier onlyOwner() {
        require(msg.sender==owner, "caller is not owner");
        _;
    }

    modifier onlyVerifier() {
        require(verifiers[msg.sender], "caller is not verifier");
        _;
    }
}
