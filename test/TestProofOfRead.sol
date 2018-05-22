pragma solidity 0.4.24;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/ProofOfRead.sol";


contract TestProofOfRead {

    function testInitialIsActive() public {
        ProofOfRead proofOfRead = new ProofOfRead();

        Assert.isTrue(proofOfRead.getIsActive(), "isActive should be true");
    }

    function testInitialMaxLengthOfAuthors() public {
        ProofOfRead proofOfRead = new ProofOfRead();

        Assert.equal(uint(proofOfRead.getMaxLengthOfAuthors()), 6, "maxLengthOfAuthors should be 6");
    }

    /*
     function testInitialAuthors() public {
        ProofOfRead proofOfRead = new ProofOfRead();

        address[] memory addressList;
        uint8[] memory LoyaltyList;
        (addressList, LoyaltyList) = proofOfRead.getAuthors(1);

        Assert.equal(uint(addressList.length), 6, "maxLengthOfAuthors should be 6");
    }
    */

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

}
