import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import '../../../resources/my_colors.dart';
import '../TaskAction/TaskActionController.dart';
import '../TaskModel.dart';

class CompletedTaskScreen extends StatelessWidget {
  final Task task;
  CompletedTaskScreen({super.key, required this.task});

  final TaskActionController controller = Get.put(TaskActionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Task'),
        backgroundColor: MyColor.dashbord,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              _showFileOptions(context, task.completionFields?.audioUrl ?? '');
            },
            child: _buildFileCard(icon: Icons.multitrack_audio, title: task.completionFields?.audioUrl ?? ''),
          ),
          GestureDetector(
            onTap: () {
              _showFileOptions(context, task.completionFields?.imageUrl ?? '');
            },
            child: _buildFileCard(icon: Icons.image, title: task.completionFields?.imageUrl ?? '')
          )
        ],
      ),
    );
  }

  Widget _buildFileCard({
    required IconData icon,
    required String title,
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
            ],
          ),
        ),
      ),
    );
  }

  void _showFileOptions(BuildContext context, String url) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.download),
                title: Text("Download File"),
                onTap: () {
                  Navigator.pop(context);
                  controller.downloadFileToDownloads(url, context);
                },
              ),
              ListTile(
                leading: Icon(Icons.open_in_new),
                title: Text("Open File"),
                onTap: () {
                  Navigator.pop(context);
                  controller.downloadAndOpenFile(url, context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
