// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_tinh_diem/screens/homeScreen.dart';
import 'package:app_tinh_diem/screens/players/player_provider.dart';  // Import the new provider

void main() {
  runApp(
    ChangeNotifierProvider( // Provide PlayerListProvider to the app
      create: (context) => PlayerListProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Homescreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}