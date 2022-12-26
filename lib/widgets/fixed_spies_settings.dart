import 'package:flutter/material.dart';

import '../providers/players_provider.dart';
import '../providers/settings_provider.dart';

class FixedSpiesSettings extends StatelessWidget {
  const FixedSpiesSettings(this.settingsProvider, this.playersProvider,
      {Key? key})
      : super(key: key);
  final SettingsProvider settingsProvider;
  final PlayersProvider playersProvider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            'Fixed spies',
            textAlign: TextAlign.center,
            style: theme.textTheme.headline6,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircleAvatar(
                backgroundColor: theme.colorScheme.primary,
                child: IconButton(
                  color: Colors.white,
                  onPressed: settingsProvider.fixedSpies <= 1
                      ? () {}
                      : settingsProvider.decrementFixedSpies,
                  icon: const Icon(Icons.remove),
                ),
              ),
              CircleAvatar(
                backgroundColor: theme.colorScheme.primary,
                child: Text(
                  '${settingsProvider.fixedSpies}',
                  style: const TextStyle(
                    color: Colors.white,
                    //fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              CircleAvatar(
                backgroundColor: theme.colorScheme.primary,
                child: IconButton(
                  color: Colors.white,
                  onPressed: settingsProvider.fixedSpies == 0
                      ? settingsProvider.incrementFixedSpies
                      : playersProvider.players.length -
                                  settingsProvider.fixedSpies <
                              playersProvider.players.length / 2 + 1
                          ? () {}
                          : settingsProvider.incrementFixedSpies,
                  icon: const Icon(Icons.add),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
