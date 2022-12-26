import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/player.dart';
import '../providers/game_provider.dart';
import '../providers/locations_provider.dart';
import '../providers/settings_provider.dart';
import '../main.dart';
import '../providers/players_provider.dart';
import '../widgets/revealed_location_item.dart';

class PlayingScreen extends StatefulWidget {
  static const routeName = '/playing';
  PlayingScreen({Key? key}) : super(key: key);

  @override
  State<PlayingScreen> createState() => _PlayingScreenState();
}

class _PlayingScreenState extends State<PlayingScreen> {
  late GameProvider _gameProvider;

  late PlayersProvider _playersProvider;

  late SettingsProvider _settingsProvider;

  late LocationsProvider _locationsProvider;

  var _initialized = false;

  void _revealLocations(BuildContext context) {
    _gameProvider.revealLocations();
    showModalBottomSheet(
      context: context,
      builder: ((_) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.75,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.5,
            ),
            itemCount: _gameProvider.locations.length,
            itemBuilder: (_, i) {
              return RevealedLocationItem(_gameProvider.locations[i]);
            },
          ),
        );
      }),
    );
  }

  void _revealSpies(BuildContext context) {
    _gameProvider.revealSpies();
    showModalBottomSheet(
      context: context,
      builder: ((_) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.75,
          child: ListView.builder(
            itemCount: _gameProvider.spies.length,
            itemBuilder: (_, i) {
              return Card(
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _gameProvider.spies[i].name,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  void _check(BuildContext context, Player player) {
    showModalBottomSheet(
      isDismissible: false,
      context: context,
      builder: ((_) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.75,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _gameProvider.isSpy(player)
                        ? _settingsProvider.coopSpies
                            ? 'Spies :'
                            : 'Spy'
                        : _gameProvider.secretLocation.name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                if (_settingsProvider.coopSpies && _gameProvider.isSpy(player))
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _gameProvider.spies.length,
                    itemBuilder: (_, i) {
                      return Card(
                        elevation: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _gameProvider.spies[i].name,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  ),
                const Divider(),
                ElevatedButton(
                  onPressed: () {
                    _gameProvider.checkPlayer(player);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Okay',
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _playersProvider = Provider.of<PlayersProvider>(context, listen: false);
      _settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
      _locationsProvider =
          Provider.of<LocationsProvider>(context, listen: false);
      _gameProvider = Provider.of<GameProvider>(context);
      _gameProvider.init(
          _settingsProvider, _playersProvider, _locationsProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Text(
          'QUIT',
          style: theme.textTheme.headline4,
        ),
        onPressed: () {
          _gameProvider.updatePreviousLocation();
          Navigator.of(context).pushReplacementNamed(MyHomePage.routeName);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: const Text('Enhanced Spyfall'),
      ),
      body: !_initialized
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  ...List.generate(
                    _playersProvider.players.length,
                    (i) => Card(
                      elevation: 6,
                      child: ListTile(
                          leading: Text(
                            _playersProvider.players[i].name,
                            style: theme.textTheme.headline6,
                          ),
                          trailing: _gameProvider
                                  .hasChecked(_playersProvider.players[i])
                              ? ElevatedButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Check',
                                    style: theme.textTheme.headline4!.copyWith(
                                        color: theme.colorScheme.secondary),
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: () => _check(
                                        context,
                                        _playersProvider.players[i],
                                      ),
                                  child: const Text('Check'))),
                    ),
                  ),
                  const Divider(),
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _settingsProvider.randomSpies
                              ? _settingsProvider.maxSpies >= 2
                                  ? '${_settingsProvider.minSpies} ... ${_settingsProvider.maxSpies}\nspies'
                                  : '${_settingsProvider.minSpies} ... ${_settingsProvider.maxSpies}\nspy'
                              : _settingsProvider.fixedSpies >= 2
                                  ? '${_settingsProvider.fixedSpies}\nspies'
                                  : '${_settingsProvider.fixedSpies}\nspy',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headline6,
                        ),
                      ),
                    ),
                  ),
                  const Divider(),
                  if (_gameProvider.checkedPlayers.length ==
                      _playersProvider.players.length)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.08,
                          width: MediaQuery.of(context).size.width * 1 / 3,
                          child: ElevatedButton(
                            style: _gameProvider.spiesRevealed
                                ? ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            theme.colorScheme.primary),
                                  )
                                : null,
                            onPressed: () => _revealSpies(context),
                            child: FittedBox(
                              child: Text(
                                _gameProvider.spiesRevealed
                                    ? 'Spies\nrevealed'
                                    : 'Reveal\nspies',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.08,
                          width: MediaQuery.of(context).size.width * 1 / 3,
                          child: ElevatedButton(
                            style: _gameProvider.locationsRevealed
                                ? ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            theme.colorScheme.primary),
                                  )
                                : null,
                            onPressed: () => _revealLocations(context),
                            child: FittedBox(
                              child: Text(
                                _gameProvider.locationsRevealed
                                    ? 'Locations\nrevealed'
                                    : 'Reveal\nlocations',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 100.0),
                ],
              ),
            ),
    );
  }
}
