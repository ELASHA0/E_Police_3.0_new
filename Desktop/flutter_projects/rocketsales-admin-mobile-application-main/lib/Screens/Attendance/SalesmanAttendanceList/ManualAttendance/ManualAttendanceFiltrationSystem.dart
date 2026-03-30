import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:intl/intl.dart';

import '../../../../resources/my_colors.dart';
import 'ManualAttendanceController.dart';

class ManualAttendanceFiltrationSystem extends StatefulWidget {
  const ManualAttendanceFiltrationSystem({super.key});

  @override
  State<ManualAttendanceFiltrationSystem> createState() => _ManualAttendanceFiltrationSystemState();
}

class _ManualAttendanceFiltrationSystemState extends State<ManualAttendanceFiltrationSystem> {

  final Debouncer _debouncer = Debouncer();

  final TextEditingController searchController = TextEditingController();

  final ManualAttendanceController controller = Get.find();

  void _handleTextFieldChange(String value) {
    const duration = Duration(milliseconds: 500);
    _debouncer.debounce(
      duration: duration,
      onDebounce: () {
        controller.searchString.value = value;
        controller.getManualAttendances();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 7, bottom: 7),
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
                hintText: 'Search Salesmen',
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
