import 'package:flutter/material.dart';
import 'package:mobile/mobile/utils/translate.dart';

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
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.flash_on),
            label: t(context)!.today,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            label: t(context)!.events,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.event_available),
            label: t(context)!.myTickets,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: t(context)!.profile,
          ),
        ],
        currentIndex: widget.selectedIndex,
        onTap: widget.onItemTapped,
      ),
    );
  }
}
