import 'dart:math';

import 'package:flutter/material.dart';

import '../models/locations.dart';
import '../models/player.dart';
import 'settings_provider.dart';
import 'locations_provider.dart';
import 'players_provider.dart';

class GameProvider with ChangeNotifier {
  late List<Player> _spies;
  late Location _secretLocation;
  late List<Location> _locations;
  late List<Location> _checkedLocations;
  late List<Player> _checkedPlayers;
  late bool _spiesRevealed;
  late bool _locationsRevealed;
  Location? _previousLocation;

  @override
  String toString() {
    return 'GameProvider{_spies: $_spies, _location: ${_secretLocation.name}, _hasCheck: $_checkedPlayers}';
  }

  void updatePreviousLocation() {
    _previousLocation = _secretLocation;
  }

  Location? get previousLocation {
    return _previousLocation;
  }

  bool get spiesRevealed {
    return _spiesRevealed;
  }

  bool get locationsRevealed {
    return _locationsRevealed;
  }

  void revealSpies() {
    _spiesRevealed = true;
    notifyListeners();
  }

  void revealLocations() {
    _locationsRevealed = true;
    notifyListeners();
  }

  List<Location> get locations {
    return [..._locations];
  }

  List<Player> get checkedPlayers {
    return [..._checkedPlayers];
  }

  Location get secretLocation {
    return _secretLocation;
  }

  List<Location> get checkedLocations {
    return [..._checkedLocations];
  }

  List<Player> get spies {
    return [..._spies];
  }

  bool isSpy(Player player) {
    return _spies.contains(player);
  }

  void checkPlayer(Player player) {
    _checkedPlayers.add(player);
    notifyListeners();
  }

  void checkLocation(Location location) {
    _checkedLocations.add(location);
    notifyListeners();
  }

  bool hasChecked(Player player) {
    return _checkedPlayers.contains(player);
  }

  void init(
    SettingsProvider settingsProvider,
    PlayersProvider playersProvider,
    LocationsProvider locationsProvider,
  ) {
    _spiesRevealed = false;
    _locationsRevealed = false;
    _checkedPlayers = [];
    _checkedLocations = [];
    _spies = [];
    final players = playersProvider.players;
    players.shuffle();
    switch (settingsProvider.randomSpies) {
      case false:
        {
          _spies.addAll(
            players.getRange(0, settingsProvider.fixedSpies),
          );
          break;
        }
      case true:
        {
          var numberOfSpies = -1;
          while (numberOfSpies < settingsProvider.minSpies) {
            numberOfSpies = Random().nextInt(settingsProvider.maxSpies + 1);
          }
          _spies.addAll(
            players.getRange(0, numberOfSpies),
          );
          break;
        }
    }
    switch (settingsProvider.randomList) {
      case false:
        {
          _locations = locationsProvider.getLocations(
            locationsProvider.getList(settingsProvider.listId),
          );
          do {
            _secretLocation = _locations[Random().nextInt(_locations.length)];
          } while (_secretLocation == _previousLocation);
          break;
        }
      case true:
        {
          final locationsLists = locationsProvider.lists;
          _locations = locationsProvider.getLocations(
            locationsLists[Random().nextInt(locationsLists.length)],
          );
          do {
            _secretLocation = _locations[Random().nextInt(_locations.length)];
          } while (_secretLocation == _previousLocation);
          break;
        }
    }
  }
}
