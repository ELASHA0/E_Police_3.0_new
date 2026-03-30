import 'package:flutter/material.dart';

import '../../resources/my_colors.dart';
import '../AttendanceTrakingOfSalesman/AttendanceTrackingScreen.dart';
import '../PayrollPolicy/PayrollTrakingScreen.dart';

class AttendancePayrollCombineScreen extends StatefulWidget {
  const AttendancePayrollCombineScreen({super.key});

  @override
  State<AttendancePayrollCombineScreen> createState() =>
      _AttendancePayrollCombineScreenState();
}

class _AttendancePayrollCombineScreenState
    extends State<AttendancePayrollCombineScreen> {

  int selectedIndex = 0;
  // 0 = Attendance, 1 = Payroll

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: MyColor.dashbord,
        title: const Text(
          "Attendance & Payroll",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      body: Column(
        children: [

          // ================= TOP BUTTONS ================
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => selectedIndex = 0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: selectedIndex == 0 ? Colors.white : MyColor.dashbord,
                      borderRadius: selectedIndex == 1 ? BorderRadius.only(
                        bottomRight: Radius.circular(12),
                      ) : BorderRadius.circular(0),
                    ),
                    child: Center(
                      child: Text(
                        "Attendance Track",
                        style: TextStyle(
                          color: selectedIndex == 0 ? Colors.black : Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: InkWell(
                  onTap: () => setState(() => selectedIndex = 1),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: selectedIndex == 1 ? Colors.white : MyColor.dashbord,
                      borderRadius: selectedIndex == 0 ? BorderRadius.only(
                        // topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ) : BorderRadius.circular(0),
                    ),
                    child: Center(
                      child: Text(
                        "Payroll Track",
                        style: TextStyle(
                          color: selectedIndex == 1 ? Colors.black : Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ================= SHOW SELECTED SCREEN ================
          Expanded(
            child: selectedIndex == 0
                ? AttendanceTrakingScreen()   // your widget
                : Payrolltrakingscreen(),      // your widget
          ),
        ],
      ),
    );
  }
}
