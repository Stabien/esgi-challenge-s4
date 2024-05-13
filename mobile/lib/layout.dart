import 'package:flutter/material.dart';
import 'package:mobile/screens/customer_register_screen.dart';
import 'package:mobile/screens/home_screen.dart';
import 'package:mobile/screens/login_screen.dart';
import 'package:mobile/screens/organizer_register_screen.dart';
import 'components/navigation/bottom_bar.dart';
import 'package:mobile/events/screen_events.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int _selectedPageIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomeScreen(),
    LoginScreen(),
    CustomerRegisterScreen(),
    OrganizerRegisterScreen(),
    ScreenEvent(),

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
      bottomNavigationBar: BottomBar(
        selectedIndex: _selectedPageIndex,
        onItemTapped: _onBottomBarItemTapped,
      ),
      body: _pages.elementAt(_selectedPageIndex),
    );
  }
}
