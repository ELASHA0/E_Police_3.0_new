import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:rocketsales_admin/Screens/AdminDashboard/RaiseTicket/FiltrationSystemRaiseTicket.dart';
import 'package:rocketsales_admin/Screens/AdminDashboard/RaiseTicket/RaiseTicketController.dart';

import '../../../resources/my_colors.dart';
import 'TicketCard.dart';

class TicketHistoryScreen extends StatefulWidget {
  const TicketHistoryScreen({super.key});

  @override
  State<TicketHistoryScreen> createState() => _TicketHistoryScreenState();
}

class _TicketHistoryScreenState extends State<TicketHistoryScreen> {
  final RaiseTicketController controller = Get.put(RaiseTicketController());

  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        print('reached end');
        controller.isMoreCardsAvailable.value = true;
        controller.getMoreTicketsCards();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    Get.delete<RaiseTicketController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.dashbord,
        foregroundColor: Colors.white,
        title: const Text('Raise Ticket'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // controller.createNewQR(context);
          await controller.getTicketTypes();
          await controller.createNewTicket(context);
        },
        icon: const Icon(Icons.add),
        label: const Text('Raise ticket'),
        backgroundColor: MyColor.dashbord,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8, left: 8, right: 8),
                    child: FiltrationsystemTickets(),
                  ),
                  Expanded(
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(
                            child: CircularProgressIndicator(
                              color: MyColor.dashbord,
                            ));
                      } else if (controller.tickets.isEmpty) {
                        return const Center(child: Text("No Tickets found."));
                      } else {
                        return RefreshIndicator(
                          backgroundColor: Colors.white,
                          color: MyColor.dashbord,
                          onRefresh: () async {
                            controller.getTickets();
                          },
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: controller.tickets.length + 1,
                            itemBuilder: (context, index) {
                              if (index < controller.tickets.length) {
                                final item = controller.tickets[index];
                                return TicketCard(
                                  ticket: item,
                                );
                              } else {
                                if (controller.isMoreCardsAvailable.value) {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 32),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: MyColor.dashbord,
                                      ),
                                    ),
                                  );
                                } else {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: Center(child: Text('')),
                                  );
                                }
                              }
                            },
                          ),
                        );
                      }
                    }),
                  ),
                ],
              ),
            ),
            if (controller.isLoadingTicketType.value)
              Positioned.fill(
                child: Container(
                  color: Color.fromRGBO(0, 0, 0, 0.35),
                  child: const Center(
                    child: CircularProgressIndicator(color: MyColor.dashbord),
                  ),
                ),
              ),
          ],
        );
      })

    );

  }
}
