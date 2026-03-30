import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import '../../../../resources/my_colors.dart';
import 'PhotoPreviewScreenTask.dart';
import 'TaskActionController.dart';

class PhotoTakingScreenTask extends StatefulWidget {
  const PhotoTakingScreenTask({super.key});

  @override
  State<PhotoTakingScreenTask> createState() => _PhotoTakingScreenTaskState();
}

class _PhotoTakingScreenTaskState extends State<PhotoTakingScreenTask> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  bool _isFrontCamera = false;
  bool _isFlashOn = false;

  final TaskActionController controller = Get.find();

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _cameraController = null;
    _isFrontCamera = false;
    _isFlashOn = false;
    super.dispose();
  }

  Future<void> _initCamera({bool useFrontCamera = false}) async {
    _cameras = await availableCameras();
    final selectedCamera = _cameras!.firstWhere(
          (camera) => camera.lensDirection ==
          (useFrontCamera ? CameraLensDirection.front : CameraLensDirection.back),
    );

    _cameraController = CameraController(
      selectedCamera,
      ResolutionPreset.ultraHigh,
      enableAudio: false,
    );

    await _cameraController!.initialize();

    if (!useFrontCamera) {
      // Reset flash when switching to back camera
      await _cameraController!.setFlashMode(
          _isFlashOn ? FlashMode.torch : FlashMode.off);
    }

    if (mounted) {
      setState(() => _isInitialized = true);
    }
  }

  Future<void> _toggleFlash() async {
    if (_isFrontCamera) return; // no flash on front camera

    _isFlashOn = !_isFlashOn;

    await _cameraController!.setFlashMode(
      _isFlashOn ? FlashMode.torch : FlashMode.off,
    );

    setState(() {});
  }

  Future<void> _toggleCamera() async {
    _isFrontCamera = !_isFrontCamera;

    await _cameraController?.dispose();
    _cameraController = null;
    _isInitialized = false;

    _isFlashOn = false; // reset flash when switching camera

    await _initCamera(useFrontCamera: _isFrontCamera);

    setState(() {});
  }

  Future<File> flipImage(File file) async {
    final bytes = await file.readAsBytes();
    final image = img.decodeImage(bytes)!;
    final flipped = img.flipHorizontal(image);

    final directory = await getTemporaryDirectory();
    final newPath = path.join(
        directory.path, "flipped_${DateTime.now().millisecondsSinceEpoch}.jpg");

    final newFile = File(newPath);
    await newFile.writeAsBytes(img.encodeJpg(flipped));
    return newFile;
  }

  Future<void> _captureImage() async {
    if (!_cameraController!.value.isInitialized) return;

    final rawImage = await _cameraController!.takePicture();

    File finalImage;

    // Flip only if using front camera
    if (_isFrontCamera) {
      finalImage = await flipImage(File(rawImage.path));
    } else {
      finalImage = File(rawImage.path);
    }

    await _cameraController?.dispose();

    _cameraController = null;

    setState(() {
      _isInitialized = false;
      _isFrontCamera = false;
      _isFlashOn = false;
    });

    final result =
    await Get.to(() => PhotoPreviewScreenTask(imageFile: finalImage));

    if (result == 'retake') {
      _initCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.dashbord,
        title: const Text('Submit Info', style: TextStyle(color: Colors.white)),
        leading: const BackButton(color: Colors.white),
      ),
      body: _isInitialized
          ? Stack(
        children: [
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _cameraController!.value.previewSize!.height,
                height: _cameraController!.value.previewSize!.width,
                child: (_cameraController != null && _cameraController!.value.isInitialized)
                    ? CameraPreview(_cameraController!)
                    : const SizedBox(),
              ),
            ),
          ),

          // 🔘 TOP RIGHT BUTTONS: Flash + Flip
          Positioned(
            top: 20,
            right: 20,
            child: Column(
              children: [
                // FLASH BUTTON (only for back camera)
                if (!_isFrontCamera)
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: MyColor.dashbord,
                    child: IconButton(
                      color: Colors.white,
                      icon: Icon(
                        _isFlashOn ? Icons.flash_on : Icons.flash_off,
                        size: 26,
                      ),
                      onPressed: _toggleFlash,
                    ),
                  ),
                const SizedBox(height: 12),

                // CAMERA FLIP BUTTON
                CircleAvatar(
                  radius: 26,
                  backgroundColor: MyColor.dashbord,
                  child: IconButton(
                    color: Colors.white,
                    icon: const Icon(Icons.flip_camera_android, size: 26),
                    onPressed: _toggleCamera,
                  ),
                ),
              ],
            ),
          ),

          // 🔘 CAPTURE BUTTON
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton(
                backgroundColor: MyColor.dashbord,
                onPressed: _captureImage,
                child:
                const Icon(Icons.camera_alt, color: Colors.white),
              ),
            ),
          ),
        ],
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
