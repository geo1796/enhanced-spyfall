import 'package:flutter/material.dart';

import '../providers/players_provider.dart';
import '../providers/settings_provider.dart';

class RandomSpiesSettings extends StatelessWidget {
  const RandomSpiesSettings(this.settingsProvider, this.playersProvider,
      {Key? key})
      : super(key: key);
  final SettingsProvider settingsProvider;
  final PlayersProvider playersProvider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondaryColor = theme.colorScheme.secondary;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            'Random Spies',
            textAlign: TextAlign.center,
            style: theme.textTheme.headline6,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text('Min spies '),
              CircleAvatar(
                backgroundColor: secondaryColor,
                child: IconButton(
                  onPressed: settingsProvider.minSpies < 1
                      ? () {}
                      : settingsProvider.decrementMinSpies,
                  icon: const Icon(
                    Icons.remove,
                    color: Colors.white,
                  ),
                ),
              ),
              CircleAvatar(
                backgroundColor: secondaryColor,
                child: Text(
                  '${settingsProvider.minSpies}',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              CircleAvatar(
                backgroundColor: secondaryColor,
                child: IconButton(
                  onPressed:
                      settingsProvider.minSpies >= settingsProvider.maxSpies - 1
                          ? () {}
                          : settingsProvider.incrementMinSpies,
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text('Max spies'),
              CircleAvatar(
                backgroundColor: secondaryColor,
                child: IconButton(
                  onPressed:
                      settingsProvider.maxSpies <= settingsProvider.minSpies + 1
                          ? () {}
                          : settingsProvider.decrementMaxSpies,
                  icon: const Icon(
                    Icons.remove,
                    color: Colors.white,
                  ),
                ),
              ),
              CircleAvatar(
                backgroundColor: secondaryColor,
                child: Text(
                  '${settingsProvider.maxSpies}',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              CircleAvatar(
                backgroundColor: secondaryColor,
                child: IconButton(
                  onPressed: playersProvider.players.length -
                              settingsProvider.maxSpies <=
                          playersProvider.players.length / 2
                      ? () {}
                      : settingsProvider.incrementMaxSpies,
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
