import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../resources/my_colors.dart';
import 'ToDoModel.dart';
import 'ToDosController.dart';

class ToDoAddEditScreen extends StatefulWidget {
  final ToDoModel? note;
  final bool isEdit;

  const ToDoAddEditScreen({
    super.key,
    this.note,
    this.isEdit = false,
  });

  @override
  State<ToDoAddEditScreen> createState() => _ToDoAddEditScreenState();
}

class _ToDoAddEditScreenState extends State<ToDoAddEditScreen> {
  final _formKey = GlobalKey<FormState>();

  final ToDosController controller = Get.find<ToDosController>();

  @override
  void initState() {
    super.initState();
    controller.titleController = TextEditingController(text: widget.note?.title ?? '');
    controller.bodyController = TextEditingController(text: widget.note?.description ?? '');
  }

  @override
  void dispose() {
    controller.titleController.dispose();
    controller.bodyController.dispose();
    super.dispose();
  }

  void _saveNote() {
    if (widget.isEdit) {
      controller.updateTodo(context, widget.note!.id, widget.note!.status);
    } else {
      controller.uploadTodo(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: MyColor.dashbord,
        foregroundColor: Colors.white,
        title: Text(widget.isEdit ? "Edit Note" : "New Note"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Field
              TextFormField(
                controller: controller.titleController,
                decoration: InputDecoration(
                  labelText: "Title",
                  // border: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(8),
                  // ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Title is required";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              Expanded(
                child: TextFormField(
                  controller: controller.bodyController,
                  decoration: const InputDecoration(
                    labelText: "Body",
                    alignLabelWithHint: true,
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Body is required";
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
