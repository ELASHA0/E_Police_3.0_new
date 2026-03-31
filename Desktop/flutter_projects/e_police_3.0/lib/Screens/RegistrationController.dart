import 'dart:convert';

import 'package:epolicemarch/Screens/Model/CountryModel.dart';
import 'package:epolicemarch/Screens/Model/DistrictModel.dart';
import 'package:epolicemarch/Screens/Model/SdpoModel.dart';
import 'package:epolicemarch/Screens/Model/PoliceStationModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import '../UISnack_bar.dart';
import 'Model/CitiesModel.dart';
import 'Model/StateModel.dart';

class RegistrationController extends GetxController {
  final RxList<CountryModel> country = <CountryModel>[].obs;
  final RxList<StateModel> states = <StateModel>[].obs;
  final RxList<DistrictModel> districts = <DistrictModel>[].obs;
  final RxList<SdpoModel> sdpo = <SdpoModel>[].obs;
  final RxList< CityModel> cities= <CityModel>[].obs;
  final RxList< PoliceStationModel> station= <PoliceStationModel>[].obs;





  Rxn<StateModel> selectedState = Rxn();
  Rxn<CountryModel> selectedCountry = Rxn();
  Rxn<DistrictModel> selectedDistrict = Rxn();
  Rxn<SdpoModel> selectedSdpo = Rxn();
  Rxn<CityModel> selectedCity= Rxn();
  Rxn<PoliceStationModel> selectedStaion= Rxn();



  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var gender = ''.obs;

  void clearFields() {
    nameController.clear();
    mobileController.clear();
    passwordController.clear();
    emailController.clear();
    formKey.currentState?.reset();
    gender.value = '';
  }

  String? validateName(String value) {
    // this removes all the white spaces
    if (value.trim().isEmpty) return "Name is required";
    if (value.trim().length < 3) return "Name must be at least 3 characters";
    return null;
  }

  String? validateMobile(String value) {
    if (value.isEmpty) return "Mobile number is required";
    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
      return "Enter a valid 10 digit number";
    }
    return null;
  }

  String? validateEmail(String value) {
    // this removes all the white spaces
    if (value.isEmpty) return "Email is required";
    if (!RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(value)) {
      return "Enter a valid Email- Id ";
    }
    return null;
  }

  bool validateFormPersonalDetails(GlobalKey<FormState> formKey) {
    final isValid = formKey.currentState?.validate() ?? false;
    if (gender.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select gender",
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    return isValid;
  }

  String? validateDropdown(String value, String label) {
    if (value.isEmpty) {
      return "$label is required";
    }
    return null;
  }

  bool validateFormAddressDetails(GlobalKey<FormState> key) {
    final valid = key.currentState!.validate();
    return valid;
  }

  Future<void> getStates() async {
    selectedState.value = null;
    selectedDistrict.value = null;
    selectedSdpo.value = null;
    states.clear();
    districts.clear();
    sdpo.clear();
    UIComponents.showLoading();
    const int countryId = 1;

    try {
      String url = "${dotenv.env['BASE_URL']}/common/states/1";
      print("URL: $url");
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      print("response =========>${response.body}");
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> dataList = jsonData['data'];
        final statesList = dataList
            .map((item) => StateModel.fromJson(item))
            .toList();
        states.assignAll(statesList);
      } else {
        print("Error: ${response.statusCode}");
        print("States loaded: ${states.length}");
      }
    } catch (e) {
      print("Exception: $e");
    } finally {
      Get.back();
    }
  }

  Future<void> getDistricts(int? StateId) async {
    districts.clear();
    sdpo.clear();
    selectedSdpo.value = null;
    selectedDistrict.value = null;
    UIComponents.showLoading();

    try {
      String url = "${dotenv.env['BASE_URL']}/common/districts/$StateId";
      print("URL: $url");
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      print("response =========>${response.body}");
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> dataList = jsonData['data'];
        final districtsList = dataList
            .map((item) => DistrictModel.fromJson(item))
            .toList();
        districts.assignAll(districtsList);
      } else {
        print("Error: ${response.statusCode}");
        print("States loaded: ${states.length}");
      }
    } catch (e) {
      print("Exception: $e");
    } finally {
      Get.back();
    }
  }

  Future<void> getSdpo(int? districtId) async {
    sdpo.clear();
    cities.clear();
    selectedCity.value = null;
    selectedSdpo.value = null;
    UIComponents.showLoading();
    try {
      String url = "${dotenv.env['BASE_URL']}//common/sdpo/$districtId";
      print("URL: $url");
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      print("response =========>${response.body}");
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> dataList = jsonData['data'];
        final sdpoList = dataList
            .map((item) => SdpoModel.fromJson(item))
            .toList();
        sdpo.assignAll(sdpoList);
      } else {
        print("Error: ${response.statusCode}");
        print("States loaded: ${states.length}");
      }
    } catch (e) {
      print("Exception: $e");
    } finally {
      Get.back();
    }
  }

  Future<void> getCity(int? districtId) async {

    cities.clear();
   // station.clear();
   // selectedStation.value = null;
    selectedCity.value = null;
    UIComponents.showLoading();
    try {
      String url = "${dotenv.env['BASE_URL']}//common/cities/$districtId";
      print("URL: $url");
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      print("response =========>${response.body}");
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> dataList = jsonData['data'];
        final cityList = dataList
            .map((item) => CityModel.fromJson(item))
            .toList();
        cities.assignAll(cityList);
      } else {
        print("Error: ${response.statusCode}");
        print("States loaded: ${states.length}");
      }
    } catch (e) {
      print("Exception: $e");
    } finally {
      Get.back();
    }
  }

  Future<void> getStationId(int? districtId) async {

    station.clear();
    //cities.clear();
    selectedStaion.value = null;
    //selectedSdpo.value = null;
    UIComponents.showLoading();
    try {
      String url = "${dotenv.env['BASE_URL']}//common/police-stations/$districtId";
      print("URL: $url");
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      print("response =========>${response.body}");
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> dataList = jsonData['data'];
        final StationList = dataList
            .map((item) => PoliceStationModel.fromJson(item))
            .toList();
        station.assignAll(StationList);
      } else {
        print("Error: ${response.statusCode}");
        print("States loaded: ${states.length}");
      }
    } catch (e) {
      print("Exception: $e");
    } finally {
      Get.back();
    }
  }
}
