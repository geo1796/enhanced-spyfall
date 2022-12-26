class Player {
  String id;
  String name;

  Player(this.id, this.name);

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }

  @override 
  String toString() {
    return 'Player{id: $id, name: $name}';
  }
}