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
    return BottomNavigationBar(items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.login),
        label: 'Login',
      ),
    ], currentIndex: widget.selectedIndex, onTap: widget.onItemTapped);
  }
}
