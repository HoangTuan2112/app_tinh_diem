import 'package:app_tinh_diem/screens/history/component_history/gameComponent.dart';
import 'package:app_tinh_diem/screens/history/mockAPI_service/api_service.dart';
import 'package:app_tinh_diem/screens/history/newGamePage.dart';
import 'package:flutter/material.dart';
import 'model_history/gameInfo.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

enum FilterOption { today, yesterday, older }

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<GameInfo>> _gamesFuture;
  List<GameInfo> _allGames = [];
  List<GameInfo> _filteredGames = [];
  FilterOption _currentFilter = FilterOption.today; // Store filter as an enum

  @override
  void initState() {
    super.initState();
    _fetchAndFilterGames(); // Initial fetch and filter
  }

  void _fetchAndFilterGames() {
    _gamesFuture = fetchGames().then((games) {
      _allGames = games;
      _filteredGames = _filterGamesByDate(_allGames, _currentFilter);
      return games;
    });
  }

  void _onDeleteGame() {
    _fetchAndFilterGames();
    setState(() {}); // Trigger rebuild.
  }

  void _onCoppyGame() {
    _fetchAndFilterGames();
    setState(() {}); // Trigger rebuild
  }

  // Filter games based on the FilterOption
  List<GameInfo> _filterGamesByDate(List<GameInfo> games, FilterOption filter) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(Duration(days: 1));

    switch (filter) {
      case FilterOption.today:
        return games
            .where((game) =>
                game.now != null &&
                game.now!.year == today.year &&
                game.now!.month == today.month &&
                game.now!.day == today.day)
            .toList();
      case FilterOption.yesterday:
        return games
            .where((game) =>
                game.now != null &&
                game.now!.year == yesterday.year &&
                game.now!.month == yesterday.month &&
                game.now!.day == yesterday.day)
            .toList();
      case FilterOption.older:
        return games
            .where((game) => game.now != null && game.now!.isBefore(yesterday))
            .toList();
    }
  }

  // Update the filter and refresh the list
  void _onFilterButtonPressed(FilterOption filter) {
    setState(() {
      _currentFilter = filter;
      _filteredGames = _filterGamesByDate(_allGames, _currentFilter);
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
              _buildFilterButton(FilterOption.today, "Hôm nay"),
              _buildFilterButton(FilterOption.yesterday, "Hôm qua"),
              _buildFilterButton(FilterOption.older, "Cũ hơn"),
            ],
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              child: FutureBuilder<List<GameInfo>>(
                future: _gamesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: _filteredGames.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            GameComponent(
                              gameInfo: _filteredGames[index],
                              onDelete: _onDeleteGame,
                              onCoppy: _onCoppyGame,
                            ),
                            SizedBox(
                              height: 16,
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    return Center(child: Text('Không có dữ liệu'));
                  }
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewGameScreen()),
          ).then((value) {
            if (value == true) {
              _fetchAndFilterGames(); // Refetch and refilter
              setState(() {});
            }
          });
        },
        icon: const Icon(Icons.add),
        label: const Text('Tạo trò chơi mới'),
      ),
    );
  }

  // Helper function to create filter buttons (DRY principle)
  Widget _buildFilterButton(FilterOption filter, String label) {
    return ElevatedButton.icon(
      onPressed: () => _onFilterButtonPressed(filter),
      icon: Icon(Icons.calendar_today),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: _currentFilter == filter
            ? Colors.blueAccent[700] // Active
            : Colors.blueAccent, // Inactive
      ),
    );
  }
}
