import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'RaiseTicketController.dart';
import 'TicketModel.dart';

class TicketCard extends StatefulWidget {
  final TicketModel ticket;

  TicketCard({super.key, required this.ticket});

  @override
  State<TicketCard> createState() => _TicketCardState();
}

class _TicketCardState extends State<TicketCard> {
  final RaiseTicketController controller = Get.find<RaiseTicketController>();

  final ExpansibleController expansionController = ExpansibleController();
  bool _isExpanded = false;

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, right: 20, left: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(
          color: Colors.black12, // border color
          width: 2, // border thickness
        ),
      ),
      child: GestureDetector(
        onTap: () {
          if (expansionController.isExpanded) {
            expansionController.collapse();
          } else {
            expansionController.expand();
          }
        },
        child: ExpansionTile(
          shape: const Border(),
          collapsedShape: const Border(),
          tilePadding:
          const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
          onExpansionChanged: (expanded) {
            setState(() {
              _isExpanded = expanded;
            });
          },
          controller: expansionController,
          title: Text(widget.ticket.description,
              maxLines: _isExpanded ? 20 : 1,
              softWrap: _isExpanded ? true : false,
              overflow: TextOverflow.fade),
          subtitle: Row(
            children: [
              const Icon(
                Icons.watch_later_outlined,
                size: 20,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black54),
                  controller
                      .formattedDate(widget.ticket.createdAt.toString())),
            ],
          ),
          trailing: widget.ticket.status == "resolved"
              ? Container(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(
                    224, 247, 210, 1), // background color
                border: Border.all(
                  color: Colors.green, // border color
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
                    const Icon(
                      Icons.check_circle_outline,
                      color: Color.fromRGBO(37, 87, 9, 1),
                      size: 12,
                    ),
                    Text(
                      "Resolved",
                      style: const TextStyle(
                          color: Color.fromRGBO(37, 87, 9, 1)),
                    ),
                  ],
                ),
              ))
              : widget.ticket.status == "open" ? Container(
              decoration: BoxDecoration(
                color: Colors.grey, // background color
                border: Border.all(
                  color: Colors.grey, // border color
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
                    const Icon(
                      Icons.pending_actions,
                      color: Colors.white,
                      size: 12,
                    ),
                    Text(
                      "Open",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              )) : Container(
              decoration: BoxDecoration(
                color: Colors.yellow, // background color

                borderRadius:
                BorderRadius.circular(6), // optional: rounded corners
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 1, left: 8, right: 8, bottom: 1),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.pending_actions,
                      color: Colors.black87,
                      size: 12,
                    ),
                    Text(
                      "In Progress",
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
