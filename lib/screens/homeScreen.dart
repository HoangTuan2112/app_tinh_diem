import 'package:app_tinh_diem/screens/history/historyPage.dart';
import 'package:app_tinh_diem/screens/players/playerPage.dart';
import 'package:app_tinh_diem/screens/settings/settingsPage.dart';
import 'package:flutter/material.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  String appbarTittle = 'Lịch sử';
  var listTitle = ['Lịch sử', 'Người chơi', 'Cài đặt'];
  var selectedIndex=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appbarTittle),
        backgroundColor: Colors.deepPurple,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.history), label: listTitle[0],),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: listTitle[1],),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: listTitle[2],),
          
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex:selectedIndex,
        backgroundColor: (Colors.grey),
        onTap: (int index){
          this.onTapHandler(index);
        },
      ),
      body: handlePage(this.selectedIndex),
    );
  }
  
  void onTapHandler(int index) {
    this.setState(() {
      selectedIndex=index;
      appbarTittle= listTitle[index];
    });
  }
  
  Widget handlePage(int index) {
    if(selectedIndex==0){
      return HistoryPage();
    }else if( selectedIndex==1){
      return Players();
    }
    else{
      return Settings();
    }

  }
}




