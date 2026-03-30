import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rocketsales_admin/Screens/Workpad/ToDos/ToDoAddEditScreen.dart';
import 'package:rocketsales_admin/Screens/Workpad/ToDos/ToDoCard.dart';

import '../../../resources/my_colors.dart';
import 'FiltrationSystemToDos.dart';
import 'ToDosController.dart';

class ToDosScreen extends StatefulWidget {
  const ToDosScreen({super.key});

  @override
  State<ToDosScreen> createState() => _ToDosScreenState();
}

class _ToDosScreenState extends State<ToDosScreen> {
  final ToDosController controller = Get.find<ToDosController>();

  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        print('reached end');
        controller.isMoreCardsAvailable.value = true;
        controller.getMoreToDoCards();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    Get.delete<ToDosController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(ToDoAddEditScreen());
        },
        backgroundColor: MyColor.dashbord,
        foregroundColor: Colors.white,
        child: const Icon(Icons.edit),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8, left: 8, right: 8),
              child: FiltrationSystemToDo(),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                      child: CircularProgressIndicator(
                        color: MyColor.dashbord,
                      ));
                } else if (controller.todos.isEmpty) {
                  return const Center(child: Text("No Notes found."));
                } else {
                  return RefreshIndicator(
                    backgroundColor: Colors.white,
                    color: MyColor.dashbord,
                    onRefresh: () async {
                      controller.getToDos();
                    },
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: scrollController,
                      itemCount: controller.todos.length + 1,
                      itemBuilder: (context, index) {
                        if (index < controller.todos.length) {
                          final note = controller.todos[index];
                          return Dismissible(
                            key: Key(note.id),
                            direction: DismissDirection.endToStart, // swipe left only
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              color: Colors.redAccent,
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            confirmDismiss: (direction) async {
                              final confirm = await Get.dialog(
                                AlertDialog(
                                  title: const Text("Delete Note"),
                                  content: const Text("Are you sure you want to delete this note?"),
                                  actions: [
                                    TextButton(onPressed: () => Get.back(result: false), child: const Text("Cancel")),
                                    TextButton(onPressed: () => Get.back(result: true), child: const Text("Delete")),
                                  ],
                                ),
                              );
                              return confirm ?? false;
                            },
                            onDismissed: (direction) async {
                              await controller.deleteToDo(context, note.id);
                              Get.snackbar("Deleted", "Note deleted successfully");
                            },
                            child: ToDoCard(note: note),
                          );
                        } else {
                          if (controller.isMoreCardsAvailable.value) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 32),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: MyColor.dashbord,
                                ),
                              ),
                            );
                          } else {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Center(child: Text('')),
                            );
                          }
                        }
                      },
                    ),
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
