import 'package:app_tinh_diem/screens/history/component_history/gameComponent.dart';
import 'package:app_tinh_diem/screens/history/mockAPI_service/api_service.dart';
import 'package:flutter/material.dart';

import 'model_history/gameInfo.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<GameInfo>> _gamesFuture = [] as Future<List<GameInfo>>;

  @override
  void initState() {
    super.initState();
    _gamesFuture = fetchGames();
  }

  void _onDeleteGame() {
    setState(() {
      _gamesFuture = fetchGames(); // Fetch lại danh sách game
    });
  }

  void _onCoppyGame() {
    setState(() {
      _gamesFuture = fetchGames(); // Fetch lại danh sách game
    });
  }

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
              child: FutureBuilder<List<GameInfo>>(
                // Sử dụng FutureBuilder
                future: _gamesFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      // Truy cập length từ snapshot.data
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            GameComponent(
                                gameInfo: snapshot.data![index],
                                onDelete: _onDeleteGame,
                                onCoppy: _onCoppyGame),
                            // Truy cập dữ liệu từ snapshot.data
                            SizedBox(
                              height: 16,
                            ),
                          ],
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('${snapshot.error}'));
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: Icon(Icons.add),
        label: Text('Tạo trò chơi mới'),
      ),
    );
  }
}
