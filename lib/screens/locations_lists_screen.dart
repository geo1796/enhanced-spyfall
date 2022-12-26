import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/locations_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/location_list_item.dart';
import 'locations_details_screen.dart';
import 'new_locations_list_screen.dart';

class LocationsListsScreen extends StatelessWidget {
  static const routeName = '/locations-lists';
  LocationsListsScreen({Key? key}) : super(key: key);
  late LocationsProvider _locationsProvider;
  late SettingsProvider _settingsProvider;

  @override
  Widget build(BuildContext context) {
    _locationsProvider = Provider.of<LocationsProvider>(context);
    _settingsProvider = Provider.of<SettingsProvider>(context);
    final lists = _locationsProvider.lists;
    final currentList = _locationsProvider.getList(_settingsProvider.listId);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.of(context).pushNamed(
          NewLocationsListScreen.routeName,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Locations lists'),
      ),
      body: ListView.builder(
        itemCount: lists.length,
        itemBuilder: lists.length > 1
            ? (_, i) => Dismissible(
                  key: ValueKey(
                    lists[i],
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
                    if (currentList == lists[i]) {
                      i > 0
                          ? _locationsProvider.removeCurrentList(
                              currentList,
                              lists[i - 1],
                              _settingsProvider,
                            )
                          : _locationsProvider.removeCurrentList(
                              currentList,
                              lists[i + 1],
                              _settingsProvider,
                            );
                    } else {
                      _locationsProvider.removeList(lists[i]);
                    }
                  },
                  confirmDismiss: (_) => showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text(
                        'Are you sure?',
                      ),
                      content: Text('Remove list ${lists[i].name}?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Yes'),
                        ),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: i == lists.length - 1 ? 100.0 : 0.0),
                    child: LocationListItem(
                      editHandler: () => Navigator.of(context).pushNamed(
                        LocationsDetailsScreen.routeName,
                        arguments: lists[i].id,
                      ),
                      list: lists[i],
                      index: i,
                      isCurrentList: lists[i] == currentList,
                      settingsProvider: _settingsProvider,
                      locationsProvider: _locationsProvider,
                    ),
                  ),
                )
            : (_, i) => LocationListItem(
                  editHandler: () => Navigator.of(context).pushNamed(
                    LocationsDetailsScreen.routeName,
                    arguments: lists[i].id,
                  ),
                  list: lists[i],
                  index: i,
                  isCurrentList: lists[i] == currentList,
                  settingsProvider: _settingsProvider,
                  locationsProvider: _locationsProvider,
                ),
      ),
    );
  }
}
