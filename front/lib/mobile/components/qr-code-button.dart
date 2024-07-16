import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';

class QRButton extends StatelessWidget {
  final String text;
  QRButton({required this.text});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              content: SizedBox(
                width: 200.0,
                height: 200.0,
                child: Center(
                  child: QrImageView(
                    data: text,
                    version: QrVersions.auto,
                    size: 200,
                  ),
                ),
              ),
            );
          },
        );
      },
      child: const Icon(
        Icons.qr_code,
        color: Colors.white,
      ),
    );
  }
}
