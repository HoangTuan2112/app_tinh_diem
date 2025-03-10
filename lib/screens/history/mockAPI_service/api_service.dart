import 'package:app_tinh_diem/screens/history/model_history/gameInfo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model_history/gameConfig.dart';
import '../model_history/playerInfo.dart';

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
    // Tạo một GameInfo mới từ dữ liệu JSON, nhưng thay đổi id và now
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
    body: jsonEncode(newGame.toJson()), // Send the GameInfo object as JSON
  );

  if (response.statusCode == 201) {
    // If the server returns a 201 CREATED response, parse the JSON and return the new GameInfo.
    return GameInfo.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // throw an exception.
    throw Exception(
        'Failed to create game. Status code: ${response.statusCode}, Body: ${response.body}');
  }
}
