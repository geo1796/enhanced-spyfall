import 'package:flutter/material.dart';

class PlayerListItem extends StatelessWidget {
  final String label;
  final int index;
  final Function editHandler;

  const PlayerListItem({
    Key? key,
    required this.label,
    required this.index,
    required this.editHandler,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Text(
            '${index + 1}',
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        title: Text(
          label, style: Theme.of(context).textTheme.headline5,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => editHandler.call(),
        ),
      ),
    );
  }
}
