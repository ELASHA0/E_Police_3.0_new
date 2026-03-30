import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rocketsales_admin/Screens/MeetingandCollaboration/LeadGeneration/DateFilterLeadGen.dart';

import 'package:rocketsales_admin/Screens/MeetingandCollaboration/LeadGeneration/LeadCard.dart';
import 'package:rocketsales_admin/Screens/MeetingandCollaboration/LeadGeneration/LeadgenerationController.dart';
import 'package:rocketsales_admin/Screens/MeetingandCollaboration/LeadGeneration/leadgenerationmodel.dart';
import 'package:rocketsales_admin/Screens/SalesmanListScreen/SalesmanListScreen.dart';
import 'package:rocketsales_admin/resources/my_colors.dart';

import '../../SalesmanListScreen/SalesmanListController.dart';
import 'CreateLead.dart';

class LeadGenerationScreen extends StatefulWidget {
 const  LeadGenerationScreen({super.key});

  @override
  State<LeadGenerationScreen> createState() => _LeadGenerationScreenState();
}

class _LeadGenerationScreenState extends State<LeadGenerationScreen> {
  final LeadGenerationController leadController = Get.put(
    LeadGenerationController(),
  );

  final SalesmanListController salesmanController = Get.put(SalesmanListController());



  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);


  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 300) {
      print('reached end');
      if (!leadController.isFetchingMore.value &&
          leadController.moreCardsAvailable.value) {
        //
        // ```moreCardsAvailable = true  → more pages exist, fetch ✓
        // true  && true  = true  ✓ → getMoreLeads() runs
        // true  && false = false ✗ → getMoreLeads() blocked
        // false && true  = false ✗ → getMoreLeads() blocked
        // false && false = false ✗ → getMoreLeads() blocked
        leadController.getMoreLeads();
        print('got more leads');
      } else {
        print('no more leads to fetch');
      }
    }
  }

  @override
  void dispose() {

    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Leads and Clients"),
          backgroundColor: const Color(0xFF1E4DB7),
          foregroundColor: Colors.white,
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () async  {
              leadController.clearFields();
              await Get.to(() => CreateEditLeadScreen());

            }, child: Icon(Icons.add),
        ),
              body:

              Container(child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 8, left: 8, right: 8),
                      child: Datefilterlead(),
                    ),

                    Expanded(
                      child: Obx(() {
                        if (leadController.isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(
                                color: MyColor.dashbord),
                          );
                        } else if (leadController.leadList.isEmpty) {
                          return const Center(child: Text("No Lead found."));
                        } else {
                          return RefreshIndicator(
                            backgroundColor: Colors.white,
                            color: MyColor.dashbord,
                            onRefresh: () async {
                              leadController.getLeads();
                            },

                            /*if (leadController.isLoading.value && leadController.leadList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }*/
                            child: ListView.builder(
                              controller: scrollController,

                              itemCount: leadController.leadList.length + 1,
                              itemBuilder: (context, index) {
                                if (index == leadController.leadList.length) {
                                  if (leadController.isFetchingMore.value) {
                                    return const Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 20),
                                      child: Center(
                                          child: CircularProgressIndicator()),
                                    );
                                  }

                                  if (!leadController.moreCardsAvailable
                                      .value) {
                                    return const Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Center(
                                        child: Text(
                                          "You've seen all leads ✓",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                    );
                                  }

                                  return const SizedBox.shrink();
                                }

                                final lead = leadController.leadList[index];
                                return LeadCard(lead: lead);
                              },
                            ),
                          );
                        }
                      }),
                    ),
                  ],
                ),
              ),
              )



        );

  }


  double getResponsiveFontSize(BuildContext context, double baseFontSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    const double referenceWidth = 375.0; // iPhone 8 width
    return baseFontSize * (screenWidth / referenceWidth);
  }
}
