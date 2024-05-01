import 'package:flutter/material.dart';
import 'package:mobile/screens/customer_register_screen.dart';
import 'package:mobile/screens/home_screen.dart';
import 'package:mobile/screens/login_screen.dart';
import 'package:mobile/screens/organizer_register_screen.dart';
import 'components/navigation/bottom_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedPageIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomeScreen(),
    LoginScreen(),
    CustomerRegisterScreen(),
    OrganizerRegisterScreen(),
  ];

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
        child: Placeholder(),
      ),
      bottomNavigationBar: BottomBar(
        selectedIndex: _selectedPageIndex,
        onItemTapped: _onBottomBarItemTapped,
      ),
      body: _pages.elementAt(_selectedPageIndex),
    );
  }
}
