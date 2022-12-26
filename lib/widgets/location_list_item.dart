import 'package:flutter/material.dart';

import '../models/locations.dart';
import '../providers/locations_provider.dart';
import '../providers/settings_provider.dart';

class LocationListItem extends StatelessWidget {
  final LocationsList list;
  final int index;
  final Function editHandler;
  final bool isCurrentList;
  final LocationsProvider locationsProvider;
  final SettingsProvider settingsProvider;

  const LocationListItem({
    Key? key,
    required this.list,
    required this.index,
    required this.editHandler,
    required this.isCurrentList,
    required this.locationsProvider,
    required this.settingsProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isCurrentList
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.primary,
          child: IconButton(
            onPressed: () => settingsProvider.setListId(list.id),
            icon: Text(
              '${index + 1}',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        title: Text(
          '${list.name}\n- ${locationsProvider.getLocations(list).length} locations -',
          style: Theme.of(context).textTheme.headline5,
        ),
        subtitle: isCurrentList ? const Text('Current list') : null,
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => editHandler.call(),
        ),
      ),
    );
  }
}
