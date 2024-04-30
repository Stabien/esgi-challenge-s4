import 'package:flutter/material.dart';
import 'components/navigation/bottom_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedPageIndex = 0;

  void _onBottomBarItemTapped(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: Text('eerte'),
      ),
      bottomNavigationBar: BottomBar(
          selectedIndex: _selectedPageIndex,
          onItemTapped: _onBottomBarItemTapped),
      body: Container(
        color: Colors.white,
        child: const Center(
          child: Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                "EASY NIGHT",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              )),
        ),
      ),
    );
  }
}

class AppBar extends StatelessWidget {
  const AppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// class BottomBar extends StatelessWidget {
//   const BottomBar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
