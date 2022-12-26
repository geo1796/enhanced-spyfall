import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/locations.dart';
import '../providers/game_provider.dart';

class RevealedLocationItem extends StatefulWidget {
  const RevealedLocationItem(this.location, {super.key});
  final Location location;

  @override
  State<RevealedLocationItem> createState() => _RevealedLocationItemState();
}

class _RevealedLocationItemState extends State<RevealedLocationItem> {
  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final _selected = gameProvider.checkedLocations.contains(widget.location);
    return GestureDetector(
      onTap:
          !_selected ? () => gameProvider.checkLocation(widget.location) : null,
      child: Card(
        color: !_selected
            ? null
            : gameProvider.secretLocation == widget.location
                ? Colors.green
                : Colors.red,
        elevation: 6,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.location.name,
                textAlign: TextAlign.center,
                style: widget.location == gameProvider.previousLocation
                    ? TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: !_selected ? Colors.black : Colors.white)
                    : TextStyle(
                        color: !_selected ? Colors.black : Colors.white)),
          ),
        ),
      ),
    );
  }
}
