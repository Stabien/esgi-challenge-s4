import 'package:flutter/material.dart';

class WebAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  const WebAppBar({Key? key})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Your App'),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            Navigator.pushNamed(context, '/');
          },
        ),
        IconButton(
          icon: const Icon(Icons.person),
          onPressed: () {
            Navigator.pushNamed(context, '/users');
          },
        ),
        IconButton(
          icon: const Icon(Icons.event),
          onPressed: () {
            Navigator.pushNamed(context, '/events');
          },
        ),
        IconButton(
          icon: const Icon(Icons.message),
          onPressed: () {
            Navigator.pushNamed(context, '/messages');
          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
            Navigator.pushNamed(context, '/notification');
          },
        ),
        IconButton(
          icon: const Icon(Icons.group),
          onPressed: () {
            Navigator.pushNamed(context, '/organizer');
          },
        ),
        IconButton(
          icon: const Icon(Icons.star),
          onPressed: () {
            Navigator.pushNamed(context, '/rates');
          },
        ),
        IconButton(
          icon: const Icon(Icons.book),
          onPressed: () {
            Navigator.pushNamed(context, '/reservations');
          },
        ),
        IconButton(
          icon: const Icon(Icons.flip_camera_android),
          onPressed: () {
            Navigator.pushNamed(context, '/feature_flipping');
          },
        ),
        IconButton(
          icon: const Icon(Icons.insert_drive_file_outlined),
          onPressed: () {
            Navigator.pushNamed(context, '/logs');
          },
        ),
      ],
    );
  }
}
