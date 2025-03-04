import 'package:app_tinh_diem/screens/history/component_history/gameComponent.dart';
import 'package:app_tinh_diem/screens/history/model_history/gameConfig.dart';
import 'package:app_tinh_diem/screens/history/model_history/gameInfo.dart';
import 'package:app_tinh_diem/screens/history/model_history/playerInfo.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    List<PlayerInfo> playerInfo = [
      PlayerInfo(name: 'A', point: 1),
      PlayerInfo(name: 'B', point: 2),
      PlayerInfo(name: 'C', point: 3),
      PlayerInfo(name: 'D', point: 4),
    ];
    List<PlayerInfo> playerInfo2 = [
      PlayerInfo(name: 'A2', point: 1),
      PlayerInfo(name: 'B2', point: 2),
      PlayerInfo(name: 'C2', point: 3),
      PlayerInfo(name: 'D2', point: 4),
    ];
    List<PlayerInfo> playerInfo3 = [
      PlayerInfo(name: 'A3', point: 1),
      PlayerInfo(name: 'B3', point: 2),
      PlayerInfo(name: 'C3', point: 3),
      PlayerInfo(name: 'D3', point: 4),
    ];
    List<PlayerInfo> playerInfo4 = [
      PlayerInfo(name: 'A4', point: 1),
      PlayerInfo(name: 'B4', point: 2),
      PlayerInfo(name: 'C4', point: 3),
      PlayerInfo(name: 'D4', point: 4),
    ];
    GameConfig gameConfig = GameConfig(
        isLimitPoints: false,
        limitPoints: 0,
        isLimitRound: true,
        limitRound: 5,
        isAutoCalculate: true,
        currentRound: 0);
    GameConfig gameConfig2 = GameConfig(
        isLimitPoints: true,
        limitPoints: 10,
        isLimitRound: true,
        limitRound: 8,
        isAutoCalculate: true,
        currentRound: 0);
    GameConfig gameConfig3 = GameConfig(
        isLimitPoints: true,
        limitPoints: 10,
        isLimitRound: false,
        limitRound: 0,
        isAutoCalculate: true,
        currentRound: 0);
    GameConfig gameConfig4 = GameConfig(
        isLimitPoints: false,
        limitPoints: 10,
        isLimitRound: false,
        limitRound: 0,
        isAutoCalculate: true,
        currentRound: 0);

    late GameInfo gameInfo;
    late GameInfo gameInfo2;
    late GameInfo gameInfo3;
    late GameInfo gameInfo4;
    late GameInfo gameInfo5;
    DateTime now = DateTime.now();
    DateTime yesterday = DateTime.now().subtract(Duration(days: 1));
    DateTime old = DateTime.now().subtract(Duration(days: 2));

    gameInfo = GameInfo(playerInfo: playerInfo, gameConfig: gameConfig);
    gameInfo2 = GameInfo(playerInfo: playerInfo2, gameConfig: gameConfig2);
    gameInfo3 = GameInfo(playerInfo: playerInfo3, gameConfig: gameConfig3);
    gameInfo4 = GameInfo.now(
        playerInfo: playerInfo, gameConfig: gameConfig, time: yesterday);
    gameInfo5 = GameInfo.now(
        playerInfo: playerInfo2, gameConfig: gameConfig2, time: old);
    listItem = [
      gameInfo,
      gameInfo2,
      gameInfo3,
      gameInfo4,
      gameInfo5,
      gameInfo,
      gameInfo2,
      gameInfo3,
      gameInfo4,
      gameInfo5,
      gameInfo,
      gameInfo2,
      gameInfo3,
      gameInfo4,
      gameInfo5,
    ]; // Khởi tạo listItem
  }

  late List<GameInfo> listItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton.icon(
                  onPressed: () {},
                  label: Text('Hôm nay'),
                  icon: Icon(Icons.calendar_today)),
              ElevatedButton.icon(
                  onPressed: () {},
                  label: Text('Hôm qua'),
                  icon: Icon(Icons.calendar_today)),
              ElevatedButton.icon(
                  onPressed: () {},
                  label: Text('Cũ hơn'),
                  icon: Icon(Icons.calendar_today)),
            ],
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: listItem.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      GameComponent(gameInfo: listItem[index]),
                      SizedBox(
                        height: 16,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: Icon(Icons.add),
        label: Text('Tạo trò chơi mới'), // Thêm label
        // Các thuộc tính tùy chỉnh khác (backgroundColor, foregroundColor, shape...)
      ),
    );
  }
}
