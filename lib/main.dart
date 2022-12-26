import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:provider/provider.dart';

import '/providers/settings_provider.dart';
import '/providers/game_provider.dart';
import '/repositories/settings_repository.dart';
import '/screens/playing_screen.dart';
import '/screens/players_screen.dart';
import '/screens/locations_details_screen.dart';
import '/screens/locations_lists_screen.dart';
import '/screens/new_locations_list_screen.dart';
import '/screens/game_settings_screen.dart';
import '/providers/players_provider.dart';
import '/repositories/players_repository.dart';
import '/widgets/app_drawer.dart';
import 'providers/locations_provider.dart';
import 'repositories/locations_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await openDatabase(
    join(await getDatabasesPath(), 'spyfall_database.db'),
    onCreate: (db, version) => db
        .execute(
          'CREATE TABLE players(id TEXT PRIMARY KEY, name TEXT);',
        )
        .then(
          (_) => db.execute(
            'CREATE TABLE locations_lists(id TEXT PRIMARY KEY, name TEXT);',
          ),
        )
        .then(
          (_) => db.execute(
            'CREATE TABLE locations(id TEXT PRIMARY KEY, name TEXT, list_id TEXT, FOREIGN KEY(list_id) REFERENCES locations_lists(id));',
          ),
        )
        .then(
          (_) => db.execute(
            'CREATE TABLE settings(id TEXT PRIMARY KEY, prank_mode INT, random_spies INT, coop_spies INT, fixed_spies INT, max_spies INT, min_spies INT, random_list INT, list_id TEXT, FOREIGN KEY(list_id) REFERENCES locations_lists(id));',
          ),
        ),
    version: 1,
  );
  final playersRepository = PlayersRepository(database);
  final playersProvider = PlayersProvider(playersRepository);
  await playersProvider.init();
  final locationsRepository = LocationsRepository(database);
  final locationsProvider = LocationsProvider(locationsRepository);
  await locationsProvider.init();
  final settingsRepository = SettingsRepository(database);
  final settingsProvider = SettingsProvider(settingsRepository);
  await settingsProvider.init();
  runApp(MyApp(playersProvider, locationsProvider, settingsProvider));
}

class MyApp extends StatefulWidget {
  final PlayersProvider playersProvider;
  final LocationsProvider locationsProvider;
  final SettingsProvider settingsProvider;

  const MyApp(
      this.playersProvider, this.locationsProvider, this.settingsProvider,
      {Key? key})
      : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: widget.playersProvider),
        ChangeNotifierProvider.value(value: widget.locationsProvider),
        ChangeNotifierProvider.value(value: widget.settingsProvider),
        ChangeNotifierProvider(create: (_) => GameProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Enhanced Spyfall',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          appBarTheme: AppBarTheme.of(context).copyWith(
            titleTextStyle: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          colorScheme: ThemeData.light().colorScheme.copyWith(
                primary: Colors.purple[600],
                secondary: Colors.amber[600],
                tertiary: Colors.purple[300],
              ),
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: const TextStyle(
                  color: Color.fromARGB(255, 128, 128, 128),
                  fontSize: 14,
                ),
                headline5: const TextStyle(
                  color: Color.fromARGB(255, 128, 128, 128),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                headline4: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              primary: Colors.amber[600],
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        //home: ,
        initialRoute: MyHomePage.routeName,
        routes: {
          MyHomePage.routeName: (_) => const MyHomePage(),
          PlayersScreen.routeName: (_) => PlayersScreen(),
          LocationsListsScreen.routeName: (_) => LocationsListsScreen(),
          LocationsDetailsScreen.routeName: (_) => LocationsDetailsScreen(),
          NewLocationsListScreen.routeName: (_) => NewLocationsListScreen(),
          GameSettingsScreen.routeName: (_) => GameSettingsScreen(),
          PlayingScreen.routeName: (_) => PlayingScreen(),
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  static const routeName = '/home';
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Text(
          'PLAY',
          style: Theme.of(context).textTheme.headline4,
        ),
        onPressed: () => Navigator.of(context).pushReplacementNamed(
          PlayingScreen.routeName,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Enhanced Spyfall'),
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 1/2,
          child: const Image(
            image: AssetImage('assets/spy.png'),
          ),
        ),
      ),
    );
  }
}
