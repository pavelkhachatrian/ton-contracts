pragma ton-solidity >= 0.47.0;


import "./../_ErrorCodes.sol";


contract CheckPubKey {
    modifier checkPubKey() {
        require(msg.pubkey() == tvm.pubkey(), _ErrorCodes.DIFFERENT_PUB_KEYS);
        _;
    }
}
