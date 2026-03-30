import 'package:get/get.dart';
import 'package:rocketsales_admin/Screens/live%20trackings/SalesmanLiveTrack.dart';
import 'package:rocketsales_admin/Screens/live%20trackings/SocketServiceSalesmanTrack.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../TokenManager.dart';

class LiveTrackController extends GetxController {
  late IO.Socket socket;
  var salesmen = <SalesmanLiveTrack>[].obs;
  final isLoading = true.obs;
  late final SocketServiceSalesmanTrack socketService;
  final searchString = ''.obs;
  final RxString selectedTag = "".obs;
  var filteredSalesmen = <SalesmanLiveTrack>[].obs;

  @override
  void onInit() {
    initializeController();
    super.onInit();
  }

  @override
  void onClose() {
    print("🛑 Closing LiveTrackController, disconnecting socket...");
    socketService.dispose();
    super.onClose();
  }

  Future<void> initializeController() async {
    socketService = SocketServiceSalesmanTrack();
    await initSocket();

    ever(searchString, (_) => applyFilter());
    ever(salesmen, (_) => applyFilter());
    ever(selectedTag, (_) => applyFilter());
  }

  Future<void> initSocket() async {
    String? token = await TokenManager.getToken();
    socketService.connect(token!);

    isLoading.value = true; // start loading

    socketService.socket.onConnect((_) {
      socketService.authenticate(token);
    });

    socketService.onReceive((dataList) {
      print("before getting data");

      salesmen.clear();

      for (var item in dataList) {
        final salesman = SalesmanLiveTrack.fromJson(item);
        salesmen.add(salesman);
      }

      isLoading.value = false; // stop loading after data is received
    });
  }

  bool isOlderThan20Seconds(DateTime givenTime) {
    final now = DateTime.now();
    final difference = now.difference(givenTime).inSeconds;
    return difference >= 20;
  }

  void applyFilter() {
    if (searchString.value.isEmpty) {
      filteredSalesmen.value = salesmen.toList();
    } else {
      filteredSalesmen.value = salesmen
          .where((s) => s.salesmanName!.toLowerCase().contains(searchString.value.toLowerCase()))
          .toList();
    }
    if (selectedTag.value == "") {
      filteredSalesmen.value = salesmen.toList();
    } else if (selectedTag.value == "Online") {
      filteredSalesmen.value = salesmen
          .where((s) => s.timestamp != null && !isOlderThan20Seconds(s.timestamp!))
          .toList();
    } else if (selectedTag.value == "Offline") {
      filteredSalesmen.value = salesmen
          .where((s) => s.timestamp == null)
          .toList();
    }
  }
}