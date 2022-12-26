import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/locations_provider.dart';
import '../providers/players_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/fixed_spies_settings.dart';
import '../widgets/random_spies_settings.dart';

class GameSettingsScreen extends StatelessWidget {
  static const routeName = '/game-settings';
  GameSettingsScreen({Key? key}) : super(key: key);
  late SettingsProvider _settingsProvider;
  late PlayersProvider _playersProvider;
  late LocationsProvider _locationsProvider;

  @override
  Widget build(BuildContext context) {
    _settingsProvider = Provider.of<SettingsProvider>(context);
    _playersProvider = Provider.of<PlayersProvider>(context);
    _locationsProvider = Provider.of<LocationsProvider>(context);
    final theme = Theme.of(context);
    final spiesSettings =
        Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          'Spies settings\nCurrently ${_playersProvider.players.length} players',
          style: theme.textTheme.headline5,
          textAlign: TextAlign.center,
        ),
      ),
      Switch(
        activeColor: theme.colorScheme.secondary,
        inactiveThumbColor: theme.colorScheme.primary,
        inactiveTrackColor: theme.colorScheme.tertiary,
        value: _settingsProvider.prankMode,
        onChanged: _settingsProvider.setPrankMode,
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          'Prank mode ' +
              (_settingsProvider.prankMode
                  ? 'ON\n(1 out of 5 chance that all players are spies)'
                  : 'OFF'),
          textAlign: TextAlign.center,
          style: theme.textTheme.headline6,
        ),
      ),
      Switch(
        activeColor: theme.colorScheme.secondary,
        inactiveThumbColor: theme.colorScheme.primary,
        inactiveTrackColor: theme.colorScheme.tertiary,
        value: _settingsProvider.coopSpies,
        onChanged: _settingsProvider.setCoopSpies,
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          'Cooperative spies ' +
              (_settingsProvider.coopSpies
                  ? 'ON\n(spies know each other)'
                  : 'OFF'),
          textAlign: TextAlign.center,
          style: theme.textTheme.headline6,
        ),
      ),
      Switch(
        activeColor: theme.colorScheme.secondary,
        inactiveThumbColor: theme.colorScheme.primary,
        inactiveTrackColor: theme.colorScheme.tertiary,
        value: _settingsProvider.randomSpies,
        onChanged: _settingsProvider.setRandomSpies,
      ),
      if (!_settingsProvider.randomSpies)
        FixedSpiesSettings(_settingsProvider, _playersProvider),
      if (_settingsProvider.randomSpies)
        RandomSpiesSettings(_settingsProvider, _playersProvider),
    ]);

    final listsSettings = Column(children: [
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          'Lists settings',
          style: theme.textTheme.headline5,
        ),
      ),
      Switch(
        activeColor: theme.colorScheme.secondary,
        inactiveThumbColor: theme.colorScheme.primary,
        inactiveTrackColor: theme.colorScheme.tertiary,
        value: _settingsProvider.randomList,
        onChanged: _settingsProvider.setRandomList,
      ),
      if (_settingsProvider.randomList)
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            'Random list',
            textAlign: TextAlign.center,
            style: theme.textTheme.headline6,
          ),
        ),
      if (!_settingsProvider.randomList)
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            'Current list : ${_locationsProvider.getList(_settingsProvider.listId).name}',
            textAlign: TextAlign.center,
            style: theme.textTheme.headline6,
          ),
        )
    ]);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Game settings'),
      ),
      body: ListView(
        children: [
          Card(elevation: 6, child: spiesSettings),
          const Divider(),
          Card(elevation: 6, child: listsSettings),
        ],
      ),
    );
  }
}
