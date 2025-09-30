import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schedule_app/model/Calender_model.dart';

class Event {
  final String id;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final String eventDate;
  final String customerName;
  final String hall;
  final String timeRange;
  final String specialRequirements;
  final Color color;
  final int? guests;

  Event({
    required this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.eventDate,
    required this.customerName,
    required this.hall,
    required this.timeRange,
    required this.specialRequirements,
    this.color = const Color(0xFF22C55E),
    this.guests,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    DateTime startTime;
    DateTime endTime;
    int? guests;

    String customerName =
        json['customerName'] ??
        '${json['firstname'] ?? ''} ${json['lastname'] ?? ''}'.trim();
    if (customerName.isEmpty) {
      customerName = 'Customer';
    }

    // Parse and combine event date with time
    try {
      final String eventDate = json['event_date'];

      // Extract time parts from the time strings and combine with event date
      startTime = DateTime.parse(
        '$eventDate${json['start_time']?.substring(10) ?? 'T10:00:00.000Z'}',
      );
      endTime = DateTime.parse(
        '$eventDate${json['end_time']?.substring(10) ?? 'T12:00:00.000Z'}',
      );
    } catch (e) {
      print('Error parsing dates: $e');
      // Fallback to current time if parsing fails
      final now = DateTime.now();
      startTime = DateTime(now.year, now.month, now.day, 10, 0);
      endTime = DateTime(now.year, now.month, now.day, 12, 0);
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
      eventDate: json['event_date'],
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

  CalendarEvent toCalendarEvent() {
    return CalendarEvent(
      id: id,
      title: title,
      start: startTime,
      end: endTime,
      eventDate: eventDate,
      guests: guests.toString(),
      subtitle: '${guests != null ? ' • $guests guests' : ''}',
      color: color,
    );
  }
}
