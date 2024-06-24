import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final Function(int) onItemTapped;
  final int selectedIndex;

  const BottomNavigation({
    super.key,
    required this.onItemTapped,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 1,
            color: Color.fromRGBO(255, 255, 255, 0.5),
          ),
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedIconTheme: const IconThemeData(
          color: Colors.green,
        ),
        unselectedIconTheme: const IconThemeData(
          color: Color.fromRGBO(255, 255, 255, 0.75),
        ),
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color.fromRGBO(255, 255, 255, 0.75),
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: selectedIndex,
        iconSize: 28,
        selectedFontSize: 12,
        onTap: (value) => onItemTapped(value),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            label: "HOME",
            icon: Icon(Icons.home),
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            label: "ADD",
            icon: Icon(Icons.add_box_outlined),
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            label: "USAGE",
            icon: Icon(Icons.power),
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            label: "SETTINGS",
            icon: Icon(Icons.settings),
            backgroundColor: Colors.black,
          ),
        ],
      ),
    );
  }
}
