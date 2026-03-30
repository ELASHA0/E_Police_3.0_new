import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../../resources/my_colors.dart';
import 'NoteAddEditScreen.dart';
import 'NoteModel.dart';
import 'NotesController.dart';

class NoteCard extends StatelessWidget {
  final NoteModel note;
  NoteCard({super.key, required this.note});

  String formatDate(DateTime? date) {
    if (date == null) {
      return "N/A";
    } else {
      return DateFormat('dd MMM').format(date);
    }
  }

  Future<void> shareNote() async {
    try {
      SharePlus.instance.share(
          ShareParams(text: "${note.title}\n${note.description}")
      );
    } catch (e) {
      Get.snackbar("Error", "Could not share: $e");
    }
  }

  final NotesController controller = Get.find<NotesController>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        Get.bottomSheet(
          LongPressActions(context),
        );
      },
      onTap: () {
        Get.to(NoteAddEditScreen(note: note, isEdit: true));
      },
      child: ListTile(
        title: Text(note.title, maxLines: 1, overflow: TextOverflow.ellipsis,),
        subtitle: Text(note.description, maxLines: 2, overflow: TextOverflow.ellipsis,),
        trailing: Text(formatDate(note.createdAt)),
      ),
    );
  }

  Widget LongPressActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.share, color: MyColor.dashbord,),
            title: const Text("Share"),
            onTap: () {
              shareNote();
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red,),
            title: const Text("Delete"),
            onTap: () {
              controller.deleteNote(context, note.id);
            },
          ),
        ],
      ),
    );
  }
}
