pragma ton-solidity >= 0.47.0;

import "../PlatformBase.sol";

contract TestPlatform is PlatformBase {
    uint32 public /*static*/ id;
    uint32 public notId;
    uint8 public platformType;

    function onCodeUpgrade(TvmCell data) private {
        tvm.resetStorage();
        TvmSlice s = data.toSlice();
        address sendGasTo;
        (root, platformType, sendGasTo) = s.decode(address, uint8, address);

        platformCode = s.loadRef();

        TvmSlice initialData = s.loadRefAsSlice();
        id = initialData.decode(uint32);

        TvmSlice params = s.loadRefAsSlice();
        notId = params.decode(uint32);
    }

}
