import 'package:app_tinh_diem/model/game_info.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../model/game_config.dart';
import '../../../model/player_info.dart';

Future<List<GameInfo>> fetchGames() async {
  final response = await http
      .get(Uri.parse('https://67c7c277c19eb8753e7a9e2b.mockapi.io/games'));

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((gameJson) => GameInfo.fromJson(gameJson)).toList();
  } else {
    throw Exception('Failed to load games');
  }
}

Future<GameInfo> copyGame(String gameId) async {
  final response = await http.get(
      Uri.parse('https://67c7c277c19eb8753e7a9e2b.mockapi.io/games/$gameId'));
  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData = jsonDecode(response.body);

    final newGameInfo = GameInfo(
      id: '',
      playerInfo: (jsonData['playerInfo'] as List)
          .map((playerJson) => PlayerInfo.fromJson(playerJson))
          .toList(),
      gameConfig: GameConfig.fromJson(jsonData['gameConfig']),
      now: DateTime.now(),
    );
    final createResponse = await http.post(
      Uri.parse('https://67c7c277c19eb8753e7a9e2b.mockapi.io/games'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(newGameInfo.toJson()),
    );
    if (createResponse.statusCode == 201) {
      // Trả về game mới được tạo
      return GameInfo.fromJson(jsonDecode(createResponse.body));
    } else {
      throw Exception('Failed to create new game');
    }
  } else {
    throw Exception('Failed to copy game');
  }
}

Future<void> deleteGame(String gameId) async {
  final response = await http.delete(
      Uri.parse('https://67c7c277c19eb8753e7a9e2b.mockapi.io/games/$gameId'));
  if (response.statusCode != 200) {
    throw Exception('Failed to delete game');
  }
}

Future<GameInfo> createGame(GameInfo newGame) async {
  final response = await http.post(
    Uri.parse('https://67c7c277c19eb8753e7a9e2b.mockapi.io/games'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(newGame.toJson()),
  );

  if (response.statusCode == 201) {
    return GameInfo.fromJson(jsonDecode(response.body));
  } else {
    throw Exception(
        'Failed to create game. Status code: ${response.statusCode}, Body: ${response.body}');
  }
}

Future<GameInfo> updateGame(GameInfo updatedGame) async {
  final response = await http.put(
    Uri.parse(
        'https://67c7c277c19eb8753e7a9e2b.mockapi.io/games/${updatedGame.id}'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(updatedGame.toJson()),
  );
  if (response.statusCode == 200) {
    return GameInfo.fromJson(jsonDecode(response.body));
  } else {
    throw Exception(
        'Failed to update game. Status code: ${response.statusCode}, Body: ${response.body}');
  }
}


// Inside api_service.dart
Future<List<String>> fetchPlayerNamesClientSide() async {
  final List<GameInfo> games = await fetchGames();
  print("Fetched games: $games"); // Debug print

  final Set<String> playerNames = {};

  for (final game in games) {
    print("Game ID: ${game.id}"); // Debug print
    for (final player in game.playerInfo) {
      print("Player Name: ${player.name}"); // Debug print
      playerNames.add(player.name!.trim());
    }
  }

  print("Extracted player names: $playerNames"); // Debug print
  return playerNames.toList();
}