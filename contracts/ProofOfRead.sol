pragma solidity 0.4.23;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";


/**
 * @title ProofOfRead
 */
contract ProofOfRead is Ownable {

    // Author of a Book
    struct Author {
        address addr;
        uint loyalty;
    }

    // Book
    struct Book {
        bytes32 isbn13;
        Author[] authors;
    }

    bool public isActive;
    uint8 private maxLengthOfAuthors;

    mapping(bytes32 => Author) public books;

    event Logging (bytes32 _isbn13, address reader, uint8 score);

    function ProofOfRead(bool _isActive) public {
        isActive = _isActive;
        maxLengthOfAuthors = 6;
    }

    function activateContract() public onlyOwner {
        isActive = true;
    }

    function deactivateContract() public onlyOwner {
        isActive = false;
    }

    function changeMaxLengthOfAuthors(uint8 _maxLength) public onlyOwner {
        maxLengthOfAuthors = _maxLength;
    }

    /**
     * @dev Add a book information to this Contract.
     */
    function addBook(bytes32 _isbn13, address[] _addressList, uint[] _loyaltyList) public onlyOwner {

        require(isISBN(_isbn13));
        require(_addressList.length <= maxLengthOfAuthors);
        require(isEqualLength(_addressList, _loyaltyList));
        require(isTotal100(_loyaltyList));

        for (var i = 0; i < _addressList.length; i++) {
            books[_isbn13].authors.push(Author({addr : _addressList[i], loyalty : _loyaltyList[i]}));
        }
    }

    /**
     * @dev Remove a book information from this Contract.
     * @param _isbn13 An ISBN code
     */
    function removeBook(bytes32 _isbn13) public onlyOwner {

        require(isISBN(_isbn13));

        delete books[_isbn13];
    }

    /**
     * @dev Get authors from this Contract.
     * @param _isbn13 An ISBN code
     */
    function getAuthors(bytes32 _isbn13) public view returns (address[], uint8) {

        require(isISBNExists(_isbn13));

        address[] memory _addressList;
        uint8[] memory _loyaltyList;
        bytes32 memory _book;

        _book = books[_isbn13];

        for (var i = 0; i < _book.authors.length; i++) {
            _addressList.push(_book.authors[i].addr);
            _loyaltyList.push(_book.authors[i].loyalty);
        }
        return (_addressList, _loyaltyList);
    }

    /**
     * @dev Record the reading history of a reader.
     * @param _isbn13 An ISBN code
     * @param _score The score from the reader for books
     */
    function recordReadingHistory(bytes32 _isbn13, uint8 score) public payable {
        assert(isActive);

        require(isValidScore(_score));
        require(isISBNExists(_isbn13));

        // TODO split ether
        books[_isbn13].authors[0].transfer(msg.value);

        Logging(_isbn13, msg.sender, score);
    }

    /**
     * @dev Return whether the result of a calculation equal 100.
     * @param a The array of numbers.
     */
    function isTotal100(uint8[] a) private pure returns (bool) {

        uint8 memory _total;

        _total = 0;
        for (var i = 0; i < a.length; i++) {
            _total = _total + a;
        }

        return (_total == 100);
    }

    /**
     * @dev Return whether the lengths of two arrays are equal.
     * @param a1 The array of addresses.
     * @param a2 The array of numbers.
     */
    function isEqualLength(address[] a1, uint8[] a2) private pure returns (bool) {
        return (a1.length == a2.length);
    }

    /**
     * @dev Return whether a ISBN is valid.
     * @param _isbn13 An ISBN code
     * https://github.com/chriso/validator.js/blob/3443132beccddf06c3f0a5e88c1dd2ee6513b612/src/lib/isISBN.js#L7
     */
    function isISBN(bytes32 _isbn13) private pure returns (bool) {
        // TODO: need to implement
        return true;
    }

    /**
     * @dev Return whether a ISBN exists.
     * @param _isbn13 An ISBN code
     */
    function isISBNExists(bytes32 _isbn13) private pure returns (bool) {
        return books[_isbn13];
    }

    /**
     * @dev Return whether a score is valid. It should be between 1 and 5.
     * @param _score The score from the reader for books
     */
    function isValidScore(uint8 _score) private pure returns (bool) {
        if (_score >= 1 && _score <= 5) {
            return true;
        }
        return false;
    }
}
