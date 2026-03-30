import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:rocketsales_admin/Screens/ManageShop/ManageShopsScreen.dart';

import '../../../resources/my_colors.dart';
import 'CreateEditTaskController.dart';

class AddTaskScreen extends StatelessWidget {
  AddTaskScreen({super.key});

  final CreateEditTaskController controller = Get.put(CreateEditTaskController(), permanent: true);

  final _formKey = GlobalKey<FormState>();

  Future<void> _selectTillDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: controller.tillDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime(2040),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: MyColor.dashbord,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      controller.tillDate.value = picked;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Task"), backgroundColor: MyColor.dashbord, foregroundColor: Colors.white,),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dynamic Task Fields
                buildLabel("Task Description:"),
                Obx(() => ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.taskControllers.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller:
                              controller.taskControllers[index],
                              decoration: InputDecoration(
                                // labelText: "Task Description ${index + 1}",
                                hint: Text("Task Description ${index + 1}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Task description is required";
                                }
                                return null;
                              },
                            ),
                          ),
                          if (controller.taskControllers.length > 1)
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.red),
                              onPressed: () =>
                                  controller.removeTaskField(index),
                            ),
                        ],
                      ),
                    );
                  },
                )),
        
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: controller.addTaskField,
                    icon: const Icon(Icons.add),
                    label: const Text("Add Another Task"),
                  ),
                ),
        
                const SizedBox(height: 10),
        
                // Address
                buildLabel("Address:"),
                TextFormField(
                  controller: controller.addressController,
                  decoration: const InputDecoration(
                    // labelText: "Address",
                    hint: Text("Address", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  // validator: (value) {
                  //   if (value == null || value.trim().isEmpty) {
                  //     return "Address is required";
                  //   }
                  //   return null;
                  // },
                ),
        
                const SizedBox(height: 10),
        
                buildLabel("Geofence:"),
                Obx(() => SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      side: const BorderSide(color: Colors.black54),
                    ),
                    onPressed: () {
                      // controller.selectedGeoFence.value = "Geofence-1"; // Example
                      Get.to(ManageShopsScreen(), arguments: {
                        "targetScreen": "selectGeofence"
                      });
                    },
                    icon: const Icon(
                      Icons.warehouse_outlined,
                      color: Colors.black,
                    ),
                    label: Text(
                      controller.selectedShop.value != null
                          ? controller.selectedShop.value!.shopName
                          : "Select geofence",
                      style: const TextStyle(color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),),
        
                const SizedBox(height: 10),
        
                // Deadline
                buildLabel("Deadline:"),
                Obx(() => OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    side: const BorderSide(color: Colors.black54),
                  ),
                  onPressed: () => _selectTillDate(context),
                  icon: const Icon(
                    Icons.date_range,
                    color: Colors.black,
                  ),
                  label: Text(DateFormat('dd/MM/yyyy')
                      .format(controller.tillDate.value),
                    style: const TextStyle(color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),),
        
                const SizedBox(height: 30),
        
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // if (controller.selectedShop.value == null) {
                        //   // geofence validation (manual, since it's a button)
                        //   Get.snackbar("Error", "Geofence is required");
                        //   return;
                        // }
                        controller.uploadTask(context);
                      }
                    },
                    child: const Text("Submit"),
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
