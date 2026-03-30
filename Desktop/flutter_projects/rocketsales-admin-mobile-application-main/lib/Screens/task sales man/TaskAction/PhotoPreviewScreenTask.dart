import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../../resources/my_colors.dart';
import 'TaskActionController.dart';

class PhotoPreviewScreenTask extends StatelessWidget {
  final File imageFile;

  PhotoPreviewScreenTask({super.key, required this.imageFile});

  final TaskActionController controller =
  Get.find<TaskActionController>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevents default back navigation
      onPopInvokedWithResult: (didPop, setResult) {
        if (didPop) return;
        Navigator.pop(context, 'retake');
        setResult!;
      },
      child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: MyColor.dashbord,
            title: const Text(
              'Photo Preview',
              style: TextStyle(color: Colors.white),
            ),
            leading: const BackButton(
              color: Colors.white,
            ),
          ),
          body: Stack(
            children: [
              Center(
                child: Image.file(
                  imageFile,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding:
                  const EdgeInsets.only(right: 12.0, left: 12, bottom: 60),
                  child: Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor:
                            const Color.fromRGBO(28, 80, 140, 0.59),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () {
                            Navigator.pop(context, 'retake'); // 👈 return retake flag
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.refresh),
                              SizedBox(width: 6),
                              Text("Retake"),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12), // spacing between buttons
                      Expanded(
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor:
                            const Color.fromRGBO(28, 80, 140, 0.59),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () async {
                            final compressed = await controller.compressImageUnder30kb(imageFile, context);

                            if (compressed != null) {
                              controller.proofPhoto.value = compressed;
                            } else {
                              controller.proofPhoto.value = imageFile; // fallback
                            }
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.upload),
                              SizedBox(width: 6),
                              Text("Submit"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
