import 'package:mobile/mobile/utils/navigation.dart';
import 'package:mobile/mobile/utils/secureStorage.dart';
import 'package:flutter/material.dart';

class DisconnectButton extends StatelessWidget {
  const DisconnectButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: ElevatedButton(
        onPressed: () async {
          await SecureStorage.deleteStorageItem('token');
          redirectToPath(context, "/auth");
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(8),
        ),
        child: const Icon(
          Icons.logout,
          color: Colors.white,
        ),
      ),
    );
  }
}
