import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../resources/my_colors.dart';
import 'LeadModel.dart';

class LeadCard extends StatelessWidget {
  final LeadModel lead;
  const LeadCard({super.key, required this.lead});

  String formatDate(DateTime? date) {
    if (date == null) {
      return "N/A";
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 325,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(19)),
        border: Border.all(
          color: Colors.black12, // border color
          width: 2, // border thickness
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            decoration: const BoxDecoration(
              color: const Color(0xFFE8F0FE), // Blue header
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  lead.shopName,
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    // color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    lead.status,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

          // Details
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 18, color: Colors.blue),
                    SizedBox(width: 6),
                    Text(formatDate(lead.createdAt)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.person, size: 18, color: Colors.blue),
                    SizedBox(width: 6),
                    Text(lead.clientName),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 18, color: Colors.blue),
                    const SizedBox(width: 6),
                    Text(lead.clientAdd),
                    const Spacer(),
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8F0FE),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(6),
                      child: const Icon(
                        Icons.phone,
                        color: Colors.blue,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(lead.clientPhone.toString()),
                  ],
                ),
              ],
            ),
          ),

          // Agenda Section
          Container(
            width: double.infinity,
            padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F0FE),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Text(
              'Agenda : ${lead.leadTitle}',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
