
import 'package:app_tinh_diem/screens/history/model_history/gameConfig.dart';
import 'package:app_tinh_diem/screens/history/model_history/playerInfo.dart';

class GameInfo {
  List<PlayerInfo> _playerInfo=[];
  GameConfig? _gameConfig;
  DateTime now = DateTime.now();

  GameInfo({required List<PlayerInfo> playerInfo, required GameConfig gameConfig}){
    this._playerInfo = playerInfo;
    this._gameConfig = gameConfig;
  }
  List<PlayerInfo> get playerInfo => _playerInfo;
  GameConfig? get gameConfig => _gameConfig;
  set playerInfo(List<PlayerInfo> playerInfo){
    this._playerInfo = playerInfo;
  }
  set gameConfig(GameConfig? gameConfig){
    this._gameConfig = gameConfig;
  }

  int currentMaxPoints(){
    int max = 0;
    for (int i = 0; i < _playerInfo.length; i++){
      if (_playerInfo[i].point! > max){
        max = _playerInfo[i].point!.toInt();
      }
    }
    return max;
  }




  
}