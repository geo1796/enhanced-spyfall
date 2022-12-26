import 'package:flutter/material.dart';

class AppDrawerItem extends StatelessWidget {
  const AppDrawerItem(this.label, this.icon, this.route, {Key? key})
      : super(key: key);
  final String label;
  final String route;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.secondary,
      ),
      title: Text(label, style: Theme.of(context).textTheme.headline5),
      onTap: () => Navigator.of(context).pushReplacementNamed(route),
    );
  }
}
