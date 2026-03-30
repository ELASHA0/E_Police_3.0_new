import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rocketsales_admin/Screens/live%20trackings/LiveTrackSalesman/SocketServiceSpecificSalesmanTrack.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../../TokenManager.dart';

class TrackSalesmanController extends GetxController {
  var isLoading = true.obs;
  late final SocketServiceSpecificSalesmanTrack socketService;
  final RxList<LatLng> polylineCoordinates = <LatLng>[].obs;
  GoogleMapController? mapController;

  @override
  void onInit() {
    socketService = SocketServiceSpecificSalesmanTrack();
    super.onInit();
  }

  @override
  void onClose() {
    print("🛑 Closing SocketServiceSpecificSalesmanTrackController, disconnecting socket...");
    socketService.dispose();
    super.onClose();
  }

  Future<void> initSocket(String salesmanId) async {
    String? token = await TokenManager.getToken();
    socketService.connect(token!);

    isLoading.value = true;

    print("salesman Id  =============>>>>>>>>>> $salesmanId");

    socketService.socket.onConnect((_) {
      print("🚀 Socket connected, now authenticating...");
      socketService.authenticate(token);
      socketService.requestSalesmanTracking(salesmanId);
    });

    socketService.onReceiveSalesmanSpecificData((salesmanData) {
      final LatLng newPosition = LatLng(
        salesmanData['latitude'],
        salesmanData['longitude'],
      );
      polylineCoordinates.add(newPosition);

      // Move map camera smoothly to new position
      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newLatLng(newPosition),
        );
      }
    });
  }

  void setMapController(GoogleMapController controller) {
    mapController = controller;
  }
}
