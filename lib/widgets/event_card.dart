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
import 'package:syncfusion_flutter_calendar/calendar.dart';
// import 'package:wedding_booking_app/Model/Calender_Event.dart';

class EventTile extends StatelessWidget {
  final Appointment appointment;

  const EventTile({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final CalendarEvent event = appointment.id as CalendarEvent;

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
              if (event.subtitle != null) ...[
                const SizedBox(height: 2),
                Text(event.subtitle!, style: const TextStyle(fontSize: 11)),
              ],
            ],
          ),
    );
  }

  static String _fmt(DateTime dt) => DateFormat('h:mm a').format(dt);
}
