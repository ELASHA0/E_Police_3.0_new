
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:open_filex/open_filex.dart';

import '../../../../resources/my_colors.dart';
import 'PhotoTakingScreenTask.dart';
import 'TaskActionController.dart';

class TaskActionScreen extends StatelessWidget {
  final String taskId;
  TaskActionScreen({super.key, required this.taskId});

  final TaskActionController controller = Get.put(TaskActionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Task Action"), backgroundColor: MyColor.dashbord, foregroundColor: Colors.white,),
      bottomNavigationBar: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: controller.proofPhoto.value != null && controller.proofAudio.value != null ? OutlinedButton(
              style: ElevatedButton.styleFrom(
                side: const BorderSide(
                  color: Colors.green,
                  width: 1.5,
                ),
                backgroundColor: const Color.fromRGBO(224, 247, 210, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                  controller.changeStatusDialogue("Completed", context, taskId);
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 15,
                    color: Color.fromRGBO(37, 87, 9, 1),
                  ),
                  SizedBox(width: 6),
                  Text(
                    "Mark as complete",
                    style: TextStyle(
                      fontSize: 13,
                      color: Color.fromRGBO(37, 87, 9, 1),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ) :
            OutlinedButton(
              style: ElevatedButton.styleFrom(
                side: const BorderSide(
                  color: Colors.grey,
                  width: 1.5,
                ),
                backgroundColor: const Color.fromRGBO(234, 234, 234, 1.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {},
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 15,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 6),
                  Text(
                    "Select photo and audio",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
      body: SafeArea(
        child: Obx(() {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Audio",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 30),
                // ---------- Upload Audio Button ----------
                if(!controller.isRecording.value)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.upload, color: Colors.white),
                      label: const Text(
                        "Upload Audio",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyColor.dashbord,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        // Upload audio logic
                        controller.pickAudio(context);
                      },
                    ),
                  ),
                if (controller.proofAudio.value != null)
                  GestureDetector(
                    onTap: () {
                      OpenFilex.open(controller.proofAudio.value!.path);
                    },
                    child: _buildFileCard(icon: Icons.multitrack_audio, title: controller.proofAudio.value!.path, onTap: () {
                      controller.proofAudio.value = null;
                    }),
                  )
                  ,

                const SizedBox(height: 30),
                Divider(),

                // // ---------- Title ----------
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Picture",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ---------- Camera & Image Cards ----------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildProofCard(
                      icon: Icons.camera_alt_outlined,
                      title: "Camera",
                      onTap: () {
                        Get.to(PhotoTakingScreenTask());
                      },
                    ),
                    _buildProofCard(
                      icon: Icons.image_outlined,
                      title: "Upload Image",
                      onTap: () {
                        controller.pickImage(context);
                      },
                    ),
                  ],
                ),
                if (controller.proofPhoto.value != null)
                  GestureDetector(
                    onTap: () {
                      OpenFilex.open(controller.proofPhoto.value!.path);
                    },
                    child: _buildFileCard(icon: Icons.photo, title: controller.proofPhoto.value!.path, onTap: () {
                      controller.proofPhoto.value = null;
                    }),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ---------- Reusable Card Widget ----------
  Widget _buildProofCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 120,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.grey.shade700),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700, fontWeight: FontWeight.bold
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFileCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    String displayText;
    if (title.length > 20) {
      displayText = '...' + title.substring(title.length - 20);
    } else {
      displayText = title;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        height: 70,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.grey.shade700),
              SizedBox(width: 10,),
              Expanded(
                child: Text(
                  displayText,
                  // overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
              // Spacer(),
              GestureDetector(
                child: Icon(Icons.delete_outline_outlined, size: 40, color: Colors.red.shade700),
                onTap: onTap,
              )
              ,
            ],
          ),
        ),
      ),
    );
  }
}