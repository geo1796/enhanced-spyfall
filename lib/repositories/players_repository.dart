import 'package:sqflite/sqlite_api.dart';

import '../models/player.dart';

class PlayersRepository {
  final Database database;

  PlayersRepository(this.database);

  Future<List<Player>> getPlayers() async {
    final List<Map<String, dynamic>> maps = await database.query('players');

    return List.generate(
        maps.length,
        (i) => Player(
              maps[i]['id'],
              maps[i]['name'],
            ));
  }

  Future<void> insertPlayer(Player player) async {
    await database.insert('players', player.toMap());
  }

  Future<void> insertPlayers(List<Player> players) async {
    for (var player in players) {
      await insertPlayer(player);
    }
  }

  Future<void> updatePlayer(Player player) async {
    await database.update(
      'players',
      player.toMap(),
      where: 'id = ?',
      whereArgs: [player.id],
    );
  }

  Future<void> deletePlayer(String id) async {
    await database.delete(
      'players',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
