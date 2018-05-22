pragma solidity 0.4.23;


contract ProofOfRead {

    struct Author {
        address addr;
        uint loyalty;
    }

    struct Book {
        bytes32 isbn;
        Author[] authors;
    }

    Book public book;
    mapping(bytes32 => Author) public books;

    event Logging (bytes32 _isbn, address reader, uint8 score);

    function ProofOfRead(bytes32 _isbn, address[] _addressList, uint[] _loyaltyList) {
        // constructor
        book.isbn = _isbn;

        // TODO validate isbn code
        require(isEqualLength(_addressList, _loyaltyList));

        for (var i = 0; i < _addressList.length; i++) {
            book.authors.push(Author({addr : _addressList[i], loyalty : _loyaltyList[i]}));
        }
    }

    function addBook(bytes32 _isbn, address[] _addressList, uint[] _loyaltyList) public {
        // TODO ownerble

        require(isEqualLength(_addressList, _loyaltyList));
        require(isValidIsbn(_isbn));

        Author authors;
        for (var i = 0; i < _addressList.length; i++) {
            authors.push(Author({addr : _addressList[i], loyalty : _loyaltyList[i]}));
        }

        books[_isbn] = authors;
    }

    function getAuthors(bytes32 _isbn) public view returns (address[], uint8) {
        address[] _addressList;
        uint8[] _loyaltyList;
        _book = books[_isbn];

        for (var i = 0; i < _book.authors.length; i++) {
            _addressList.push(_book.authors[i].addr);
            _loyaltyList.push(_book.authors[i].loyalty);
        }
        return (_addressList, _loyaltyList);
    }

    function recordReadingHistory(bytes32 _isbn, uint8 score) public payable {
        require(isValidScore(_score));
        require(isIsbnExists(_isbn));

        // TODO split ether
        books[_isbn].authors[0].transfer(msg.value);

        Logging(_isbn, msg.sender, score);
    }

    function isEqualLength(address[] a1, uint8[] a2) private view returns (bool) {
        // Return whether the lengths of two arrays are equal.
        return (a1.length == a2.length);
    }

    function isValidIsbn(bytes32 _isbn) private view returns (bool) {
        // Return whether a ISBN is valid.
        // TODO need to implement
        return true;
    }

    function isIsbnExists(bytes32 _isbn) private view returns (bool) {
        // Return whether a ISBN exists.
        return books[_isbn];
    }

    function isValidScore(uint8 _score) private view returns (bool) {
        // Return whether a score is valid. It should be between 1 and 5.
        if (_score >= 1 && _score <= 5) {
            return true;
        }
        return false;
    }
}
