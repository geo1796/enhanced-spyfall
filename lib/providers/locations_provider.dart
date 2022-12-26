import 'package:flutter/material.dart';

import 'settings_provider.dart';
import '../repositories/locations_repository.dart';
import '../models/locations.dart';

class LocationsProvider with ChangeNotifier {
  final LocationsRepository repository;
  Map<LocationsList, List<Location>> _lists = {};
  LocationsProvider(this.repository);

  Future<void> init() async {
    repository.getLists().then((storedLists) async {
      if (storedLists.isEmpty) {
        _lists = {
          LocationsList('1', 'Default'): [
            Location('1', 'The beach', '1'),
            Location('2', 'The Moon', '1'),
            Location('3', 'The Eiffel Tower', '1'),
            Location('4', 'A space ship', '1'),
            Location('5', 'A Spyfall game', '1'),
            Location('6', 'A submarine', '1'),
            Location('7', 'A TV reality show', '1'),
            Location('8', 'Woodstock', '1'),
            Location('9', 'Sahara desert', '1'),
            Location('10', 'A snake pit', '1'),
          ],
        };
        _lists.forEach((key, value) {
          repository.insertList(key);
          repository.insertLocations(value);
        });
      } else {
        for (var list in storedLists) {
          _lists.addAll({list: await repository.getLocations(list.id)});
        }
      }
    });
  }

  List<LocationsList> get lists {
    return [..._lists.keys];
  }

  LocationsList getList(String listId) {
    return lists.singleWhere((list) => list.id == listId);
  }

  List<Location> getLocations(LocationsList list) {
    return [...?_lists[list]];
  }

  Map<LocationsList, List<Location>> getMap(String listId) {
    final list = getList(listId);
    return {
      list: [...?_lists[list]]
    };
  }

  void editLocation(Location newLocation, int index) {
    if (index == -1) {
      repository.insertLocation(newLocation).then(
            (_) => fetchLocations(newLocation.listId),
          );
    } else {
      repository.updateLocation(newLocation).then(
            (_) => fetchLocations(newLocation.listId),
          );
    }
  }

  void editList(LocationsList list) {
    repository.updateList(list);
    notifyListeners();
  }

  void removeLocation(Location location) {
    repository.deleteLocation(location.id).then(
          (_) => fetchLocations(location.listId),
        );
  }

  void createList(LocationsList list, List<Location> locations) {
    repository
        .insertList(list)
        .then(
          (_) => repository.insertLocations(locations),
        )
        .then(
          (value) => fetch(),
        );
  }

  Future<void> fetch() async {
    repository.getLists().then(
      ((storedLists) async {
        _lists.clear();
        for (var list in storedLists) {
          _lists.addAll(
            {list: await repository.getLocations(list.id)},
          );
        }
        notifyListeners();
      }),
    );
  }

  Future<void> fetchLocations(String listId) async {
    repository.getLocations(listId).then(
      (storedLocations) {
        _lists.update(
          getList(listId),
          (locations) => locations = storedLocations,
        );
        notifyListeners();
      },
    );
  }

  void removeList(LocationsList list) {
    repository.deleteList(list.id).then(
          (_) => fetch(),
        );
  }

  void removeCurrentList(
    LocationsList currentList,
    LocationsList newCurrentList,
    SettingsProvider settingsProvider,
  ) async {
    settingsProvider.setListIdWithoutNotify(newCurrentList.id);
    await settingsProvider.repository.updateSettings(settingsProvider.settings);
    await repository.deleteList(currentList.id);
    await fetch();
  }
}
