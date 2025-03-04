import 'package:flutter/material.dart';

class GameComponent extends StatefulWidget {
  /*  List<PlayerInfo> _playerInfo=[];
  GameConfig? _gameConfig;
  DateTime now = DateTime.now();
    String? _name;
  double? _point;
     late bool _isLimitPoints;
  late int _limitPoints;
  late bool _isLimitRound;
  late int _limitRound;
  late bool _isAutoCalculate;
  late int _currentRound;
   */
  final String a;
  final String b;
  const GameComponent({super.key, required this.a, required this.b});

  @override
  State<GameComponent> createState() => _GameComponentState();
}

class _GameComponentState extends State<GameComponent> {
  @override
  Widget build(BuildContext context) {
    return infoComponent(widget.a, widget.b);
  }
  
  Widget infoComponent(String a, String b) {
    return Container(
      padding: EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height * 0.12, 
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: FractionallySizedBox(
              heightFactor: 1.0, // Set the height to 100% of the parent container's height
              child: Container(
                color: Colors.blue,
                child: Center(child: Text(a)),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: FractionallySizedBox(
              heightFactor: 1.0, // Set the height to 100% of the parent container's height
              child: Container(
                color: Colors.red,
                child: Center(child: Text(b)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}