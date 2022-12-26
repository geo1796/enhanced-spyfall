import 'package:sqflite/sqflite.dart';

import '../models/settings.dart';

class SettingsRepository {
  final Database database;

  SettingsRepository(this.database);

  Future<List<Settings>> getSettings() async {
    final List<Map<String, dynamic>> maps = await database.query('settings');

    return List.generate(
        maps.length,
        (i) => Settings(
              id: maps[i]['id'],
              prankMode: maps[i]['prank_mode'],
              randomSpies: maps[i]['random_spies'],
              coopSpies: maps[i]['coop_spies'],
              fixedSpies: maps[i]['fixed_spies'],
              maxSpies: maps[i]['max_spies'],
              minSpies: maps[i]['min_spies'],
              randomList: maps[i]['random_list'],
              listId: maps[i]['list_id'],
            ));
  }

  Future<void> insertSettings(Settings settings) async {
    await database.insert('settings', settings.toMap());
  }

  Future<void> updateSettings(Settings settings) async {
    await database.update(
      'settings',
      settings.toMap(),
      where: 'id = ?',
      whereArgs: [settings.id],
    );
  }
}
