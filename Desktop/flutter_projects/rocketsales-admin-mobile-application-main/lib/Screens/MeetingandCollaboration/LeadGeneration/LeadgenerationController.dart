import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rocketsales_admin/Screens/SalesmanListScreen/SalesmanModel.dart';

import '../../../TokenManager.dart';
import 'leadScreen.dart';
import 'leadgenerationmodel.dart';

class LeadGenerationController extends GetxController {
  TextEditingController leadclientTitleController = TextEditingController();

  TextEditingController leadclientNameController = TextEditingController();
  TextEditingController leadclientEmailController = TextEditingController();
  TextEditingController leadclientPhoneController = TextEditingController();
  TextEditingController leadclientAddController = TextEditingController();
  TextEditingController leadshopNameController = TextEditingController();

  TextEditingController leadNotesController = TextEditingController();
  TextEditingController searchTextController = TextEditingController();


  String branchId = '';
  String companyId = '';
  String salesmanId = '';


  final RxList<LeadManagement> leadList = <LeadManagement>[].obs;
  final RxList<SalesmanModel> salesmanList = <SalesmanModel>[].obs;
  final RxString selectedsalesmanId = ''.obs;
  final RxBool isFetchingMore = false.obs;
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;
  final findString = ''.obs;
  final RxString choosenTag = "".obs;

  final dateTimeLeadFilter = ''.obs;

  RxInt page = 1.obs;
  RxBool moreCardsAvailable = false.obs;
   // i added this now
  final RxString selectedSalesmanName = "".obs;
  final RxBool isLoadingInDetails = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserIds();
    getLeads();
    getSalesman();
  }

  @override
  void onClose() {
    leadclientTitleController.dispose();
    leadclientNameController.dispose();
    leadclientEmailController.dispose();
    leadclientPhoneController.dispose();
    leadclientAddController.dispose();
    leadshopNameController.dispose();
    leadNotesController.dispose();

    super.onClose();
  }

  Future<void> loadUserIds() async {
    branchId = await TokenManager.getBranchId() ?? '';
    companyId = await TokenManager.getCompanyId() ?? '';
    salesmanId = await TokenManager.getSalesmanID() ?? '';


  }

  String formattedLeadDate(String? dateTimeStr) {
    DateTime dateTime = DateTime.parse(dateTimeStr!);
    return DateFormat('dd/MM/yy').format(dateTime);
  }

  String formattedLeadTime(String? dateTimeStr) {
    DateTime dateTime = DateTime.parse(dateTimeStr!);

    // Format to hh:mm a (12-hour format with AM/PM)
    return DateFormat('hh:mm a').format(dateTime);
  }

  // Function for drop down of slaes man


  Future<Map<String, String>> _getHeaders() async {
    final token = await TokenManager.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<void> getSalesman() async{
    isLoading .value = true;
    try{
      final headers = await  _getHeaders();
      final url = Uri.parse('${dotenv.env['BASE_URL']}/api/api/salesman?page=1&limit=10');
      print('url ======> $url') ;

      final response = await http.get(url,headers:headers);

      if(response.statusCode == 200 || response.statusCode == 201 ){
        final jsonData = json.decode(response.body);

        //   //jsonData['data'] →  [
        //         //                       { "_id": "699f47a8...", "leadTitle": "test led 36", ... },
        //         //                       { "_id": "699f2596...", "leadTitle": "test led 42", ... },
        //         //                       ...
        //         //                     ]
        print(jsonData);
        final List<dynamic> salesmanList = jsonData['data'];

        final leadSalesmenList = salesmanList.map((item)=> SalesmanModel.fromJson(item)).toList();
        salesmanList.assignAll(salesmanList);

        /*final jsonData = json.decode(response.body);
        final List<dynamic> rawList = jsonData['data'] ?? [];
        salesmanList.assignAll(
            rawList.map((item) => SalesmanModel.fromJson(item)).toList()
        );*/
        // 1.[
        //   { "_id": "699f47a8...", "leadTitle": "test led 36", "clientName": "Amit" },
        //   { "_id": "699f2596...", "leadTitle": "test led 42", "clientName": "smit" },
        // ]
        //  //2. .map((item) => ...)
        //         // item 1 → { "_id": "699f47a8...", "leadTitle": "test led 36" ... }
        //         // item 2 → { "_id": "699f2596...", "leadTitle": "test led 42" ... }
        //         // item 3 → { "_id": "699f2580...", "leadTitle": "test led 41" ... }
        //3.  leadSalesmen(
        //         //   id: "699f47a8...",
        //         //   leadTitle: "test led 36",
        //         //   clientName: "Amit",
        //         //   ...
        //         // )

        //  4. leadSalesmenList
        //fetchedLeads = [
        //   LeadManagement(id: "...", leadTitle: "test led 36", clientName: "Amit"),
        //   LeadManagement(id: "...", leadTitle: "test led 42", clientName: "smit"),
        // ] //



        // For dropDown
        // How to acess a single value
        // make a new varible  named SalesmenName =  "controllername". leadSalesmenList[index]; -> put this in the dropdown
        // final  Salesmancontrollerlead salesmenname=  Salesmancontrollerlead(),);
        // asign all gives new set of leads

        // pagination

      }
    }
    catch(e){
      print("error");
    }
    finally{
      isLoading.value = false;
    }
  }







  Future<void> getLeads() async {
    isLoading.value = true;
    moreCardsAvailable.value = false;
    page.value = 1;
    leadList.clear();

    try {
      final headers = await _getHeaders();

      final url = Uri.parse(
        '${dotenv
            .env['BASE_URL']}/api/api/leadGen?page=1&limit=10$dateTimeLeadFilter&search=${findString
            .value}&status=${choosenTag.value}',
      );
      print("url ======>>>>> $url");
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        //  jsonData['currentPage'] = 1 in the api
        // jsonData['hasNextPage'] = true in the api
        final int currentPage = jsonData['currentPage'] ?? 1;
        final bool hasNextPage = jsonData['hasNextPage'] ?? false;

        // not yet dart object
        //jsonData['data'] →  [
        //                       { "_id": "699f47a8...", "leadTitle": "test led 36", ... },
        //                       { "_id": "699f2596...", "leadTitle": "test led 42", ... },
        //                       ...
        //                     ]
        final List<dynamic> rawList = jsonData['data'] ?? [];

        // 1.[
        //   { "_id": "699f47a8...", "leadTitle": "test led 36", "clientName": "Amit" },
        //   { "_id": "699f2596...", "leadTitle": "test led 42", "clientName": "smit" },
        // ]
        //2. .map((item) => ...)
        // item 1 → { "_id": "699f47a8...", "leadTitle": "test led 36" ... }
        // item 2 → { "_id": "699f2596...", "leadTitle": "test led 42" ... }
        // item 3 → { "_id": "699f2580...", "leadTitle": "test led 41" ... }
        //3.  LeadManagement(
        //   id: "699f47a8...",
        //   leadTitle: "test led 36",
        //   clientName: "Amit",
        //   ...
        // ) 4.
        //fetchedLeads = [
        //   LeadManagement(id: "...", leadTitle: "test led 36", clientName: "Amit"),
        //   LeadManagement(id: "...", leadTitle: "test led 42", clientName: "smit"),
        // ]
        print("getLeads fetched: ${rawList.length} leads");
        final fetchedLeads = rawList
            .map((item) => LeadManagement.fromJson(item))
            .toList();
        // assignAll() = Erase everything on the whiteboard
        //               and write fresh new content
        print("first lead salesman: ${fetchedLeads.first.salesman?.salesmanName}");
        print("raw lead data: ${rawList.first}");
        leadList.assignAll(fetchedLeads);
        //// BEFORE assignAll
        // leadList = [
        //   LeadManagement(leadTitle: "old lead 1"),
        //   LeadManagement(leadTitle: "old lead 2"),
        //   LeadManagement(leadTitle: "old lead 3"),
        // ]
        //
        // leadList.assignAll(fetchedLeads);
        //
        // // AFTER assignAll
        // leadList = [
        //   LeadManagement(leadTitle: "test led 36"),
        //   LeadManagement(leadTitle: "test led 42"),
        //   LeadManagement(leadTitle: "test led 41"),
        //   ... fresh data from API
        // ]
        // ← Old data is completely gone ✓

        moreCardsAvailable.value = hasNextPage;

        if (moreCardsAvailable.value) {
          page.value = currentPage + 1;
        }
      } else {
        print("Failed to load leads (${response.statusCode})");
      }
    } catch (e) {
      print("getLeads Error => $e");
      print("Couldn't load leads");
    } finally {
      isLoading.value = false;
      //runs NO MATTER WHAT ← always
    }
  }

  Future<void> getMoreLeads() async {
    // security guard
    // should we even run this fuction or not
    if (isFetchingMore.value) return; // t
    if (!moreCardsAvailable.value) return; // f -  t

    isFetchingMore.value = true;
    //getMoreLeads() called 5 times
    // without secutiry

    try {
      final headers = await _getHeaders();

      final url = Uri.parse(
        '${dotenv.env['BASE_URL']}/api/api/leadGen?page=${page
            .value}&limit=10$dateTimeLeadFilter&search=${findString
            .value}&status=$choosenTag',
        // `
        // First load  → page.value = 1 → ?page=1
        // After scroll → page.value = 2 → ?page=2
        // After scroll → page.value = 3 → ?page=3
      );

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        final int currentPage = jsonData['currentPage'] ?? page.value;
        final bool hasNextPage = jsonData['hasNextPage'] ?? false;

        final List<dynamic> rawList = jsonData['data'] ?? [];

        if (rawList.isEmpty) {
          moreCardsAvailable.value = false;
          return;
        }

        final moreLeads = rawList
            .map((item) => LeadManagement.fromJson(item))
            .toList();

        leadList.addAll(moreLeads);
        // It appends the new leads to the end of the existing list without touching the data already there.

        moreCardsAvailable.value = hasNextPage;

        if (moreCardsAvailable.value) {
          page.value = currentPage + 1;
        }
      } else {
        print("Failed to load more (${response.statusCode})");
      }
    } catch (e) {
      print("getMoreLeads Error => $e");
      print("Couldn't load more leads");
    } finally {
      isFetchingMore.value = false;
    }
  }

  Future<void> createLead() async {
    print("=== createLead called ===");
    print("branchId: $branchId");
    print("companyId: $companyId");

    print("title: ${leadclientTitleController.text}");
    print("name: ${leadclientNameController.text}");
    try {
      isLoading.value = true;
      final token = await TokenManager.getToken();

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json', // ← JSON instead of multipart
      };

      final body = json.encode({
        'leadTitle': leadclientTitleController.text.trim(),
        'clientName': leadclientNameController.text.trim(),
        'clientEmail': leadclientEmailController.text.trim(),
        'clientPhone': leadclientPhoneController.text.trim(),
        'clientAdd': leadclientAddController.text.trim(),
        'shopName': leadshopNameController.text.trim(),
        'Notes': leadNotesController.text.trim(),
        'branchId': branchId,
        'companyId': companyId,
        if (selectedsalesmanId.value.isNotEmpty)
          'salesmanId': selectedsalesmanId.value,

      });

      // ← check what's being sent

      final response = await http.post(
        Uri.parse('${dotenv.env['BASE_URL']}/api/api/leadGen'),
        headers: headers,
        body: body,
      );

      print("status: ${response.statusCode}");
      print("body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        clearFields();
        getLeads();
        Get.back();
      } else {
        print("Error: ${response.body}");
      }
    } catch (e) {
      print("createLead Error => $e");
    } finally {
      isLoading.value = false;
    }
  }

  void clearFields() {
    leadclientTitleController.clear(); // ← was missing
    leadclientNameController.clear();
    leadclientEmailController.clear();
    leadclientPhoneController.clear();
    leadclientAddController.clear();
    leadshopNameController.clear();
    leadNotesController.clear();
    searchTextController.clear();
    selectedsalesmanId.value = '';
    findString.value = '';
    choosenTag.value = ''; // ← clear status filter
    dateTimeLeadFilter.value = '';
  }

  /* try {
      isLoading.value = true;

      final token = await TokenManager.getToken();

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final body = json.encode({
        'leadTitle'  : leadclientTitleController.text.trim(),
        'clientName' : leadclientNameController.text.trim(),
        'clientEmail': leadclientEmailController.text.trim(),
        'clientPhone': leadclientPhoneController.text.trim(),
        'clientAdd'  : leadclientAddController.text.trim(),
        'shopName'   : leadshopNameController.text.trim(),
        'Notes'      : leadNotesController.text.trim(),
        'branchId'   : branchId,
        'companyId'  : companyId,
        'salesmanId' : salesmanId,
      });

      print("Updating Lead ID: $leadId");
      print("Body: $body");

      final response = await http.put(
        Uri.parse('${dotenv.env['BASE_URL']}/api/api/leadGen/$leadId'),
        headers: headers,
        body: body,
      );

      print("updateLead status: ${response.statusCode}");
      print("updateLead body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        clearFields();
        await getLeads();
        Get.back();
        Get.snackbar("Success", "Lead updated successfully");
      } else {
        Get.snackbar("Error", "Update failed (${response.statusCode})");
      }

    } catch (e) {
      print("updateLead Error => $e");
      Get.snackbar("Exception", "Something went wrong");
    } finally {
      isLoading.value = false;
    }*/

  Future<void> updateLead(String leadId) async {
    try {
      print("Updating Lead ID: $leadId");

      isLoading.value = true;

      final token = await TokenManager.getToken();
      print("Token: $token");

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final body = json.encode({
        'leadTitle': leadclientTitleController.text.trim(),
        'clientName': leadclientNameController.text.trim(),
        'clientEmail': leadclientEmailController.text.trim(),
        'clientPhone': leadclientPhoneController.text.trim(),
        'clientAdd': leadclientAddController.text.trim(),
        'shopName': leadshopNameController.text.trim(),
        'Notes': leadNotesController.text.trim(),
        'branchId': branchId,
        'companyId': companyId,
        if (selectedsalesmanId.value.isNotEmpty)
          'salesmanId': selectedsalesmanId.value,
      });

      final response = await http.put(
        Uri.parse('${dotenv.env['BASE_URL']}/api/api/leadGen/$leadId'),
        headers: headers,
        body: body,
      );
      print("URL: ======> ${response}");

      print("updateLead status: ${response.statusCode}");
      print("updateLead body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("=== update success ===");
        await getLeads();
        Get.back();
      } else {
        print("Error");
      }
    } catch (e) {
      print("updateLead Error => $e");
      print("Exception");
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> deleteLead(String leadId) async {
    try {
      print("Deleteing Lead ID: $leadId");

      final token = await TokenManager.getToken();
      print("Token: $token");

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final response = await http.delete(
        Uri.parse('${dotenv.env['BASE_URL']}/api/api/leadGen/$leadId'),
        headers: headers,
      );
      print("URL: ======> ${response}");

      print("DeletedLead status: ${response.statusCode}");
      print("DeletedLead body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("=== Delete success ===");
        await getLeads();
        //Get.back(result: LeadGenerationScreen());
        Get.back();
        Get.back();
      } else {
        print("Error");
      }
    } catch (e) {
      print("DeleteLead Error => $e");
      print("Exception");
    } finally {
      isLoading.value = false;
    }
  }

}