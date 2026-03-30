import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:intl/intl.dart';
import 'package:rocketsales_admin/Screens/live%20trackings/LiveTrackController.dart';

import '../../resources/my_colors.dart';

class FiltrationsystemLiveTrack extends StatefulWidget {
  const FiltrationsystemLiveTrack({super.key});

  @override
  State<FiltrationsystemLiveTrack> createState() => _FiltrationsystemLiveTrackState();
}

class _FiltrationsystemLiveTrackState extends State<FiltrationsystemLiveTrack> {

  final Debouncer _debouncer = Debouncer();

  final TextEditingController searchController = TextEditingController();

  final LiveTrackController controller = Get.find<LiveTrackController>();

  void _handleTextFieldChange(String value) {
    const duration = Duration(milliseconds: 500);
    _debouncer.debounce(
      duration: duration,
      onDebounce: () {
        controller.searchString.value = value;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
        child: Column(
          children: [
            Container(
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
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        print("show all clicked");
                        controller.selectedTag.value = "";
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, top: 2),
                      child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: MyColor.dashbord, // border color
                              width: 1, // border thickness
                            ),
                            color: controller.selectedTag.value == ""
                                ? MyColor.dashbord
                                : Colors.white,
                            borderRadius: BorderRadius.circular(
                                10), // optional: rounded corners
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 10, left: 20, right: 20),
                            child: Text(
                              "Show all",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: controller.selectedTag.value == ""
                                      ? Colors.white
                                      : MyColor.dashbord),
                            ),
                          )),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        print("online clicked");
                        controller.selectedTag.value = "Online";
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, top: 2),
                      child: Container(
                          decoration: BoxDecoration(
                            color: controller.selectedTag.value == "Online"
                                ? MyColor.dashbord
                                : Colors.green,
                            borderRadius: BorderRadius.circular(
                                10), // optional: rounded corners
                          ),
                          child: const Padding(
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 10, left: 20, right: 20),
                            child: Text(
                              "Online",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          )),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        print("offline clicked");
                        controller.selectedTag.value = "Offline";
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, top: 2),
                      child: Container(
                          decoration: BoxDecoration(
                            color: controller.selectedTag.value == "Offline"
                                ? MyColor.dashbord
                                : Colors.redAccent,
                            borderRadius: BorderRadius.circular(
                                10), // optional: rounded corners
                          ),
                          child: const Padding(
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 10, left: 20, right: 20),
                            child: Text(
                              "Offline",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          )),
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
