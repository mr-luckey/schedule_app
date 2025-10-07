// import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:intl/intl.dart';
// import '../theme/app_colors.dart';
// import 'filter_button.dart';
// import 'nav_item.dart';

// class Sidebar extends StatefulWidget {
//   const Sidebar({super.key});

//   @override
//   State<Sidebar> createState() => _SidebarState();
// }

// class _SidebarState extends State<Sidebar> {
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;
//   String _selectedFilter = 'Confirmed';

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 280,
//       color: AppColors.surface,
//       child: Column(
//         children: [
//           // Branding section
//           Container(
//             padding: const EdgeInsets.all(20),
//             child: Row(
//               children: [
//                 Container(
//                   width: 32,
//                   height: 32,
//                   decoration: const BoxDecoration(
//                     color: AppColors.primary,
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(Icons.check, color: Colors.white, size: 20),
//                 ),
//                 const SizedBox(width: 12),
//                 const Text(
//                   'Bookings',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                     color: AppColors.textPrimary,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Mini calendar section
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   DateFormat('MMMM yyyy').format(_focusedDay),
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: AppColors.textPrimary,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 TableCalendar(
//                   firstDay: DateTime.utc(2020, 1, 1),
//                   lastDay: DateTime.utc(2030, 12, 31),
//                   focusedDay: _focusedDay,
//                   selectedDayPredicate: (day) {
//                     return isSameDay(_selectedDay, day);
//                   },
//                   onDaySelected: (selectedDay, focusedDay) {
//                     if (!mounted) return;
//                     setState(() {
//                       _selectedDay = selectedDay;
//                       _focusedDay = focusedDay;
//                     });
//                   },
//                   calendarFormat: CalendarFormat.week,
//                   startingDayOfWeek: StartingDayOfWeek.monday,
//                   headerVisible: false,
//                   daysOfWeekVisible: false,
//                   calendarStyle: const CalendarStyle(
//                     outsideDaysVisible: false,
//                     weekendTextStyle: TextStyle(color: AppColors.textSecondary),
//                     defaultTextStyle: TextStyle(
//                       color: AppColors.textPrimary,
//                       fontSize: 12,
//                     ),
//                     selectedTextStyle: TextStyle(
//                       color: Colors.white,
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                     ),
//                     selectedDecoration: BoxDecoration(
//                       color: AppColors.primary,
//                       shape: BoxShape.circle,
//                     ),
//                     todayDecoration: BoxDecoration(
//                       color: AppColors.primary100,
//                       shape: BoxShape.circle,
//                     ),
//                     todayTextStyle: TextStyle(
//                       color: AppColors.primary,
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 20),

//           // Filter buttons
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: FilterButton(
//                     label: 'Confirmed',
//                     isSelected: _selectedFilter == 'Confirmed',
//                     onTap: () {
//                       setState(() {
//                         _selectedFilter = 'Confirmed';
//                       });
//                     },
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 // Inquiry tab removed per request
//               ],
//             ),
//           ),

//           const SizedBox(height: 20),

//           // Navigation items
//           Expanded(
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 children: [
//                   NavItem(
//                     icon: Icons.receipt_long,
//                     label: 'Bookings',
//                     isSelected: true,
//                     onTap: () {},
//                   ),
//                   NavItem(
//                     icon: Icons.bar_chart,
//                     label: 'Orders',
//                     isSelected: false,
//                     onTap: () {},
//                   ),
//                   // Inquiry nav item removed per request
//                   NavItem(
//                     icon: Icons.group,
//                     label: 'Users',
//                     isSelected: false,
//                     onTap: () {},
//                   ),
//                   NavItem(
//                     icon: Icons.settings_outlined,
//                     label: 'Settings',
//                     isSelected: false,
//                     onTap: () {},
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // User profile section
//           Container(
//             padding: const EdgeInsets.all(20),
//             child: Row(
//               children: [
//                 Container(
//                   width: 40,
//                   height: 40,
//                   decoration: const BoxDecoration(
//                     color: Colors.pink,
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Center(
//                     child: Text(
//                       'EA',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w600,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 const Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Easin Arafat',
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w600,
//                           color: AppColors.textPrimary,
//                         ),
//                       ),
//                       Text(
//                         'Free Account',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: AppColors.textSecondary,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const Icon(
//                   Icons.keyboard_arrow_down,
//                   color: AppColors.textSecondary,
//                   size: 20,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
