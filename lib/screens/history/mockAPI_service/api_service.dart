import 'package:app_tinh_diem/screens/history/model_history/gameInfo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



Future<List<GameInfo>> fetchGames() async {
  final response = await http.get(Uri.parse('https://67c7c277c19eb8753e7a9e2b.mockapi.io/games'));

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((gameJson) => GameInfo.fromJson(gameJson)).toList();
  } else {
    throw Exception('Failed to load games');
  }
}