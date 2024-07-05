import 'package:mobile/mobile/utils/navigation.dart';
import 'package:mobile/mobile/utils/secureStorage.dart';
import 'package:flutter/material.dart';

class DisconnectButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
        backgroundColor: Colors.red,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: () async {
        await SecureStorage.deleteStorageItem('token');
        redirectToPath(context, "/auth");
      },
      child: const Icon(
        Icons.logout,
        color: Colors.white,
      ),
    );
  }
}
