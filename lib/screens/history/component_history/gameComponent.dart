import 'package:app_tinh_diem/screens/history/mockAPI_service/api_service.dart';
import 'package:app_tinh_diem/screens/history/model_history/gameInfo.dart';

import 'package:flutter/material.dart';

class GameComponent extends StatefulWidget {

  final GameInfo? gameInfo;
  final VoidCallback? onDelete;
  final VoidCallback onCoppy;
  GameComponent({super.key, required this.gameInfo, this.onDelete, required this.onCoppy});


  @override
  State<GameComponent> createState() => _GameComponentState();
}

class _GameComponentState extends State<GameComponent> {
  @override
  Widget build(BuildContext context) {
    return infoComponent(widget.gameInfo!);
  }

  Widget infoComponent(GameInfo gameInfo) {
    // noi chuoi danh sach player
    String name = '';
    for (var i = 0; i < gameInfo.playerInfo.length; i++) {
      if (i != gameInfo.playerInfo.length - 1) {
        name += gameInfo.playerInfo[i].name.toString() + ', ';
      } else {
        name += gameInfo.playerInfo[i].name.toString();
      }
    }

    String limit = '';
    //noi chuoi limit thanh "gioi han diem: gameInfo.gameConfig.limitPoints, gioi han vong: gameInfo.gameConfig.limitRound"
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

    //Noi chuoi thoi gian
    String time = '';
    DateTime now = DateTime.now();
    if (gameInfo.now?.day == now.day) {
      time = 'Hôm nay';
    } else {
      if (gameInfo.now?.day == now.day - 1) {
        time = 'Hôm qua';
      } else {
        time = gameInfo.now.toString();
      }
    }
    double height = MediaQuery.of(context).orientation == Orientation.portrait
        ? MediaQuery.of(context).size.height * 0.12
        : MediaQuery.of(context).size.width * 0.12;
    return Container(
      padding: EdgeInsets.all(10),
      height: height,

      color: Colors.grey[300],
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: FractionallySizedBox(
              heightFactor:
                  1.0, // Set the height to 100% of the parent container's height
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    children: [
                      Text(
                        limit,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                   SizedBox(height: 5,),
                  Row(
                    children: [
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: FractionallySizedBox(
              heightFactor:
                  1.0,
              child: Container(
                color: Colors.grey[300],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 40,
                      child: TextButton(
                        onPressed: () async {
                          try {
                            final copiedGame = await copyGame(widget.gameInfo!.id!);
                            // Xử lý sau khi copy thành công (ví dụ: hiển thị thông báo)
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Copied game successful ${copiedGame.id}')),
                            );
                            widget.onCoppy.call();
                          } catch (e) {
                            // Xử lý lỗi copy
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to copy game: $e')),
                            );
                          }
                        },
                        child: Icon(Icons.copy, size: 20, color: Colors.black),
                      ),
                    ),
                    SizedBox(

                      width: 40,
                      child: TextButton(
                        onPressed: () async {
                          try {
                            print(widget.gameInfo!.id!.toString());

                            await deleteGame(widget.gameInfo!.id!);
                            // Xử lý sau khi delete thành công
                            widget.onDelete?.call();
                          } catch (e) {
                            // Xử lý lỗi delete
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to delete game: $e')),
                            );
                          }
                        },
                        child: Icon(Icons.delete, size: 20, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
