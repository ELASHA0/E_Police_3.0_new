import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScanScreen extends StatelessWidget {
  final void Function(String) onScan;

  const BarcodeScanScreen({super.key, required this.onScan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Barcode')),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (capture) {
              for (final barcode in capture.barcodes) {
                final code = barcode.rawValue;
                if (code != null) {
                  onScan(code);
                  Navigator.pop(context); // Close scanner
                }
              }
            },
          ),
          Center(
            child: Icon(
              Icons.camera_alt,
              color: Colors.white.withOpacity(0.5),
              size: 80,
            ),
          ),
        ],
      ),
    );
  }
}
