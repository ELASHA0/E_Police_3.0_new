class PermissionModel {
  final String id;
  final String companyId;
  final String? branchId;
  final Modules modules;

  PermissionModel({
    required this.id,
    required this.companyId,
    required this.branchId,
    required this.modules,
  });

  factory PermissionModel.fromJson(Map<String, dynamic> json) {
    return PermissionModel(
      id: json["_id"],
      companyId: json["companyId"],
      branchId: json["branchId"],
      modules: Modules.fromJson(json["modules"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "companyId": companyId,
    "branchId": branchId,
    "modules": modules.toJson(),
  };
}

class Modules {
  final HomeModule home;
  final ManagementModule management;
  final AttendanceModule attendance;
  final OrdersModule orders;
  final ReportsModule reports;
  final PayrollModule payroll;

  Modules({
    required this.home,
    required this.management,
    required this.attendance,
    required this.orders,
    required this.reports,
    required this.payroll,
  });

  factory Modules.fromJson(Map<String, dynamic> json) {
    return Modules(
      home: HomeModule.fromJson(json["home"]),
      management: ManagementModule.fromJson(json["management"]),
      attendance: AttendanceModule.fromJson(json["attendance"]),
      orders: OrdersModule.fromJson(json["orders"]),
      reports: ReportsModule.fromJson(json["reports"]),
      payroll: PayrollModule.fromJson(json["payroll"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "home": home.toJson(),
    "management": management.toJson(),
    "attendance": attendance.toJson(),
    "orders": orders.toJson(),
    "reports": reports.toJson(),
    "payroll": payroll.toJson(),
  };
}

class HomeModule {
  final bool dashboard;

  HomeModule({required this.dashboard});

  factory HomeModule.fromJson(Map<String, dynamic> json) =>
      HomeModule(dashboard: json["dashboard"]);

  Map<String, dynamic> toJson() => {"dashboard": dashboard};
}

class ManagementModule {
  final TaskManagementModule taskManagement;
  final bool company;
  final bool branch;
  final bool supervisor;
  final bool manageUser;
  final bool manageQrCode;
  final bool manageQrQuestion;
  final bool meetingAndCollab;
  final bool workpad;

  ManagementModule({
    required this.taskManagement,
    required this.company,
    required this.branch,
    required this.supervisor,
    required this.manageUser,
    required this.manageQrCode,
    required this.manageQrQuestion,
    required this.meetingAndCollab,
    required this.workpad,
  });

  factory ManagementModule.fromJson(Map<String, dynamic> json) {
    return ManagementModule(
      taskManagement: TaskManagementModule.fromJson(json["taskManagement"]),
      company: json["company"],
      branch: json["branch"],
      supervisor: json["supervisor"],
      manageUser: json["manageUser"],
      manageQrCode: json["manageQrCode"],
      manageQrQuestion: json["manageQrQuestion"],
      meetingAndCollab: json["meetingAndCollab"],
      workpad: json["workpad"],
    );
  }

  Map<String, dynamic> toJson() => {
    "taskManagement": taskManagement.toJson(),
    "company": company,
    "branch": branch,
    "supervisor": supervisor,
    "manageUser": manageUser,
    "manageQrCode": manageQrCode,
    "manageQrQuestion": manageQrQuestion,
    "meetingAndCollab": meetingAndCollab,
    "workpad": workpad,
  };
}

class TaskManagementModule {
  final bool geofence;
  final bool image;
  final bool video;
  final bool audio;

  TaskManagementModule({
    required this.geofence,
    required this.image,
    required this.video,
    required this.audio,
  });

  factory TaskManagementModule.fromJson(Map<String, dynamic> json) {
    return TaskManagementModule(
      geofence: json["geofence"],
      image: json["image"],
      video: json["video"],
      audio: json["audio"],
    );
  }

  Map<String, dynamic> toJson() => {
    "geofence": geofence,
    "image": image,
    "video": video,
    "audio": audio,
  };
}

class AttendanceModule {
  final bool attendance;
  final bool manualAttendance;
  final bool salesmanLeaveRequest;
  final bool approveRequest;
  final bool rejectRequest;

  AttendanceModule({
    required this.attendance,
    required this.manualAttendance,
    required this.salesmanLeaveRequest,
    required this.approveRequest,
    required this.rejectRequest,
  });

  factory AttendanceModule.fromJson(Map<String, dynamic> json) {
    return AttendanceModule(
      attendance: json["attendance"],
      manualAttendance: json["manualAttendance"],
      salesmanLeaveRequest: json["salesmanLeaveRequest"],
      approveRequest: json["approveRequest"],
      rejectRequest: json["rejectRequest"],
    );
  }

  Map<String, dynamic> toJson() => {
    "attendance": attendance,
    "manualAttendance": manualAttendance,
    "salesmanLeaveRequest": salesmanLeaveRequest,
    "approveRequest": approveRequest,
    "rejectRequest": rejectRequest,
  };
}

class OrdersModule {
  final bool pendingOrder;
  final bool productList;
  final bool salesmanExpense;
  final bool expenseType;
  final bool chatBot;
  final bool invoice;

  OrdersModule({
    required this.pendingOrder,
    required this.productList,
    required this.salesmanExpense,
    required this.expenseType,
    required this.chatBot,
    required this.invoice,
  });

  factory OrdersModule.fromJson(Map<String, dynamic> json) {
    return OrdersModule(
      pendingOrder: json["pendingOrder"],
      productList: json["productList"],
      salesmanExpense: json["salesmanExpense"],
      expenseType: json["expenseType"],
      chatBot: json["chatBot"],
      invoice: json["invoice"],
    );
  }

  Map<String, dynamic> toJson() => {
    "pendingOrder": pendingOrder,
    "productList": productList,
    "salesmanExpense": salesmanExpense,
    "expenseType": expenseType,
    "chatBot": chatBot,
    "invoice": invoice,
  };
}

class ReportsModule {
  final bool distanceReport;
  final bool taskReport;
  final bool qrScanReport;
  final bool trackingHistory;

  ReportsModule({
    required this.distanceReport,
    required this.taskReport,
    required this.qrScanReport,
    required this.trackingHistory,
  });

  factory ReportsModule.fromJson(Map<String, dynamic> json) {
    return ReportsModule(
      distanceReport: json["distanceReport"],
      taskReport: json["taskReport"],
      qrScanReport: json["qrScanReport"],
      trackingHistory: json["trackingHistory"],
    );
  }

  Map<String, dynamic> toJson() => {
    "distanceReport": distanceReport,
    "taskReport": taskReport,
    "qrScanReport": qrScanReport,
    "trackingHistory": trackingHistory,
  };
}

class PayrollModule {
  final bool companyPolicy;
  final bool companyCalendar;
  final bool attendanceTracking;
  final bool payrollTracking;

  PayrollModule({
    required this.companyPolicy,
    required this.companyCalendar,
    required this.attendanceTracking,
    required this.payrollTracking,
  });

  factory PayrollModule.fromJson(Map<String, dynamic> json) {
    return PayrollModule(
      companyPolicy: json["companyPolicy"],
      companyCalendar: json["companyCalendar"],
      attendanceTracking: json["attendanceTracking"],
      payrollTracking: json["payrollTracking"],
    );
  }

  Map<String, dynamic> toJson() => {
    "companyPolicy": companyPolicy,
    "companyCalendar": companyCalendar,
    "attendanceTracking": attendanceTracking,
    "payrollTracking": payrollTracking,
  };
}
