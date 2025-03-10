import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_tinh_diem/screens/history/mockAPI_service/api_service.dart';

class PlayerListProvider with ChangeNotifier {
  static const _prefsKey = 'playerNames';
  List<String> _playerNames = [];
  bool _isLoading = false; // Add a loading state
  bool _hasError = false;  // Add an error state
  String _errorMessage = '';

  List<String> get playerNames => _playerNames;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;


  PlayerListProvider() {
    _loadPlayerNames(); // Load initially
  }

  // Load player names from shared_preferences
  Future<void> _loadPlayerNames() async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    notifyListeners(); // Notify before loading

    final prefs = await SharedPreferences.getInstance();
    final savedNames = prefs.getStringList(_prefsKey);

    if (savedNames != null && savedNames.isNotEmpty) {
      _playerNames = savedNames;
      _isLoading = false;
      notifyListeners(); // Notify after loading from shared_preferences
    } else {
      // ONLY fetch from API if shared_preferences is empty
      await _fetchAndSavePlayerNames();
    }
  }

  // Fetch player names from the API and save them to shared_preferences
  Future<void> _fetchAndSavePlayerNames() async {
    _isLoading = true; // Set loading state
    _hasError = false; // Reset error state
    _errorMessage = '';

    notifyListeners();
    try {
      final fetchedNames = await fetchPlayerNamesClientSide(); // Or fetchPlayerNames()

      // Add fetched names to the list, avoiding duplicates
      for (final name in fetchedNames) {
        if (!_playerNames.contains(name)) {
          _playerNames.add(name);
        }
      }

      await _savePlayerNames(); // Save after fetching

    } catch (error) {
      print('Error fetching player names: $error');
      _hasError = true; //Set Error flag
      _errorMessage = "Failed to fetch player names"; // Set Error message.
      // Consider:  Do you want to re-throw, or handle here?
      // rethrow; // If you rethrow, the UI will show the error.
    } finally {
      _isLoading = false; // Reset loading state, whether success or failure.
      notifyListeners(); // *Always* notify after changing state.
    }
  }

  // Save player names to shared_preferences
  Future<void> _savePlayerNames() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefsKey, _playerNames);
  }

  // Delete a player name
  Future<void> deletePlayer(String name) async {
    _playerNames.remove(name);
    await _savePlayerNames(); // Save after deleting
    notifyListeners();
  }

  // Add a refresh method
  Future<void> refreshPlayers() async {
    _playerNames = []; // Clear existing names
    await _savePlayerNames(); // Clear SharedPreferences
    await _fetchAndSavePlayerNames(); // Fetch from API, save, and notify
  }
}