import 'package:app_tinh_diem/screens/history/model_history/gameConfig.dart';
import 'package:app_tinh_diem/screens/history/model_history/playerInfo.dart';

class GameInfo {
  String? _id;
  List<PlayerInfo> _playerInfo = [];
  GameConfig? _gameConfig;
  DateTime? now;

  GameInfo(
      {required String id ,required List<PlayerInfo> playerInfo,
      required GameConfig gameConfig,
      required DateTime now}) {
    this._id=id;
    this._playerInfo = playerInfo;
    this._gameConfig = gameConfig;
    this.now = now;
  }

  GameInfo.empty() {
    this._playerInfo = [];
    this._gameConfig = GameConfig.empty();
    this.now = DateTime.now();
  }


  List<PlayerInfo> get playerInfo => _playerInfo;

  GameConfig? get gameConfig => _gameConfig;

  String? get id => _id;

  set playerInfo(List<PlayerInfo> playerInfo) {
    this._playerInfo = playerInfo;
  }

  set gameConfig(GameConfig? gameConfig) {
    this._gameConfig = gameConfig;
  }

  int currentMaxPoints() {
    int max = 0;
    for (int i = 0; i < _playerInfo.length; i++) {
      if (_playerInfo[i].point! > max) {
        max = _playerInfo[i].point!.toInt();
      }
    }
    return max;
  }

  Map<String, dynamic> toJson() {
    return {
      'playerInfo': _playerInfo.map((player) => player.toJson()).toList(),
      'gameConfig': _gameConfig!.toJson(),
      'now': now?.toIso8601String(),
    };
  }

  factory GameInfo.fromJson(Map<String, dynamic> json) {
    return GameInfo(
      playerInfo: (json['playerInfo'] as List)
          .map((playerJson) => PlayerInfo.fromJson(playerJson))
          .toList(),
      gameConfig: GameConfig.fromJson(json['gameConfig']),
      now: DateTime.parse(json['now']), id: json['id'],
    );
  }
}
