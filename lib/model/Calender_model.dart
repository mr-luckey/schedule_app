import 'package:flutter/material.dart';

class CalendarEvent {
  final String id;
  final String title;
  final String eventDate;
  final DateTime start;
  final DateTime end;
  final String? subtitle;
  final Color color;
  final Widget? child;
  final String? guests;

  const CalendarEvent({
    required this.id,
    required this.guests,
    required this.eventDate,
    required this.title,
    required this.start,
    required this.end,
    this.subtitle,
    required this.color,
    this.child,
  });
}
