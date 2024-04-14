import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child:  const Center(
          child: Directionality(textDirection: TextDirection.ltr,child: Text(
            "EASY NIGHT",

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

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
