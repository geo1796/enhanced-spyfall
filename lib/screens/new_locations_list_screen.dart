import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'locations_lists_screen.dart';
import '../providers/locations_provider.dart';
import '../models/locations.dart';

class NewLocationsListScreen extends StatelessWidget {
  static const routeName = '/new-locations-list';
  NewLocationsListScreen({Key? key}) : super(key: key);
  final _form = GlobalKey<FormState>();
  late LocationsProvider locationsProvider;
  late LocationsList list;
  List<Location> locations = [];
  var _isInit = false;

  void _init(BuildContext context) {
    if (_isInit) {
      return;
    }

    locationsProvider = Provider.of<LocationsProvider>(context);
    list = LocationsList(DateTime.now().toString(), '');
    for (var i = 0; i < 10; i++) {
      locations.add(
        Location(DateTime.now().toString(), '', list.id),
      );
    }

    _isInit = true;
  }

  bool _saveForm() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return false;
    }
    _form.currentState!.save();
    locationsProvider.createList(list, locations);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    _init(context);
    final locationsFormFields = List.generate(
        10,
        (i) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Location ${i + 1}'),
                textInputAction: TextInputAction.next,
                validator: ((value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide a valid location';
                  }
                  if ((value.length < 2) && value.contains(' ')) {
                    return 'Please provide a valid location';
                  }
                  if (!value.contains(RegExp(r'(\w+)'))) {
                    return 'Please provide a valid location';
                  }
                  final eventualDuplicate =
                      locations.where((location) => location.name == value);
                  if (eventualDuplicate.length > 1) {
                    return 'This location is already in the list';
                  } else if (eventualDuplicate.length == 1) {
                    if (eventualDuplicate.first != locations[i]) {
                      return 'This location is already in the list';
                    }
                  }
                  return null;
                }),
                onFieldSubmitted: (newValue) {
                  locations[i].name = newValue;
                },
                onChanged: (newValue) {
                  locations[i].name = newValue;
                },
              ),
            ));

    return Scaffold(
      appBar: AppBar(
        title: const Text('New locations list'),
      ),
      body: Form(
        key: _form,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_saveForm()) {
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text('Confirm'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'List name'),
                  textInputAction: TextInputAction.next,
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
                  onSaved: (newValue) => list.name = newValue!,
                ),
              ),
              ...locationsFormFields,
            ],
          ),
        ),
      ),
    );
  }
}
