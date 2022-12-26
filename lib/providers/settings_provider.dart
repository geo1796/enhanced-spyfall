import 'package:flutter/material.dart';

import '../models/settings.dart';
import '../repositories/settings_repository.dart';

class SettingsProvider with ChangeNotifier {
  final SettingsRepository repository;
  late final Settings _settings;

  SettingsProvider(this.repository);

  Future<void> init() async {
    repository.getSettings().then((storedSettings) {
      if (storedSettings.isEmpty) {
        _settings = Settings(
          id: '0',
          prankMode: 0,
          randomSpies: 0,
          coopSpies: 0,
          fixedSpies: 1,
          listId: '1',
          maxSpies: 1,
          minSpies: 0,
          randomList: 0,
        );
        repository.insertSettings(_settings);
      } else {
        _settings = storedSettings.single;
      }
    });
  }

  Settings get settings {
    return _settings;
  }

  bool get randomSpies {
    return _settings.randomSpies == 1;
  }

  void setRandomSpies(bool newValue) {
    newValue ? _settings.randomSpies = 1 : _settings.randomSpies = 0;
    repository.updateSettings(_settings).then((_) => notifyListeners());
  }

  bool get prankMode {
    return _settings.prankMode == 1;
  }

  void setPrankMode(bool newValue) {
    if (newValue) {
      _settings.prankMode = 1;
      _settings.coopSpies = 0;
    } else {
      _settings.prankMode = 0;
    }
    repository.updateSettings(_settings).then((_) => notifyListeners());
  }

  bool get randomList {
    return _settings.randomList == 1;
  }

  void setRandomList(bool newValue) {
    newValue ? _settings.randomList = 1 : _settings.randomList = 0;
    repository.updateSettings(_settings).then((_) => notifyListeners());
  }

  bool get coopSpies {
    return _settings.coopSpies == 1;
  }

  void setCoopSpies(bool newValue) {
    if (newValue) {
      _settings.coopSpies = 1;
      _settings.prankMode = 0;
    } else {
      _settings.coopSpies = 0;
    }
    repository.updateSettings(_settings).then((_) => notifyListeners());
  }

  String get listId {
    return _settings.listId;
  }

  void setListId(String newValue) {
    _settings.listId = newValue;
    repository.updateSettings(_settings).then((_) => notifyListeners());
  }

  void setListIdWithoutNotify(String newValue) {
    _settings.listId = newValue;
  }

  int get fixedSpies {
    return _settings.fixedSpies;
  }

  int get maxSpies {
    return _settings.maxSpies;
  }

  int get minSpies {
    return _settings.minSpies;
  }

  void incrementFixedSpies() {
    _settings.fixedSpies++;
    repository.updateSettings(_settings).then((_) => notifyListeners());
  }

  void decrementFixedSpies() {
    _settings.fixedSpies--;
    repository.updateSettings(_settings).then((_) => notifyListeners());
  }

  void incrementMaxSpies() {
    _settings.maxSpies++;
    repository.updateSettings(_settings).then((_) => notifyListeners());
  }

  void decrementMaxSpies() {
    _settings.maxSpies--;
    repository.updateSettings(_settings).then((_) {
      if (_settings.minSpies > _settings.maxSpies - 1) {
        decrementMinSpies(); //decrementMinSpies() calls notifyListeners
      } else {
        notifyListeners(); // so we should not call it again
      }
    });
  }

  void incrementMinSpies() {
    _settings.minSpies++;
    repository.updateSettings(_settings).then((_) {
      notifyListeners();
    });
  }

  void decrementMinSpies() {
    _settings.minSpies--;
    repository.updateSettings(_settings).then((_) {
      notifyListeners();
    });
  }
}
