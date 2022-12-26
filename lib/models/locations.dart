class LocationsList {
  String id;
  String name;

  LocationsList(this.id, this.name);

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }

  @override 
  String toString() {
    return 'LocationsList{id: $id, name: $name}';
  }
}

class Location {
  String id;
  String name;
  String listId;

  Location(this.id, this.name, this.listId);

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'list_id': listId};
  }

  @override 
  String toString() {
    return 'Location{id: $id, name: $name, listId: $listId}';
  }
}