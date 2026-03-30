import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/root/parse_route.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:http/http.dart';
import 'package:rocketsales_admin/Screens/MeetingandCollaboration/LeadGeneration/LeadgenerationController.dart';
import 'package:rocketsales_admin/Screens/SalesmanListScreen/SalesmanModel.dart';

import '../../../resources/my_assets.dart';
import '../../../resources/my_colors.dart';
import '../../SalesmanListScreen/SalesmanListController.dart';
import '../../SalesmanListScreen/SalesmanListScreen.dart';
import '../../UserManagement/UserManagementController.dart';
import 'SelectSalesmen.dart';
import 'leadgenerationmodel.dart';

class CreateEditLeadScreen extends StatefulWidget {
  final LeadManagement? lead;

  const CreateEditLeadScreen({super.key, this.lead});

  @override
  State<CreateEditLeadScreen> createState() => _CreateEditLeadScreenState();
}

class _CreateEditLeadScreenState extends State<CreateEditLeadScreen> {
  bool get isEdit => widget.lead != null;

  final LeadGenerationController controller =
      Get.find<LeadGenerationController>();
  final SalesmanListController salesmanController = Get.put(
    SalesmanListController(),
  );

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.lead != null) {
      controller.leadclientTitleController.text = widget.lead!.leadTitle ?? "";
      controller.leadclientNameController.text = widget.lead!.clientName ?? "";
      controller.leadclientEmailController.text =
          widget.lead!.clientEmail ?? "";
      controller.leadclientPhoneController.text =
          widget.lead!.clientPhone ?? "";
      controller.leadclientAddController.text = widget.lead!.clientAdd ?? "";
      controller.leadshopNameController.text = widget.lead!.shopName ?? "";
      controller.leadNotesController.text = widget.lead!.notes ?? "";
      controller.selectedsalesmanId.value = widget.lead!.salesman?.id ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Lead" : "Create Lead"),
        backgroundColor: MyColor.dashbord,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildLabel("Lead Title"),
                TextFormField(
                  controller: controller.leadclientTitleController,
                  decoration: const InputDecoration(
                    // labelText: "Address",
                    hint: Text(
                      "Enter Lead Title ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "leadTitle is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                buildLabel("Client Name"),
                TextFormField(
                  controller: controller.leadclientNameController,
                  decoration: const InputDecoration(
                    // labelText: "Address",
                    hint: Text(
                      "Enter Client Name",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "clientName is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                buildLabel("Client Email "),
                TextFormField(
                  /*controller: controller.emailController,*/
                  controller: controller.leadclientEmailController,
                  decoration: const InputDecoration(
                    // labelText: "Address",
                    hint: Text(
                      "Enter Client Email",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "clientEmail is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                buildLabel("Client Contact "),
                TextFormField(
                  /*controller: controller.phoneController,*/
                  controller: controller.leadclientPhoneController,
                  decoration: const InputDecoration(
                    // labelText: "Address",
                    hint: Text(
                      "Enter Client Phone",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "clientPhone is required";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
                const SizedBox(height: 10),
                buildLabel("Client Address"),
                TextFormField(
                  /*controller: controller.NotesController,*/
                  controller: controller.leadclientAddController,
                  decoration: const InputDecoration(
                    // labelText: "Address",
                    hint: Text(
                      "Enter Client Address ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Notes is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                buildLabel("Shop Name"),
                TextFormField(
                  /*controller: controller.shopNameController,*/
                  controller: controller.leadshopNameController,
                  decoration: const InputDecoration(
                    // labelText: "Address",
                    hint: Text(
                      "Enter Shop Name",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "shopName is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                buildLabel("Notes"),
                TextFormField(
                  /*controller: controller.NotesController,*/
                  controller: controller.leadNotesController,
                  decoration: const InputDecoration(
                    // labelText: "Address",
                    hint: Text(
                      "Enter Notes",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Notes is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                buildLabel("Select Salesman"),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    icon:  Icon(Icons.ads_click),


                    onPressed: () {
                      Get.to(
                        () => selectsalesmen(
                          onSalesmanSelected: (SalesmanModel selected) {
                            controller.selectedsalesmanId.value =
                                selected.id ?? '';
                            print("=== salesman selected ===");
                            print("name: ${selected.salesmanName}");
                            print("id: ${selected.id}");
                            print("selectedsalesmanId: ${controller.selectedsalesmanId.value}");
                            setState(() {});
                            print("Selected: ${selected.salesmanName}");
                          },
                        ),

                      );
                    },
                    style: ElevatedButton.styleFrom(
                      side:BorderSide(
                        color:MyColor.dashbord,


                      ),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,

                   // child: Text('Select Salesman'),
                      // chnaged this now
                  ),  label: Text( controller.selectedsalesmanId.value.isNotEmpty
                      ? "Selected Salesman : ${salesmanController.salesmen.firstWhereOrNull((s) => s.id == controller.selectedsalesmanId.value)?.salesmanName ?? ''}"
                      : "Select Salesman",),

                  ),
                ),
                const SizedBox(height: 10),

                // Dropdown logic if ever needed .
                /* DropdownSearch<SalesmanModel>(
                      items: (filter, infiniteScrollProps) =>
                          salesmanController.salesmen,

                      itemAsString: (SalesmanModel salesman) =>
                          salesman.salesmanName ?? "",

                      compareFn: (item1, item2) => item1.id == item2.id,
                 selectedItem: salesmanController.salesmen.firstWhereOrNull(
                       (s) => s.id == controller.selectedsalesmanId.value,
                 ),
                      decoratorProps: const DropDownDecoratorProps(
                        decoration: InputDecoration(
                          labelText: "Selected Salesman ",

                          hintText: "Search Salesman",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ),

                      // search box inside dropdown
                      popupProps: const PopupProps.menu(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          decoration: InputDecoration(
                            hintText: "Search...",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),

                      onChanged: (SalesmanModel? selected) {
                        if (selected != null) {
                          controller.selectedsalesmanId.value = selected.id ?? '';
                          print("Selected: ${selected.salesmanName}");
                          print("Selected ID: ${selected.id}");
                        }
                      },
                    ),*/
                if (isEdit)
                  Row(
                    children: [
                      SizedBox(
                        width: 120,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            controller.deleteLead(widget.lead!.id ?? "");
                          },
                          child: Text("Delete"),
                        ),
                      ),
                      Spacer(),
                      SizedBox(
                        width: 120,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              controller.updateLead(widget.lead!.id ?? "");
                            }
                          },
                          child: Text("Update"),
                        ),
                      ),
                    ],
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          controller.createLead();
                        }
                      },
                      child: Text(" Submit"),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 3, bottom: 5),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }
}
