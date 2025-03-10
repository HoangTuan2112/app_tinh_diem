import 'package:app_tinh_diem/model/game_info.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class GameDetailScreen extends StatefulWidget {
  final GameInfo? gameInfo;

  const GameDetailScreen({Key? key, this.gameInfo}) : super(key: key);

  @override
  _GameDetailScreenState createState() => _GameDetailScreenState();
}

class _GameDetailScreenState extends State<GameDetailScreen> {
  late List<String?> playerNames;
  late List<int> playerScores;
  late String maxRounds = "∞";
  late String maxScore = "∞";
  late int currentRound;
  late int currentMaxScore;
  List<dynamic> gameRounds = [];

  @override
  void initState() {
    super.initState();
    if (widget.gameInfo != null) {
      playerNames =
          widget.gameInfo!.playerInfo.map((player) => player.name).toList();
      playerScores = widget.gameInfo!.playerInfo
          .map((player) => player.point)
          .cast<int>()
          .toList();
      if (widget.gameInfo!.gameConfig!.isLimitRound) {
        maxRounds = (widget.gameInfo!.gameConfig?.limitRound).toString();
      } else {
        maxRounds = "∞";
      }
      if (widget.gameInfo!.gameConfig!.isLimitPoints) {
        maxScore = (widget.gameInfo!.gameConfig?.limitPoints).toString();
      } else {
        maxScore = "∞";
      }
      currentRound = widget.gameInfo!.gameConfig?.currentRound ?? 0;
      currentMaxScore = playerScores.max;
    }
  }

  void _addRound() {
    print('Add Round Pressed');
    setState(() {
      gameRounds.add("New Round");
      // maxRounds = gameRounds.length as String;
    });
  }
  // Modified _truncatePlayerName to consider orientation
  String _truncatePlayerName(String? name, Orientation orientation) {
    if (name == null) {
      return '?';
    }
    if (orientation == Orientation.portrait && name.length > 8) { // Only truncate in portrait
      return name.substring(0, 8) + '...';
    }
    return name; // Return full name in landscape
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation; // Get orientation

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết trò chơi'),
        backgroundColor: Colors.blue,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              print('Settings Pressed');
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Player Scores Display
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(playerNames.length, (index) {
                return Column(
                  children: [
                    Text(
                      _truncatePlayerName(playerNames[index], orientation), // Pass orientation
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 20,
                          child: Text(
                            '${playerScores[index]}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
            ),
          ),

          // Game Limits
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              '[ Ván tối đa: $currentRound/$maxRounds, Điểm số tối đa:  $currentMaxScore/$maxScore ]',
              style: const TextStyle(color: Colors.black),
            ),
          ),

          // Game Rounds Display (Conditional)
          Expanded(
            child: gameRounds.isEmpty
                ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sentiment_dissatisfied,
                      size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Chưa có ván chơi nào',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Thêm ván mới bằng cách bấm vào\nhình (+) bên dưới',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
                : ListView.builder(
              itemCount: gameRounds.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    'Round ${index + 1}: ${gameRounds[index]}',
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addRound,
        backgroundColor: Colors.blue,
        icon: const Icon(Icons.add),
        label: const Text('THÊM VÁN MỚI'),
      ),
    );
  }
}