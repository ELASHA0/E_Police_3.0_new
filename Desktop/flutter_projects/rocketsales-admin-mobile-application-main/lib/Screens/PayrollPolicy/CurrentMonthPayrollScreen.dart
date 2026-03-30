import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:rocketsales_admin/Screens/PayrollPolicy/PayRollController.dart';
import '../../resources/my_colors.dart';
import 'CurrentMonthPayrollController.dart';
import 'FdfControllerOfCurrentPayroll.dart';
import 'MonthPayrollDetailScreen.dart';
import 'PayRollController.dart';

class Currentmonthpayrollscreen extends StatefulWidget {
  final String id;
  final String branchId;

  const Currentmonthpayrollscreen({
    super.key,
    required this.id,
    required this.branchId,
  });

  @override
  State<Currentmonthpayrollscreen> createState() =>
      _CurrentmonthpayrollscreenState();
}

class _CurrentmonthpayrollscreenState extends State<Currentmonthpayrollscreen> {
  final CurrentMonthPayrollController payRollController = Get.put(
    CurrentMonthPayrollController(),
  );
  final FdfControllerOfCurrentPayRoll fdfController = Get.put(FdfControllerOfCurrentPayRoll());

  @override
  void initState() {
    super.initState();
    payRollController.getPayrollOfWorkingDay(widget.id, widget.branchId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: MyColor.dashbord,
        title: const Text(
          "Current Month Payroll",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Obx(() {
        final payroll = payRollController.payrollDataWorkingDay.value?.payroll;

        if (payRollController.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (payroll == null) {
          return const Center(child: Text("No Data Found"));
        }

        final salaryTillNow = payroll.salaryTillNow ?? 0;
        final grossSalary = payroll.grossSalary ?? 1;
        final percent = grossSalary > 0 ? (salaryTillNow / grossSalary) : 0;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ------------------------------------------------
              // COMPANY AND BRANCH CARD
              // ------------------------------------------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      child: Icon(Icons.person, size: 30),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          payroll.employeeName ?? "N/A",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.business, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              payroll.companyId?.companyName ?? "N/A",
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),

                        const SizedBox(height: 4),

                        Row(
                          children: [
                            const Icon(Icons.home, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              payroll.branchId?.branchName ?? "N/A",
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E4DB7),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Monthpayrolldetailscreen(
                              id: widget.id,
                              // branchId: widget.branchId,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        "Monthly Salary",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: Color(0xFF1E4DB7)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        final payroll = payRollController.payrollDataWorkingDay.value?.payroll;
                        if (payroll != null) {
                          fdfController.generateSalarySlip(payroll);
                        }
                      },
                      icon: const Icon(
                        Icons.download,
                        color: Color(0xFF1E4DB7),
                      ),
                      label: const Text(
                        "Salary Receipt",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF1E4DB7),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              // ------------------------------------------------
              // CURRENT MONTH PROGRESS
              // ------------------------------------------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Salary Earned Till Now",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("₹ ${salaryTillNow.toStringAsFixed(2)}"),
                        Text(
                          "${(percent * 100).toStringAsFixed(2)} %",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    LinearProgressIndicator(
                      value: (percent ?? 0).toDouble(),
                      minHeight: 8,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation(MyColor.dashbord),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Current: ₹ ${salaryTillNow.toStringAsFixed(2)}"),
                        Text("Target: ₹ ${grossSalary}"),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ------------------------------------------------
              // FINAL AMOUNT
              // ------------------------------------------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Final Amount Breakdown",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 10),
                    _amountRow(
                      "Net Pay",
                      "₹ ${(payroll.netPay ?? 0).toStringAsFixed(2)}",
                    ),
                    _amountRow(
                      "Late Arrival Deduction",
                      "₹ ${(payroll.lateArrivalDeductionAmount ?? 0).toStringAsFixed(2)}",
                    ),
                    _amountRow(
                      "Total Deductions",
                      "₹ ${(payroll.totalDeductions ?? 0).toStringAsFixed(2)}",
                    ),

                    const SizedBox(height: 10),

                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Final Salary",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "₹ ${(payroll.salaryYouWillReceive ?? 0).toStringAsFixed(2)}",
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  Widget _amountRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
//
// import '../../resources/my_colors.dart';
//
// class Currentmonthpayrollscreen extends StatefulWidget {
//   final String id;
//   final String branchId;
//
//   const Currentmonthpayrollscreen({
//     super.key,
//     required this.id,
//     required this.branchId,
//   });
//
//   @override
//   State<Currentmonthpayrollscreen> createState() =>
//       _CurrentmonthpayrollscreenState();
// }
//
// class _CurrentmonthpayrollscreenState extends State<Currentmonthpayrollscreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // body: Center(
//       //   child: Text("ID: ${widget.id}, Branch: ${widget.branchId}"),
//       // ),
//       appBar: AppBar(
//         foregroundColor: Colors.white,
//         backgroundColor: MyColor.dashbord,
//         title: const Text(
//           "Current Month Payroll",
//           style: TextStyle(fontWeight: FontWeight.w600),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//
//         ),
//       ),
//
//     );
//   }
// }
