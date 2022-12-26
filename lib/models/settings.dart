class Settings {
  String id;
  int prankMode;
  int randomSpies;
  int randomList;
  int coopSpies;
  int fixedSpies;
  int minSpies;
  int maxSpies;
  String listId;

  Settings({
    required this.id,
    required this.prankMode,
    required this.randomSpies,
    required this.coopSpies,
    required this.fixedSpies,
    required this.listId,
    required this.maxSpies,
    required this.minSpies,
    required this.randomList,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'prank_mode': prankMode,
      'random_spies': randomSpies,
      'coop_spies': coopSpies,
      'fixed_spies': fixedSpies,
      'list_id': listId,
      'max_spies': maxSpies,
      'min_spies': minSpies,
      'random_list': randomList,
    };
  }
}
