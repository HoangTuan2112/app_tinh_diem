import 'package:app_tinh_diem/screens/history/api_service/api_service.dart';
import 'package:app_tinh_diem/model/game_info.dart';
import 'package:app_tinh_diem/screens/playing/playing.dart';
import 'package:flutter/material.dart';


class GameComponent extends StatefulWidget {
  final GameInfo? gameInfo;
  final VoidCallback? onDelete;
  final VoidCallback onCoppy;

  const GameComponent({
    Key? key,
    required this.gameInfo,
    this.onDelete,
    required this.onCoppy,
  }) : super(key: key);

  @override
  State<GameComponent> createState() => _GameComponentState();
}

class _GameComponentState extends State<GameComponent> {
  @override
  Widget build(BuildContext context) {
    // Wrap the entire widget with InkWell for tap handling
    return InkWell(
      onTap: () {
        // Navigate to GameDetailScreen when tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                GameDetailScreen(gameInfo: widget.gameInfo), // Pass gameInfo
          ),
        );
      },
      child: infoComponent(widget.gameInfo!),
    );
  }

  Widget infoComponent(GameInfo gameInfo) {
    String name = '';
    for (var i = 0; i < gameInfo.playerInfo.length; i++) {
      if (i != gameInfo.playerInfo.length - 1) {
        name += gameInfo.playerInfo[i].name.toString() + ', ';
      } else {
        name += gameInfo.playerInfo[i].name.toString();
      }
    }

    String limit = '';
    if (gameInfo.gameConfig?.isLimitPoints == true) {
      if (gameInfo.gameConfig?.isLimitRound == true) {
        limit +=
            'gioi han diem: ${gameInfo.gameConfig?.limitPoints}, gioi han vong: ${gameInfo.gameConfig?.limitRound}';
      } else {
        limit += 'gioi han diem: ${gameInfo.gameConfig?.limitPoints}';
      }
    } else {
      if (gameInfo.gameConfig?.isLimitRound == true) {
        limit += 'gioi han vong: ${gameInfo.gameConfig?.limitRound}';
      }
    }

    String time = '';
    DateTime now = DateTime.now();
    if (gameInfo.now?.day == now.day) {
      time = 'Hôm nay';
    } else {
      if (gameInfo.now?.day == now.day - 1) {
        time = 'Hôm qua';
      } else {
        time =
            '${gameInfo.now?.day.toString()} tháng ${gameInfo.now?.month.toString()} năm ${gameInfo.now?.year.toString()}';
      }
    }

    double height = MediaQuery.of(context).orientation == Orientation.portrait
        ? MediaQuery.of(context).size.height * 0.12
        : MediaQuery.of(context).size.width * 0.12;

    return Container(
      // Moved Container outside
      padding: const EdgeInsets.all(10),
      height: height,
      color: Colors.grey[300],
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: FractionallySizedBox(
              heightFactor: 1.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        limit,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        time,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2, //Kept flex
            child: FractionallySizedBox(
              // Kept FractionallySizeBox
              heightFactor: 1.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                //Kept Alignment
                children: [
                  SizedBox(
                    width: 40,
                    child: TextButton(
                      onPressed: () async {
                        try {
                          await copyGame(widget.gameInfo!.id!);
                          widget.onCoppy.call();
                        } catch (e) {
                          // Xử lý lỗi delete
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to coppy game: $e')),
                          );
                        }
                      },
                      child:
                          const Icon(Icons.copy, size: 20, color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    child: TextButton(
                      onPressed: () async {
                        try {
                          await deleteGame(widget.gameInfo!.id!);
                          // Xử lý sau khi delete thành công
                          widget.onDelete?.call();
                        } catch (e) {
                          // Xử lý lỗi delete
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Failed to delete game: $e')),
                          );
                        }
                      },
                      child: const Icon(Icons.delete,
                          size: 20, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
