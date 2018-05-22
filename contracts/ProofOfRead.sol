pragma solidity 0.4.23;


contract ProofOfRead {

    struct Author {
        address addr;
        uint loyalty;
    }

    struct Book {
        bytes32 isbn13;
        Author[] authors;
    }

    bool public isActive;
    mapping(bytes32 => Author) public books;

    event Logging (bytes32 _isbn13, address reader, uint8 score);

    function ProofOfRead(bool _isActive) public {
        isActive = _isActive;
    }

    function activateContract() public {
        isActive = true;
    }

    function deactivateContract() public {
        isActive = false;
    }

    function addBook(bytes32 _isbn13, address[] _addressList, uint[] _loyaltyList) public {
        // TODO ownerble

        require(isEqualLength(_addressList, _loyaltyList));
        require(isValidIsbn(_isbn13));

        Author authors;
        for (var i = 0; i < _addressList.length; i++) {
            authors.push(Author({addr : _addressList[i], loyalty : _loyaltyList[i]}));
        }

        books[_isbn13] = authors;
    }

    function getAuthors(bytes32 _isbn13) public view returns (address[], uint8) {
        address[] _addressList;
        uint8[] _loyaltyList;
        _book = books[_isbn13];

        for (var i = 0; i < _book.authors.length; i++) {
            _addressList.push(_book.authors[i].addr);
            _loyaltyList.push(_book.authors[i].loyalty);
        }
        return (_addressList, _loyaltyList);
    }

    function recordReadingHistory(bytes32 _isbn13, uint8 score) public payable {
        assert(isActive);

        require(isValidScore(_score));
        require(isIsbnExists(_isbn13));

        // TODO split ether
        books[_isbn13].authors[0].transfer(msg.value);

        Logging(_isbn13, msg.sender, score);
    }

    function isEqualLength(address[] a1, uint8[] a2) private pure returns (bool) {
        // Return whether the lengths of two arrays are equal.
        return (a1.length == a2.length);
    }

    function isValidIsbn(bytes32 _isbn13) private pure returns (bool) {
        // Return whether a ISBN is valid.
        // TODO need to implement
        return true;
    }

    function isIsbnExists(bytes32 _isbn13) private pure returns (bool) {
        // Return whether a ISBN exists.
        return books[_isbn13];
    }

    function isValidScore(uint8 _score) private pure returns (bool) {
        // Return whether a score is valid. It should be between 1 and 5.
        if (_score >= 1 && _score <= 5) {
            return true;
        }
        return false;
    }
}
