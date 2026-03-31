import 'package:epolicemarch/Screens/Model/PoliceStationModel.dart';
import 'package:epolicemarch/Screens/Model/SdpoModel.dart';
import 'package:epolicemarch/Screens/Model/StateModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../resources/AppAssets.dart';
import 'Model/CitiesModel.dart';
import 'Model/DistrictModel.dart';
import 'RegistrationController.dart';

class AddressInfoScreen extends StatelessWidget {
  final RegistrationController controller = Get.find();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  AddressInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Address Details"),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Logo
              Center(child: Image(image: ePoliceLogo, height: 120)),

              const SizedBox(height: 30),
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Select State",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => DropdownButtonFormField<StateModel>(
                        value: controller.selectedState.value,
                        onChanged: (v) {
                          controller.selectedState.value = v!;
                          controller.getDistricts(v.id);
                        },
                        validator: (v) => controller.validateDropdown(
                          v?.state_name_en ?? "",
                          "State",
                        ),
                        items: controller.states
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.state_name_en ?? ""),
                              ),
                            )
                            .toList(),
                        decoration: const InputDecoration(
                          hintText: "Select Your State",
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ),

                    const Text(
                      "Select District",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    Obx(
                      () => DropdownButtonFormField<DistrictModel>(
                        value: controller.selectedDistrict.value,
                        items: controller.districts
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.districtName ?? ''),
                              ),
                            )
                            .toList(),
                        onChanged: (v) {
                          controller.selectedDistrict.value = v!;
                          controller.getSdpo(v.id);
                          controller.getCity(controller.selectedDistrict.value?.id);
                          controller.getStationId(controller.selectedDistrict.value?.id);

                          // controller.getCity(v.id);
                        },
                        validator: (v) => controller.validateDropdown(
                          v?.districtName ?? "",
                          "District",
                        ),
                        decoration: const InputDecoration(
                          hintText: "Select Your District",
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ),

                    const Text(
                      "Select SDPO",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    Obx(
                      () => DropdownButtonFormField<SdpoModel>(
                        value: controller.selectedSdpo.value,
                        items: controller.sdpo
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.name ?? ''),
                              ),
                            )
                            .toList(),
                        onChanged: (v) {
                          controller.selectedSdpo.value = v!;

                        },
                        validator: (v) =>
                            controller.validateDropdown(v?.name ?? "", "SDPO"),
                        decoration: const InputDecoration(
                          hintText: "Select Your Spdo",
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),
                    const Text(
                      "Select City",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Obx(
                          () => DropdownButtonFormField<CityModel>(
                        value: controller.selectedCity.value,
                        items: controller.cities
                            .map(
                              (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e.cityName ?? ''),
                          ),
                        )
                            .toList(),
                        onChanged: (v) {
                          controller.selectedCity.value = v!;
                         // controller.getStationId(v.id);
                        },
                        validator: (v) =>
                            controller.validateDropdown(v?.cityName ?? "", "Cities"),
                        decoration: const InputDecoration(
                          hintText: "Select Your Cities",
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Select Station_Id",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Obx(
                          () => DropdownButtonFormField<PoliceStationModel>(
                        value: controller.selectedStaion.value,
                        items: controller.station
                            .map(
                              (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e.name ?? ''),
                          ),
                        )
                            .toList(),
                        onChanged: (v) {
                          controller.selectedStaion.value = v!;
                          // controller.getStates();
                        },
                        validator: (v) =>
                            controller.validateDropdown(v?.name ?? "", "Cities"),
                        decoration: const InputDecoration(
                          hintText: "Select Your Cities",
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFE06234),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {},
                          child: const Text(
                            "Next",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
