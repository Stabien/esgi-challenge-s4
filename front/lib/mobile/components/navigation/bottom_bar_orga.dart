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
            label: 'Events Organizer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner_outlined),
            label: 'QR Code Scanner',
          ),
        ],
        currentIndex: widget.selectedIndex,
        onTap: widget.onItemTapped,
      ),
    );
  }
}
