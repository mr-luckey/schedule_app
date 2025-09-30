import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schedule_app/model/Calender_model.dart';

class Event {
  final String id;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final String customerName;
  final String hall;
  final String timeRange;
  final String specialRequirements;
  final Color color;
  final int? guests; // Add guests field

  Event({
    required this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.customerName,
    required this.hall,
    required this.timeRange,
    required this.specialRequirements,
    this.color = const Color(0xFF22C55E),
    this.guests,
  });
  factory Event.fromJson(Map<String, dynamic> json) {
    // Parse date and time from API response
    DateTime startTime;
    DateTime endTime;
    int? guests;

    String customerName =
        json['customerName'] ??
        '${json['firstname'] ?? ''} ${json['lastname'] ?? ''}'.trim();
    if (customerName.isEmpty) {
      customerName = 'Customer';
    }

    // Parse string dates to DateTime objects
    try {
      startTime = DateTime.parse(json['start_time']);
      endTime = DateTime.parse(json['end_time']);
    } catch (e) {
      print('Error parsing dates: $e');
      // Fallback to current time if parsing fails
      startTime = DateTime.now();
      endTime = DateTime.now().add(const Duration(hours: 1));
    }

    // Handle guests field
    guests = json['no_of_gust'] != null
        ? int.tryParse(json['no_of_gust'].toString())
        : null;

    // Build time range string
    final timeFormat = DateFormat('hh:mm a');
    final timeRange =
        '${timeFormat.format(startTime)} - ${timeFormat.format(endTime)}';

    print("Guests: $guests");

    return Event(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      title: json['title'] ?? json['event_type'] ?? 'Booking',
      startTime: startTime,
      endTime: endTime,
      customerName: customerName,
      hall: json['hall'] ?? json['venue'] ?? 'Main Hall',
      timeRange: timeRange,
      specialRequirements:
          json['specialRequirements'] ??
          json['requirement'] ??
          json['description'] ??
          '',
      guests: guests,
    );
  }
  // factory Event.fromJson(Map<String, dynamic> json) {
  //   // Parse date and time from API response
  //   DateTime startTime;
  //   DateTime endTime;
  //   int? guests;

  //   String customerName =
  //       json['customerName'] ??
  //       '${json['firstname'] ?? ''} ${json['lastname'] ?? ''}'.trim();
  //   if (customerName.isEmpty) {
  //     customerName = 'Customer';
  //   }
  //   startTime = DateTime.parse(json['start_time']).toLocal();
  //   endTime = DateTime.parse(json['end_time']).toLocal();
  //   final timeFormat = DateFormat('hh:mm a');
  //   final timeRange =
  //       '${timeFormat.format(startTime)} - ${timeFormat.format(endTime)}';
  //   print("........................");
  //   print(guests);

  //   return Event(
  //     id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
  //     title: json['title'] ?? json['event_type'] ?? 'Booking',
  //     startTime: DateTime.parse(json['start_time']).toLocal(),
  //     endTime: DateTime.parse(json['end_time']).toLocal(),
  //     customerName: customerName,
  //     hall: json['hall'] ?? json['venue'] ?? 'Main Hall',
  //     timeRange: timeRange,
  //     specialRequirements:
  //         json['specialRequirements'] ??
  //         json['requirement'] ??
  //         json['description'] ??
  //         '',
  //     guests: guests,
  //   );
  // }

  // Convert to CalendarEvent for the calendar widget
  CalendarEvent toCalendarEvent() {
    return CalendarEvent(
      id: id,
      title: title,
      start: startTime,
      end: endTime,
      guests: guests,
      subtitle: '${guests != null ? ' • $guests guests' : ''}',
      color: color,
    );
  }
}
