import 'package:flutter/material.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rocketsales_admin/Screens/SalesmanListScreen/SalesmanListController.dart';

class SearchSalesmanList extends StatefulWidget {
  SearchSalesmanList({super.key});

  @override
  State<SearchSalesmanList> createState() => _SearchSalesmanListState();
}

class _SearchSalesmanListState extends State<SearchSalesmanList> {
  final Debouncer _debouncer = Debouncer();

  final TextEditingController searchController = TextEditingController();

  final SalesmanListController controller = Get.find<SalesmanListController>();

  void _handleTextFieldChange(String value) {
    const duration = Duration(milliseconds: 500);
    _debouncer.debounce(
      duration: duration,
      onDebounce: () {
        controller.searchString.value = value;
        controller.getSalesmen();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
