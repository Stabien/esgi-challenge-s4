import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: QrImageView(
            data: "ca marche",
            version: QrVersions.auto,
            size: 200.0,
          ),
          // Text(
          //   "EASY NIGHT",
          //   style: TextStyle(
          //     color: Colors.red,
          //     fontSize: 22,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
        ),
      ),
    );
  }
}
