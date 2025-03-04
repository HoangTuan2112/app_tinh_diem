import 'package:app_tinh_diem/screens/history/component_history/gameComponent.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  var listItem = <GameComponent>[
    GameComponent(a: '1', b: '1'),
    GameComponent(a: '2', b: '2'),
    GameComponent(a: '3', b: '3'),
     GameComponent(a: '1', b: '1'),
    GameComponent(a: '2', b: '2'),
    GameComponent(a: '3', b: '3'),
     GameComponent(a: '1', b: '1'),
    GameComponent(a: '2', b: '2'),
    GameComponent(a: '3', b: '3'),
     GameComponent(a: '1', b: '1'),
    GameComponent(a: '2', b: '2'),
    GameComponent(a: '3', b: '3'),
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton.icon(onPressed: (){}, label: Text('Hôm nay'), icon: Icon(Icons.calendar_today)),
            ElevatedButton.icon(onPressed: (){}, label: Text('Hôm qua'), icon: Icon(Icons.calendar_today)),
            ElevatedButton.icon(onPressed: (){}, label: Text('Cũ hơn'), icon: Icon(Icons.calendar_today)),
          ],
        ),
        Expanded(// expand the ListView to fill the remaining space
          child: ListView.builder(
            itemCount: listItem.length,
            itemBuilder: (context, index){
              return listItem[index];
            },
          ),
        ),
      ],
    );
   
  }
}
