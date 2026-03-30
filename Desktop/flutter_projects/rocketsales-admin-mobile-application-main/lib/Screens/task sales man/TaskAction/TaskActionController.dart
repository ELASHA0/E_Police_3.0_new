import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../NativeChannel.dart';
import '../../../../TokenManager.dart';
import '../../../../resources/my_colors.dart';
import '../saleTask_controller.dart';

class TaskActionController extends GetxController {
  // Recording state
  RxBool isRecording = false.obs;
  RxBool isPlaying = false.obs;

  RxBool isLoading = false.obs;

  // Audio path
  RxString audioPath = ''.obs;

  // Timer
  Timer? _timer;
  RxInt recordDuration = 0.obs;
  var proofPhoto = Rxn<File?>();
  var proofAudio = Rxn<File?>();
  RxBool isPicking = false.obs;

  TaskController controller = Get.find<TaskController>();

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  Future<void> downloadFileToDownloads(String url, BuildContext context) async {
    showLoading(context);

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final downloadsDir = Directory('/storage/emulated/0/Download'); // Android
        final filename = url.split('/').last;
        final savePath = '${downloadsDir.path}/$filename';

        final file = File(savePath);
        await file.writeAsBytes(response.bodyBytes);

        Navigator.of(context).pop();
        showSnackbar("File downloaded to Downloads folder");

      } else {
        Navigator.of(context).pop();
        showSnackbar("Download failed: ${response.statusCode}");
      }
    } catch (e) {
      Navigator.of(context).pop();
      showSnackbar("Error downloading file");
    }
  }

  Future<void> downloadAndOpenFile(String url, BuildContext context) async {
    showLoading(context);
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // get local storage folder
        final dir = await getTemporaryDirectory();

        // extract filename
        final filename = url.split('/').last;

        // create local file path
        final filePath = '${dir.path}/$filename';

        // save file
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        // open
        Navigator.of(context).pop();
        await OpenFilex.open(filePath);
      } else {
        print("Download failed: ${response.statusCode}");
        Navigator.of(context).pop();
      }
    } catch (e) {
      print("Error downloading file: $e");
      Navigator.of(context).pop();
    }
  }

  Future<File?> compressImageUnder30kb(File file, BuildContext context) async {
    showLoading(context);
    const maxSize = 30 * 1024; // 30 KB
    int quality = 90;

    File? compressed;

    while (quality > 5) {
      final result = await FlutterImageCompress.compressWithFile(
        file.path,
        quality: quality,
        minWidth: 800,
        minHeight: 800,
      );

      if (result == null) return null;

      compressed = File(file.path)..writeAsBytesSync(result);

      if (compressed.lengthSync() <= maxSize) {
        return compressed;
      }

      quality -= 10; // reduce and retry
    }

    return compressed; // best effort
  }


  Future<void> pickImage(BuildContext context) async {
    if (isPicking.value) return;   // Prevent multiple requests
    isPicking.value = true;

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );

      if (result != null && result.files.single.path != null) {
        final pickedImage = File(result.files.single.path!);
        final compressed = await compressImageUnder30kb(pickedImage, context);

        if (compressed != null) {
          proofPhoto.value = compressed;
        } else {
          proofPhoto.value = pickedImage;
        }

        Navigator.pop(context);
      }
    } catch (e) {
      print("Pick error: $e");
    } finally {
      isPicking.value = false;
    }
  }

  Future<void> pickAudio(BuildContext context) async {
    if (isPicking.value) return;
    isPicking.value = true;

    // CLOSE BOTTOM SHEET / DIALOG FIRST
    // if (Navigator.canPop(context)) {
    //   Navigator.pop(context);
    // }

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['m4a', 'mp3', 'aac', 'wav'],
        allowMultiple: false,
        withData: true,
      );

      if (result != null && result.files.single.path != null) {
        proofAudio.value = File(result.files.single.path!);
        audioPath.value = result.files.single.path!;
      }
    } catch (e) {
      print("Audio pick error: $e");
    } finally {
      isPicking.value = false;
    }
  }


  MediaType? getMediaType(String path) {
    final ext = path.split('.').last.toLowerCase();

    switch (ext) {
    // Images
      case 'jpg':
      case 'jpeg':
        return MediaType('image', 'jpeg');
      case 'png':
        return MediaType('image', 'png');

    // Audio
      case 'mp3':
        return MediaType('audio', 'mpeg');
      case 'wav':
        return MediaType('audio', 'wav');
      case 'flac':
        return MediaType('audio', 'flac');
      case 'wma':
        return MediaType('audio', 'x-ms-wma');
      case 'ogg':
        return MediaType('audio', 'ogg');
      case 'aac':
        return MediaType('audio', 'aac');
      case 'm4a':
        return MediaType('audio', 'x-m4a');
      case 'aiff':
      case 'aif':
        return MediaType('audio', 'aiff');

      default:
        return null; // Unknown
    }
  }

  void showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: const Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: MyColor.dashbord),
                SizedBox(width: 20),
                Text("Loading..."),
              ],
            ),
          ),
        );
      },
    );
  }


  Future<bool> toggleTaskStatus(
      String taskId, String newStatus, BuildContext buildContext) async {

    isLoading.value = true;
    final url = Uri.parse('${dotenv.env['BASE_URL']}/api/api/task/status/$taskId');

    final id = await TokenManager.getSupervisorId();
    if (id == null) {
      showSnackbar("User ID not found from token");
      isLoading.value = false;
      return Future.error("Failed");
    }

    final token = await TokenManager.getToken();
    if (token == null) {
      showSnackbar("Auth token not found");
      isLoading.value = false;
      return Future.error("Failed");
    }

    print("url =====>>>> ${url.toString()}");

    try {
      var request = http.MultipartRequest("PUT", url);
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      request.fields['status'] = newStatus;

      if (proofAudio.value != null) {
        final audioPath = proofAudio.value!.path;
        final mediaType = getMediaType(audioPath);

        request.files.add(
          await http.MultipartFile.fromPath(
            'audio',
            audioPath,
            contentType: mediaType,
          ),
        );
      }

      if (proofPhoto.value != null) {
        final imagePath = proofPhoto.value!.path;
        final mediaType = getMediaType(imagePath);

        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            imagePath,
            contentType: mediaType,
          ),
        );
      }

      var streamed = await request.send();
      var response = await http.Response.fromStream(streamed);

      if (response.statusCode == 200) {
        showSnackbar("Task marked as $newStatus");
        isLoading.value = false;
        return true;
      } else {
        showSnackbar("Failed: ${response.body}");
        isLoading.value = false;
        print("error======>>>> ${response.body}");
        return Future.error("Failed");
      }

    } catch (e) {
      showSnackbar("Error updating status");
      isLoading.value = false;
      return Future.error("Failed");
    }
  }

  Future<String?> changeStatusDialogue(String status, BuildContext context, String taskId) {
    return showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: const Text('Change task status'),
          content:
          Text('Are you sure you want to mark this task as $status ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'No',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () async {
                showLoading(context);
                toggleTaskStatus(taskId, status, context)
                    .then((success) {
                  print("SUCCESS: Status updated");
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  proofAudio.value = null;
                  proofPhoto.value = null;
                  controller.getTasks();
                }, onError: (error) {
                  print("FAILED: $error");
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                });
              },
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ));
  }

  void showSnackbar(String message) {
    Get.snackbar('Message', message);
  }
}
