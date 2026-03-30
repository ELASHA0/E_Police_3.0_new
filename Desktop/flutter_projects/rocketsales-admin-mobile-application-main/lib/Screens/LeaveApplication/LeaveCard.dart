import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get_connect/connect.dart';
import 'package:intl/intl.dart';

import '../../TokenManager.dart';
import '../../resources/my_colors.dart';
import 'LeaveModel.dart';

class LeaveCard extends StatefulWidget {
  Leave leave;
  LeaveCard({super.key, required this.leave});

  @override
  State<LeaveCard> createState() => _LeaveCardState();
}

class _LeaveCardState extends State<LeaveCard> {
  final ExpansibleController expansionController = ExpansibleController();
  bool _isExpanded = false;

  late String leaveStatus;

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  DateTime parseCustomDate(String dateString) {
    // Your API gives: "17-09-2025"
    return DateFormat("dd-MM-yyyy").parse(dateString);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    leaveStatus = widget.leave.status;
  }

  void showLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: const Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: MyColor.dashbord),
                SizedBox(width: 20),
                Text("Loading..."),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<String?> changeStatusDialogue(String status) {
    return showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: const Text('Change task status'),
          content:
          Text('Are you sure you want to mark this leave request as $status ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'No',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () async {
                showLoading();
                toggleLeaveStatus(widget.leave.id, status, context);
              },
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ));
  }

  Future<void> toggleLeaveStatus(
      String leaveId, String newStatus, BuildContext buildContext) async {
    print("leave request ======>>>>>>>> $leaveId");
    final url = '${dotenv.env['BASE_URL']}/api/api/leaverequest/$leaveId';

    final id = await TokenManager.getSupervisorId(); // Get user ID from token
    if (id == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('There was an error!'),
      ));
      Navigator.of(buildContext).pop();
      Navigator.of(buildContext).pop();
    }
    final token = await TokenManager.getToken(); // Get the full token

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('There was an error!'),
      ));
      Navigator.of(buildContext).pop();
      Navigator.of(buildContext).pop();
    }
    try {
      final response = await GetConnect().put(
        url,
        {
          'leaveRequestStatus': newStatus,
        },
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      // Debug: Print response status and body
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          leaveStatus = newStatus;
        });
        Navigator.of(buildContext).pop();
        Navigator.of(buildContext).pop();

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Leave marked as $newStatus'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('There was an error!'),
        ));
        Navigator.of(buildContext).pop();
        Navigator.of(buildContext).pop();
      }
    } catch (e) {
      print("Error updating status: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('There was an error!'),
      ));
      Navigator.of(buildContext).pop();
      Navigator.of(buildContext).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, right: 20, left: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(
          color: Colors.black12,
          width: 2,
        ),
      ),
      child: GestureDetector(
        onTap: () {
          if (expansionController.isExpanded) {
            expansionController.collapse();
          } else {
            expansionController.expand();
          }
        },
        child: ExpansionTile(
          shape: const Border(),
          collapsedShape: const Border(),
          tilePadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
          onExpansionChanged: (expanded) {
            setState(() {
              _isExpanded = expanded;
            });
          },
          controller: expansionController,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.leave.salesman?.salesmanName ?? "N/A",
                maxLines: _isExpanded ? 20 : 1,
                softWrap: _isExpanded,
                overflow: TextOverflow.fade,
                style: TextStyle(color: MyColor.dashbord),
              ),
              Text(
                widget.leave.reason,
                maxLines: _isExpanded ? 20 : 1,
                softWrap: _isExpanded,
                overflow: TextOverflow.fade,
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("From Date: ${formatDate(parseCustomDate(widget.leave.leaveStartdate))}"),
              Text("To Date: ${formatDate(parseCustomDate(widget.leave.leaveEnddate))}"),
            ],
          ),
          trailing: leaveStatus == "Approved"
              ? _statusBox(leaveStatus, Colors.green, const Color.fromRGBO(224, 247, 210, 1))
              : leaveStatus == "Pending"
              ? _statusBox(leaveStatus, Colors.black87, Colors.yellow, icon: Icons.pending_actions)
              : _statusBox(leaveStatus, Colors.red, const Color.fromRGBO(247, 210, 210, 1),
              icon: Icons.cancel_outlined),

          children: _isExpanded
              ? [
                leaveStatus == "Pending" ?
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton.icon(
                        onPressed: () {
                          changeStatusDialogue("Approved");
                        },
                        icon: const Icon(Icons.check, color: Colors.green,),
                        label: const Text("Approve"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(224, 247, 210, 1),
                          foregroundColor: Colors.green.shade900,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10), // Adjust radius as needed
                          ),
                          side: BorderSide(
                            color: Colors.green,
                            width: 2, // thickness of border
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton.icon(
                        onPressed: () {
                          changeStatusDialogue("Rejected");
                        },
                        icon: const Icon(Icons.close),
                        label: const Text("Reject"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(247, 210, 210, 1),
                          foregroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10), // Adjust radius as needed
                          ),
                          side: BorderSide(
                            color: Colors.red,
                            width: 2, // thickness of border
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ) : leaveStatus == "Approved" ?
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlinedButton.icon(
                      onPressed: () {
                        changeStatusDialogue("Rejected");
                      },
                      icon: const Icon(Icons.close),
                      label: const Text("Reject"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(247, 210, 210, 1),
                        foregroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // Adjust radius as needed
                        ),
                        side: BorderSide(
                          color: Colors.red,
                          width: 2, // thickness of border
                        ),
                      ),
                    ),
                  ),
                ) : SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlinedButton.icon(
                      onPressed: () {
                        changeStatusDialogue("Approved");
                      },
                      icon: const Icon(Icons.check, color: Colors.green,),
                      label: const Text("Approve"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(224, 247, 210, 1),
                        foregroundColor: Colors.green.shade900,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // Adjust radius as needed
                        ),
                        side: BorderSide(
                          color: Colors.green,
                          width: 2, // thickness of border
                        ),
                      ),
                    ),
                  ),
                ),
          ]
              : [],
        ),
      ),
    );
  }

  Widget _statusBox(String status, Color textColor, Color bgColor,
      {IconData icon = Icons.check_circle_outline}) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: textColor, width: 1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: textColor, size: 12),
            const SizedBox(width: 4),
            Text(status, style: TextStyle(color: textColor)),
          ],
        ),
      ),
    );
  }
}
