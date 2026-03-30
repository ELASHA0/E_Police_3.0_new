import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rocketsales_admin/Screens/live%20trackings/LiveTrackController.dart';
import 'package:rocketsales_admin/Screens/live%20trackings/SalesmanLiveTrack.dart';
import 'package:rocketsales_admin/resources/my_colors.dart';
import 'package:share_plus/share_plus.dart';

import '../LiveTrackSalesmanHistory/LiveTrackHistoryController.dart';
import '../LiveTrackSalesmanHistory/LiveTrackHistoryScreen.dart';
import 'TrackSalesmanController.dart';

class MapsScreen extends StatefulWidget {
  final SalesmanLiveTrack salesman;
  const MapsScreen({super.key, required this.salesman});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {

  final TrackSalesmanController controller = Get.put(TrackSalesmanController());
  // final LiveTrackHistoryController trackHistoryController = Get.put(LiveTrackHistoryController());
  final LiveTrackController liveTrackController = Get.find<LiveTrackController>();

  Set<Marker> markers = {};

  BitmapDescriptor? salesmanIcon;

  bool _trafficEnabled = false;
  MapType _mapType = MapType.normal;

  @override
  void initState() {
    super.initState();
    print("MapsScreen salesman object = ${widget.salesman}");
    print("MapsScreen salesman id = ${widget.salesman.salesmanId}");
    print("MapsScreen salesman name = ${widget.salesman.salesmanName}");
    controller.initSocket(widget.salesman.salesmanId!);
    bitmapDescriptorFromIconData(Icons.person_pin_circle_sharp, color: MyColor.dashbord).then((icon) {
      setState(() {
        salesmanIcon = icon;
      });
    });
  }

  @override
  void dispose() {
    controller.mapController?.dispose();
    super.dispose();
  }

  Future<void> _shareLocation(double latitude, double longitude) async {
    try {
      final googleMapsUrl = "https://www.google.com/maps?q=$latitude,$longitude";

      SharePlus.instance.share(
          ShareParams(text: "Here’s ${widget.salesman.salesmanName}'s location: $googleMapsUrl")
      );
    } catch (e) {
      Get.snackbar("Error", "Could not fetch location: $e");
    }
  }

  Future<BitmapDescriptor> bitmapDescriptorFromIconData(
      IconData iconData, {
        Color color = Colors.blue,
        double size = 120,
      }) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    textPainter.text = TextSpan(
      text: String.fromCharCode(iconData.codePoint),
      style: TextStyle(
        fontSize: size,
        fontFamily: iconData.fontFamily,
        package: iconData.fontPackage,
        color: color,
      ),
    );

    textPainter.layout();
    textPainter.paint(canvas, Offset.zero);

    final picture = pictureRecorder.endRecording();
    final img = await picture.toImage(
      textPainter.width.toInt(),
      textPainter.height.toInt(),
    );
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Live track"),
        backgroundColor: MyColor.dashbord,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          (widget.salesman.latitude != null && widget.salesman.longitude != null)
              ?
          Obx(() =>
              Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(widget.salesman.latitude!, widget.salesman.longitude!),
                      zoom: 17,
                    ),
                    markers: {
                      Marker(
                        icon: salesmanIcon ?? BitmapDescriptor.defaultMarker,
                        markerId: const MarkerId("salesman"),
                        position: controller.polylineCoordinates.isNotEmpty
                            ? controller.polylineCoordinates.last
                            : LatLng(widget.salesman.latitude!, widget.salesman.longitude!),
                        infoWindow: InfoWindow(title: widget.salesman.salesmanName),
                      )
                    },
                    polylines: {
                      Polyline(
                        polylineId: const PolylineId("route"),
                        points: controller.polylineCoordinates.toList(),
                        color: Colors.blue,
                        width: 5,
                      ),
                    },
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    zoomControlsEnabled: true,
                    tiltGesturesEnabled: false,
                    trafficEnabled: _trafficEnabled,
                    mapType: _mapType,
                    onMapCreated: controller.setMapController,
                  ),
                  Positioned(
                    top: 65,
                    right: 10,
                    child: Column(
                      children: [
                        _mapButton(
                          icon: Icons.traffic,
                          active: _trafficEnabled,
                          onTap: () {
                            setState(() {
                              _trafficEnabled = !_trafficEnabled;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        _mapButton(
                          icon: Icons.satellite_alt,
                          active: _mapType == MapType.satellite,
                          onTap: () {
                            setState(() {
                              _mapType = _mapType == MapType.normal
                                  ? MapType.satellite
                                  : MapType.normal;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        _mapButton(
                          icon: Icons.share,
                          active: false,
                          onTap: () async {
                            if (controller.polylineCoordinates.isNotEmpty) {
                              await _shareLocation(
                                controller.polylineCoordinates.last.latitude,
                                controller.polylineCoordinates.last.longitude,
                              );
                            } else {
                              await _shareLocation(
                                widget.salesman.latitude!,
                                widget.salesman.longitude!,
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        _mapButton(
                          icon: Icons.history,
                          active: false,
                          onTap: () {
                            Get.to(LiveTrackHistoryScreen(salesman: widget.salesman));
                          }
                        ),
                      ],
                    ),
                  ),
                ]
              )
          ) : const Center(
            child: Text(
              "Location not available",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mapButton({
    required IconData icon,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: active ? MyColor.dashbord : Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Icon(
          icon,
          color: active ? Colors.white : MyColor.dashbord,
          size: 24,
        ),
      ),
    );
  }
}
