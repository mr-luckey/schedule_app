// import 'package:wedding_booking_app/Model/Calender_Event.dart';

import 'package:schedule_app/model/Calender_model.dart';

final events = <CalendarEvent>[
  CalendarEvent(
    id: 'e1',
    title: 'Birthday',
    start: DateTime(2025, 9, 22, 9, 0),
    end: DateTime(2025, 9, 22, 12, 0),
    subtitle: 'Guests: 1000',
  ),
  CalendarEvent(
    id: 'e2',
    title: 'Marrige',
    start: DateTime(2025, 9, 24, 10, 0),
    end: DateTime(2025, 9, 24, 11, 0),
    subtitle: 'Guests: 1000',
  ),
  CalendarEvent(
    id: 'e3',
    title: 'Consultation',
    start: DateTime(2025, 9, 8, 10, 0),
    end: DateTime(2025, 9, 8, 12, 0),
    subtitle:
        '1000', //TODO: API data should be overrider be int to string or guest should be string in API
  ),
  CalendarEvent(
    id: 'e4',
    title: 'Consultation',
    start: DateTime(2025, 4, 28, 14, 0),
    end: DateTime(2025, 4, 28, 15, 0),
    subtitle: '1000',
  ),
  CalendarEvent(
    id: 'e5',
    title: 'Consultation',
    start: DateTime(2025, 4, 30, 9, 0),
    end: DateTime(2025, 4, 30, 12, 0),
    subtitle: 'Guests: 500',
  ),
  CalendarEvent(
    id: 'e6',
    title: 'Consultation',
    start: DateTime(2025, 5, 1, 11, 0),
    end: DateTime(2025, 5, 1, 12, 0),
    subtitle: 'Guests: 1000',
  ),
];
