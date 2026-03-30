import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:month_year_picker/month_year_picker.dart';
import '../../resources/my_colors.dart';
import 'CurrentMonthPayrollController.dart';
import 'FdfControllerForMonthlyPayRoll.dart';
import 'MonthPayrollDetailModel.dart';

class Monthpayrolldetailscreen extends StatefulWidget {
  final String id;

  const Monthpayrolldetailscreen({
    super.key,
    required this.id,
  });

  @override
  State<Monthpayrolldetailscreen> createState() =>
      _MonthpayrolldetailscreenState();
}

class _MonthpayrolldetailscreenState extends State<Monthpayrolldetailscreen> {
  final CurrentMonthPayrollController controller =
  Get.put(CurrentMonthPayrollController());
  final FdfControllerForMonthlyPayRoll FdfController = Get.put(FdfControllerForMonthlyPayRoll());
  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final monthYear = "${now.year}-${now.month.toString().padLeft(2, '0')}";
    controller.selectedMonthYear.value = monthYear;
    controller.fetchSelectedMonthPayroll(monthYear, widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Selected Month Payroll"),
        backgroundColor: MyColor.dashbord,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: Obx(() => InkWell(
                      onTap: () async {
                        final DateTime? picked = await showMonthYearPicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2024),
                          lastDate: DateTime.now(),
                        );

                        if (picked != null) {
                          controller.setDate(picked);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(controller.selectedMonthYear.value),
                            const Icon(Icons.calendar_month),
                          ],
                        ),
                      ),
                    )),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E4DB7),
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      controller.fetchSelectedMonthPayroll(controller.selectedMonthYear.value, widget.id);
                    },
                    child: Text("Apply",style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            ),
            Obx(() {
              if (controller.loading1.value) {
                return const Center(child: CircularProgressIndicator());
              }
        
              final PayrollDetail? payroll =
                  controller.monthPayroll.value?.data?.first;
        
              if (payroll == null) {
                return const Center(child: Text("No Payroll Data Found"));
              }
        
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // ================= HEADER CARD ================
                    _profileCard(payroll),
        
                    const SizedBox(height: 16),
        
                    // ================= PAYROLL DETAILS ==================
                    _card(
                      child: Column(
                        children: [
                          _salaryItem("Gross Salary", payroll.grossSalary, Colors.blue),
                          _salaryItem("Net Pay", payroll.netPay, Colors.green),
                          _salaryItem("Total Earnings", payroll.totalEarnings, Colors.teal),
                          _salaryItem("Total Deductions", payroll.totalDeductions, Colors.red),
                          _salaryItem("Total Salary", (payroll.totalEarnings ?? 0) - (payroll.totalDeductions ?? 0), Colors.green),
        
                        ],
                      ),
                    ),
        
                    const SizedBox(height: 12),
        
                    // DOWNLOAD BUTTON
                    InkWell(
                      onTap: () async {
                        final payroll = controller.monthPayroll.value?.data?.first;
                        if (payroll != null) {
                          FdfController.generateMonthlySalarySlip(payroll);
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF1E4DB7)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.download, color: Color(0xFF1E4DB7)),
                              SizedBox(width: 5),
                              Text("Download Salary Slip",
                                  style: TextStyle(color: Color(0xFF1E4DB7))),
                            ],
                          ),
                        ),
                      ),
                    ),
        
                    const SizedBox(height: 16),
        
                    // ================= BANK DETAILS ==================
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: cardStyle(),
                      child: Column(
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Bank Details",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              )
                          ),
        
                          const SizedBox(height: 10),
        
                          bankTile(Icons.person, "Account Holder", payroll.bankDetails?.accountHolderName,Colors.grey.shade300),
                          bankTile(Icons.account_balance, "Bank Name", payroll.bankDetails?.bankName,Colors.grey.shade300),
                          bankTile(Icons.numbers, "Account Number", payroll.bankDetails?.accountNumber,Colors.grey.shade300),
                          bankTile(Icons.code, "IFSC Code", payroll.bankDetails?.ifscCode,Colors.grey.shade300),
        
                        ],
                      ),
                    ),
        
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // ================= COMPONENTS =================

  /// PROFILE CARD UI
  Widget _profileCard(PayrollDetail payroll) {
    return _card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // avatar
          const CircleAvatar(
            radius: 30,
            child: Icon(Icons.person, size: 30),
          ),
          const SizedBox(width: 12),

          // employee detail
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payroll.employeeName ?? "-",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    const Icon(Icons.business, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      payroll.companyName ?? "-",
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
                      payroll.branchName ?? "-",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// MAIN CARD WRAPPER
  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: child,
    );
  }

  /// BANK DETAIL ITEM
  Widget bankTile(IconData icon, String title, String? value, dynamic color) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: cardStyle(),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color,
            // foregroundColor: color,
            child: Icon(icon, color: Colors.grey.shade700),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style:
                  TextStyle(fontSize: 13, color: Colors.grey.shade600)),
              Text(
                value ?? "",
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ],
          )
        ],
      ),
    );
  }
  BoxDecoration cardStyle() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
      ],
    );
  }

  /// SALARY ITEM
  Widget _salaryItem(String title, num? value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            // "₹ ${value ?? 0}",
            "₹ ${(value ?? 0).toStringAsFixed(2)}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

}