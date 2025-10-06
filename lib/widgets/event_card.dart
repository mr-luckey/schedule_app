import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_calendar/calendar.dart';
// import 'calendar_event.dart';
import 'package:intl/intl.dart';
import 'package:schedule_app/model/Calender_model.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
// import 'package:wedding_booking_app/Model/Calender_Event.dart';

class EventTile extends StatelessWidget {
  final Appointment appointment;

  const EventTile({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    // final CalendarEvent event = appointment.id as CalendarEvent;
    final CalendarEvent event = CalendarEvent(
      id: appointment.id!.toString(),
      guests: appointment.notes,
      title: appointment.subject,
      start: appointment.startTime,
      end: appointment.endTime,
      color: appointment.color,
      eventDate: DateTime.now().toString(),
    );

    print("Here is the events details" + "${event.guests}");

    return Container(
      // padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: appointment.color,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: event.color, width: 1.2),
      ),
      child:
          event.child ??
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(height: 10),
                // Show customer name as title
                Text(
                  event.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                // Show event name and number of guests under customer name
                if (event.subtitle != null && event.subtitle!.isNotEmpty) ...[
                  Text(event.subtitle!, style: const TextStyle(fontSize: 11)),
                  const SizedBox(height: 2),
                ],
                Text(
                  '${_fmt(event.start)} - ${_fmt(event.end)}',
                  style: const TextStyle(fontSize: 11),
                ),
                const SizedBox(height: 2),
                Text(
                  "${appointment.notes}",
                  style: const TextStyle(fontSize: 11),
                ),
              ],
            ),
          ),
    );
  }

  static String _fmt(DateTime dt) => DateFormat('h:mm a').format(dt);
}
