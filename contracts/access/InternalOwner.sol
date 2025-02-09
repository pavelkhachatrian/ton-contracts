pragma ton-solidity >= 0.47.0;
pragma AbiHeader expire;
pragma AbiHeader pubkey;


import "./../_ErrorCodes.sol";


contract InternalOwner {
    address public owner;

    event OwnershipTransferred(address previousOwner, address newOwner);

    modifier onlyOwner() {
        require(msg.sender == owner, _ErrorCodes.NOT_OWNER);
        _;
    }

    /*
        @dev Internal function for setting owner
        Can be used in child contracts
    */
    function setOwnership(address newOwner) internal {
        address oldOwner = owner;

        owner = newOwner;

        emit OwnershipTransferred(oldOwner, newOwner);
    }

    /*
        @dev Transfer ownership to the new owner
    */
    function transferOwnership(
        address newOwner
    ) external onlyOwner {
        require(newOwner != address.makeAddrStd(0, 0), _ErrorCodes.ZERO_OWNER);

        setOwnership(newOwner);
    }

    /*
        @dev Renounce ownership. Can't be aborted!
    */
    function renounceOwnership() external onlyOwner {
        address newOwner = address.makeAddrStd(0, 0);

        setOwnership(newOwner);
    }
}
