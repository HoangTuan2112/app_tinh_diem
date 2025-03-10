import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app_tinh_diem/screens/history/model_history/gameConfig.dart';
import 'package:app_tinh_diem/screens/history/model_history/gameInfo.dart';
import 'package:app_tinh_diem/screens/history/model_history/playerInfo.dart';
import 'package:app_tinh_diem/screens/history/mockAPI_service/api_service.dart'; // Import api_service

class NewGameScreen extends StatefulWidget {
  const NewGameScreen({Key? key}) : super(key: key);

  @override
  _NewGameScreenState createState() => _NewGameScreenState();
}

class _NewGameScreenState extends State<NewGameScreen> {
  final _formKey = GlobalKey<FormState>();

  final _playerNameController = TextEditingController();
  final _limitPointsController = TextEditingController();
  final _limitRoundsController = TextEditingController();

  bool _isLimitPoints = false;
  bool _isLimitRounds = false;
  bool _isAutoCalculate = true;

  @override
  void dispose() {
    _playerNameController.dispose();
    _limitPointsController.dispose();
    _limitRoundsController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      List<String> playerNames = _playerNameController.text
          .split(',')
          .map((name) => name.trim())
          .toList();
      List<PlayerInfo> players =
          playerNames.map((name) => PlayerInfo(name: name, point: 0)).toList();

      GameConfig gameConfig = GameConfig(
        isLimitPoints: _isLimitPoints,
        limitPoints:
            _isLimitPoints ? int.tryParse(_limitPointsController.text) ?? 0 : 0,
        isLimitRound: _isLimitRounds,
        limitRound:
            _isLimitRounds ? int.tryParse(_limitRoundsController.text) ?? 0 : 0,
        isAutoCalculate: _isAutoCalculate,
        currentRound: 0,
      );

      GameInfo newGame = GameInfo(
        id: '',
        playerInfo: players,
        gameConfig: gameConfig,
        now: DateTime.now(),
      );

      try {
        GameInfo createdGame =
            await createGame(newGame); // Await the API call, use api_service
        print('Game created successfully: ${createdGame.id}');

        Navigator.pop(context, true); // Go back to HistoryPage
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Trò chơi mới đã được tạo! ID: ${createdGame.id}')),
        );
      } catch (e) {
        print('Error creating game: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi tạo trò chơi: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo trò chơi mới'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _playerNameController,
                decoration: const InputDecoration(
                  labelText: 'Tên người chơi (A, B, C, ...)',
                  hintText: 'Nhập tên 4 người chơi, cách nhau bằng dấu phẩy',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên người chơi';
                  } else if (value.split(',').length - 1 != 3 ||
                      value.endsWith(',') ||
                      value.contains(',,')) {
                    return 'Vui lòng nhập đúng 4 tên người chơi';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Giới hạn điểm'),
                value: _isLimitPoints,
                onChanged: (value) {
                  setState(() {
                    _isLimitPoints = value!;
                  });
                },
              ),
              if (_isLimitPoints) ...[
                TextFormField(
                  controller: _limitPointsController,
                  decoration: const InputDecoration(
                    labelText: 'Điểm giới hạn',
                    hintText: 'Nhập điểm giới hạn',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (_isLimitPoints && (value == null || value.isEmpty)) {
                      return 'Vui lòng nhập điểm giới hạn';
                    }
                    if (_isLimitPoints && int.tryParse(value!) == null) {
                      return 'Vui lòng nhập số';
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Giới hạn vòng'),
                value: _isLimitRounds,
                onChanged: (value) {
                  setState(() {
                    _isLimitRounds = value!;
                  });
                },
              ),
              if (_isLimitRounds) ...[
                TextFormField(
                  controller: _limitRoundsController,
                  decoration: const InputDecoration(
                    labelText: 'Số vòng giới hạn',
                    hintText: 'Nhập số vòng giới hạn',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (_isLimitRounds && (value == null || value.isEmpty)) {
                      return 'Vui lòng nhập số vòng giới hạn';
                    }
                    if (_isLimitRounds && int.tryParse(value!) == null) {
                      return 'Vui lòng nhập số';
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Tự động tính toán'),
                value: _isAutoCalculate,
                onChanged: (value) {
                  setState(() {
                    _isAutoCalculate = value!;
                  });
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Tạo trò chơi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
