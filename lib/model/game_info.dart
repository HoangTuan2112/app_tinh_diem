import 'package:app_tinh_diem/model/player_info.dart';
import 'package:app_tinh_diem/model/round.dart';

import 'game_config.dart';

class GameInfo {
  String? id;
  List<PlayerInfo> playerInfo;
  GameConfig? gameConfig;
  DateTime? now;
  List<Round> rounds; // Add the list of rounds

  GameInfo({
    this.id,
    required this.playerInfo,
    this.gameConfig,
    this.now,
    this.rounds = const [], // Initialize with an empty list
  });

  factory GameInfo.fromJson(Map<String, dynamic> json) {
    return GameInfo(
      id: json['id'] as String?,
      playerInfo: (json['playerInfo'] as List<dynamic>)
          .map((playerJson) => PlayerInfo.fromJson(playerJson))
          .toList(),
      gameConfig: json['gameConfig'] != null
          ? GameConfig.fromJson(json['gameConfig'] as Map<String, dynamic>)
          : null,
      now: json['now'] != null ? DateTime.parse(json['now'] as String) : null,
      rounds: (json['rounds'] as List<dynamic>?)
          ?.map((roundJson) => Round.fromJson(roundJson))
          .toList() ??
          [], // Handle null or missing rounds
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'playerInfo': playerInfo.map((player) => player.toJson()).toList(),
      'gameConfig': gameConfig?.toJson(),
      'now': now?.toIso8601String(), // Use toIso8601String()
      'rounds': rounds.map((round) => round.toJson()).toList(), // Convert rounds to JSON
    };
  }

  // Optional: A copyWith method for GameInfo as well
  GameInfo copyWith({
    String? id,
    List<PlayerInfo>? playerInfo,
    GameConfig? gameConfig,
    DateTime? now,
    List<Round>? rounds,
  }) {
    return GameInfo(
      id: id ?? this.id,
      playerInfo: playerInfo ?? this.playerInfo,
      gameConfig: gameConfig ?? this.gameConfig,
      now: now ?? this.now,
      rounds: rounds ?? this.rounds,
    );
  }
  // Optional: toString for GameInfo
  @override
  String toString() {
    return 'GameInfo{id: $id, playerInfo: $playerInfo, gameConfig: $gameConfig, now: $now, rounds: $rounds}';
  }
}