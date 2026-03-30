import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

import 'PayrollModelOfWarkingDay.dart';

class FdfControllerOfCurrentPayRoll extends GetxController{

  //--------- THIS IS FOR FDF TOTAL WORKING DAY Salary Receipt IN PAYROLL SCREEN

  Future<void> generateSalarySlip(PayrollData payroll) async {
    final pdf = pw.Document();

    // Colors
    final headerColor = PdfColor.fromHex('#1E3A5F'); // Dark blue
    final lightGrey = PdfColor.fromHex("#F0F0F0");

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [

              /// ===================== HEADER =====================
              pw.Container(
                color: headerColor,
                width: double.infinity,
                padding: const pw.EdgeInsets.all(12),
                child: pw.Center(
                  child: pw.Column(
                    children: [
                      pw.Text(
                        payroll.companyId?.companyName ?? "",
                        style: pw.TextStyle(
                          color: PdfColors.white,
                          fontSize: 22,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        "Salary Slip",
                        style: pw.TextStyle(
                          color: PdfColors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              pw.SizedBox(height: 14),

              /// ===================== EMPLOYEE INFO =====================
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("Employee: ${payroll.employeeName}"),
                      pw.Text("Branch: ${payroll.branchId?.branchName ?? ""}"),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                          "Month Period: ${DateTime.now().month} ${DateTime.now().year}"),
                      pw.Text(
                          "Generated: ${DateFormat('dd MMMM yyyy').format(DateTime.now())}"),
                    ],
                  ),
                ],
              ),

              pw.SizedBox(height: 10),
              pw.Divider(),

              pw.SizedBox(height: 10),

              /// ===================== EARNINGS & DEDUCTION TABLE =====================
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: const pw.FlexColumnWidth(2),
                  1: const pw.FlexColumnWidth(1),
                  2: const pw.FlexColumnWidth(2),
                  3: const pw.FlexColumnWidth(1),
                },
                children: [

                  /// Header Row
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: headerColor),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          "EARNINGS",
                          style: pw.TextStyle(
                            color: PdfColors.white,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          "AMOUNT",
                          style: pw.TextStyle(
                            color: PdfColors.white,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          "DEDUCTIONS",
                          style: pw.TextStyle(
                            color: PdfColors.white,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          "AMOUNT",
                          style: pw.TextStyle(
                            color: PdfColors.white,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  /// Row: Earn Salary & Deduction
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text("Earn Salary"),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          payroll.salaryTillNow?.toStringAsFixed(2) ?? "0",
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text("Late Arrival"),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          (payroll.lateArrivalDeductionAmount ?? 0).toString(),
                        ),
                      ),
                    ],
                  ),

                  /// Row: Days Worked
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text("Days Worked"),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          ((payroll.salaryTillNow ?? 0) /
                              (payroll.perDaySalary ?? 1))
                              .toStringAsFixed(0),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(""),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(""),
                      ),
                    ],
                  ),

                  /// Row: Total Earnings & Total Deductions
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: lightGrey),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          "TOTAL EARNINGS",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          payroll.totalEarnings?.toString() ?? "0",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          "TOTAL DEDUCTIONS",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          payroll.totalDeductions?.toString() ?? "0",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              /// Net Salary Row Box
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: headerColor,
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      "NET SALARY",
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      payroll.salaryYouWillReceive?.toString() ?? "0",
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 20),

              /// ===================== BANK DETAILS =====================
              pw.Text(
                "Bank Details",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
              ),
              pw.SizedBox(height: 8),

              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("Account Holder: ${payroll.bankDetails?.accountHolderName ?? ""}"),
                      pw.Text("Account No: ${payroll.bankDetails?.accountNumber ?? ""}"),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("Bank: ${payroll.bankDetails?.bankName ?? ""}"),
                      pw.Text("IFSC: ${payroll.bankDetails?.ifscCode ?? ""}"),
                    ],
                  ),
                ],
              ),

              pw.SizedBox(height: 12),

              pw.Text(
                "Net Amount:  ${payroll.salaryYouWillReceive}",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),

              pw.Text(
                "To be credited to ${payroll.bankDetails?.bankName ?? ""}",
              ),

              pw.SizedBox(height: 20),
              pw.Text(
                "This is a computer generated salary slip and does not require a signature.",
                style: pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
              ),
            ],
          );
        },
      ),
    );

    // Save & Open
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/salary_slip.pdf");
    await file.writeAsBytes(await pdf.save());
    OpenFilex.open(file.path);
  }

}