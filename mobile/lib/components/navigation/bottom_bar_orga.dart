import 'package:flutter/material.dart';

class BottomBarOrga extends StatefulWidget {
  const BottomBarOrga(
      {super.key, required this.selectedIndex, this.onItemTapped});

  final int selectedIndex;
  final ValueChanged<int>? onItemTapped;

  @override
  State<BottomBarOrga> createState() => _BottomBarOrgaState();
}

class _BottomBarOrgaState extends State<BottomBarOrga> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(
          top: BorderSide(
            color: Colors.white,
            width: 2.0,
          ),
        ),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.login),
          //   label: 'Connexion',
          // ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.login),
          //   label: 'Inscription utilisateur',
          // ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.login),
          //   label: 'Inscription organisateur',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Events Organizer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_drive_file_outlined),
            label: 'Logs',
          ),
        ],
        currentIndex: widget.selectedIndex,
        onTap: widget.onItemTapped,
      ),
    );
  }
}
