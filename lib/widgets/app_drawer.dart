import 'package:flutter/material.dart';

import 'app_drawer_item.dart';
import '../main.dart';
import '../screens/game_settings_screen.dart';
import '../screens/locations_lists_screen.dart';
import '../screens/players_screen.dart';
import '../screens/playing_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          AppBar(
            title: const Text('Menu'),
          ),
          const Divider(),
          const AppDrawerItem('Home', Icons.home, MyHomePage.routeName),
          const Divider(),
          const AppDrawerItem(
              'Players', Icons.person_add, PlayersScreen.routeName),
          const Divider(),
          const AppDrawerItem(
              'Locations', Icons.place, LocationsListsScreen.routeName),
          const Divider(),
          const AppDrawerItem(
              'Game settings', Icons.settings, GameSettingsScreen.routeName),
          const Divider(),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context)
                  .pushReplacementNamed(PlayingScreen.routeName),
              child: const Text(
                'PLAY',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
