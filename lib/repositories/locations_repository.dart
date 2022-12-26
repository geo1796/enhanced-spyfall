import 'package:sqflite/sqlite_api.dart';

import '../models/locations.dart';

class LocationsRepository {
  final Database database;

  LocationsRepository(this.database);

  Future<List<LocationsList>> getLists() async {
    final List<Map<String, dynamic>> maps =
        await database.query('locations_lists');

    return List.generate(
        maps.length,
        (i) => LocationsList(
              maps[i]['id'],
              maps[i]['name'],
            ));
  }

  Future<void> insertList(LocationsList list) async {
    await database.insert('locations_lists', list.toMap());
  }

  Future<void> insertLists(List<LocationsList> lists) async {
    for (var list in lists) {
      await insertList(list);
    }
  }

  Future<void> updateList(LocationsList list) async {
    await database.update(
      'locations_lists',
      list.toMap(),
      where: 'id = ?',
      whereArgs: [list.id],
    );
  }

  Future<void> deleteList(String listId) async {
    await getLocations(listId).then(
      (locations) async {
        for (var location in locations) {
          await deleteLocation(location.id);
        }
      },
    ).then((_) => database.delete(
      'locations_lists',
      where: 'id = ?',
      whereArgs: [listId],
    ));
  }

  Future<List<Location>> getLocations(String listId) async {
    final List<Map<String, dynamic>> maps = await database.query(
      'locations',
      where: 'list_id = ?',
      whereArgs: [listId],
    );

    return List.generate(
        maps.length,
        (i) => Location(
              maps[i]['id'],
              maps[i]['name'],
              maps[i]['list_id'],
            ));
  }

  Future<void> insertLocation(Location location) async {
    await database.insert('locations', location.toMap());
  }

  Future<void> insertLocations(List<Location> locations) async {
    for (var location in locations) {
      await insertLocation(location);
    }
  }

  Future<void> updateLocation(Location location) async {
    await database.update(
      'locations',
      location.toMap(),
      where: 'id = ?',
      whereArgs: [location.id],
    );
  }

  Future<void> deleteLocation(String id) async {
    await database.delete(
      'locations',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
