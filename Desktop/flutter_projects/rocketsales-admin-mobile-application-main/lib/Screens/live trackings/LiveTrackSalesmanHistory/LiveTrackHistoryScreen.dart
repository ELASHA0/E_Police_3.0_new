import 'dart:ffi';
import 'dart:ui' as ui;

import 'package:based_battery_indicator/based_battery_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../../resources/my_colors.dart';
import '../SalesmanLiveTrack.dart';
import 'LiveTrackHistoryController.dart';

class LiveTrackHistoryScreen extends StatefulWidget {
  final SalesmanLiveTrack salesman;
  const LiveTrackHistoryScreen({super.key, required this.salesman});

  @override
  State<LiveTrackHistoryScreen> createState() => _LiveTrackHistoryScreenState();
}

class _LiveTrackHistoryScreenState extends State<LiveTrackHistoryScreen> {

  final LiveTrackHistoryController controller = Get.put(LiveTrackHistoryController());

  Set<Marker> markers = {};

  BitmapDescriptor? salesmanIcon;

  bool _trafficEnabled = false;
  MapType _mapType = MapType.normal;

  @override
  void initState() {
    super.initState();
    controller.salesmanId.value = widget.salesman.salesmanId!;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.showFiltrationSystemLiveTrack(context);
    });
    // controller.getLiveTrackHistory(widget.salesman.salesmanId!);
    print("LiveTrackHistoryScreen salesman object = ${widget.salesman}");
    print("LiveTrackHistoryScreen salesman id = ${widget.salesman.salesmanId}");
    print("LiveTrackHistoryScreen salesman name = ${widget.salesman.salesmanName}");
    bitmapDescriptorFromIconData(Icons.person_pin_circle_sharp, color: MyColor.dashbord).then((icon) {
      setState(() {
        salesmanIcon = icon;
      });
    });
  }

  @override
  void dispose() {
    controller.mapController?.dispose();
    controller.salesmanLiveTrackHistory.clear();
    controller.allCoordinates.clear();
    controller.polylineCoordinates.clear();
    controller.mapController = null;
    controller.dispose();
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
        title: Text("Tracking history"),
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
                    controller.isLoading.value ? const Center(child: CircularProgressIndicator()) :
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(widget.salesman.latitude!, widget.salesman.longitude!),
                        zoom: 17,
                      ),
                      markers: {
                        if (controller.currentMarkerPosition.value != null)
                          Marker(
                            icon: salesmanIcon ?? BitmapDescriptor.defaultMarker,
                            markerId: const MarkerId("salesman"),
                            position: controller.currentMarkerPosition.value!,
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
                      myLocationEnabled: false,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      tiltGesturesEnabled: false,
                      trafficEnabled: _trafficEnabled,
                      mapType: _mapType,
                      onMapCreated: controller.setMapController,
                    ),
                    Positioned(
                      top: 0,
                      right: 10,
                      child: Column(
                        children: [
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
                            icon: Icons.tune,
                            active: false,
                            onTap: () {
                              controller.showFiltrationSystemLiveTrack(context);
                            },
                          ),
                        ],
                      ),
                    ),
                    controller.isLoading.value ? const Center(child: CircularProgressIndicator()) :
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        color: MyColor.dashbord,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // 🎛 Playback Buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(() => Text(
                                  controller.currentTime.value.isNotEmpty
                                      ? controller.currentTime.value
                                      : "--:--",
                                  style: const TextStyle(color: Colors.white, fontSize: 16),
                                )),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // IconButton(
                                    //   icon: const Icon(Icons.stop, color: Colors.white),
                                    //   onPressed: controller.stopRoute,
                                    // ),
                                    Obx(() => IconButton(
                                      icon: Icon(
                                        controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        controller.isPlaying.value
                                            ? controller.pauseRoute()
                                            : controller.playRoute();
                                      },
                                    )),
                                    // Obx(() => Text(
                                    //   "${controller.currentIndex.value}/${controller.allCoordinates.length}",
                                    //   style: const TextStyle(color: Colors.white),
                                    // )),
                                  ],
                                ),
                                Row(
                                  children: [
                                    BasedBatteryIndicator(
                                      status: BasedBatteryStatus(
                                        value: (double.tryParse(controller.currentBatteryPercentage.value) ?? 100).round(),
                                        type: (() {
                                          final battery = double.tryParse(controller.currentBatteryPercentage.value) ?? 100;
                                          if (battery > 70) return BasedBatteryStatusType.normal;
                                          if (battery > 30) return BasedBatteryStatusType.low;
                                          return BasedBatteryStatusType.error;
                                        })(),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text("${controller.currentBatteryPercentage.value}%", style: TextStyle(color: Colors.white),),
                                  ],
                                ),
                              ],
                            ),

                            // 🎚 Progress Slider
                            Obx(() {
                              final total = controller.allCoordinates.length;
                              if (total <= 1) return const SizedBox.shrink();

                              return Column(
                                children: [
                                  SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      thumbColor: Colors.white,
                                      activeTrackColor: Colors.blueAccent,
                                      inactiveTrackColor: Colors.white30,
                                    ),
                                    child: Slider(
                                      min: 0,
                                      max: (total - 1).toDouble(),
                                      value: controller.currentIndex.value
                                          .toDouble()
                                          .clamp(0, (total - 1).toDouble()),
                                      onChanged: (value) {
                                        controller.seekTo(value.toInt());
                                      },
                                    ),
                                  ),
                                  // 🕒 Playback speed buttons
                                  Obx(() => Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [1, 5, 10, 30, 50, 100].map((speed) {
                                      final isSelected = controller.playbackSpeed.value == speed.toDouble();
                                      return GestureDetector(
                                        onTap: () => controller.setPlaybackSpeed(speed.toDouble()),
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                                          padding:
                                          const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: isSelected ? Colors.white : Colors.white24,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            "${speed}X",
                                            style: TextStyle(
                                              color: isSelected ? MyColor.dashbord : Colors.white70,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  )),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ]
              )
          )
              : const Center(
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
