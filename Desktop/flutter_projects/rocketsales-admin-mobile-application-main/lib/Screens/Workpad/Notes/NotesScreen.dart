import 'package:flutter/material.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../resources/my_colors.dart';
import 'NoteAddEditScreen.dart';
import 'NoteCard.dart';
import 'NotesController.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final NotesController controller = Get.find<NotesController>();

  final scrollController = ScrollController();
  final Debouncer _debouncer = Debouncer();

  final TextEditingController searchController = TextEditingController();

  void _handleTextFieldChange(String value) {
    const duration = Duration(milliseconds: 500);
    _debouncer.debounce(
      duration: duration,
      onDebounce: () {
        controller.searchString.value = value;
        controller.getNotes();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        print('reached end');
        controller.isMoreCardsAvailable.value = true;
        controller.getMoreNotesCards();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    Get.delete<NotesController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(NoteAddEditScreen());
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
              child: SearchNotes(),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                      child: CircularProgressIndicator(
                        color: MyColor.dashbord,
                      ));
                } else if (controller.notes.isEmpty) {
                  return const Center(child: Text("No Notes found."));
                } else {
                  return RefreshIndicator(
                    backgroundColor: Colors.white,
                    color: MyColor.dashbord,
                    onRefresh: () async {
                      controller.getNotes();
                    },
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: scrollController,
                      itemCount: controller.notes.length + 1,
                      itemBuilder: (context, index) {
                        if (index < controller.notes.length) {
                          final note = controller.notes[index];
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
                              await controller.deleteNote(context, note.id);
                              Get.snackbar("Deleted", "Note deleted successfully");
                            },
                            child: NoteCard(note: note),
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

  Widget SearchNotes() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        // color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black54)),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: _handleTextFieldChange,
              decoration: const InputDecoration(
                hintText: 'Search Notes',
                border: InputBorder.none,
              ),
            ),
          ),
          const Icon(Icons.search),
        ],
      ),
    );
  }
}
