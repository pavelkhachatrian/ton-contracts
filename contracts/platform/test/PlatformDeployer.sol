pragma ton-solidity >= 0.47.0;

import "../Platform.sol";
import "../../libraries/MsgFlag.sol";

contract PlatformDeployer {
    uint8 constant DEFAULT_PLATFORM_TYPE = 1;
    uint128 constant DEFAULT_PLATFORM_DEPLOY_VALUE = 0.1 ton;

    TvmCell public platformCode;
    TvmCell public platformBasedImage;

    constructor (TvmCell _platformCode, TvmCell _platformBasedImage) public {
        tvm.accept();
        platformCode = _platformCode;
        platformBasedImage = _platformBasedImage;
    }

    function expectedAddress(address root, uint32 id, uint8 platformType) public view returns (address){
        TvmBuilder initialData;
        initialData.store(id);
        return address(tvm.hash(_buildState(root, platformType, initialData.toCell())));
    }

    function deployPlatformBased(uint32 id, uint32 notId, uint8 platformType) public {
        tvm.accept();
        deploy(address(this), id, notId, platformType);
    }

    function deployNotFromRoot(address root, uint32 id, uint32 notId, uint8 platformType) public {
        tvm.accept();
        deploy(root, id, notId, platformType);

    }

    function deploy(address root, uint32 id, uint32 notId, uint8 platformType) private {
        TvmBuilder initialData;
        initialData.store(id);
        TvmBuilder params;
        params.store(notId);
        new Platform{
            stateInit: _buildState(root, platformType, initialData.toCell()),
            value: DEFAULT_PLATFORM_DEPLOY_VALUE,
            flag: MsgFlag.SENDER_PAYS_FEES
        }(platformBasedImage, params.toCell(), msg.sender);
    }

    function _buildState(address root, uint8 platformType, TvmCell initialData) private view returns (TvmCell) {
        return tvm.buildStateInit({
            contr: Platform,
            varInit: {
                root: root,
                platformType: platformType,
                initialData: initialData,
                platformCode: platformCode
            },
            pubkey: 0,
            code: platformCode
        });
    }
}
