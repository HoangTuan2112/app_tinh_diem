import 'package:app_tinh_diem/model/player_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_tinh_diem/model/game_info.dart';

import 'package:app_tinh_diem/screens/history/api_service/api_service.dart';
import 'package:app_tinh_diem/screens/players/player_provider.dart';

import '../../model/game_config.dart';

class NewGameScreen extends StatefulWidget {
  const NewGameScreen({Key? key}) : super(key: key);

  @override
  _NewGameScreenState createState() => _NewGameScreenState();
}

class _NewGameScreenState extends State<NewGameScreen> {
  final _formKey = GlobalKey<FormState>();
  final _limitPointsController = TextEditingController();
  final _limitRoundsController = TextEditingController();
  final _playerNameController = TextEditingController();
  bool _isLimitPoints = false;
  bool _isLimitRounds = false;
  bool _isAutoCalculate = true;

  late List<String> _selectedPlayers = [];

  @override
  void dispose() {
    _limitPointsController.dispose();
    _limitRoundsController.dispose();
    _playerNameController.dispose();
    super.dispose();
  }

  void _addPlayerName(String name) {
    setState(() {
      List<String> currentNames =
          _playerNameController.text.split(',').map((e) => e.trim()).toList();
      currentNames.removeWhere((element) => element.isEmpty);

      if (!currentNames.contains(name) && currentNames.length < 4) {
        currentNames.add(name);
        _selectedPlayers = currentNames;

        _playerNameController.text = currentNames.join(', ');
        if (currentNames.length < 4) {
          _playerNameController.text += ', ';
        }

        _playerNameController.selection = TextSelection.fromPosition(
          TextPosition(offset: _playerNameController.text.length),
        );
      }
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      List<String> playerNames = _playerNameController.text
          .split(',')
          .map((name) => name.trim())
          .where((name) => name.isNotEmpty)
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
        GameInfo createdGame = await createGame(newGame);
        print('Game created successfully: ${createdGame.id}');

        final playerListProvider =
            Provider.of<PlayerListProvider>(context, listen: false);
        for (final player in players) {
          if (!playerListProvider.playerNames.contains(player.name)) {
            await playerListProvider.addPlayerName(player.name.toString());
          }
        }

        Navigator.pop(context, true);
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
    final playerListProvider =
        Provider.of<PlayerListProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo trò chơi mới'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _playerNameController,
                // Use the controller
                style: TextStyle(color: Colors.black),
                // Black text for input
                decoration: const InputDecoration(
                  labelText: 'Tên người chơi (A, B, C, ...)',
                  labelStyle: TextStyle(color: Colors.grey),
                  // Style for label text
                  hintText: 'Nhập tên 4 người chơi, cách nhau bằng dấu phẩy',
                  hintStyle: TextStyle(color: Colors.grey),
                  // Style for hint
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.grey), // Color when not focused
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blue), // Color when focused
                  ),
                  errorBorder: UnderlineInputBorder(
                    // Style when error
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên người chơi';
                  }

                  final names = value
                      .split(',')
                      .map((e) => e.trim())
                      .where((name) => name.isNotEmpty)
                      .toList();
                  if (names.length != 4) {
                    return 'Vui lòng nhập đúng 4 tên người chơi';
                  }
                  if (value.endsWith(',') || value.contains(',,')) {
                    return 'Vui lòng nhập đúng 4 tên người chơi';
                  }
                  return null;
                },
                onChanged: (value) {
                  //Keep tracking on change
                  _selectedPlayers =
                      value.split(',').map((e) => e.trim()).toList();
                },
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text(
                  'Giới hạn điểm',
                  style: TextStyle(color: Colors.black),
                ),
                // Black text
                value: _isLimitPoints,
                checkColor: Colors.white,
                // Color of the checkmark
                activeColor: Colors.blue,
                // Color when checked
                side: MaterialStateBorderSide.resolveWith(
                  (states) => BorderSide(
                      width: 1.0, color: Colors.grey), // Border color
                ),
                onChanged: (value) {
                  setState(() {
                    _isLimitPoints = value!;
                  });
                },
              ),
              if (_isLimitPoints) ...[
                TextFormField(
                  controller: _limitPointsController,
                  style: TextStyle(color: Colors.black),
                  // Black text
                  decoration: const InputDecoration(
                    labelText: 'Điểm giới hạn',
                    labelStyle: TextStyle(color: Colors.grey),
                    hintText: 'Nhập điểm giới hạn',
                    hintStyle: TextStyle(color: Colors.grey),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                    errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    focusedErrorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
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
                title: const Text(
                  'Giới hạn vòng',
                  style: TextStyle(color: Colors.black),
                ),
                // Black text
                value: _isLimitRounds,
                checkColor: Colors.white,
                activeColor: Colors.blue,
                side: MaterialStateBorderSide.resolveWith(
                  (states) => BorderSide(width: 1.0, color: Colors.grey),
                ),
                onChanged: (value) {
                  setState(() {
                    _isLimitRounds = value!;
                  });
                },
              ),
              if (_isLimitRounds) ...[
                TextFormField(
                  controller: _limitRoundsController,
                  style: TextStyle(color: Colors.black),
                  // Black text
                  decoration: const InputDecoration(
                    labelText: 'Số vòng giới hạn',
                    labelStyle: TextStyle(color: Colors.grey),
                    hintText: 'Nhập số vòng giới hạn',
                    hintStyle: TextStyle(color: Colors.grey),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                    errorBorder: UnderlineInputBorder(
                      // Style when error
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    focusedErrorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
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
                title: const Text(
                  'Tự động tính toán',
                  style: TextStyle(color: Colors.black),
                ),

                value: _isAutoCalculate,
                checkColor: Colors.white,

                activeColor: Colors.blue,

                side: MaterialStateBorderSide.resolveWith(
                  (states) =>
                      BorderSide(width: 1.0, color: Colors.grey),
                ),
                onChanged: (value) {
                  setState(() {
                    _isAutoCalculate = value!;
                  });
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Blue button
                ),
                child: const Text(
                  'Tạo trò chơi',
                  style: TextStyle(color: Colors.white),
                ), // White text
              ),

              // --- Display Saved Player Names ---
              const SizedBox(height: 24),
              const Text(
                'Gợi ý người chơi:',
                style: TextStyle(color: Colors.grey, fontSize: 16), // Grey text
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: playerListProvider.playerNames.map((name) {
                  return InkWell(
                    onTap: () => _addPlayerName(name),
                    child: Chip(
                      label: Text(name),
                      backgroundColor:
                          Colors.grey[300],
                    ),
                  );
                }).toList(),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
