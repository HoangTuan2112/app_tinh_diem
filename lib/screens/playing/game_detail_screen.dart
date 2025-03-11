import 'package:app_tinh_diem/model/game_info.dart';
import 'package:app_tinh_diem/model/round.dart'; // Import the Round model
import 'package:app_tinh_diem/screens/history/api_service/api_service.dart';
import 'package:app_tinh_diem/screens/playing/add_round_screen.dart';
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
  late GameInfo currentGame; // Store the current game locally

  @override
  void initState() {
    super.initState();
    if (widget.gameInfo != null) {
      currentGame = widget.gameInfo!; // Initialize currentGame
      playerNames = currentGame.playerInfo.map((player) => player.name).toList();
      playerScores = _calculateTotalScores(currentGame);
      currentRound = currentGame.rounds.length;
      currentMaxScore = playerScores.isNotEmpty ? playerScores.max : 0;

      if (currentGame.gameConfig!.isLimitRound) {
        maxRounds = currentGame.gameConfig!.limitRound.toString();
      }
      if (currentGame.gameConfig!.isLimitPoints) {
        maxScore = currentGame.gameConfig!.limitPoints.toString();
      }
    }
  }
  List<int> _calculateTotalScores(GameInfo game) {
    final numPlayers = game.playerInfo.length;
    final totalScores = List<int>.filled(numPlayers, 0);

    for (final round in game.rounds) {
      for (int i = 0; i < numPlayers; i++) {
        if (i < round.scores.length) {
          totalScores[i] += round.scores[i];
        }
      }
    }
    return totalScores;
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

  void _addRound() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddRoundScreen(
          playerNames: playerNames.map((name) => name ?? 'Unknown').toList(), // Handle null names
          roundNumber: currentRound + 1, // Pass the next round number
          onSave: (Round newRound) {
            // Update local state (add the new round)
            setState(() {
              currentGame = currentGame.copyWith(
                  rounds: List.from(currentGame.rounds)..add(newRound));
              currentRound = currentGame.rounds.length;
              playerScores =
                  _calculateTotalScores(currentGame); // Recalculate
              currentMaxScore = playerScores.max;
            });

            // Update the game on the server.  VERY IMPORTANT
            _updateGameOnServer();

          },
        ),
      ),
    );
  }

  Future<void> _updateGameOnServer() async {
    try{
      await updateGame(currentGame); // Use api_service
      // Optionally show success message.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Round added and game updated!")),
      );

    } catch(e){
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update game: $e")),
      );
      // Consider reverting local state if the update failed.
    }
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
            child: currentGame.rounds.isEmpty
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
              itemCount: currentGame.rounds.length,
              itemBuilder: (context, index) {
                final round = currentGame.rounds[index];
                return ListTile(
                  title: Text(
                    'Ván ${round.roundNumber}', // Show round number
                    style: const TextStyle(color: Colors.black),
                  ),
                  subtitle: Row( // Display scores in subtitle
                    children: round.scores.map((score) =>
                        Padding(
                            padding: EdgeInsets.only(right: 16.0),
                            child: Text('$score'))).toList(),
                  ),
                  // Add more details (notes, etc.) as needed
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addRound, // Use _addRound
        backgroundColor: Colors.blue,
        icon: const Icon(Icons.add),
        label: const Text('THÊM VÁN MỚI'),
      ),
    );
  }
}