import 'package:flutter/material.dart';

import '../models/player.dart';
import '../repositories/players_repository.dart';
import 'settings_provider.dart';

class PlayersProvider with ChangeNotifier {
  final PlayersRepository repository;
  late List<Player> _players;
  PlayersProvider(this.repository);

  Future<void> init() async {
    repository.getPlayers().then((storedPlayers) {
      if (storedPlayers.length < 3) {
        _players = [
          Player('1', 'Player 1'),
          Player('2', 'Player 2'),
          Player('3', 'Player 3'),
        ];
        repository.insertPlayers(_players);
      } else {
        _players = storedPlayers;
      }
    });
  }

  List<Player> get players {
    return [..._players];
  }

  void removePlayer(String id, SettingsProvider settingsProvider) {
    repository.deletePlayer(id).then(
          (_) => fetch().then(
            (_) {
              if ((_players.length - settingsProvider.fixedSpies <
                      _players.length / 2 + 1) &&
                  (_players.length % 2 == 0)) {
                settingsProvider.decrementFixedSpies();
              }
              if ((_players.length - settingsProvider.maxSpies <=
                      _players.length / 2) &&
                  (_players.length % 2 != 0)) {
                settingsProvider.decrementMaxSpies();
              }
            },
          ),
        );
  }

  // _playersProvider.players.length -
  //                             _settingsProvider.maxSpies <=
  //                         _playersProvider.players.length / 2
  //                     ? () {}
  //                     : _settingsProvider.incrementMaxSpies

  Player getPlayer(int index) {
    return _players.elementAt(index);
  }

  void editPlayer(Player newPlayer, int index) {
    if (index == -1) {
      repository.insertPlayer(newPlayer).then(
            (_) => fetch(),
          );
    } else {
      repository.updatePlayer(newPlayer).then(
            (_) => fetch(),
          );
    }
  }

  Future<void> fetch() async {
    repository.getPlayers().then((storedPlayers) {
      _players = storedPlayers;
      notifyListeners();
    });
  }
}
