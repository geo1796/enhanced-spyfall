import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/locations.dart';
import '../providers/locations_provider.dart';
import '../widgets/player_list_item.dart';

class LocationsDetailsScreen extends StatelessWidget {
  static const routeName = '/locations-details';
  LocationsDetailsScreen({Key? key}) : super(key: key);
  late LocationsProvider locationsProvider;
  late String listId;
  late List<Location> locations;
  late LocationsList list;

  _saveLocation(GlobalKey<FormState> form, Location newLocation, int index) {
    final isValid = form.currentState!.validate();
    if (!isValid) {
      return false;
    }
    form.currentState!.save();
    locationsProvider.editLocation(newLocation, index);
    return true;
  }

  void _startEditingLocation(
    BuildContext context,
    int index,
  ) {
    var newLocation = (index == -1)
        ? Location(DateTime.now().toString(),
            '', listId)
        : locations[index];
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
                initialValue: newLocation.name,
                decoration: InputDecoration(labelText: 'Location ${locations.length + 1}', contentPadding: EdgeInsets.all(8)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide a valid location';
                  }
                  if ((value.length < 2) && value.contains(' ')) {
                    return 'Please provide a valid location';
                  }
                  if (!value.contains(RegExp(r'(\w+)'))) {
                    return 'Please provide a valid location';
                  }
                  if (locations.lastIndexWhere(
                          (location) => location.name == value) !=
                      -1) {
                    return 'This location is already in the list';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  newLocation.name = newValue!;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: FloatingActionButton(
                  onPressed: () {
                    if (_saveLocation(form, newLocation, index)) {
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

  _startEditingListName(BuildContext context, LocationsList list) {
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
                initialValue: list.name,
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
                  if (locationsProvider.lists.lastIndexWhere(
                          (storedList) => storedList.name == value) !=
                      -1) {
                    return 'This name is already taken';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  list.name = newValue!;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: FloatingActionButton(
                  onPressed: () {
                    if (_saveListName(form, list)) {
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

  _saveListName(GlobalKey<FormState> form, LocationsList list) {
    final isValid = form.currentState!.validate();
    if (!isValid) {
      return false;
    }
    form.currentState!.save();
    locationsProvider.editList(list);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    locationsProvider = Provider.of<LocationsProvider>(context);
    listId = ModalRoute.of(context)!.settings.arguments as String;
    list = locationsProvider.getList(listId);
    locations = locationsProvider.getLocations(list);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _startEditingLocation(context, -1),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: Text(list.name),
        actions: [
          IconButton(
            onPressed: () => _startEditingListName(context, list),
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: locations.length,
        itemBuilder: locations.length > 10
            ? (_, i) => Dismissible(
                  key: ValueKey(
                    locations[i],
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
                    locationsProvider.removeLocation(locations[i]);
                  },
                  confirmDismiss: (_) => showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text(
                        'Are you sure?',
                      ),
                      content:
                          Text('Remove ${locations[i].name} from the list?'),
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
                    padding: EdgeInsets.only(
                        bottom: i == locations.length - 1 ? 100.0 : 0.0),
                    child: PlayerListItem(
                      label: locations[i].name,
                      index: i,
                      editHandler: () => _startEditingLocation(context, i),
                    ),
                  ),
                )
            : (_, i) => PlayerListItem(
                  label: locations[i].name,
                  index: i,
                  editHandler: () => _startEditingLocation(context, i),
                ),
      ),
    );
  }
}
