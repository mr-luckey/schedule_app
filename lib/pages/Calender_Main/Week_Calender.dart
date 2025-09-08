import 'package:flutter/material.dart';
import 'package:schedule_app/model/Calender_model.dart';
import 'package:schedule_app/model/Source/Data_sorce.dart';
import 'package:schedule_app/widgets/event_card.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class WeekTimeCalendar extends StatelessWidget {
  final List<CalendarEvent> events;
  final DateTime? initialWeek;
  final int startHour;
  final int endHour;
  final bool showWeekend;
  final void Function(CalendarEvent event)? onEventTap;

  const WeekTimeCalendar({
    super.key,
    required this.events,
    this.initialWeek,
    this.startHour = 8,
    this.endHour = 18,
    this.showWeekend = true,
    this.onEventTap,
  });

  @override
  Widget build(BuildContext context) {
    final List<Appointment> appts = events.map((e) {
      return Appointment(
        id: e,
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
            ? (showWeekend ? CalendarView.week : CalendarView.workWeek)
            : CalendarView.day;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: (showWeekend ? 7 : 5) * 200,
            child: SfCalendar(
              view: view,
              dataSource: dataSource,
              initialDisplayDate: initialWeek ?? DateTime.now(),
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
                startHour: startHour.toDouble(),
                endHour: endHour.toDouble(),
                timeInterval: const Duration(minutes: 60),
                timeFormat: 'h:mm a',
                timeRulerSize: 68,
                timeIntervalHeight: 100,
                timeIntervalWidth: 100,
                timeTextStyle: const TextStyle(fontSize: 12),
              ),
              appointmentBuilder: (context, details) {
                final appt = details.appointments.first as Appointment;
                return EventTile(appointment: appt);
              },
              onTap: (details) {
                if (details.targetElement == CalendarElement.appointment &&
                    details.appointments != null &&
                    details.appointments!.isNotEmpty) {
                  final Appointment tapped =
                      details.appointments!.first as Appointment;
                  final CalendarEvent event = tapped.id as CalendarEvent;
                  onEventTap?.call(event);
                }
              },
            ),
          ),
        );
      },
    );
  }
}
