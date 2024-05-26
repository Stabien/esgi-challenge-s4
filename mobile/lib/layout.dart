import 'package:flutter/material.dart';
import 'package:mobile/events/events_organizer.dart';
import 'package:mobile/screens/home_screen.dart';
import 'package:mobile/screens/logs_screen.dart';
import 'package:mobile/utils/navigation.dart';
import 'components/navigation/bottom_bar.dart';
import 'components/navigation/bottom_bar_orga.dart';
import 'package:mobile/events/screen_events.dart';
import 'package:mobile/eventsReservation/screen_eventsReserv.dart';
import 'package:mobile/events/screen_eventsToday.dart';
import 'package:mobile/utils/secureStorage.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  String _userRole = "";
  int _selectedPageIndex = 0;

  Future<void> redirectIfNotAuthenticated() async {
    String? token = await SecureStorage.getStorageItem('token');

    if (token == null) {
      Future.delayed(Duration.zero, () => {redirectToPath(context, '/auth')});
    }
  }

  @override
  void initState() {
    super.initState();
    redirectIfNotAuthenticated();
    initUser();
  }

  Future<void> initUser() async {
    String? userRole = await SecureStorage.getStorageItem('userRole');
    setState(() {
      _userRole = userRole ?? "";
    });
  }

  static const List<Widget> _pages = <Widget>[
    HomeScreen(),
    ScreenEventToday(),
    ScreenEvent(),
    ScreenEventReservation(),
    EventsOrganizer(),
    // LogsScreen(),
  ];

  static const List<Widget> _pagesOrga = <Widget>[
    HomeScreen(),
    EventsOrganizer(),
    LogsScreen(),
  ];

  void _onBottomBarItemTapped(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pagesToShow = _userRole == 'organizer' ? _pagesOrga : _pages;

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _userRole == 'organizer'
          ? BottomBarOrga(
              selectedIndex: _selectedPageIndex,
              onItemTapped: _onBottomBarItemTapped,
            )
          : BottomBar(
              selectedIndex: _selectedPageIndex,
              onItemTapped: _onBottomBarItemTapped,
            ),
      body: pagesToShow.elementAt(_selectedPageIndex),
    );
  }
}
