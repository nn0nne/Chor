import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  // const BottomNavBar({super.key});

  final int selectedIndex;
  final Function(int) onTap;

  const BottomNavBar(
      {super.key, required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.library_music),
          label: 'Playlists',
        ),
      ],
      backgroundColor: const Color(0xFF1B1A55),
      selectedItemColor: const Color(0xFFEEEEEE),
      unselectedItemColor: const Color(0xFF9290C3),
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
      onTap: onTap,
    );
  }
}
