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
  late String maxRounds ="∞";
  late String maxScore="∞";
  late int currentRound;
  late int currentMaxScore;
  List<dynamic> gameRounds = [];

  @override
  void initState() {
    super.initState();
    if (widget.gameInfo != null) {
      playerNames =
          widget.gameInfo!.playerInfo.map((player) => player.name).toList();
      // Initialize scores to 0 or get them from your data source
      playerScores = widget.gameInfo!.playerInfo.map((player) => player.point).cast<int>().toList();
      if(widget.gameInfo!.gameConfig!.isLimitRound){
        maxRounds=(widget.gameInfo!.gameConfig?.limitRound) .toString();
      }
      else {
        maxRounds = "∞";
      }
      if(widget.gameInfo!.gameConfig!.isLimitPoints){
        maxScore=(widget.gameInfo!.gameConfig?.limitPoints) .toString();
      }
      else {
        maxScore = "∞";
      }
      currentRound = widget.gameInfo!.gameConfig?.currentRound?? 0;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết trò chơi'),
        backgroundColor: Colors.blue, // Match the image
        elevation: 0, // Remove the shadow
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Implement settings
              print('Settings Pressed');
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      backgroundColor: Colors.white, // Match the image
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
                      playerNames[index] ?? '?',
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500), // Style consistent
                      overflow: TextOverflow.ellipsis, // Prevent overflow
                    ),
                    const SizedBox(height: 8),
                    // Stack for layout
                    Stack(
                      alignment: Alignment.center,
                      children: [

                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 20, // Adjust the radius as needed
                          child: Text(
                            '${playerScores[index]}', // Display score
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20, // Adjust font size
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
                ? Center(
                    // Center the content
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // Center vertically
                      children: [
                        const Icon(Icons.sentiment_dissatisfied,
                            size: 64, color: Colors.grey), // Icon with styling
                        const SizedBox(height: 16),
                        const Text(
                          'Chưa có ván chơi nào',
                          style: TextStyle(
                              color: Colors.grey, fontSize: 18), // Styling
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Thêm ván mới bằng cách bấm vào\nhình (+) bên dưới',
                          // Added newline for better display
                          style: TextStyle(color: Colors.grey),
                          textAlign: TextAlign.center, // Center-align the text
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
                          style: TextStyle(color: Colors.black),
                        ), // Style the round display
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
