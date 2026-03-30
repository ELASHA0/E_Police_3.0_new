import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:convert';
import 'dart:typed_data';

import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../../resources/my_colors.dart';
import '../QRModel.dart';

class SaveQRScreen extends StatelessWidget {
  final QRModel qrCode;

  SaveQRScreen({super.key, required this.qrCode});

  final GlobalKey _globalKey = GlobalKey();

  Uint8List decodeBase64Image(String base64String) {
    final cleanedBase64 = base64String.contains(",")
        ? base64String.split(",")[1]
        : base64String;

    return base64Decode(cleanedBase64);
  }

  Future<Uint8List> _captureScreen() async {
    RenderRepaintBoundary boundary =
    _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }

  Future<void> _saveAsPdf() async {
    final capturedImage = await _captureScreen();

    final pdf = pw.Document();
    final image = pw.MemoryImage(capturedImage);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(child: pw.Image(image));
        },
      ),
    );

    // Save / Share PDF
    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    Uint8List bytes = decodeBase64Image(qrCode.qrImage);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _saveAsPdf();
        },
        icon: const Icon(Icons.save_alt),
        label: const Text('Download'),
        backgroundColor: MyColor.dashbord,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: RepaintBoundary(
          key: _globalKey,
          child: Container(
            // margin: const EdgeInsets.all(16),
            height: double.infinity,
            padding: const EdgeInsets.all(46),
            decoration: BoxDecoration(
              border: Border.all(color: Color.fromRGBO(0, 53, 58, 1), width: 15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // QR Code
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  width: 400,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ClipRRect(
                      child: Image.memory(
                        bytes,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
          
                const SizedBox(height: 20),
          
                // Company Name
                _buildInfoSection("COMPANY NAME", qrCode.company.companyName ?? ""),
          
                const Divider(thickness: 1, color: Colors.black26),
          
                // Branch Name
                _buildInfoSection("BRANCH NAME", qrCode.branch.branchName ?? ""),
          
                const Divider(thickness: 1, color: Colors.black26),
          
                // Box No
                _buildInfoSection("BOX NO", qrCode.boxNo),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: MyColor.dashbord,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.amber[100], // background highlight
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
      ],
    );
  }
}
