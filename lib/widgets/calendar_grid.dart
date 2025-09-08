// import 'package:flutter/material.dart';
// import '../theme/app_colors.dart';
// import 'event_card.dart';
// import 'current_time_indicator.dart';
// import 'event_popover.dart';

// class CalendarGrid extends StatefulWidget {
//   const CalendarGrid({super.key});

//   @override
//   State<CalendarGrid> createState() => _CalendarGridState();
// }

// class _CalendarGridState extends State<CalendarGrid> {
//   final List<String> _timeSlots = [
//     '9:00 AM',
//     '10:00 AM',
//     '11:00 AM',
//     '12:00 PM',
//     '1:00 PM',
//     '2:00 PM',
//     '3:00 PM',
//   ];

//   final List<String> _weekDays = [
//     'GMT +05:00',
//     '25 Apr, Monday',
//     '26 Apr, Tuesday',
//     '27 Apr, Wednesday',
//     '28 Apr, Thursday',
//     '29 May, Friday',
//     '30 May, Saturday',
//     '01 May, Sunday',
//   ];

//   // Sample events data
//   final List<Map<String, dynamic>> _events = [
//     {
//       'id': '124553',
//       'title': 'Consultation',
//       'duration': 'Half day (9:00 AM - 12:00 PM)',
//       'guests': 1000,
//       'timeRemaining': 'In 3 hour',
//       'day': 0, // Monday
//       'startHour': 0, // 9:00 AM
//       'endHour': 3, // 12:00 PM
//       'customerName': 'Kristin Watson',
//       'description':
//           'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do.',
//       'hall': 'Shadiyana marriage hall',
//       'timeRange': '10:00 AM - 2:00 PM',
//       'eventDate': DateTime(2025, 6, 30),
//     },
//     {
//       'id': '124554',
//       'title': 'Consultation',
//       'duration': 'Half day (9:00 AM - 12:00 PM)',
//       'guests': 1000,
//       'timeRemaining': '1 day',
//       'day': 1, // Tuesday
//       'startHour': 0,
//       'endHour': 3,
//       'customerName': 'John Smith',
//       'description':
//           'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do.',
//       'hall': 'Grand Ballroom',
//       'timeRange': '9:00 AM - 12:00 PM',
//       'eventDate': DateTime(2025, 6, 30),
//     },
//     {
//       'id': '124555',
//       'title': 'Consultation',
//       'duration': 'Half day (9:00 AM - 12:00 PM)',
//       'guests': 1000,
//       'timeRemaining': '1 day',
//       'day': 2, // Wednesday
//       'startHour': 0,
//       'endHour': 3,
//       'customerName': 'Sarah Johnson',
//       'description':
//           'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do.',
//       'hall': 'Conference Hall',
//       'timeRange': '9:00 AM - 12:00 PM',
//       'eventDate': DateTime(2025, 6, 30),
//     },
//     {
//       'id': '124556',
//       'title': 'Consultation',
//       'duration': 'Half day (9:00 AM - 12:00 PM)',
//       'guests': 1000,
//       'timeRemaining': '1 day',
//       'day': 3, // Thursday
//       'startHour': 0,
//       'endHour': 3,
//       'customerName': 'Mike Brown',
//       'description':
//           'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do.',
//       'hall': 'Event Center',
//       'timeRange': '9:00 AM - 12:00 PM',
//       'eventDate': DateTime(2025, 6, 30),
//     },
//     {
//       'id': '124557',
//       'title': 'Consultation',
//       'duration': 'Half day (9:00 AM - 12:00 PM)',
//       'guests': 1000,
//       'timeRemaining': '1 day',
//       'day': 4, // Friday
//       'startHour': 0,
//       'endHour': 3,
//       'customerName': 'Emily Davis',
//       'description':
//           'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do.',
//       'hall': 'Banquet Hall',
//       'timeRange': '9:00 AM - 12:00 PM',
//       'eventDate': DateTime(2025, 6, 30),
//     },
//     {
//       'id': '124558',
//       'title': 'Consultation',
//       'duration': 'Half day (9:00 AM - 12:00 PM)',
//       'guests': 1000,
//       'timeRemaining': '1 day',
//       'day': 5, // Saturday
//       'startHour': 0,
//       'endHour': 3,
//       'customerName': 'David Wilson',
//       'description':
//           'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do.',
//       'hall': 'Wedding Hall',
//       'timeRange': '9:00 AM - 12:00 PM',
//       'eventDate': DateTime(2025, 6, 30),
//     },
//     {
//       'id': '124559',
//       'title': 'Consultation',
//       'duration': 'Half day (9:00 AM - 12:00 PM)',
//       'guests': 1000,
//       'timeRemaining': '1 day',
//       'day': 6, // Sunday
//       'startHour': 0,
//       'endHour': 3,
//       'customerName': 'Lisa Anderson',
//       'description':
//           'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do.',
//       'hall': 'Reception Hall',
//       'timeRange': '9:00 AM - 12:00 PM',
//       'eventDate': DateTime(2025, 6, 30),
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: AppColors.surface,
//       child: Column(
//         children: [
//           // Header row with days
//           _buildHeaderRow(),

//           // Divider
//           const Divider(height: 1, color: AppColors.border),

//           // Calendar grid
//           Expanded(child: _buildCalendarGrid()),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeaderRow() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       color: AppColors.background,
//       child: Row(
//         children: _weekDays.map((day) {
//           final bool isTimeColumn = day == _weekDays.first;
//           return Expanded(
//             child: Text(
//               day,
//               textAlign: isTimeColumn ? TextAlign.left : TextAlign.center,
//               style: TextStyle(
//                 fontSize: isTimeColumn ? 12 : 14,
//                 fontWeight: FontWeight.w600,
//                 color: isTimeColumn
//                     ? AppColors.textSecondary
//                     : AppColors.textPrimary,
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }

//   Widget _buildCalendarGrid() {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         // Time column
//         Container(
//           width: 100,
//           padding: const EdgeInsets.symmetric(vertical: 8),
//           decoration: const BoxDecoration(
//             border: Border(right: BorderSide(color: AppColors.border)),
//           ),
//           child: Column(
//             children: _timeSlots.map((time) {
//               return Expanded(
//                 child: Container(
//                   alignment: Alignment.topRight,
//                   padding: const EdgeInsets.only(right: 8, top: 4),
//                   child: Text(
//                     time,
//                     style: const TextStyle(
//                       fontSize: 12,
//                       color: AppColors.textSecondary,
//                     ),
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//         ),

//         // Calendar grid
//         Expanded(
//           child: Stack(
//             children: [
//               // Grid lines
//               _buildGridLines(),

//               // Events
//               _buildEvents(),

//               // Current time indicator
//               _buildCurrentTimeIndicator(),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildGridLines() {
//     return Column(
//       children: List.generate(_timeSlots.length, (timeIndex) {
//         return Expanded(
//           child: Row(
//             children: List.generate(_weekDays.length - 1, (dayIndex) {
//               return Expanded(
//                 child: Container(
//                   decoration: const BoxDecoration(
//                     border: Border(
//                       right: BorderSide(color: AppColors.border),
//                       bottom: BorderSide(color: AppColors.border),
//                     ),
//                   ),
//                 ),
//               );
//             }),
//           ),
//         );
//       }),
//     );
//   }

//   Widget _buildEvents() {
//     return Stack(
//       children: _events.map((event) {
//         final double left =
//             (event['day'] * (MediaQuery.of(context).size.width - 100) / 7);
//         final double width = (MediaQuery.of(context).size.width - 100) / 7;
//         final double top =
//             (event['startHour'] *
//             (MediaQuery.of(context).size.height - 200) /
//             _timeSlots.length);
//         final double height =
//             ((event['endHour'] - event['startHour']) *
//             (MediaQuery.of(context).size.height - 200) /
//             _timeSlots.length);

//         return Positioned(
//           left: left + 4,
//           top: top + 4,
//           width: width - 8,
//           height: height - 8,
//           child: GestureDetector(
//             onTap: () => _showEventPopover(context, event),
//             child: EventCard(
//               title: event['title'],
//               duration: event['duration'],
//               guests: event['guests'],
//               timeRemaining: event['timeRemaining'],
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }

//   void _showEventPopover(BuildContext context, Map<String, dynamic> event) {
//     showDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (BuildContext context) {
//         return Stack(
//           children: [
//             // Backdrop
//             Positioned.fill(
//               child: GestureDetector(
//                 onTap: () => Navigator.of(context).pop(),
//                 child: Container(color: Colors.transparent),
//               ),
//             ),
//             // Popover positioned in center
//             Center(
//               child: EventPopover(
//                 bookingId: event['id'],
//                 customerName: event['customerName'],
//                 eventDescription: event['description'],
//                 hall: event['hall'],
//                 timeRange: event['timeRange'],
//                 eventDate: event['eventDate'],
//                 onEdit: () {
//                   Navigator.of(context).pop();
//                   _handleEditEvent(event);
//                 },
//                 onViewDetails: () {
//                   Navigator.of(context).pop();
//                   _handleViewDetails(event);
//                 },
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _handleEditEvent(Map<String, dynamic> event) {
//     // TODO: Implement edit functionality
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Edit event: ${event['title']}'),
//         backgroundColor: AppColors.primary,
//       ),
//     );
//   }

//   void _handleViewDetails(Map<String, dynamic> event) {
//     // TODO: Implement view details functionality
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('View details for: ${event['title']}'),
//         backgroundColor: AppColors.primary,
//       ),
//     );
//   }

//   Widget _buildCurrentTimeIndicator() {
//     return CurrentTimeIndicator(time: '12:00 PM', left: 0, right: 0);
//   }
// }
import 'package:flutter/material.dart';
import 'package:schedule_app/controllers/calender_controller.dart';
import 'package:schedule_app/model/event_model.dart';
import 'package:schedule_app/pages/Calender_Main/Sample_Data.dart';
import 'package:schedule_app/pages/Calender_Main/Week_Calender.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';
// import '../controllers/calendar_controller.dart';
import 'event_card.dart';
import 'event_popover.dart';

class CalendarGrid extends StatefulWidget {
  const CalendarGrid({super.key});

  @override
  State<CalendarGrid> createState() => _CalendarGridState();
}

class _CalendarGridState extends State<CalendarGrid> {
  // final CalendarController _calendarController = Get.put(CalendarController());
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    // _calendarController.loadEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: Column(
        children: [
          // Calendar
          Expanded(
            child:
                // Obx(
                //   () =>
                TableCalendar(
                  firstDay: DateTime.now().subtract(const Duration(days: 365)),
                  lastDay: DateTime.now().add(const Duration(days: 365)),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                    });
                  },
                  // eventLoader: (day) {
                  //   // return _calendarController.getEventsForDay(day);
                  // },
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    markerDecoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    markerSize: 6,
                    outsideDaysVisible: false,
                  ),
                  headerStyle: HeaderStyle(
                    titleCentered: true,
                    formatButtonVisible: true,
                    formatButtonShowsNext: false,
                    formatButtonDecoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    formatButtonTextStyle: const TextStyle(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    weekendStyle: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, day, events) {
                      if (events.isNotEmpty) {
                        return Positioned(
                          right: 1,
                          bottom: 1,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                events.length.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      return null;
                    },
                  ),
                ),
          ),
          // ),

          // Events list for selected day
          if (_selectedDay != null) _buildEventsList(),
        ],
      ),
    );
  }

  Widget _buildEventsList() {
    // final events = [];
    return WeekTimeCalendar(
      //TODO: Need to make this widget when we will make rest of the tabs
      events: events,

      // initialWeek: DateTime(2025, 4, 28),
      startHour: 9,
      endHour: 15,
      showWeekend: true,
      onEventTap: (e) {
        // handle tap
      },
    );

    // return Obx(() {
    //   // final events = _calendarController.getEventsForDay(_selectedDay!);
    //   // if (events.isEmpty) {
    //   //   return Container(
    //   //     padding: const EdgeInsets.all(16),
    //   //     child: const Text(
    //   //       'No events scheduled for this day',
    //   //       style: TextStyle(color: AppColors.textSecondary),
    //   //     ),
    //   //   );
    //   // }

    //   return Expanded(
    //     flex: 1,
    //     child: Container(
    //       padding: const EdgeInsets.all(16),
    //       decoration: const BoxDecoration(
    //         border: Border(top: BorderSide(color: AppColors.border)),
    //       ),
    //       child: ListView.builder(
    //         itemCount: events.length,
    //         itemBuilder: (context, index) {
    //           final event = events[index];
    //           return EventCard(
    //             title: event.title,
    //             duration: event.duration,
    //             guests: event.guests,
    //             timeRemaining: event.timeRemaining,
    //             onTap: () => _showEventPopover(context, event),
    //           );
    //         },
    //       ),
    //     ),
    //   );
    // });
  }

  void _showEventPopover(BuildContext context, Event event) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Stack(
          children: [
            // Backdrop
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(color: Colors.transparent),
              ),
            ),
            // Popover positioned in center
            Center(
              child: EventPopover(
                bookingId: event.id,
                customerName: event.customerName,
                eventDescription: event.specialRequirements.isNotEmpty
                    ? event.specialRequirements
                    : 'No special requirements',
                hall: event.hall,
                timeRange: event.timeRange,
                eventDate: event.startTime,
                onEdit: () {
                  Navigator.of(context).pop();
                  _handleEditEvent(event);
                },
                onViewDetails: () {
                  Navigator.of(context).pop();
                  _handleViewDetails(event);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleEditEvent(Event event) {
    // TODO: Implement edit functionality
    Get.snackbar(
      'Edit Event',
      'Edit functionality for ${event.title}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.primary,
    );
  }

  void _handleViewDetails(Event event) {
    // TODO: Implement view details functionality
    Get.snackbar(
      'Event Details',
      'View details for ${event.title}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.primary,
    );
  }
}
