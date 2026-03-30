import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rocketsales_admin/Screens/AttendanceTrakingOfSalesman/AttendanceOverviewModel.dart';

import '../../TokenManager.dart';
import 'AttendanceTrakingModel.dart';

class AttendanceTrakController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool loading = false.obs;
  /// Original data from API
  RxList<SalesmanData> salesmans = <SalesmanData>[].obs;

  /// Filtered list for UI
  RxList<SalesmanData> filteredSalesmans = <SalesmanData>[].obs;
  int page = 1;
  int limit = 5; // initial page size
  RxBool isLoadingMore = false.obs;
  var selectedMonthYear = "Month".obs;       // reactive value
  Rxn<AttendanceOverviewModel> attendanceData = Rxn<AttendanceOverviewModel>();



  @override
  void onInit() {
    fetchSalesman();
    super.onInit();
    // setDate(DateTime.now());
  }

  Future<void> fetchSalesman({bool loadMore = false}) async {
    try {
      if (loadMore) {
        isLoadingMore.value = true;
      } else {
        isLoading.value = true;
        page = 1;
        salesmans.clear();
        filteredSalesmans.clear();
      }

      final token = await TokenManager.getToken();
      final supervisorId = await TokenManager.getSupervisorId();
      final companyId = await TokenManager.getCompanyId();
      final branchId = await TokenManager.getBranchId();

      final url =
          "${dotenv.env['BASE_URL']}/api/api/salesman"
          "?page=$page&limit=$limit&supervisorId=$supervisorId&companyId=$companyId&branchId=$branchId";

      var response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        SalesmanResponse model = SalesmanResponse.fromJson(jsonData);

        // Add NEW data to existing list
        salesmans.addAll(model.data ?? []);
        filteredSalesmans.assignAll(salesmans);

        // Next fetch will request more
        page++;
      } else {
        print("API Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching salesman: $e");
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  /// Search filter
  void filterSearch(String query) {
    if (query.isEmpty) {
      filteredSalesmans.assignAll(salesmans);
    } else {
      filteredSalesmans.assignAll(
        salesmans.where(
              (item) => (item.salesmanName ?? "")
              .toLowerCase()
              .contains(query.toLowerCase()),
        ),
      );
    }
  }

  void setDate(DateTime date) {
    final formatted = "${date.year}-${date.month.toString().padLeft(2, '0')}";
    selectedMonthYear.value = formatted;
  }

  Future<void> getAttendanceOverview(String monthYear, String Id) async{
    loading.value = true;
    attendanceData.value = null;

    try{
       final token = await TokenManager.getToken();
       final id = Id;
       final url = Uri.parse('${dotenv.env['BASE_URL']}/api/api/attendanceTrack/$id?monthYear=$monthYear');
       final response = await http.get(
         url,
         headers: {
           'Content-Type': 'application/json',
           'Authorization': 'Bearer $token',
         },
       );

       if (response.statusCode == 200) {
         final jsonMap = json.decode(response.body);

         attendanceData.value = AttendanceOverviewModel.fromJson(jsonMap);
         // loading.value = false;
         print("this is attendance data: ${response.body} & ${monthYear} ${response.statusCode}");
       } else {
         attendanceData.value = null;
         print("here issue ${response.body} & ${monthYear} ${response.statusCode}");
       }

     }catch (e){
       print("This is error of attendance tracking api: $e");
     } finally{
       loading.value = false;
     }
  }


}
