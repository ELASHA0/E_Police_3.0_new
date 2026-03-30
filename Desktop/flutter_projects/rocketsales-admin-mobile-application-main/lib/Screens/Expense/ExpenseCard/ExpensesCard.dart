import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../../../resources/my_colors.dart';
import '../ExpenseModel.dart';
import 'ExpenseCardController.dart';

class ExpenseCard extends StatefulWidget {
  final Expense expense;
  ExpenseCard({super.key, required this.expense});

  @override
  State<ExpenseCard> createState() => _ExpenseCardState();
}

class _ExpenseCardState extends State<ExpenseCard> {
  String formatDate(DateTime? date) {
    if (date == null) return "";
    return DateFormat('dd/MM/yyyy').format(date);
  }

  late String status;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    status = widget.expense.status ?? "";
  }

  final ExpenseCardController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, right: 20, left: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (status == "Approved")
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 16),
              child: statusTag(status, Color.fromRGBO(224, 247, 210, 1), Color.fromRGBO(37, 87, 9, 1), Icons.check_circle_outline),
            ),
          if (status == "Rejected")
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 16),
              child: statusTag(status, Color.fromRGBO(247, 210, 210, 1), Colors.red, Icons.close),
            ),
          if (status == "Pending")
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 16),
              child: statusTag(status, Colors.yellow, Colors.black54, Icons.pending_actions),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: double.infinity,
              padding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total Amount",
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    widget.expense.amount ?? "",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                ],
              ),
            ),
          ),

          /// --------- EXPAND FOR BUTTONS ONLY ----------
          ExpansionTile(
            shape: const Border(),
            collapsedShape: const Border(),
            // tilePadding: const EdgeInsets.symmetric(horizontal: 16),
            childrenPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.expense.expenceType ?? "",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),

                  ],
                ),

                const SizedBox(height: 12),
                Text("From: ${widget.expense.salesman?.salesmanName ?? ""}"),
                const SizedBox(height: 12),

                const Text("Description",
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(
                  widget.expense.expenceDescription ?? "",
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
              ],
            ),

            trailing: Text(
              formatDate(widget.expense.date),
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600),
            ),

            children: [
              if (status == "Pending") ...[
                statusChangeButton(context, Colors.red, "Reject", "Rejected"),
                statusChangeButton(context, Colors.green, "Approve", "Approved"),
              ],

              if (status == "Rejected") ...[
                statusChangeButton(context, Colors.green, "Approve", "Approved"),
              ],

              if (status == "Approved") ...[
                statusChangeButton(context, Colors.red, "Reject", "Rejected"),
              ],
            ]
          ),
        ],
      ),
    );
  }

  Widget statusChangeButton(
      BuildContext context, Color color, String buttonName, String newStatus) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 45),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          changeStatusDialogue(newStatus);
        },
        child: Text(
          buttonName,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget statusTag(String expenseStatus, Color backgroundColor, Color textColor, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor, // background color
        border: Border.all(
          color: textColor, // border color
          width: 1, // border thickness
        ),
        borderRadius:
        BorderRadius.circular(6), // optional: rounded corners
      ),
      child: Padding(
        padding: const EdgeInsets.only(
            top: 1, left: 8, right: 8, bottom: 1),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: textColor,
              size: 12,
            ),
            Text(
              expenseStatus,
              style: TextStyle(
                  color: textColor),
            ),
          ],
        ),
      ));
  }

  Future<String?> changeStatusDialogue(String newStatus) {
    return showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: const Text('Change expense status'),
          content:
          Text('Are you sure you want to mark this expense as $newStatus ?'),
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
                controller.toggleExpenseStatus(widget.expense.id ?? "", newStatus, context).then((_) {
                  setState(() {
                    status = newStatus;
                  });
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }).catchError((error) {
                  print("Error toggling status: $error");
                });
              },
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ));
  }
}
