import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../../resources/my_colors.dart';
import '../Notes/NotesController.dart';
import 'ToDoAddEditScreen.dart';
import 'ToDoModel.dart';
import 'ToDosController.dart';

class ToDoCard extends StatefulWidget {
  final ToDoModel note;
  ToDoCard({super.key, required this.note});

  @override
  State<ToDoCard> createState() => _ToDoCardState();
}

class _ToDoCardState extends State<ToDoCard> {
  String formatDate(DateTime? date) {
    if (date == null) {
      return "N/A";
    } else {
      return DateFormat('dd MMM').format(date);
    }
  }

  Future<void> shareToDo() async {
    try {
      SharePlus.instance.share(
          ShareParams(text: "${widget.note.title}\n${widget.note.description}")
      );
    } catch (e) {
      Get.snackbar("Error", "Could not share: $e");
    }
  }

  late bool isChecked;

  @override
  void initState() {
    isChecked = widget.note.status == 'Completed';
    super.initState();
  }

  final ToDosController controller = Get.find<ToDosController>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        Get.bottomSheet(
          LongPressActions(),
        );
      },
      onTap: () {
        Get.to(ToDoAddEditScreen(note: widget.note, isEdit: true));
      },
      child: ListTile(
        leading: Checkbox(
          checkColor: Colors.white,
          // fillColor: WidgetStateProperty.resolveWith(getColor),
          value: isChecked,
          onChanged: (bool? value) {
            controller.updateTodoFromCheckbox(context, widget.note.id, value == true ? 'Completed' : 'Pending').then((_) {
              setState(() {
                isChecked = value!;
                widget.note.status = value ? 'Completed' : 'Pending';
              });
            });
          },
        ),
        title: Text(widget.note.title, maxLines: 1, overflow: TextOverflow.ellipsis,),
        subtitle: Text(widget.note.description, maxLines: 2, overflow: TextOverflow.ellipsis,),
        trailing: Text(formatDate(widget.note.createdAt)),
      ),
    );
  }

  Widget LongPressActions() {
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
              shareToDo();
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red,),
            title: const Text("Delete"),
            onTap: () {
              controller.deleteToDo(context, widget.note.id);
            },
          ),
        ],
      ),
    );
  }
}
