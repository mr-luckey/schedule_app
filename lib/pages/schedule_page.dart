// // import 'package:flutter/material.dart';
// // import 'package:responsive_framework/responsive_framework.dart';
// // import 'package:intl/intl.dart';
// // import 'package:schedule_app/APIS/Api_Service.dart';
// // import 'package:schedule_app/model/event_model.dart';
// // import 'package:schedule_app/widgets/event_card.dart';
// // // import 'package:schedule_app/widgets/event_tile.dart';
// // import '../theme/app_colors.dart';
// // import '../widgets/sidebar.dart';
// // import '../pages/booking_page.dart';

// // // Internal helper for overlap layout
// // class _LaneInfo {
// //   final Event event;
// //   final int lane;
// //   final int lanesCount;
// //   _LaneInfo(this.event, this.lane, this.lanesCount);
// // }

// // class SchedulePageFixed extends StatefulWidget {
// //   const SchedulePageFixed({super.key});

// //   @override
// //   State<SchedulePageFixed> createState() => _SchedulePageFixedState();
// // }

// // class _SchedulePageFixedState extends State<SchedulePageFixed> {
// //   DateTime _currentDate = DateTime.now();
// //   String _selectedView = 'Week';
// //   bool _showBookingPage = false;
// //   late Future<List<Event>> _eventsFuture;
// //   // List<Event> _events = [];
// //   final ScrollController _verticalScrollController = ScrollController();

// //   @override
// //   void initState() {
// //     super.initState();
// //     _eventsFuture = _fetchEvents();
// //   }

// //   @override
// //   void dispose() {
// //     _verticalScrollController.dispose();
// //     super.dispose();
// //   }

// //   Future<List<Event>> _fetchEvents() async {
// //     try {
// //       print('🚀 Starting to fetch events...');
// //       final List<Event> orders = await ApiService.getOrders();
// //       print('✅ Successfully fetched ${orders.length} events');

// //       // Log each event for debugging
// //       for (var event in orders) {
// //         print(
// //           '📅 Event: ${event.title} | ${event.startTime} | ${event.endTime} | Guests: ${event.guests}',
// //         );
// //       }

// //       return orders;
// //     } catch (e) {
// //       print('❌ Error in _fetchEvents: $e');
// //       // Return sample data for testing
// //       return _getSampleEvents();
// //     }
// //   }

// //   List<Event> _getSampleEvents() {
// //     return [];
// //     // final now = DateTime.now();
// //     // return [
// //     //   Event(
// //     //     id: '1',
// //     //     title: 'Consultation',
// //     //     startTime: DateTime(now.year, now.month, now.day, 9, 0),
// //     //     endTime: DateTime(now.year, now.month, now.day, 12, 0),
// //     //     customerName: 'John Doe',
// //     //     hall: 'Main Hall',
// //     //     timeRange: '9:00 AM - 12:00 PM',
// //     //     specialRequirements: 'Guests: 1000',
// //     //     guests: 1000,
// //     //     color: const Color(0xFF22C55E),
// //     //   ),
// //     //   Event(
// //     //     id: '2',
// //     //     title: 'Wedding',
// //     //     startTime: DateTime(now.year, now.month, now.day + 1, 15, 0),
// //     //     endTime: DateTime(now.year, now.month, now.day + 1, 20, 0),
// //     //     customerName: 'Jane Smith',
// //     //     hall: 'Grand Hall',
// //     //     timeRange: '3:00 PM - 8:00 PM',
// //     //     specialRequirements: 'Guests: 500',
// //     //     guests: 500,
// //     //     color: const Color(0xFF3B82F6),
// //     //   ),
// //     //   Event(
// //     //     id: '3',
// //     //     title: 'Birthday Party',
// //     //     startTime: DateTime(now.year, now.month, now.day + 2, 18, 0),
// //     //     endTime: DateTime(now.year, now.month, now.day + 2, 22, 0),
// //     //     customerName: 'Mike Johnson',
// //     //     hall: 'Party Room',
// //     //     timeRange: '6:00 PM - 10:00 PM',
// //     //     specialRequirements: 'Guests: 150',
// //     //     guests: 150,
// //     //     color: const Color(0xFF8B5CF6),
// //     //   ),
// //     // ];
// //   }

// //   void _refreshEvents() {
// //     setState(() {
// //       _eventsFuture = _fetchEvents();
// //     });
// //   }

// //   void _goToToday() {
// //     setState(() {
// //       _currentDate = DateTime.now();
// //     });
// //   }

// //   void _navigateWeek(int direction) {
// //     setState(() {
// //       _currentDate = _currentDate.add(Duration(days: direction * 7));
// //     });
// //   }

// //   // View toggle placeholder (unused)

// //   void _toggleBookingPage() {
// //     setState(() {
// //       _showBookingPage = !_showBookingPage;
// //     });
// //   }

// //   Widget _buildScheduleHeader() {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
// //       decoration: const BoxDecoration(
// //         color: AppColors.surface,
// //         border: Border(bottom: BorderSide(color: AppColors.border)),
// //       ),
// //       child: Row(
// //         children: [
// //           const Text(
// //             'Booking Schedule',
// //             style: TextStyle(
// //               fontSize: 24,
// //               fontWeight: FontWeight.bold,
// //               color: AppColors.textPrimary,
// //             ),
// //           ),
// //           const SizedBox(width: 24),
// //           TextButton(
// //             onPressed: _goToToday,
// //             style: TextButton.styleFrom(
// //               foregroundColor: AppColors.primary,
// //               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// //             ),
// //             child: const Text('Today'),
// //           ),
// //           const SizedBox(width: 16),
// //           Row(
// //             children: [
// //               IconButton(
// //                 onPressed: () => _navigateWeek(-1),
// //                 icon: const Icon(Icons.chevron_left),
// //                 style: IconButton.styleFrom(
// //                   foregroundColor: AppColors.textSecondary,
// //                 ),
// //               ),
// //               Text(
// //                 DateFormat('MMMM d, yyyy').format(_currentDate),
// //                 style: const TextStyle(
// //                   fontSize: 16,
// //                   fontWeight: FontWeight.w600,
// //                   color: AppColors.textPrimary,
// //                 ),
// //               ),
// //               IconButton(
// //                 onPressed: () => _navigateWeek(1),
// //                 icon: const Icon(Icons.chevron_right),
// //                 style: IconButton.styleFrom(
// //                   foregroundColor: AppColors.textSecondary,
// //                 ),
// //               ),
// //             ],
// //           ),
// //           const Spacer(),
// //           ElevatedButton.icon(
// //             onPressed: _toggleBookingPage,
// //             icon: const Icon(Icons.add, size: 18),
// //             label: Text(_showBookingPage ? 'View Schedule' : 'New Booking'),
// //             style: ElevatedButton.styleFrom(
// //               backgroundColor: AppColors.primary,
// //               foregroundColor: Colors.white,
// //               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// //             ),
// //           ),
// //           const SizedBox(width: 16),
// //           IconButton(
// //             onPressed: _refreshEvents,
// //             icon: const Icon(Icons.refresh),
// //             tooltip: 'Refresh Events',
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildEventList(List<Event> events) {
// //     // Filter events for the current week
// //     final startOfWeek = _currentDate.subtract(
// //       Duration(days: _currentDate.weekday - 1),
// //     );
// //     final endOfWeek = startOfWeek.add(const Duration(days: 7));

// //     final weekEvents = events.where((event) {
// //       return event.startTime.isAfter(startOfWeek) &&
// //           event.startTime.isBefore(endOfWeek);
// //     }).toList();

// //     if (weekEvents.isEmpty) {
// //       return Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
// //             const SizedBox(height: 16),
// //             Text(
// //               'No events this week',
// //               style: TextStyle(color: Colors.grey[600], fontSize: 18),
// //             ),
// //             const SizedBox(height: 8),
// //             Text(
// //               'Create a new booking to get started',
// //               style: TextStyle(color: Colors.grey[500]),
// //             ),
// //           ],
// //         ),
// //       );
// //     }

// //     return ListView.builder(
// //       padding: const EdgeInsets.all(16),
// //       itemCount: weekEvents.length,
// //       itemBuilder: (context, index) {
// //         final event = weekEvents[index];
// //         return Card(
// //           margin: const EdgeInsets.only(bottom: 12),
// //           child: Padding(
// //             padding: const EdgeInsets.all(16),
// //             child: Row(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 // Date indicator
// //                 Container(
// //                   width: 60,
// //                   padding: const EdgeInsets.all(8),
// //                   decoration: BoxDecoration(
// //                     color: event.color.withOpacity(0.1),
// //                     borderRadius: BorderRadius.circular(8),
// //                   ),
// //                   child: Column(
// //                     children: [
// //                       Text(
// //                         DateFormat('MMM').format(event.startTime),
// //                         style: TextStyle(
// //                           fontSize: 14,
// //                           fontWeight: FontWeight.bold,
// //                           color: event.color,
// //                         ),
// //                       ),
// //                       Text(
// //                         DateFormat('dd').format(event.startTime),
// //                         style: TextStyle(
// //                           fontSize: 20,
// //                           fontWeight: FontWeight.bold,
// //                           color: event.color,
// //                         ),
// //                       ),
// //                       Text(
// //                         DateFormat('EEE').format(event.startTime),
// //                         style: TextStyle(fontSize: 12, color: event.color),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 const SizedBox(width: 16),
// //                 // Event details
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Text(
// //                         event.title,
// //                         style: const TextStyle(
// //                           fontSize: 18,
// //                           fontWeight: FontWeight.bold,
// //                         ),
// //                       ),
// //                       const SizedBox(height: 8),
// //                       Row(
// //                         children: [
// //                           Icon(Icons.person, size: 16, color: Colors.grey[600]),
// //                           const SizedBox(width: 4),
// //                           Text(
// //                             event.customerName,
// //                             style: TextStyle(color: Colors.grey[600]),
// //                           ),
// //                           const SizedBox(width: 16),
// //                           Icon(Icons.people, size: 16, color: Colors.grey[600]),
// //                           const SizedBox(width: 4),
// //                           Text(
// //                             '${event.guests ?? 0} guests',
// //                             style: TextStyle(color: Colors.grey[600]),
// //                           ),
// //                         ],
// //                       ),
// //                       const SizedBox(height: 4),
// //                       Row(
// //                         children: [
// //                           Icon(
// //                             Icons.access_time,
// //                             size: 16,
// //                             color: Colors.grey[600],
// //                           ),
// //                           const SizedBox(width: 4),
// //                           Text(
// //                             event.timeRange,
// //                             style: TextStyle(color: Colors.grey[600]),
// //                           ),
// //                           const SizedBox(width: 16),
// //                           Icon(Icons.place, size: 16, color: Colors.grey[600]),
// //                           const SizedBox(width: 4),
// //                           Text(
// //                             event.hall,
// //                             style: TextStyle(color: Colors.grey[600]),
// //                           ),
// //                         ],
// //                       ),
// //                       if (event.specialRequirements.isNotEmpty) ...[
// //                         const SizedBox(height: 8),
// //                         Text(
// //                           'Requirements: ${event.specialRequirements}',
// //                           style: TextStyle(
// //                             color: Colors.grey[600],
// //                             fontStyle: FontStyle.italic,
// //                           ),
// //                         ),
// //                       ],
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   Widget _buildCalendarView(List<Event> events) {
// //     const double hourHeight = 80; // pixel height per hour
// //     const double timeGutterWidth = 80;

// //     DateTime startOfWeek = _currentDate.subtract(
// //       Duration(days: _currentDate.weekday - 1),
// //     );
// //     DateTime endOfWeek = startOfWeek.add(const Duration(days: 7));

// //     List<Event> weekEvents = events.where((e) {
// //       return !e.startTime.isBefore(startOfWeek) &&
// //           e.startTime.isBefore(endOfWeek);
// //     }).toList();

// //     double _topFor(DateTime time) {
// //       final minutes = time.hour * 60 + time.minute;
// //       return minutes / 60.0 * hourHeight;
// //     }

// //     double _heightFor(DateTime start, DateTime end) {
// //       final minutes = end.difference(start).inMinutes.clamp(15, 24 * 60);
// //       return minutes / 60.0 * hourHeight;
// //     }

// //     List<Event> eventsForDay(DateTime day) {
// //       return weekEvents
// //           .where(
// //             (e) =>
// //                 e.startTime.year == day.year &&
// //                 e.startTime.month == day.month &&
// //                 e.startTime.day == day.day,
// //           )
// //           .toList()
// //         ..sort((a, b) => a.startTime.compareTo(b.startTime));
// //     }

// //     bool _overlaps(Event a, Event b) {
// //       return a.startTime.isBefore(b.endTime) && b.startTime.isBefore(a.endTime);
// //     }

// //     List<_LaneInfo> _layoutDayEvents(List<Event> dayEvents) {
// //       if (dayEvents.isEmpty) return const [];

// //       final int n = dayEvents.length;
// //       final List<int> laneOf = List.filled(n, -1);

// //       // Greedy lane assignment
// //       final List<DateTime?> laneEndTimes = [];
// //       for (int i = 0; i < n; i++) {
// //         final e = dayEvents[i];
// //         bool placed = false;
// //         for (int l = 0; l < laneEndTimes.length; l++) {
// //           if (laneEndTimes[l] == null ||
// //               !e.startTime.isBefore(laneEndTimes[l]!)) {
// //             laneOf[i] = l;
// //             laneEndTimes[l] = e.endTime;
// //             placed = true;
// //             break;
// //           }
// //         }
// //         if (!placed) {
// //           laneOf[i] = laneEndTimes.length;
// //           laneEndTimes.add(e.endTime);
// //         }
// //       }

// //       // Approximate lanes count per event by counting overlaps
// //       final List<int> lanesCount = List.filled(n, 1);
// //       for (int i = 0; i < n; i++) {
// //         int count = 1;
// //         for (int j = 0; j < n; j++) {
// //           if (i == j) continue;
// //           if (_overlaps(dayEvents[i], dayEvents[j])) count++;
// //         }
// //         lanesCount[i] = count.clamp(1, laneEndTimes.length);
// //       }

// //       return List.generate(
// //         n,
// //         (i) => _LaneInfo(dayEvents[i], laneOf[i], lanesCount[i]),
// //       );
// //     }

// //     Widget buildDayHeader(DateTime day) {
// //       final bool isToday =
// //           DateTime.now().year == day.year &&
// //           DateTime.now().month == day.month &&
// //           DateTime.now().day == day.day;
// //       return Column(
// //         children: [
// //           Text(
// //             DateFormat('EEE').format(day),
// //             style: TextStyle(
// //               fontWeight: FontWeight.bold,
// //               color: isToday ? AppColors.primary : Colors.black,
// //             ),
// //           ),
// //           const SizedBox(height: 4),
// //           Text(
// //             DateFormat('d').format(day),
// //             style: TextStyle(
// //               fontSize: 18,
// //               fontWeight: FontWeight.bold,
// //               color: isToday ? AppColors.primary : Colors.black,
// //             ),
// //           ),
// //         ],
// //       );
// //     }

// //     // Build red current-time line position
// //     double? nowTop() {
// //       final now = DateTime.now();
// //       if (now.isBefore(startOfWeek) || now.isAfter(endOfWeek)) return null;
// //       return _topFor(now);
// //     }

// //     final totalHeight = hourHeight * 24;

// //     return Column(
// //       children: [
// //         // Header: blank cell for time gutter + 7 day headers
// //         Container(
// //           padding: const EdgeInsets.symmetric(vertical: 8),
// //           decoration: BoxDecoration(
// //             border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
// //           ),
// //           child: Row(
// //             children: [
// //               SizedBox(width: timeGutterWidth),
// //               ...List.generate(7, (i) {
// //                 final day = startOfWeek.add(Duration(days: i));
// //                 return Expanded(child: buildDayHeader(day));
// //               }),
// //             ],
// //           ),
// //         ),
// //         Expanded(
// //           child: SingleChildScrollView(
// //             controller: _verticalScrollController,
// //             child: SizedBox(
// //               height: totalHeight,
// //               child: Row(
// //                 children: [
// //                   // Time gutter (scrolls with the grid because wrapped together)
// //                   SizedBox(
// //                     width: timeGutterWidth,
// //                     child: Column(
// //                       children: List.generate(
// //                         24,
// //                         (h) => Container(
// //                           height: hourHeight,
// //                           alignment: Alignment.topRight,
// //                           padding: const EdgeInsets.only(right: 8, top: 2),
// //                           child: Text(
// //                             '${h.toString().padLeft(2, '0')}:00',
// //                             style: const TextStyle(fontWeight: FontWeight.bold),
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                   // Calendar area with days as columns and stacked events
// //                   Expanded(
// //                     child: Stack(
// //                       children: [
// //                         Row(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: List.generate(7, (i) {
// //                             final day = startOfWeek.add(Duration(days: i));
// //                             final dayEvents = eventsForDay(day);
// //                             return Expanded(
// //                               child: Container(
// //                                 decoration: BoxDecoration(
// //                                   border: Border(
// //                                     right: BorderSide(color: Colors.grey[200]!),
// //                                   ),
// //                                 ),
// //                                 child: LayoutBuilder(
// //                                   builder: (context, constraints) {
// //                                     final positioned = _layoutDayEvents(
// //                                       dayEvents,
// //                                     );
// //                                     final double columnPadding =
// //                                         8.0; // 4 left + 4 right
// //                                     return Stack(
// //                                       children: [
// //                                         // Hour lines
// //                                         Column(
// //                                           children: List.generate(24, (h) {
// //                                             return Container(
// //                                               height: hourHeight,
// //                                               decoration: BoxDecoration(
// //                                                 border: Border(
// //                                                   bottom: BorderSide(
// //                                                     color: Colors.grey[200]!,
// //                                                   ),
// //                                                 ),
// //                                               ),
// //                                             );
// //                                           }),
// //                                         ),
// //                                         // Events positioned by time and duration (with overlap lanes)
// //                                         ...positioned.map((info) {
// //                                           final top = _topFor(
// //                                             info.event.startTime,
// //                                           );
// //                                           final height = _heightFor(
// //                                             info.event.startTime,
// //                                             info.event.endTime,
// //                                           );
// //                                           final double usableWidth =
// //                                               constraints.maxWidth -
// //                                               columnPadding;
// //                                           final int lanes = info.lanesCount > 0
// //                                               ? info.lanesCount
// //                                               : 1;
// //                                           final double laneWidth =
// //                                               usableWidth / lanes;
// //                                           final double left =
// //                                               4 + laneWidth * info.lane;
// //                                           final double right =
// //                                               4 +
// //                                               laneWidth *
// //                                                   (lanes - info.lane - 1);
// //                                           return Positioned(
// //                                             top: top + 2,
// //                                             left: left,
// //                                             right: right,
// //                                             height: height - 4,
// //                                             child: EventTile(event: info.event),
// //                                           );
// //                                         }).toList(),
// //                                       ],
// //                                     );
// //                                   },
// //                                 ),
// //                               ),
// //                             );
// //                           }),
// //                         ),
// //                         // Current time line across all days
// //                         if (nowTop() != null)
// //                           Positioned(
// //                             top: nowTop(),
// //                             left: 0,
// //                             right: 0,
// //                             child: Container(height: 1, color: Colors.red),
// //                           ),
// //                       ],
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
// //     // final bool isTablet = ResponsiveBreakpoints.of(
// //     //   context,
// //     // ).between(TABLET, DESKTOP);

// //     Widget body = FutureBuilder<List<Event>>(
// //       future: _eventsFuture,
// //       builder: (context, snapshot) {
// //         if (snapshot.connectionState == ConnectionState.waiting) {
// //           return const Center(child: CircularProgressIndicator());
// //         } else if (snapshot.hasError) {
// //           return Center(
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 const Icon(Icons.error, size: 64, color: Colors.red),
// //                 const SizedBox(height: 16),
// //                 Text(
// //                   'Error loading events',
// //                   style: TextStyle(color: Colors.grey[600], fontSize: 18),
// //                 ),
// //                 const SizedBox(height: 8),
// //                 Text(
// //                   '${snapshot.error}',
// //                   style: TextStyle(color: Colors.grey[500]),
// //                   textAlign: TextAlign.center,
// //                 ),
// //                 const SizedBox(height: 16),
// //                 ElevatedButton(
// //                   onPressed: _refreshEvents,
// //                   child: const Text('Retry'),
// //                 ),
// //               ],
// //             ),
// //           );
// //         } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
// //           final events = snapshot.data!;
// //           return _selectedView == 'Week'
// //               ? _buildCalendarView(events)
// //               : _buildEventList(events);
// //         } else {
// //           return Center(
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
// //                 const SizedBox(height: 16),
// //                 Text(
// //                   'No events found',
// //                   style: TextStyle(color: Colors.grey[600], fontSize: 18),
// //                 ),
// //                 const SizedBox(height: 8),
// //                 Text(
// //                   'Create your first booking to get started',
// //                   style: TextStyle(color: Colors.grey[500]),
// //                 ),
// //                 const SizedBox(height: 16),
// //                 ElevatedButton(
// //                   onPressed: _toggleBookingPage,
// //                   child: const Text('Create Booking'),
// //                 ),
// //               ],
// //             ),
// //           );
// //         }
// //       },
// //     );

// //     if (isMobile) {
// //       return Scaffold(
// //         backgroundColor: AppColors.background,
// //         body: Column(
// //           children: [
// //             _buildScheduleHeader(),
// //             if (_showBookingPage)
// //               Expanded(child: BookingPage())
// //             else
// //               Expanded(child: body),
// //           ],
// //         ),
// //       );
// //     } else {
// //       return Scaffold(
// //         backgroundColor: AppColors.background,
// //         body: Row(
// //           children: [
// //             if (!isMobile) const Sidebar(),
// //             Expanded(
// //               child: Column(
// //                 children: [
// //                   _buildScheduleHeader(),
// //                   if (_showBookingPage)
// //                     Expanded(child: BookingPage())
// //                   else
// //                     Expanded(child: body),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       );
// //     }
// //   }
// // }
// // import 'package:flutter/material.dart';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';

// import 'package:responsive_framework/responsive_framework.dart';
// import 'package:intl/intl.dart';
// import 'package:schedule_app/controllers/calender_controller.dart';
// import 'package:schedule_app/pages/Calender_Main/Week_Calender.dart';

// import '../theme/app_colors.dart';
// import '../widgets/sidebar.dart';
// import '../widgets/calendar_grid.dart';
// import '../pages/booking_page.dart';

// class SchedulePage extends StatefulWidget {
//   const SchedulePage({super.key});

//   @override
//   State<SchedulePage> createState() => _SchedulePageState();
// }

// class _SchedulePageState extends State<SchedulePage> {
//   // State variables from ScheduleHeader

//   DateTime _currentDate = DateTime.now();
//   String _selectedView = 'Week';
//   bool showEmptyContainer = false; // New state variable to toggle container

//   CalendarsController calendarsController = Get.put(CalendarsController());

//   @override
//   void initState() {
//     super.initState();
//     // Ensure events are loaded whenever this page is opened
//     calendarsController.loadEventsFromApi();
//   }

//   // Methods from ScheduleHeader
//   void _goToToday() {
//     setState(() {
//       _currentDate = DateTime.now();
//     });
//   }

//   void _navigateWeek(int direction) {
//     setState(() {
//       _currentDate = _currentDate.add(Duration(days: direction * 7));
//     });
//   }

//   void _setView(String view) {
//     setState(() {
//       _selectedView = view;
//     });
//   }

//   // Toggle function for the New Schedule button
//   void _toggleEmptyContainer() {
//     setState(() {
//       showEmptyContainer = !showEmptyContainer;
//     });
//   }

//   // Build method for the header content
//   Widget _buildScheduleHeader() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//       decoration: const BoxDecoration(
//         color: AppColors.surface,
//         border: Border(bottom: BorderSide(color: AppColors.border)),
//       ),
//       child: Row(
//         children: [
//           // Title
//           const Text(
//             'Booking Schedule',
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: AppColors.textPrimary,
//             ),
//           ),

//           const SizedBox(width: 24),

//           // Today button
//           TextButton(
//             onPressed: _goToToday,
//             style: TextButton.styleFrom(
//               foregroundColor: AppColors.primary,
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             ),
//             child: const Text('Today'),
//           ),

//           const SizedBox(width: 16),

//           // Date navigation
//           Row(
//             children: [
//               IconButton(
//                 onPressed: () => _navigateWeek(-1),
//                 icon: const Icon(Icons.chevron_left),
//                 style: IconButton.styleFrom(
//                   foregroundColor: AppColors.textSecondary,
//                 ),
//               ),
//               Text(
//                 DateFormat('MMMM d, yyyy').format(_currentDate),
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: AppColors.textPrimary,
//                 ),
//               ),
//               IconButton(
//                 onPressed: () => _navigateWeek(1),
//                 icon: const Icon(Icons.chevron_right),
//                 style: IconButton.styleFrom(
//                   foregroundColor: AppColors.textSecondary,
//                 ),
//               ),
//             ],
//           ),

//           const Spacer(),

//           // New Schedule button
//           ElevatedButton.icon(
//             onPressed: _toggleEmptyContainer,
//             icon: const Icon(Icons.add, size: 18),
//             label: const Text('New Schedule'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.primary,
//               foregroundColor: Colors.white,
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             ),
//           ),

//           const SizedBox(width: 16),

//           // View switcher
//           Container(
//             decoration: BoxDecoration(
//               color: AppColors.background,
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: AppColors.border),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 _buildViewButton('Day'),
//                 _buildViewButton('Week'),
//                 _buildViewButton('Month'),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildViewButton(String view) {
//     final bool isSelected = _selectedView == view;
//     return GestureDetector(
//       onTap: () => _setView(view),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: BoxDecoration(
//           color: isSelected ? AppColors.primary : Colors.transparent,
//           borderRadius: BorderRadius.circular(6),
//         ),
//         child: Text(
//           view,
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             color: isSelected ? Colors.white : AppColors.textSecondary,
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Get.put(BookingController());

//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: ResponsiveBreakpoints.builder(
//         child: _buildLayout(context),
//         breakpoints: const [
//           Breakpoint(start: 0, end: 599, name: MOBILE),
//           Breakpoint(start: 600, end: 1023, name: TABLET),
//           Breakpoint(start: 1024, end: 1439, name: DESKTOP),
//           Breakpoint(start: 1440, end: double.infinity, name: '4K'),
//         ],
//       ),
//     );
//   }

//   Widget _buildLayout(BuildContext context) {
//     final bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
//     final bool isTablet = ResponsiveBreakpoints.of(
//       context,
//     ).between(TABLET, DESKTOP);

//     if (isMobile) {
//       return _buildMobileLayout();
//     } else if (isTablet) {
//       return _buildTabletLayout();
//     } else {
//       return _buildDesktopLayout();
//     }
//   }

//   Widget _buildMobileLayout() {
//     return Column(
//       children: [
//         // Header for mobile
//         _buildScheduleHeader(),

//         // // Conditional rendering based on button state
//         // showEmptyContainer
//         //     ? Expanded(
//         //         child: Container(),
//         //       ) // Empty container when button is pressed
//         //     :
//         const Expanded(child: CalendarGrid()), // Calendar grid for mobile
//       ],
//     );
//   }

//   Widget _buildTabletLayout() {
//     return Row(
//       children: [
//         // Sidebar for tablet (narrower)
//         const SizedBox(width: 240, child: Sidebar()),

//         // Main content
//         Expanded(
//           child: Column(
//             children: [
//               _buildScheduleHeader(),

//               Expanded(
//                 child: Obx(() {
//                   final events = calendarsController.events.toList();
//                   return WeekTimeCalendar(
//                     events: events,
//                     currentDate: _currentDate,
//                     // initialWeek: DateTime(2025, 4, 28),
//                     startHour: 9,
//                     endHour: 24,
//                     showWeekend: true,
//                     onEventTap: (e) {
//                       // handle tap
//                     },
//                   );
//                 }),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildDesktopLayout() {
//     return Row(
//       children: [
//         // Sidebar for desktop
//         const Sidebar(),

//         // Main content
//         Expanded(
//           child: Column(
//             children: [
//               _buildScheduleHeader(),
//               // Conditional rendering based on button state
//               showEmptyContainer
//                   ? Expanded(
//                       child: BookingPage(),
//                     ) // Empty container when button is pressed
//                   : Expanded(
//                       child: Obx(() {
//                         final events = calendarsController.events.toList();
//                         return WeekTimeCalendar(
//                           events: events,
//                           currentDate:
//                               _currentDate, // Use the current date from state
//                           startHour: 8,
//                           endHour: 24,
//                           showWeekend: true,
//                           onEventTap: (e) {
//                             // handle tap
//                           },
//                         );
//                       }),
//                     ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:intl/intl.dart';
import 'package:schedule_app/controllers/calender_controller.dart';
import 'package:schedule_app/pages/Calender_Main/Week_Calender.dart';
import 'package:schedule_app/pages/List/ListScreen.dart';
import 'package:table_calendar/table_calendar.dart';

import '../theme/app_colors.dart';
import '../widgets/calendar_grid.dart';
import '../pages/booking_page.dart';
import '../widgets/filter_button.dart';
import '../widgets/nav_item.dart';

// Define the different sections of the app
enum AppSection { bookings, orders, users, settings }

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  DateTime _currentDate = DateTime.now();
  String _selectedView = 'Week';
  bool showEmptyContainer = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Track current section
  AppSection _currentSection = AppSection.bookings;

  CalendarsController calendarsController = Get.put(CalendarsController());

  @override
  void initState() {
    super.initState();
    calendarsController.loadEventsFromApi();
  }

  void _goToToday() {
    setState(() {
      _currentDate = DateTime.now();
    });
  }

  void _navigateWeek(int direction) {
    setState(() {
      _currentDate = _currentDate.add(Duration(days: direction * 7));
    });
  }

  void _setView(String view) {
    setState(() {
      _selectedView = view;
    });
  }

  void _toggleEmptyContainer() {
    setState(() {
      showEmptyContainer = !showEmptyContainer;
    });
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  // Method to change current section
  void _changeSection(AppSection section) {
    setState(() {
      _currentSection = section;
    });
    // Close drawer if on mobile
    if (ResponsiveBreakpoints.of(context).smallerThan(TABLET)) {
      Navigator.pop(context);
    }
  }

  Widget _buildScheduleHeader() {
    String headerTitle;
    switch (_currentSection) {
      case AppSection.bookings:
        headerTitle = 'Booking Schedule';
        break;
      case AppSection.orders:
        headerTitle = 'Orders';
        break;
      case AppSection.users:
        headerTitle = 'Users';
        break;
      case AppSection.settings:
        headerTitle = 'Settings';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          // Menu button for mobile to open drawer
          if (ResponsiveBreakpoints.of(context).smallerThan(TABLET))
            IconButton(
              onPressed: _openDrawer,
              icon: const Icon(Icons.menu),
              style: IconButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
              ),
            ),

          const SizedBox(width: 12),

          // Title - changes based on section
          Text(
            headerTitle,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),

          // Only show calendar controls in bookings section
          if (_currentSection == AppSection.bookings) ...[
            const SizedBox(width: 24),

            // Today button
            TextButton(
              onPressed: _goToToday,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              child: const Text('Today'),
            ),

            const SizedBox(width: 16),

            // Date navigation
            Row(
              children: [
                IconButton(
                  onPressed: () => _navigateWeek(-1),
                  icon: const Icon(Icons.chevron_left),
                  style: IconButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                  ),
                ),
                Text(
                  DateFormat('MMMM d, yyyy').format(_currentDate),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  onPressed: () => _navigateWeek(1),
                  icon: const Icon(Icons.chevron_right),
                  style: IconButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],

          const Spacer(),

          // Show New Schedule button only in bookings section
          if (_currentSection == AppSection.bookings) ...[
            ElevatedButton.icon(
              onPressed: _toggleEmptyContainer,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('New Schedule'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),

            const SizedBox(width: 16),

            // View switcher (only show on tablet/desktop and in bookings section)
            if (!ResponsiveBreakpoints.of(context).smallerThan(TABLET))
              Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildViewButton('Day'),
                    _buildViewButton('Week'),
                    _buildViewButton('Month'),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildViewButton(String view) {
    final bool isSelected = _selectedView == view;
    return GestureDetector(
      onTap: () => _setView(view),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          view,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  // Build main content based on current section
  Widget _buildMainContent() {
    switch (_currentSection) {
      case AppSection.bookings:
        if (showEmptyContainer) {
          return BookingPage();
        } else {
          return Obx(() {
            final events = calendarsController.events.toList();
            return WeekTimeCalendar(
              events: events,
              currentDate: _currentDate,
              startHour: 8,
              endHour: 24,
              showWeekend: true,
              onEventTap: (e) {
                // handle tap
              },
            );
          });
        }
      case AppSection.orders:
        return ListScreen();
      case AppSection.users:
        return _buildEmptySection('Users', Icons.group);
      case AppSection.settings:
        return _buildEmptySection('Settings', Icons.settings);
    }
  }

  Widget _buildEmptySection(String title, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            '$title Section',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This section is under development',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      drawer: ResponsiveBreakpoints.of(context).smallerThan(TABLET)
          ? Drawer(child: _buildDrawerContent())
          : null,
      body: ResponsiveBreakpoints.builder(
        child: _buildLayout(context),
        breakpoints: const [
          Breakpoint(start: 0, end: 599, name: MOBILE),
          Breakpoint(start: 600, end: 1023, name: TABLET),
          Breakpoint(start: 1024, end: 1439, name: DESKTOP),
          Breakpoint(start: 1440, end: double.infinity, name: '4K'),
        ],
      ),
    );
  }

  Widget _buildLayout(BuildContext context) {
    final bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    final bool isTablet = ResponsiveBreakpoints.of(
      context,
    ).between(TABLET, DESKTOP);

    if (isMobile) {
      return _buildMobileLayout();
    } else if (isTablet) {
      return _buildTabletLayout();
    } else {
      return _buildDesktopLayout();
    }
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildScheduleHeader(),
        Expanded(child: _buildMainContent()),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      children: [
        // Sidebar for tablet (narrower)
        SizedBox(
          width: 240,
          child: Sidebar(
            currentSection: _currentSection,
            onSectionChanged: _changeSection,
          ),
        ),

        // Main content
        Expanded(
          child: Column(
            children: [
              _buildScheduleHeader(),
              Expanded(child: _buildMainContent()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Sidebar for desktop
        Sidebar(
          currentSection: _currentSection,
          onSectionChanged: _changeSection,
        ),

        // Main content
        Expanded(
          child: Column(
            children: [
              _buildScheduleHeader(),
              Expanded(child: _buildMainContent()),
            ],
          ),
        ),
      ],
    );
  }

  // Drawer content for mobile
  Widget _buildDrawerContent() {
    return DrawerContent(
      currentSection: _currentSection,
      onSectionChanged: _changeSection,
    );
  }
}

// Updated Sidebar with section management
class Sidebar extends StatefulWidget {
  final AppSection currentSection;
  final Function(AppSection) onSectionChanged;

  const Sidebar({
    super.key,
    required this.currentSection,
    required this.onSectionChanged,
  });

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String _selectedFilter = 'Confirmed';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      color: AppColors.surface,
      child: Column(
        children: [
          // Branding section
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Bookings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          // Mini calendar section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('MMMM yyyy').format(_focusedDay),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!mounted) return;
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  calendarFormat: CalendarFormat.week,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  headerVisible: false,
                  daysOfWeekVisible: false,
                  calendarStyle: const CalendarStyle(
                    outsideDaysVisible: false,
                    weekendTextStyle: TextStyle(color: AppColors.textSecondary),
                    defaultTextStyle: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 12,
                    ),
                    selectedTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: AppColors.primary100,
                      shape: BoxShape.circle,
                    ),
                    todayTextStyle: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Filter buttons (only show in bookings section)
          if (widget.currentSection == AppSection.bookings) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: FilterButton(
                      label: 'Confirmed',
                      isSelected: _selectedFilter == 'Confirmed',
                      onTap: () {
                        setState(() {
                          _selectedFilter = 'Confirmed';
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Navigation items
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  NavItem(
                    icon: Icons.receipt_long,
                    label: 'Bookings',
                    isSelected: widget.currentSection == AppSection.bookings,
                    onTap: () {
                      widget.onSectionChanged(AppSection.bookings);
                    },
                  ),
                  NavItem(
                    icon: Icons.bar_chart,
                    label: 'Orders',
                    isSelected: widget.currentSection == AppSection.orders,
                    onTap: () {
                      widget.onSectionChanged(AppSection.orders);
                    },
                  ),
                  NavItem(
                    icon: Icons.group,
                    label: 'Users',
                    isSelected: widget.currentSection == AppSection.users,
                    onTap: () {
                      widget.onSectionChanged(AppSection.users);
                    },
                  ),
                  NavItem(
                    icon: Icons.settings_outlined,
                    label: 'Settings',
                    isSelected: widget.currentSection == AppSection.settings,
                    onTap: () {
                      widget.onSectionChanged(AppSection.settings);
                    },
                  ),
                ],
              ),
            ),
          ),

          // User profile section
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.pink,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      'EA',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Easin Arafat',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Free Account',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Drawer content for mobile
class DrawerContent extends StatefulWidget {
  final AppSection currentSection;
  final Function(AppSection) onSectionChanged;

  const DrawerContent({
    super.key,
    required this.currentSection,
    required this.onSectionChanged,
  });

  @override
  State<DrawerContent> createState() => _DrawerContentState();
}

class _DrawerContentState extends State<DrawerContent> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String _selectedFilter = 'Confirmed';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: Column(
        children: [
          // Branding section
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Bookings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          // Mini calendar section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('MMMM yyyy').format(_focusedDay),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!mounted) return;
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  calendarFormat: CalendarFormat.week,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  headerVisible: false,
                  daysOfWeekVisible: false,
                  calendarStyle: const CalendarStyle(
                    outsideDaysVisible: false,
                    weekendTextStyle: TextStyle(color: AppColors.textSecondary),
                    defaultTextStyle: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 12,
                    ),
                    selectedTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: AppColors.primary100,
                      shape: BoxShape.circle,
                    ),
                    todayTextStyle: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Filter buttons (only show in bookings section)
          if (widget.currentSection == AppSection.bookings) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: FilterButton(
                      label: 'Confirmed',
                      isSelected: _selectedFilter == 'Confirmed',
                      onTap: () {
                        setState(() {
                          _selectedFilter = 'Confirmed';
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Navigation items
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  NavItem(
                    icon: Icons.receipt_long,
                    label: 'Bookings',
                    isSelected: widget.currentSection == AppSection.bookings,
                    onTap: () {
                      widget.onSectionChanged(AppSection.bookings);
                      Navigator.pop(context); // Close drawer
                    },
                  ),
                  NavItem(
                    icon: Icons.bar_chart,
                    label: 'Orders',
                    isSelected: widget.currentSection == AppSection.orders,
                    onTap: () {
                      widget.onSectionChanged(AppSection.orders);
                      Navigator.pop(context); // Close drawer
                    },
                  ),
                  NavItem(
                    icon: Icons.group,
                    label: 'Users',
                    isSelected: widget.currentSection == AppSection.users,
                    onTap: () {
                      widget.onSectionChanged(AppSection.users);
                      Navigator.pop(context); // Close drawer
                    },
                  ),
                  NavItem(
                    icon: Icons.settings_outlined,
                    label: 'Settings',
                    isSelected: widget.currentSection == AppSection.settings,
                    onTap: () {
                      widget.onSectionChanged(AppSection.settings);
                      Navigator.pop(context); // Close drawer
                    },
                  ),
                ],
              ),
            ),
          ),

          // User profile section
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.pink,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      'EA',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Easin Arafat',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Free Account',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
