import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/player.dart';
import '../providers/players_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/player_list_item.dart';

class PlayersScreen extends StatelessWidget {
  static const routeName = '/players';
  PlayersScreen({Key? key}) : super(key: key);
  late PlayersProvider _playersProvider;
  late SettingsProvider _settingsProvider;
  late List<Player> _players;

  bool _savePlayer(
    GlobalKey<FormState> form,
    Player newPlayer,
    int index,
  ) {
    final isValid = form.currentState!.validate();
    if (!isValid) {
      return false;
    }
    form.currentState!.save();
    _playersProvider.editPlayer(newPlayer, index);
    return true;
  }

  void _startEditingPlayer(
    BuildContext context,
    int index,
  ) {
    var newPlayer = (index == -1)
        ? Player(DateTime.now().toString(), '')
        : _playersProvider.getPlayer(index);
    final form = GlobalKey<FormState>();
    showModalBottomSheet(
      context: context,
      builder: (_) => GestureDetector(
        onTap: () {},
        behavior: HitTestBehavior.opaque,
        child: Form(
          key: form,
          child: ListView(
            children: [
              TextFormField(
                textAlign: TextAlign.center,
                initialValue: newPlayer.name,
                decoration: InputDecoration(
                    labelText: 'Player ${_playersProvider.players.length + 1}',
                    contentPadding: EdgeInsets.all(
                      8,
                    )),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide a valid name';
                  }
                  if ((value.length < 2) && value.contains(' ')) {
                    return 'Please provide a valid name';
                  }
                  if (!value.contains(RegExp(r'(\w+)'))) {
                    return 'Please provide a valid name';
                  }
                  if (_playersProvider.players
                          .lastIndexWhere((player) => player.name == value) !=
                      -1) {
                    return 'This name is already taken';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  newPlayer.name = newValue!;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: FloatingActionButton(
                  onPressed: () {
                    if (_savePlayer(form, newPlayer, index)) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Icon(Icons.check),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _settingsProvider = Provider.of<SettingsProvider>(context);
    _playersProvider = Provider.of<PlayersProvider>(context);
    _players = _playersProvider.players;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _startEditingPlayer(context, -1),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      drawer: const AppDrawer(),
      appBar: AppBar(title: const Text('Players')),
      body: ListView.builder(
        itemCount: _players.length,
        itemBuilder: _players.length > 3
            ? ((_, i) => Dismissible(
                  key: ValueKey(
                    _players[i],
                  ),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    padding: const EdgeInsets.only(right: 16.0),
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  onDismissed: (_) {
                    _playersProvider.removePlayer(
                        _players[i].id, _settingsProvider);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: i == _players.length - 1 ? 100.0 : 0.0),
                    child: PlayerListItem(
                      index: i,
                      label: _players[i].name,
                      editHandler: () {
                        _startEditingPlayer(
                          context,
                          i,
                        );
                      },
                    ),
                  ),
                ))
            : (_, i) => PlayerListItem(
                  label: _players[i].name,
                  index: i,
                  editHandler: () {
                    _startEditingPlayer(
                      context,
                      i,
                    );
                  },
                ),
      ),
    );
  }
}
