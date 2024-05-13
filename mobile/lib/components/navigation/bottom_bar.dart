import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key, required this.selectedIndex, this.onItemTapped});

  final int selectedIndex;
  final ValueChanged<int>? onItemTapped;

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Accueil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.login),
          label: 'Connexion',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.login),
          label: 'Inscription utilisateur',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.login),
          label: 'Inscription organisateur',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Evenements',
        ),
        BottomNavigationBarItem(
                  icon: Icon(Icons.insert_drive_file_outlined),
                  label: 'Logs',
                ),

      ],
      currentIndex: widget.selectedIndex,
      onTap: widget.onItemTapped,
    );
  }
}
