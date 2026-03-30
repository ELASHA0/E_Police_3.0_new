import 'package:get/get.dart';
import 'dart:io';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'MonthPayrollDetailModel.dart';

class FdfControllerForMonthlyPayRoll extends GetxController{
  ///  ----- GET PAYROLL FOR MONTHLY SALARY ----
  Future<void> generateMonthlySalarySlip(PayrollDetail payroll) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(0),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header Section with Company Name
              _buildHeader(),

              pw.SizedBox(height: 20),

              // Title Section
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 30),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Salary Slip',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'Month: ${payroll.month ?? ""}-${payroll.year ?? ""}',
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                    pw.Text(
                      'Generated on: ${_formatDate(DateTime.now())}',
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 20),

              // Employee Information Section
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 30),
                child: _buildEmployeeInfo(payroll),
              ),

              pw.SizedBox(height: 20),

              // Earnings and Deductions Table
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 30),
                child: _buildSalaryTable(payroll),
              ),

              pw.SizedBox(height: 20),

              // Net Salary Section
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 30),
                child: _buildNetSalary(payroll),
              ),

              pw.SizedBox(height: 30),

              // Bank Details Section
              if (payroll.bankDetails != null)
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 30),
                  child: _buildBankDetails(payroll.bankDetails!),
                ),
            ],
          );
        },
      ),
    );

    // Save & Open PDF
    try {
      final dir = await getApplicationDocumentsDirectory();
      final timestamp = _formatTimestamp(DateTime.now());
      final employeeName = payroll.employeeName?.replaceAll(' ', '_') ?? 'employee';
      final file = File("${dir.path}/salary_slip_${employeeName}_$timestamp.pdf");
      await file.writeAsBytes(await pdf.save());
      await OpenFilex.open(file.path);
    } catch (e) {
      print("Error saving PDF: $e");
    }
  }

// Helper function to format date
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

// Helper function to format timestamp
  String _formatTimestamp(DateTime date) {
    return '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}_'
        '${date.hour.toString().padLeft(2, '0')}${date.minute.toString().padLeft(2, '0')}${date.second.toString().padLeft(2, '0')}';
  }

// Header with Company Name
  pw.Widget _buildHeader() {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.symmetric(vertical: 25, horizontal: 30),
      decoration: const pw.BoxDecoration(
        color: PdfColor.fromInt(0xFF364B5E),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Text(
            'HBgadgetTechnology',
            style: pw.TextStyle(
              color: PdfColors.white,
              fontSize: 22,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            'Credence Office',
            style: const pw.TextStyle(
              color: PdfColors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

// Employee Information Section
  pw.Widget _buildEmployeeInfo(PayrollDetail payroll) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Employee Information',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Employee Name:', payroll.employeeName ?? '-'),
                    pw.SizedBox(height: 5),
                    _buildInfoRow('Month:', '${payroll.month ?? ""}-${payroll.year ?? ""}'),
                    pw.SizedBox(height: 5),
                    _buildInfoRow('Payment Date:', _formatDate(DateTime.now())),
                  ],
                ),
              ),
              pw.SizedBox(width: 20),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Company:', payroll.companyName ?? '-'),
                    pw.SizedBox(height: 5),
                    _buildInfoRow('Branch:', payroll.branchName ?? '-'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

// Helper for Info Rows
  pw.Widget _buildInfoRow(String label, String value) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          width: 100,
          child: pw.Text(
            label,
            style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.Expanded(
          child: pw.Text(
            value,
            style: const pw.TextStyle(fontSize: 11),
          ),
        ),
      ],
    );
  }

// Salary Table with Earnings and Deductions
  pw.Widget _buildSalaryTable(PayrollDetail payroll) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400),
      columnWidths: {
        0: const pw.FlexColumnWidth(2),
        1: const pw.FlexColumnWidth(1.5),
        2: const pw.FlexColumnWidth(2),
        3: const pw.FlexColumnWidth(1.5),
      },
      children: [
        // Header Row
        pw.TableRow(
          decoration: const pw.BoxDecoration(
            color: PdfColor.fromInt(0xFF364B5E),
          ),
          children: [
            _buildTableCell('EARNINGS', isHeader: true),
            _buildTableCell('AMOUNT', isHeader: true),
            _buildTableCell('DEDUCTIONS', isHeader: true),
            _buildTableCell('AMOUNT', isHeader: true),
          ],
        ),
        // Data Rows
        pw.TableRow(
          children: [
            _buildTableCell('Gross Salary'),
            _buildTableCell('${payroll.grossSalary ?? 0}'),
            _buildTableCell('PF'),
            _buildTableCell('0'),
          ],
        ),
        pw.TableRow(
          children: [
            _buildTableCell('HRA'),
            _buildTableCell('0'),
            _buildTableCell('Tax'),
            _buildTableCell('0'),
          ],
        ),
        pw.TableRow(
          children: [
            _buildTableCell('Allowances'),
            _buildTableCell('0'),
            _buildTableCell('Other Deductions'),
            _buildTableCell('0'),
          ],
        ),
        // Total Row
        pw.TableRow(
          decoration: pw.BoxDecoration(
            color: PdfColors.grey200,
          ),
          children: [
            _buildTableCell('TOTAL EARNINGS', isBold: true),
            _buildTableCell('${payroll.totalEarnings ?? 0}', isBold: true),
            _buildTableCell('TOTAL DEDUCTIONS', isBold: true),
            _buildTableCell('${payroll.totalDeductions ?? 0}', isBold: true),
          ],
        ),
      ],
    );
  }

// Table Cell Builder
  pw.Widget _buildTableCell(String text, {bool isHeader = false, bool isBold = false}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 11 : 10,
          fontWeight: (isHeader || isBold) ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: isHeader ? PdfColors.white : PdfColors.black,
        ),
      ),
    );
  }

// Net Salary Section
  pw.Widget _buildNetSalary(PayrollDetail payroll) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(12),
      decoration: const pw.BoxDecoration(
        color: PdfColor.fromInt(0xFF364B5E),
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(5)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'NET SALARY',
            style: pw.TextStyle(
              color: PdfColors.white,
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Text(
            '${payroll.netPay ?? 0}',
            style: pw.TextStyle(
              color: PdfColors.white,
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

// Bank Details Section
  pw.Widget _buildBankDetails(BankDetails bankDetails) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Bank Details',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          _buildInfoRow('Bank Name:', bankDetails.bankName ?? '-'),
          pw.SizedBox(height: 5),
          _buildInfoRow('Account Holder:', bankDetails.accountHolderName ?? '-'),
          pw.SizedBox(height: 5),
          _buildInfoRow('Account Number:', bankDetails.accountNumber ?? '-'),
          pw.SizedBox(height: 5),
          _buildInfoRow('IFSC Code:', bankDetails.ifscCode ?? '-'),
        ],
      ),
    );
  }


}