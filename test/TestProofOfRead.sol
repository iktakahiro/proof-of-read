pragma solidity 0.4.24;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/ProofOfRead.sol";


contract TestProofOfRead is ProofOfRead {

    function testInitialIsActive() public {
        ProofOfRead proofOfRead = new ProofOfRead();

        Assert.isTrue(proofOfRead.getIsActive(), "isActive should be true");
    }

    function testInitialMaxLengthOfAuthors() public {
        ProofOfRead proofOfRead = new ProofOfRead();

        Assert.equal(uint(proofOfRead.getMaxLengthOfAuthors()), 6, "maxLengthOfAuthors should be 6");
    }

    function testSetIsActive() public {
        ProofOfRead proofOfRead = new ProofOfRead();
        proofOfRead.setIsActive(false);

        Assert.isFalse(proofOfRead.getIsActive(), "isActive should be false");
    }

    function testSetMaxLengthOfAuthors() public {
        ProofOfRead proofOfRead = new ProofOfRead();
        proofOfRead.setMaxLengthOfAuthors(5);

        Assert.equal(uint(proofOfRead.getMaxLengthOfAuthors()), 5, "maxLengthOfAuthors should be 6");
    }

    function testAddBookWithSingleAuthor() public {
        ProofOfRead proofOfRead = new ProofOfRead();

        bytes32 isbn = "978-4774196879";
        address[] memory _addressList = new address[](1);
        uint8[] memory _loyaltyList = new uint8[](1);

        // TODO need to get dynamically
        _addressList[0] = 0x627306090abab3a6e1400e9345bc60c78a8bef57;
        _loyaltyList[0] = 100;

        Assert.isTrue(proofOfRead.addBook(isbn, _addressList, _loyaltyList), "return value should be true");
    }

    function testAddBookWithMultipleAuthors() public {
        ProofOfRead proofOfRead = new ProofOfRead();

        bytes32 isbn = "978-4774196879";
        address[] memory _addressList = new address[](2);
        uint8[] memory _loyaltyList = new uint8[](2);

        // TODO need to get dynamically
        _addressList[0] = 0x627306090abab3a6e1400e9345bc60c78a8bef57;
        _loyaltyList[0] = 60;

        _addressList[1] = 0xf17f52151ebef6c7334fad080c5704d77216b732;
        _loyaltyList[1] = 40;

        Assert.isTrue(proofOfRead.addBook(isbn, _addressList, _loyaltyList), "return value should be true");
    }

    function testIsValidScore() public {
        Assert.isTrue(isValidScore(1), "return value should be true");
        Assert.isTrue(isValidScore(5), "return value should be true");

        Assert.isFalse(isValidScore(0), "return value should be false");
        Assert.isFalse(isValidScore(6), "return value should be false");
    }
}
