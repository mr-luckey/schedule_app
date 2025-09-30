// // // import 'package:flutter/material.dart';
// // // import 'package:schedule_app/model/Calender_model.dart';
// // // import 'package:schedule_app/model/Source/Data_sorce.dart';
// // // import 'package:schedule_app/widgets/event_card.dart';
// // // import 'package:syncfusion_flutter_calendar/calendar.dart';

// // // class WeekTimeCalendar extends StatefulWidget {
// // //   final List<CalendarEvent> events;
// // //   final DateTime? currentDate; // Changed from initialWeek to currentDate
// // //   final int startHour;
// // //   final int endHour;
// // //   final bool showWeekend;
// // //   final void Function(CalendarEvent event)? onEventTap;

// // //   const WeekTimeCalendar({
// // //     super.key,
// // //     required this.events,
// // //     this.currentDate, // Changed parameter name
// // //     this.startHour = 8,
// // //     this.endHour = 18,
// // //     this.showWeekend = true,
// // //     this.onEventTap,
// // //     // required DateTime initialWeek,
// // //   });

// // //   @override
// // //   State<WeekTimeCalendar> createState() => _WeekTimeCalendarState();
// // // }

// // // class _WeekTimeCalendarState extends State<WeekTimeCalendar> {
// // //   late CalendarController _calendarController;

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _calendarController = CalendarController();
// // //   }

// // //   @override
// // //   void didUpdateWidget(WeekTimeCalendar oldWidget) {
// // //     super.didUpdateWidget(oldWidget);
// // //     // Update the calendar display date when the currentDate changes
// // //     if (widget.currentDate != null &&
// // //         oldWidget.currentDate != widget.currentDate) {
// // //       _calendarController.displayDate = widget.currentDate!;
// // //     }
// // //   }

// // //   @override
// // //   void dispose() {
// // //     _calendarController.dispose();
// // //     super.dispose();
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final List<Appointment> appts = widget.events.map((e) {
// // //       return Appointment(
// // //         id: e,
// // //         startTime: e.start,
// // //         endTime: e.end,
// // //         subject: e.title,
// // //         notes: e.subtitle,
// // //         color: e.color.withOpacity(.18),
// // //       );
// // //     }).toList();

// // //     final dataSource = EventDataSource(appts);

// // //     return LayoutBuilder(
// // //       builder: (context, constraints) {
// // //         final bool wide = constraints.maxWidth >= 720;
// // //         final CalendarView view = wide
// // //             ? (widget.showWeekend ? CalendarView.week : CalendarView.workWeek)
// // //             : CalendarView.day;

// // //         return SingleChildScrollView(
// // //           scrollDirection: Axis.horizontal,
// // //           child: SizedBox(
// // //             width: (widget.showWeekend ? 7 : 5) * 200,
// // //             child: SfCalendar(
// // //               controller: _calendarController, // Add controller
// // //               view: view,
// // //               dataSource: dataSource,
// // //               initialDisplayDate: widget.currentDate ?? DateTime.now(),
// // //               firstDayOfWeek: 1,
// // //               allowViewNavigation: true,
// // //               showCurrentTimeIndicator: true,
// // //               headerStyle: const CalendarHeaderStyle(
// // //                 textAlign: TextAlign.center,
// // //                 textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
// // //               ),
// // //               viewHeaderHeight: 52,
// // //               viewHeaderStyle: const ViewHeaderStyle(
// // //                 dayTextStyle: TextStyle(
// // //                   fontSize: 12,
// // //                   fontWeight: FontWeight.w500,
// // //                 ),
// // //                 dateTextStyle: TextStyle(
// // //                   fontSize: 18,
// // //                   fontWeight: FontWeight.w600,
// // //                 ),
// // //               ),
// // //               timeSlotViewSettings: TimeSlotViewSettings(
// // //                 startHour: widget.startHour.toDouble(),
// // //                 endHour: widget.endHour.toDouble(),
// // //                 timeInterval: const Duration(minutes: 60),
// // //                 timeFormat: 'h:mm a',
// // //                 timeRulerSize: 68,
// // //                 timeIntervalHeight: 100,
// // //                 timeIntervalWidth: 100,
// // //                 timeTextStyle: const TextStyle(fontSize: 12),
// // //               ),
// // //               appointmentBuilder: (context, details) {
// // //                 final appt = details.appointments.first as Appointment;
// // //                 return EventTile(appointment: appt);
// // //               },
// // //               onTap: (details) {
// // //                 if (details.targetElement == CalendarElement.appointment &&
// // //                     details.appointments != null &&
// // //                     details.appointments!.isNotEmpty) {
// // //                   final Appointment tapped =
// // //                       details.appointments!.first as Appointment;
// // //                   final CalendarEvent event = tapped.id as CalendarEvent;
// // //                   widget.onEventTap?.call(event);
// // //                 }
// // //               },
// // //             ),
// // //           ),
// // //         );
// // //       },
// // //     );
// // //   }
// // // }
// // // Updated Week_Calender.dart
// // import 'package:flutter/material.dart';
// // import 'package:intl/intl.dart';
// // import 'package:schedule_app/model/Calender_model.dart';
// // import 'package:schedule_app/model/Source/Data_sorce.dart';
// // import 'package:schedule_app/model/event_model.dart';
// // import 'package:schedule_app/widgets/event_card.dart';
// // // import 'package:schedule_app/widgets/event_tile.dart'; // Add this import
// // import 'package:syncfusion_flutter_calendar/calendar.dart';

// // class WeekTimeCalendar extends StatefulWidget {
// //   final List<CalendarEvent> events;
// //   final DateTime? currentDate;
// //   final int startHour;
// //   final int endHour;
// //   final bool showWeekend;
// //   final void Function(CalendarEvent event)? onEventTap;

// //   const WeekTimeCalendar({
// //     super.key,
// //     required this.events,
// //     this.currentDate,
// //     this.startHour = 8,
// //     this.endHour = 18,
// //     this.showWeekend = true,
// //     this.onEventTap,
// //   });

// //   @override
// //   State<WeekTimeCalendar> createState() => _WeekTimeCalendarState();
// // }

// // class _WeekTimeCalendarState extends State<WeekTimeCalendar> {
// //   late CalendarController _calendarController;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _calendarController = CalendarController();
// //   }

// //   @override
// //   void didUpdateWidget(WeekTimeCalendar oldWidget) {
// //     super.didUpdateWidget(oldWidget);
// //     if (widget.currentDate != null &&
// //         oldWidget.currentDate != widget.currentDate) {
// //       _calendarController.displayDate = widget.currentDate!;
// //     }
// //   }

// //   @override
// //   void dispose() {
// //     _calendarController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final List<Appointment> appts = widget.events.map((e) {
// //       return Appointment(
// //         id: e,
// //         startTime: e.start,
// //         endTime: e.end,
// //         subject: e.title,
// //         notes: e.subtitle,
// //         color: e.color.withOpacity(.18),
// //       );
// //     }).toList();

// //     final dataSource = EventDataSource(appts);

// //     return LayoutBuilder(
// //       builder: (context, constraints) {
// //         final bool wide = constraints.maxWidth >= 720;
// //         final CalendarView view = wide
// //             ? (widget.showWeekend ? CalendarView.week : CalendarView.workWeek)
// //             : CalendarView.day;

// //         return SingleChildScrollView(
// //           scrollDirection: Axis.horizontal,
// //           child: SizedBox(
// //             width: (widget.showWeekend ? 7 : 5) * 200,
// //             child: SfCalendar(
// //               controller: _calendarController,
// //               view: view,
// //               dataSource: dataSource,
// //               initialDisplayDate: widget.currentDate ?? DateTime.now(),
// //               firstDayOfWeek: 1,
// //               allowViewNavigation: true,
// //               showCurrentTimeIndicator: true,
// //               headerStyle: const CalendarHeaderStyle(
// //                 textAlign: TextAlign.center,
// //                 textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
// //               ),
// //               viewHeaderHeight: 52,
// //               viewHeaderStyle: const ViewHeaderStyle(
// //                 dayTextStyle: TextStyle(
// //                   fontSize: 12,
// //                   fontWeight: FontWeight.w500,
// //                 ),
// //                 dateTextStyle: TextStyle(
// //                   fontSize: 18,
// //                   fontWeight: FontWeight.w600,
// //                 ),
// //               ),
// //               timeSlotViewSettings: TimeSlotViewSettings(
// //                 startHour: widget.startHour.toDouble(),
// //                 endHour: widget.endHour.toDouble(),
// //                 timeInterval: const Duration(minutes: 60),
// //                 timeFormat: 'h:mm a',
// //                 timeRulerSize: 68,
// //                 timeIntervalHeight: 100,
// //                 timeIntervalWidth: 100,
// //                 timeTextStyle: const TextStyle(fontSize: 12),
// //               ),
// //               appointmentBuilder: (context, details) {
// //                 final appt = details.appointments.first as Appointment;
// //                 final CalendarEvent event = appt.id as CalendarEvent;

// //                 return EventTile(
// //                   event: Event(
// //                     id: event.id,
// //                     title: event.title,
// //                     startTime: event.start,
// //                     endTime: event.end,
// //                     customerName: event.subtitle ?? 'Customer',
// //                     hall: 'Main Hall',
// //                     timeRange:
// //                         '${_formatTime(event.start)} - ${_formatTime(event.end)}',
// //                     specialRequirements: event.subtitle ?? '',
// //                     color: event.color,
// //                   ),
// //                 );
// //               },
// //               onTap: (details) {
// //                 if (details.targetElement == CalendarElement.appointment &&
// //                     details.appointments != null &&
// //                     details.appointments!.isNotEmpty) {
// //                   final Appointment tapped =
// //                       details.appointments!.first as Appointment;
// //                   final CalendarEvent event = tapped.id as CalendarEvent;
// //                   widget.onEventTap?.call(event);
// //                 }
// //               },
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   String _formatTime(DateTime dateTime) {
// //     return DateFormat('h:mm a').format(dateTime);
// //   }
// // }
// // Create a new file: week_view_calendar.dart
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:schedule_app/model/event_model.dart';
// import 'package:schedule_app/widgets/event_card.dart';
// // import 'package:schedule_app/widgets/event_tile.dart';

// class WeekViewCalendar extends StatefulWidget {
//   final List<Event> events;
//   final DateTime currentDate;
//   final Function(Event) onEventTap;

//   const WeekViewCalendar({
//     super.key,
//     required this.events,
//     required this.currentDate,
//     required this.onEventTap,
//   });

//   @override
//   State<WeekViewCalendar> createState() => _WeekViewCalendarState();
// }

// class _WeekViewCalendarState extends State<WeekViewCalendar> {
//   final List<String> _timeSlots = [
//     '8:00 AM',
//     '9:00 AM',
//     '10:00 AM',
//     '11:00 AM',
//     '12:00 PM',
//     '1:00 PM',
//     '2:00 PM',
//     '3:00 PM',
//     '4:00 PM',
//     '5:00 PM',
//     '6:00 PM',
//     '7:00 PM',
//     '8:00 PM',
//     '9:00 PM',
//     '10:00 PM',
//   ];

//   List<DateTime> get _weekDays {
//     final firstDayOfWeek = widget.currentDate.subtract(
//       Duration(days: widget.currentDate.weekday - 1),
//     );
//     return List.generate(
//       7,
//       (index) => firstDayOfWeek.add(Duration(days: index)),
//     );
//   }

//   List<Event> _getEventsForDayAndTime(DateTime day, String timeSlot) {
//     return widget.events.where((event) {
//       final eventDate = DateTime(
//         event.startTime.year,
//         event.startTime.month,
//         event.startTime.day,
//       );
//       final targetDate = DateTime(day.year, day.month, day.day);

//       if (eventDate != targetDate) return false;

//       final eventHour = event.startTime.hour;
//       final slotHour = _parseTimeSlot(timeSlot);

//       return eventHour == slotHour;
//     }).toList();
//   }

//   int _parseTimeSlot(String timeSlot) {
//     final parts = timeSlot.split(' ');
//     final timePart = parts[0];
//     final period = parts[1];

//     final timeParts = timePart.split(':');
//     var hour = int.parse(timeParts[0]);
//     final minute = int.parse(timeParts[1]);

//     if (period == 'PM' && hour != 12) hour += 12;
//     if (period == 'AM' && hour == 12) hour = 0;

//     return hour;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       child: Column(
//         children: [
//           // Week header with dates
//           _buildWeekHeader(),
//           // Calendar grid
//           Expanded(child: _buildCalendarGrid()),
//         ],
//       ),
//     );
//   }

//   Widget _buildWeekHeader() {
//     return Container(
//       height: 80,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
//       ),
//       child: Row(
//         children: [
//           // Time column header
//           Container(
//             width: 100,
//             alignment: Alignment.center,
//             child: const Text(
//               'Time',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//                 color: Colors.black87,
//               ),
//             ),
//           ),
//           // Day headers
//           ..._weekDays.map((day) {
//             final isToday = _isSameDay(day, DateTime.now());
//             return Expanded(
//               child: Container(
//                 decoration: BoxDecoration(
//                   border: Border(
//                     right: BorderSide(color: Colors.grey.shade300),
//                     left: BorderSide(color: Colors.grey.shade300),
//                   ),
//                   color: isToday ? Colors.blue.shade50 : Colors.white,
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       DateFormat('EEE').format(day),
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: isToday ? Colors.blue : Colors.grey.shade700,
//                         fontSize: 14,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Container(
//                       width: 32,
//                       height: 32,
//                       decoration: BoxDecoration(
//                         color: isToday ? Colors.blue : Colors.transparent,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Center(
//                         child: Text(
//                           DateFormat('d').format(day),
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: isToday ? Colors.white : Colors.black87,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }),
//         ],
//       ),
//     );
//   }

//   Widget _buildCalendarGrid() {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           // Time slots grid
//           ..._timeSlots.map((timeSlot) {
//             return Container(
//               height: 100, // Increased height for better event visibility
//               decoration: BoxDecoration(
//                 border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
//               ),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Time label
//                   Container(
//                     width: 100,
//                     padding: const EdgeInsets.all(8),
//                     child: Text(
//                       timeSlot,
//                       style: const TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ),
//                   // Day columns
//                   ..._weekDays.map((day) {
//                     final events = _getEventsForDayAndTime(day, timeSlot);
//                     return Expanded(
//                       child: Container(
//                         decoration: BoxDecoration(
//                           border: Border(
//                             right: BorderSide(color: Colors.grey.shade200),
//                             left: BorderSide(color: Colors.grey.shade200),
//                           ),
//                         ),
//                         child: Stack(
//                           children: [
//                             // Background
//                             Container(
//                               color: _isSameDay(day, DateTime.now())
//                                   ? Colors.blue.shade50
//                                   : Colors.white,
//                             ),
//                             // Events
//                             if (events.isNotEmpty)
//                               ...events.map((event) {
//                                 return GestureDetector(
//                                   onTap: () => widget.onEventTap(event),
//                                   child: Container(
//                                     margin: const EdgeInsets.all(2),
//                                     child: EventTile(event: event),
//                                   ),
//                                 );
//                               }),
//                           ],
//                         ),
//                       ),
//                     );
//                   }),
//                 ],
//               ),
//             );
//           }),
//         ],
//       ),
//     );
//   }

//   bool _isSameDay(DateTime date1, DateTime date2) {
//     return date1.year == date2.year &&
//         date1.month == date2.month &&
//         date1.day == date2.day;
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:schedule_app/model/Calender_model.dart';
// import 'package:schedule_app/model/Source/Data_sorce.dart';
// import 'package:schedule_app/widgets/event_card.dart';
// import 'package:syncfusion_flutter_calendar/calendar.dart';

// class WeekTimeCalendar extends StatelessWidget {
//   final List<CalendarEvent> events;
//   final DateTime? initialWeek;
//   final int startHour;
//   final int endHour;
//   final bool showWeekend;
//   final void Function(CalendarEvent event)? onEventTap;

//   const WeekTimeCalendar({
//     super.key,
//     required this.events,
//     this.initialWeek,
//     this.startHour = 8,
//     this.endHour = 18,
//     this.showWeekend = true,
//     this.onEventTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final List<Appointment> appts = events.map((e) {
//       return Appointment(
//         id: e,
//         startTime: e.start,
//         endTime: e.end,
//         subject: e.title,
//         notes: e.subtitle,
//         color: e.color.withOpacity(.18),
//       );
//     }).toList();

//     final dataSource = EventDataSource(appts);

//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final bool wide = constraints.maxWidth >= 720;
//         final CalendarView view = wide
//             ? (showWeekend ? CalendarView.week : CalendarView.workWeek)
//             : CalendarView.day;

//         return SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: SizedBox(
//             width: (showWeekend ? 7 : 5) * 200,
//             child: SfCalendar(
//               view: view,
//               dataSource: dataSource,
//               initialDisplayDate: initialWeek ?? DateTime.now(),
//               firstDayOfWeek: 1,
//               allowViewNavigation: true,
//               showCurrentTimeIndicator: true,
//               headerStyle: const CalendarHeaderStyle(
//                 textAlign: TextAlign.center,
//                 textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//               ),
//               viewHeaderHeight: 52,
//               viewHeaderStyle: const ViewHeaderStyle(
//                 dayTextStyle: TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 dateTextStyle: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               timeSlotViewSettings: TimeSlotViewSettings(
//                 startHour: startHour.toDouble(),
//                 endHour: endHour.toDouble(),
//                 timeInterval: const Duration(minutes: 60),
//                 timeFormat: 'h:mm a',
//                 timeRulerSize: 68,
//                 timeIntervalHeight: 100,
//                 timeIntervalWidth: 100,
//                 timeTextStyle: const TextStyle(fontSize: 12),
//               ),
//               appointmentBuilder: (context, details) {
//                 final appt = details.appointments.first as Appointment;
//                 return EventTile(appointment: appt);
//               },
//               onTap: (details) {
//                 if (details.targetElement == CalendarElement.appointment &&
//                     details.appointments != null &&
//                     details.appointments!.isNotEmpty) {
//                   final Appointment tapped =
//                       details.appointments!.first as Appointment;
//                   final CalendarEvent event = tapped.id as CalendarEvent;
//                   onEventTap?.call(event);
//                 }
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:schedule_app/controllers/calender_controller.dart';
import 'package:schedule_app/model/Calender_model.dart';
import 'package:schedule_app/model/Source/Data_sorce.dart';
import 'package:schedule_app/pages/booking_page.dart';
import 'package:schedule_app/widgets/event_card.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class WeekTimeCalendar extends StatefulWidget {
  final List<CalendarEvent> events;
  final DateTime? currentDate; // Changed from initialWeek to currentDate
  final int startHour;
  final int endHour;
  final bool showWeekend;
  final void Function(CalendarEvent event)? onEventTap;

  const WeekTimeCalendar({
    super.key,
    required this.events,
    this.currentDate, // Changed parameter name
    required this.startHour,
    required this.endHour,
    this.showWeekend = true,
    this.onEventTap,
    // required DateTime initialWeek,
  });

  @override
  State<WeekTimeCalendar> createState() => _WeekTimeCalendarState();
}

class _WeekTimeCalendarState extends State<WeekTimeCalendar> {
  late CalendarController _calendarController;
  CalendarsController calendController = Get.put(CalendarsController());

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  void didUpdateWidget(WeekTimeCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update the calendar display date when the currentDate changes
    if (widget.currentDate != null &&
        oldWidget.currentDate != widget.currentDate) {
      print("TESTING DATE");
      print(widget.currentDate);
      _calendarController.displayDate = widget.currentDate!;
    }
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Appointment> appts = calendController.events.map((e) {
      print("TESTING APPOINTMENT");
      print(e.id);
      print(e.start);
      print(e.end);
      print(e.title);
      print(e.subtitle);

      return Appointment(
        id: e.id,
        startTime: e.start,
        endTime: e.end,
        subject: e.title,
        notes: e.subtitle,
        color: e.color.withOpacity(.18),
      );
    }).toList();

    final dataSource = EventDataSource(appts);

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool wide = constraints.maxWidth >= 720;
        final CalendarView view = wide
            ? (widget.showWeekend ? CalendarView.week : CalendarView.workWeek)
            : CalendarView.day;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: (widget.showWeekend ? 7 : 5) * 200,
            child: SfCalendar(
              controller: _calendarController, // Add controller
              view: view,
              dataSource: dataSource,
              initialDisplayDate: widget.currentDate ?? DateTime.now(),
              firstDayOfWeek: 1,
              allowViewNavigation: true,
              showCurrentTimeIndicator: true,
              headerStyle: const CalendarHeaderStyle(
                textAlign: TextAlign.center,
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              viewHeaderHeight: 52,
              viewHeaderStyle: const ViewHeaderStyle(
                dayTextStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                dateTextStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              timeSlotViewSettings: TimeSlotViewSettings(
                startHour: widget.startHour.toDouble(),
                endHour: widget.endHour.toDouble(),
                timeInterval: const Duration(minutes: 60),
                timeFormat: 'h:mm a',
                timeRulerSize: 68,
                timeIntervalHeight: 150,
                timeIntervalWidth: 100,
                timeTextStyle: const TextStyle(fontSize: 12),
              ),
              appointmentBuilder: (context, details) {
                final appt = details.appointments.first as Appointment;

                return EventTile(appointment: appt);
              },
              onTap: (details) {
                Appointment tapped = details.appointments!.first as Appointment;
                CalendarEvent event = tapped.id as CalendarEvent;
                print(event.id);
                Get.to(BookingPage(selectedId: event.id));

                // print()
                // if (details.targetElement == CalendarElement.appointment &&
                //     details.appointments != null &&
                //     details.appointments!.isNotEmpty) {
                //   final Appointment tapped =
                //       details.appointments!.first as Appointment;
                //   final CalendarEvent event = tapped.id as CalendarEvent;
                //   widget.onEventTap?.call(event);
                //   print(event.id);
                // }
              },
            ),
          ),
        );
      },
    );
  }
}
