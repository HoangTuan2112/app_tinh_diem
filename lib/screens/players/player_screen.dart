import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:app_tinh_diem/screens/players/player_provider.dart';

class Players extends StatelessWidget {
  const Players({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<PlayerListProvider>(
            builder: (context, playerListProvider, child) {
              final count = playerListProvider.playerNames.length;
              return Text(
                'Bạn đã sao lưu $count người chơi',
                style: const TextStyle(color: Colors.black, fontSize: 18),
              );
            },
          ),
        ),
        Expanded(
          child: Consumer<PlayerListProvider>(
            builder: (context, playerListProvider, child) {
              final playerNames = playerListProvider.playerNames;

              if (playerListProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (playerListProvider.hasError) {
                return Center(
                    child: Text(
                      'Error: ${playerListProvider.errorMessage}',
                    ));
              }

              if (playerNames.isEmpty) {
                return const Center(
                  child: Text(
                    'No players found.',
                  ),
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent( // Changed
                  maxCrossAxisExtent: 150.0, // Maximum width for each item
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  // childAspectRatio: 1.0, // Removed fixed aspect ratio
                ),
                itemCount: playerNames.length,
                itemBuilder: (context, index) {
                  return PlayerGridItem(playerName: playerNames[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class PlayerGridItem extends StatelessWidget {
  final String playerName;

  const PlayerGridItem({Key? key, required this.playerName}) : super(key: key);

  Color _getRandomColor() {
    final random = Random();
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1,
    );
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _getRandomColor(); // Get color once

    return InkWell(
      onTap: () {
        print('Tapped on $playerName');
      },
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor, // Use the random color for the background
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(8.0), // Add padding *inside* the container
        child: Row( //Changed to Row
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween, //Important for Text to wrap
          children: [
            Expanded( // Wrap Text in Expanded
              child: Text(
                playerName,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center, // Center the text
                // overflow: TextOverflow.ellipsis, // No longer needed, text will wrap
                // maxLines: 1,                   // No longer needed
              ),
            ),
            IconButton( // Changed to IconButton
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {
                Provider.of<PlayerListProvider>(context, listen: false)
                    .deletePlayer(playerName);
              },
              icon: const Icon(Icons.delete, color: Colors.white70), // Icon button
              iconSize: 20,
            ),
          ],
        ),
      ),
    );
  }
}