pragma solidity 0.4.24;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";


/**
 * @title ProofOfRead
 */
contract ProofOfRead is Ownable {

    // Author of a Book
    struct Author {
        address addr;
        uint8 loyalty;
    }

    // Book
    struct Book {
        Author[] authors;
    }

    bool public isActive;
    uint8 private maxLengthOfAuthors;

    mapping(bytes32 => Book) private books;

    event Logging (bytes32 _isbn13, address reader, uint8 score);

    constructor() public {
        isActive = true;
        maxLengthOfAuthors = 6;
    }

    function setIsActive(bool _isActivate) public onlyOwner {
        isActive = _isActivate;
    }

    function getIsActive() public view onlyOwner returns (bool) {
        return isActive;
    }

    function setMaxLengthOfAuthors(uint8 _maxLengthOfAuthors) public onlyOwner {
        maxLengthOfAuthors = _maxLengthOfAuthors;
    }

    function getMaxLengthOfAuthors() public view onlyOwner returns (uint8) {
        return maxLengthOfAuthors;
    }

    function changeMaxLengthOfAuthors(uint8 _maxLength) public onlyOwner {
        maxLengthOfAuthors = _maxLength;
    }

    /**
     * @dev Add a book information to this Contract.
     */
    function addBook(bytes32 _isbn13, address[] _addressList, uint8[] _loyaltyList) public onlyOwner returns (bool) {

        require(isISBN(_isbn13));
        require(_addressList.length <= maxLengthOfAuthors);
        require(isEqualLength(_addressList, _loyaltyList));
        require(isTotal100(_loyaltyList));

        for (uint8 i = 0; i < _addressList.length; i++) {
            books[_isbn13].authors.push(Author({addr : _addressList[i], loyalty : _loyaltyList[i]}));
        }

        return true;
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
    function getAuthors(bytes32 _isbn13) public view returns (address[], uint8[]) {

        require(isISBNExists(_isbn13));

        Book memory _book;
        _book = books[_isbn13];

        uint len = _book.authors.length;

        address[] memory _addressList = new address[](len);
        uint8[] memory _loyaltyList = new uint8[](len);

        for (uint8 i = 0; i < _book.authors.length; i++) {
            _addressList[i] = _book.authors[i].addr;
            _loyaltyList[i] = _book.authors[i].loyalty;
        }
        return (_addressList, _loyaltyList);
    }

    /**
     * @dev Record the reading history of a reader.
     * @param _isbn13 An ISBN code
     * @param _score The score from the reader for books
     */
    function recordReadingHistory(bytes32 _isbn13, uint8 _score) public payable {
        assert(isActive);

        require(isValidScore(_score));
        require(isISBNExists(_isbn13));

        // TODO split ether
        books[_isbn13].authors[0].addr.transfer(msg.value);

        emit Logging(_isbn13, msg.sender, _score);
    }

    /**
     * @dev Return whether the result of a calculation equal 100.
     * @param a The array of numbers.
     */
    function isTotal100(uint8[] a) internal pure returns (bool) {

        uint8 _total;

        _total = 0;
        for (uint8 i = 0; i < a.length; i++) {
            _total = _total + a[i];
        }

        return (_total == 100);
    }

    /**
     * @dev Return whether the lengths of two arrays are equal.
     * @param a1 The array of addresses.
     * @param a2 The array of numbers.
     */
    function isEqualLength(address[] a1, uint8[] a2) internal pure returns (bool) {
        return (a1.length == a2.length);
    }

    /**
     * @dev Return whether a ISBN is valid.
     * @param _isbn13 An ISBN code
     * https://github.com/chriso/validator.js/blob/3443132beccddf06c3f0a5e88c1dd2ee6513b612/src/lib/isISBN.js#L7
     */
    function isISBN(bytes32 _isbn13) internal pure returns (bool) {
        // TODO: need to implement
        _isbn13;
        return true;
    }

    /**
     * @dev Return whether a ISBN exists.
     * @param _isbn13 An ISBN code
     */
    function isISBNExists(bytes32 _isbn13) internal view returns (bool) {
        if (books[_isbn13].authors.length > 0) {
            return true;
        }
        return false;
    }

    /**
     * @dev Return whether a score is valid. It should be between 1 and 5.
     * @param _score The score from the reader for books
     */
    function isValidScore(uint8 _score) internal pure returns (bool) {
        if (_score >= 1 && _score <= 5) {
            return true;
        }
        return false;
    }
}
