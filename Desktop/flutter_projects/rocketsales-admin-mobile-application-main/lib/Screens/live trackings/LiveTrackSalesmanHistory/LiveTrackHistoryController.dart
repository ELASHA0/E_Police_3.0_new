import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rocketsales_admin/Screens/live%20trackings/FiltrationSystemLiveTrack.dart';

import '../../../TokenManager.dart';
import '../../../resources/my_colors.dart';
import 'SalesmanLiveTrackHistoryModel.dart';

class LiveTrackHistoryController extends GetxController {
  var isLoading = true.obs;
  final RxList<SalesmanLiveTrackHistoryModel> salesmanLiveTrackHistory = <SalesmanLiveTrackHistoryModel>[].obs;
  GoogleMapController? mapController;
  final dateTimeFilter = ''.obs;

  final RxList<LatLng> allCoordinates = <LatLng>[].obs;
  final RxList<LatLng> polylineCoordinates = <LatLng>[].obs;

  var isPlaying = false.obs;
  var currentIndex = 0.obs;
  Timer? _playbackTimer;
  var playbackSpeed = 1.0.obs;
  final salesmanId = "".obs;

  final Rx<LatLng?> currentMarkerPosition = Rx<LatLng?>(null);

  final RxString currentTime = ''.obs;
  final RxString currentBatteryPercentage = ''.obs;


  //For filtration system

  Rxn<DateTime?> fromDate = Rxn<DateTime?>();
  Rxn<DateTime?> tillDate = Rxn<DateTime?>();

  Rxn<TimeOfDay?> fromTime = Rxn<TimeOfDay?>();
  Rxn<TimeOfDay?> tillTime = Rxn<TimeOfDay?>();

  // Rxn<DateTime> toDate = Rxn<DateTime>();

  DateTime today = DateTime.now();

  // Rxn<TimeOfDay> selectedTime = Rxn<TimeOfDay>(TimeOfDay.now());

  TimeOfDay twelveAM = const TimeOfDay(hour: 00, minute: 00);

  @override
  void onInit() {
    fromDate.value = today.subtract(const Duration(days: 1));
    fromTime.value = twelveAM;
    tillDate.value = today;
    tillTime.value = twelveAM;
    salesmanLiveTrackHistory.clear();
    allCoordinates.clear();
    polylineCoordinates.clear();
    super.onInit();
  }

  String formatTimeOfDayFull(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return "$hour:$minute:00.000";
  }

  String formatTimeOfDay(BuildContext context, TimeOfDay time) {
    return time.format(context); // returns something like "1:45 PM"
  }

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      // initialDate: fromDate ?? DateTime.now(),
      initialDate: fromDate.value ?? today.subtract(const Duration(days: 1)),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: MyColor.dashbord,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      fromDate.value = picked;
    }
  }

  Future<void> _selectTillDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      // initialDate: fromDate ?? DateTime.now(),
      initialDate: tillDate.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: MyColor.dashbord,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      tillDate.value = picked;
    }
  }

  Future<void> _selectFromTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: fromTime.value ?? const TimeOfDay(hour: 0, minute: 0),
    );
    if (picked != null) fromTime.value = picked;
  }

  Future<void> _selectTillTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: tillTime.value ?? TimeOfDay.now(),
    );
    if (picked != null) tillTime.value = picked;
  }

  DateTime combineDateTime(DateTime date, TimeOfDay? time) {
    final t = time ?? const TimeOfDay(hour: 0, minute: 0);
    // Keep it in local time — no .toUtc()
    return DateTime(
      date.year,
      date.month,
      date.day,
      t.hour,
      t.minute,
    );
  }

  String filterString(DateTime? fromDate, DateTime? tillDate, TimeOfDay? fromTime, TimeOfDay? tillTime) {
    if (fromDate == null || tillDate == null) return "";

    final fromDateTime = combineDateTime(fromDate, fromTime);
    final tillDateTime = combineDateTime(tillDate, tillTime);

    // ✅ Format as UTC-style ISO string but keep the same local values
    final fromIso = "${fromDateTime.toIso8601String()}Z";
    final tillIso = "${tillDateTime.toIso8601String()}Z";

    return "&fromDate=$fromIso&toDate=$tillIso";
  }

  Future<void> getLiveTrackHistory() async {
    isPlaying.value = false;
    currentIndex.value = 0;
    _playbackTimer = null;
    playbackSpeed.value = 1.0;
    mapController?.dispose();
    salesmanLiveTrackHistory.clear();
    allCoordinates.clear();
    polylineCoordinates.clear();
    isLoading.value = true;
    try {
      final token = await TokenManager.getToken();

      if (token == null || token.isEmpty) {
        Get.snackbar("Auth Error", "Token not found");
        return;
      }

      final url = Uri.parse(
          '${dotenv.env['BASE_URL']}/api/api/history/report?&salesmanId=${salesmanId.value}&query=${dateTimeFilter == "" ? "today" : "custom$dateTimeFilter"}');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("track history ========>>>>>>>> ${url}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> dataList = jsonData['data'];
        final salesmanLiveTrackHistoryList =
        dataList.map((item) => SalesmanLiveTrackHistoryModel.fromJson(item)).toList().reversed.toList();

        salesmanLiveTrackHistory.assignAll(salesmanLiveTrackHistoryList);

        allCoordinates.assignAll(
          salesmanLiveTrackHistoryList.map((track) => LatLng(track.latitude, track.longitude)),
        );

        if (allCoordinates.isNotEmpty) {
          currentMarkerPosition.value = allCoordinates.first;
          polylineCoordinates.assignAll([allCoordinates.first]);
        }
      } else {
        salesmanLiveTrackHistory.clear();
        Get.snackbar("Error", "Failed to connect (Code: ${response.statusCode})");
      }
    } catch (e) {
      Get.snackbar("Exception", "Couldn't get Track history");
    } finally {
      isLoading.value = false;
    }
  }

  void setMapController(GoogleMapController controller) {
    mapController = controller;
  }

  void playRoute() {
    if (allCoordinates.isEmpty || mapController == null) return;
    isPlaying.value = true;
    _playbackTimer?.cancel();

    Duration baseDuration = const Duration(seconds: 10);
    Duration adjustedDuration = Duration(
      milliseconds: (baseDuration.inMilliseconds / playbackSpeed.value).round(),
    );

    _playbackTimer = Timer.periodic(adjustedDuration, (timer) async {
      if (currentIndex.value >= allCoordinates.length - 1) {
        stopRoute();
        return;
      }

      LatLng start = allCoordinates[currentIndex.value];
      LatLng end = allCoordinates[currentIndex.value + 1];

      await _animateMarker(start, end, adjustedDuration);
      currentIndex.value++;

      // Update trailing of track
      polylineCoordinates.add(end);

      // 🕒 Update time label (correlate with the same index)
      if (currentIndex.value < salesmanLiveTrackHistory.length) {
        final timestamp = salesmanLiveTrackHistory[currentIndex.value].timestamp;
        currentTime.value = DateFormat('hh:mm a\ndd MMM').format(timestamp);
        currentBatteryPercentage.value = salesmanLiveTrackHistory[currentIndex.value].batteryLevel;
      }
    });
  }


  Future<void> _animateMarker(LatLng start, LatLng end, Duration duration) async {
    const int steps = 30;
    final double latDiff = (end.latitude - start.latitude) / steps;
    final double lngDiff = (end.longitude - start.longitude) / steps;

    for (int i = 0; i <= steps; i++) {
      if (!isPlaying.value) break;
      await Future.delayed(duration ~/ steps);
      final newPos = LatLng(
        start.latitude + (latDiff * i),
        start.longitude + (lngDiff * i),
      );
      currentMarkerPosition.value = newPos;
      update(); // <- forces GetX to rebuild if using GetBuilder
    }

  }

  void pauseRoute() {
    isPlaying.value = false;
    _playbackTimer?.cancel();
  }

  void stopRoute() {
    isPlaying.value = false;
    _playbackTimer?.cancel();
    currentIndex.value = 0;
    polylineCoordinates.clear();
    if (allCoordinates.isNotEmpty) {
      currentMarkerPosition.value = allCoordinates.first;
      polylineCoordinates.add(allCoordinates.first);
    }
  }

  void seekTo(int index) {
    if (allCoordinates.isEmpty || mapController == null) return;
    if (index < 0 || index >= allCoordinates.length) return;

    pauseRoute();

    currentIndex.value = index;
    polylineCoordinates.assignAll(allCoordinates.sublist(0, index + 1));

    final target = allCoordinates[index];
    currentMarkerPosition.value = target;

    // 🕒 update time for this point
    if (index < salesmanLiveTrackHistory.length) {
      final timestamp = salesmanLiveTrackHistory[index].timestamp;
      currentTime.value = DateFormat('hh:mm a\ndd MMM').format(timestamp);
      currentBatteryPercentage.value = salesmanLiveTrackHistory[index].batteryLevel;
    }

    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: target, zoom: 17)),
    );
  }


  void setPlaybackSpeed(double speed) {
    playbackSpeed.value = speed;
    if (isPlaying.value) {
      pauseRoute();
      playRoute();
    }
  }

  void showFiltrationSystemLiveTrack(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            "Enter Details",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: FiltrationSystem(context),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: MyColor.dashbord),
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: MyColor.dashbord,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                dateTimeFilter.value = filterString(fromDate.value, tillDate.value, fromTime.value, tillTime.value);
                Navigator.pop(context);
                getLiveTrackHistory();
              },
              child: const Text("Submit"),
            )
          ],
        );
      },
    );
  }

  Widget FiltrationSystem(BuildContext context) {
    final DateTime yesterday = today.subtract(const Duration(days: 1));
    return Obx(() {
      return Container(
        // margin: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                // From Date
                Expanded(
                  flex: 1,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      side: const BorderSide(color: Colors.black54),
                    ),
                    onPressed: () => _selectFromDate(context),
                    icon: const Icon(Icons.date_range, color: Colors.black),
                    label: Text(
                      fromDate.value != null
                          ? DateFormat('dd MMM').format(fromDate.value!)
                          : DateFormat('dd MMM').format(yesterday),
                      style: const TextStyle(color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 6),

                // From Time
                Expanded(
                  flex: 1,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      side: const BorderSide(color: Colors.black54),
                    ),
                    onPressed: () => _selectFromTime(context),
                    icon: const Icon(Icons.access_time, color: Colors.black),
                    label: Text(
                      fromTime.value != null
                          ? fromTime.value!.format(context)
                          : '12:00 AM',
                      style: const TextStyle(color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Icon(Icons.arrow_downward, size: 15),
            ),

            // --- TILL DATE & TIME ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Till Date
                Expanded(
                  flex: 1,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      side: const BorderSide(color: Colors.black54),
                    ),
                    onPressed: () => _selectTillDate(context),
                    icon: const Icon(Icons.date_range, color: Colors.black),
                    label: Text(
                      tillDate.value != null
                          ? DateFormat('dd MMM').format(tillDate.value!)
                          : DateFormat('dd MMM').format(today),
                      style: const TextStyle(color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 6),

                // Till Time
                Expanded(
                  flex: 1,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      side: const BorderSide(color: Colors.black54),
                    ),
                    onPressed: () => _selectTillTime(context),
                    icon: const Icon(Icons.access_time, color: Colors.black),
                    label: Text(
                      tillTime.value != null
                          ? tillTime.value!.format(context)
                          : '11:59 PM',
                      style: const TextStyle(color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

}
