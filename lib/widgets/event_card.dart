// // // /// The EventCard class is a Flutter widget that displays event details such as title, duration, guests,
// // // /// and time remaining in a styled container with optional onTap functionality.
// // // // import 'package:flutter/material.dart';
// // // // import '../theme/app_colors.dart';

// // // // class EventCard extends StatelessWidget {
// // // //   final String title;
// // // //   final String duration;
// // // //   final int guests;
// // // //   final String timeRemaining;
// // // //   final VoidCallback? onTap;

// // // //   const EventCard({
// // // //     super.key,
// // // //     required this.title,
// // // //     required this.duration,
// // // //     required this.guests,
// // // //     required this.timeRemaining,
// // // //     this.onTap,
// // // //   });

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return GestureDetector(
// // // //       onTap: onTap,
// // // //       child: Container(
// // // //         margin: const EdgeInsets.symmetric(vertical: 2),
// // // //         padding: const EdgeInsets.all(8),
// // // //         decoration: BoxDecoration(
// // // //           color: AppColors.primary50,
// // // //           borderRadius: BorderRadius.circular(8),
// // // //           border: Border.all(color: AppColors.primary200),
// // // //         ),
// // // //         child: Column(
// // // //           crossAxisAlignment: CrossAxisAlignment.start,
// // // //           children: [
// // // //             Text(
// // // //               title,
// // // //               style: const TextStyle(
// // // //                 fontSize: 12,
// // // //                 fontWeight: FontWeight.w600,
// // // //                 color: AppColors.primary700,
// // // //               ),
// // // //             ),
// // // //             const SizedBox(height: 2),
// // // //             Text(
// // // //               duration,
// // // //               style: const TextStyle(
// // // //                 fontSize: 10,
// // // //                 color: AppColors.textSecondary,
// // // //               ),
// // // //             ),
// // // //             const SizedBox(height: 2),
// // // //             Text(
// // // //               'Guests: $guests',
// // // //               style: const TextStyle(
// // // //                 fontSize: 10,
// // // //                 color: AppColors.textSecondary,
// // // //               ),
// // // //             ),
// // // //             const SizedBox(height: 4),
// // // //             Container(
// // // //               padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
// // // //               decoration: BoxDecoration(
// // // //                 color: AppColors.primary100,
// // // //                 borderRadius: BorderRadius.circular(4),
// // // //               ),
// // // //               child: Text(
// // // //                 timeRemaining,
// // // //                 style: const TextStyle(
// // // //                   fontSize: 8,
// // // //                   fontWeight: FontWeight.w500,
// // // //                   color: AppColors.primary700,
// // // //                 ),
// // // //               ),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }
// // // import 'package:flutter/material.dart';
// // // // import 'package:syncfusion_flutter_calendar/calendar.dart';
// // // // import 'calendar_event.dart';
// // // import 'package:intl/intl.dart';
// // // import 'package:schedule_app/model/Calender_model.dart';
// // // import 'package:syncfusion_flutter_calendar/calendar.dart';
// // // // import 'package:wedding_booking_app/Model/Calender_Event.dart';

// // // class EventTile extends StatelessWidget {
// // //   final Appointment appointment;

// // //   const EventTile({super.key, required this.appointment});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final CalendarEvent event = appointment.id as CalendarEvent;

// // //     return Container(
// // //       padding: const EdgeInsets.all(8),
// // //       decoration: BoxDecoration(
// // //         color: appointment.color,
// // //         borderRadius: BorderRadius.circular(10),
// // //         border: Border.all(color: event.color, width: 1.2),
// // //       ),
// // //       child:
// // //           event.child ??
// // //           Column(
// // //             crossAxisAlignment: CrossAxisAlignment.start,
// // //             children: [
// // //               Text(
// // //                 event.title,
// // //                 maxLines: 1,
// // //                 overflow: TextOverflow.ellipsis,
// // //                 style: const TextStyle(fontWeight: FontWeight.w600),
// // //               ),
// // //               const SizedBox(height: 2),
// // //               Text(
// // //                 '${_fmt(event.start)} - ${_fmt(event.end)}',
// // //                 style: const TextStyle(fontSize: 11),
// // //               ),
// // //               if (event.subtitle != null) ...[
// // //                 const SizedBox(height: 2),
// // //                 Text(event.subtitle!, style: const TextStyle(fontSize: 11)),
// // //               ],
// // //             ],
// // //           ),
// // //     );
// // //   }

// // //   static String _fmt(DateTime dt) => DateFormat('h:mm a').format(dt);
// // // }
// // // Create a new file: event_tile.dart
// // import 'package:flutter/material.dart';
// // import 'package:intl/intl.dart';
// // import 'package:schedule_app/model/event_model.dart';

// // class EventTile extends StatelessWidget {
// //   final Event event;

// //   const EventTile({super.key, required this.event});

// //   @override
// //   Widget build(BuildContext context) {
// //     // Calculate duration
// //     final duration = event.endTime.difference(event.startTime);
// //     final hours = duration.inHours;
// //     final minutes = duration.inMinutes % 60;

// //     String formatDuration() {
// //       if (hours >= 24) {
// //         final days = duration.inDays;
// //         return '$days day${days > 1 ? 's' : ''}';
// //       } else if (hours > 0) {
// //         return '$hours hour${hours > 1 ? 's' : ''} ${minutes > 0 ? '$minutes min' : ''}'
// //             .trim();
// //       } else {
// //         return '$minutes min';
// //       }
// //     }

// //     // Format time range
// //     final timeFormat = DateFormat('h:mm a');
// //     final startTime = timeFormat.format(event.startTime);
// //     final endTime = timeFormat.format(event.endTime);

// //     // Determine if it's half day or full day
// //     final isHalfDay = hours <= 4;
// //     final timeDescription = isHalfDay ? 'Half day' : 'Full day';

// //     return Container(
// //       margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 1),
// //       decoration: BoxDecoration(
// //         color: event.color.withOpacity(0.1),
// //         border: Border.all(color: event.color.withOpacity(0.3)),
// //         borderRadius: BorderRadius.circular(6),
// //       ),
// //       child: Padding(
// //         padding: const EdgeInsets.all(6),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             // Event Title
// //             Text(
// //               event.title,
// //               style: const TextStyle(
// //                 fontSize: 12,
// //                 fontWeight: FontWeight.bold,
// //                 color: Colors.black87,
// //               ),
// //               maxLines: 1,
// //               overflow: TextOverflow.ellipsis,
// //             ),

// //             const SizedBox(height: 2),

// //             // Time description and range
// //             Text(
// //               '$timeDescription ($startTime - $endTime)',
// //               style: TextStyle(fontSize: 10, color: Colors.grey[700]),
// //               maxLines: 1,
// //               overflow: TextOverflow.ellipsis,
// //             ),

// //             const SizedBox(height: 2),

// //             // Guests information
// //             Text(
// //               'Guests: ${_extractGuestsFromEvent(event)}',
// //               style: TextStyle(fontSize: 10, color: Colors.grey[700]),
// //             ),

// //             const SizedBox(height: 2),

// //             // Duration
// //             Text(
// //               formatDuration(),
// //               style: TextStyle(
// //                 fontSize: 10,
// //                 color: event.color,
// //                 fontWeight: FontWeight.w500,
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   String _extractGuestsFromEvent(Event event) {
// //     // Try to extract guests from various possible fields
// //     if (event.specialRequirements.isNotEmpty) {
// //       // Look for guest count in special requirements or other fields
// //       final guestMatch = RegExp(
// //         r'[Gg]uests?:\s*(\d+)',
// //       ).firstMatch(event.specialRequirements);
// //       if (guestMatch != null) {
// //         return guestMatch.group(1)!;
// //       }

// //       final noOfGestMatch = RegExp(
// //         r'[Nn]o[._\s]*of[._\s]*[Gg]uests?:\s*(\d+)',
// //       ).firstMatch(event.specialRequirements);
// //       if (noOfGestMatch != null) {
// //         return noOfGestMatch.group(1)!;
// //       }
// //     }

// //     // Fallback to default or try to get from API response structure
// //     return 'N/A';
// //   }
// // }
// // Create a new file: widgets/event_tile.dart
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:schedule_app/model/event_model.dart';

// class EventTile extends StatelessWidget {
//   final Event event;

//   const EventTile({super.key, required this.event});

//   @override
//   Widget build(BuildContext context) {
//     // Calculate duration
//     final duration = event.endTime.difference(event.startTime);
//     final hours = duration.inHours;
//     final minutes = duration.inMinutes % 60;

//     String formatDuration() {
//       if (hours >= 24) {
//         final days = duration.inDays;
//         return '$days day${days > 1 ? 's' : ''}';
//       } else if (hours > 0) {
//         return '$hours hour${hours > 1 ? 's' : ''} ${minutes > 0 ? '$minutes min' : ''}'
//             .trim();
//       } else {
//         return '$minutes min';
//       }
//     }

//     // Determine if it's half day or full day
//     final isHalfDay = hours <= 4;
//     final timeDescription = isHalfDay ? 'Half day' : 'Full day';

//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
//       decoration: BoxDecoration(
//         color: event.color.withOpacity(0.15),
//         border: Border.all(color: event.color.withOpacity(0.5), width: 1),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(8),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Title
//             // Text(
//             //   event.title,
//             //   style: const TextStyle(
//             //     fontSize: 13,
//             //     fontWeight: FontWeight.w700,
//             //     color: Colors.black87,
//             //   ),
//             //   maxLines: 1,
//             //   overflow: TextOverflow.ellipsis,
//             // ),
//             const SizedBox(height: 2),

//             // Time description
//             Text(
//               '$timeDescription (${_formatTime(event.startTime)} - ${_formatTime(event.endTime)})',
//               style: TextStyle(
//                 fontSize: 11,
//                 color: Colors.grey[700],
//                 fontWeight: FontWeight.w500,
//               ),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),

//             const SizedBox(height: 2),

//             // Guests information
//             Text(
//               'Guests: ${_extractGuestsFromEvent(event)}',
//               style: TextStyle(fontSize: 11, color: Colors.grey[700]),
//             ),

//             const SizedBox(height: 6),

//             // Duration badge (like green chip)
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//               decoration: BoxDecoration(
//                 color: event.color.withOpacity(0.25),
//                 borderRadius: BorderRadius.circular(4),
//                 border: Border.all(color: event.color.withOpacity(0.5)),
//               ),
//               child: Text(
//                 formatDuration(),
//                 style: TextStyle(
//                   fontSize: 10,
//                   color: event.color,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   String _formatTime(DateTime dateTime) {
//     return DateFormat('h:mm a').format(dateTime);
//   }

//   dynamic _extractGuestsFromEvent(Event event) {
//     // Try to extract guests from various possible fields in the API response
//     if (event.specialRequirements.isNotEmpty) {
//       final guestMatch = RegExp(
//         r'[Gg]uests?:\s*(\d+)',
//       ).firstMatch(event.specialRequirements);
//       if (guestMatch != null) return guestMatch.group(1)!;

//       final noOfGestMatch = RegExp(
//         r'[Nn]o[._\s]*of[._\s]*[Gg]uests?:\s*(\d+)',
//       ).firstMatch(event.specialRequirements);
//       if (noOfGestMatch != null) return noOfGestMatch.group(1)!;
//     }

//     // Check if we have guest information in the event model
//     if (event.guests != null && event.guests! > 0) {
//       return event.guests;
//     }

//     return 'N/A';
//   }
// }
/// The EventCard class is a Flutter widget that displays event details such as title, duration, guests,
/// and time remaining in a styled container with optional onTap functionality.
// import 'package:flutter/material.dart';
// import '../theme/app_colors.dart';

// class EventCard extends StatelessWidget {
//   final String title;
//   final String duration;
//   final int guests;
//   final String timeRemaining;
//   final VoidCallback? onTap;

//   const EventCard({
//     super.key,
//     required this.title,
//     required this.duration,
//     required this.guests,
//     required this.timeRemaining,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 2),
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: AppColors.primary50,
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(color: AppColors.primary200),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//                 color: AppColors.primary700,
//               ),
//             ),
//             const SizedBox(height: 2),
//             Text(
//               duration,
//               style: const TextStyle(
//                 fontSize: 10,
//                 color: AppColors.textSecondary,
//               ),
//             ),
//             const SizedBox(height: 2),
//             Text(
//               'Guests: $guests',
//               style: const TextStyle(
//                 fontSize: 10,
//                 color: AppColors.textSecondary,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//               decoration: BoxDecoration(
//                 color: AppColors.primary100,
//                 borderRadius: BorderRadius.circular(4),
//               ),
//               child: Text(
//                 timeRemaining,
//                 style: const TextStyle(
//                   fontSize: 8,
//                   fontWeight: FontWeight.w500,
//                   color: AppColors.primary700,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_calendar/calendar.dart';
// import 'calendar_event.dart';
import 'package:intl/intl.dart';
import 'package:schedule_app/model/Calender_model.dart';
import 'package:schedule_app/pages/Calender_Main/Sample_Data.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
// import 'package:wedding_booking_app/Model/Calender_Event.dart';

class EventTile extends StatelessWidget {
  final Appointment appointment;

  const EventTile({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    // final CalendarEvent event = appointment.id as CalendarEvent;
    final CalendarEvent event = CalendarEvent(id: appointment.id!.toString(), guests: 500, title: appointment.subject, start: appointment.startTime, end: appointment.endTime);

    print("Here is the events details" + "${event.guests}");

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: appointment.color,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: event.color, width: 1.2),
      ),
      child:
          event.child ??
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 2),
              Text(
                '${_fmt(event.start)} - ${_fmt(event.end)}',
                style: const TextStyle(fontSize: 11),
              ),
              // if (event.subtitle != null) ...[
              const SizedBox(height: 2),
              Text("${event.guests}", style: const TextStyle(fontSize: 11)),
              // ],
            ],
          ),
    );
  }

  static String _fmt(DateTime dt) => DateFormat('h:mm a').format(dt);
}
