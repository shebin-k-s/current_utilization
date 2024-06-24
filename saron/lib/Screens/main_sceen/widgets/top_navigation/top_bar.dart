import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  final String heading;
  final int id;
  const TopBar({
    super.key,
    required this.heading,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: id == 4 ? Color.fromRGBO(62, 180, 137, 1) : Colors.black,
      title: Text(
        heading,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 26,
        ),
      ),
    );
  }
}
