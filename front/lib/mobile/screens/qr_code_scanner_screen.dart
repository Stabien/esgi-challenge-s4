import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:mobile/mobile/services/api_reservation_services.dart';
import 'dart:io';

class QRCodeScannerScreen extends StatefulWidget {
  const QRCodeScannerScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _QRCodeScannerScreenState createState() => _QRCodeScannerScreenState();
}

class _QRCodeScannerScreenState extends State<QRCodeScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String qrText = '';
  bool _isLoading = false;
  bool _isDialogShowing = false;

  bool isValidUUID(String uuid) {
    final uuidRegExp = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
      caseSensitive: false,
    );
    return uuidRegExp.hasMatch(uuid);
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner QR Code'),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Text('Reservation: $qrText'),
                ),
              ),
            ],
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      String scannedText = scanData.code!;
      // print("Scanned QR Code: $scannedText");

      setState(() {
        qrText = scannedText;
      });

      if (!_isDialogShowing) {
        if (isValidUUID(scannedText)) {
          setState(() {
            _isLoading = true;
            _isDialogShowing = true;
          });

          controller.pauseCamera();

          try {
            ReservationStatus status =
                await ApiReservation.isValid(scannedText);

            setState(() {
              _isLoading = false;
            });

            if (status.isValid) {
              _showResultDialog(
                  true, 'Réservation valide pour l\'événement ${status.event}');
            } else {
              _showResultDialog(
                  false, status.message ?? 'Réservation invalide');
            }
          } catch (e) {
            setState(() {
              _isLoading = false;
            });
            _showResultDialog(false, 'Error: $e');
          }
        } else {
          _showResultDialog(false, 'QR Code invalide');
        }
      }
    });
  }

  void _showResultDialog(bool isValid, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: isValid
              ? const Icon(Icons.check_circle, color: Colors.green, size: 50)
              : const Icon(Icons.close, color: Colors.red, size: 50),
          content: Text(
            message,
            style: const TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                setState(() {
                  _isDialogShowing = false;
                });
                Navigator.of(context).pop();
                controller?.resumeCamera();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
