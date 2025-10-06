import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:schedule_app/controllers/calender_controller.dart';
import 'package:schedule_app/model/Calender_model.dart';
import 'package:schedule_app/model/Source/Data_sorce.dart';
import 'package:schedule_app/pages/Edit/edit.dart';
import 'package:schedule_app/pages/booking_page.dart';
import 'package:schedule_app/widgets/event_card.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class WeekTimeCalendar extends StatefulWidget {
  final List<CalendarEvent> events;
  final DateTime? currentDate; // Changed from initialWeek to currentDate
  final int startHour;
  final int endHour;
  final bool showWeekend;
  final void Function(CalendarEvent event)? onEventTap;

  const WeekTimeCalendar({
    super.key,
    required this.events,
    this.currentDate, // Changed parameter name
    required this.startHour,
    required this.endHour,
    this.showWeekend = true,
    this.onEventTap,
    // required DateTime initialWeek,
  });

  @override
  State<WeekTimeCalendar> createState() => _WeekTimeCalendarState();
}

class _WeekTimeCalendarState extends State<WeekTimeCalendar> {
  late CalendarController _calendarController;
  CalendarsController calendController = Get.put(CalendarsController());

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  void didUpdateWidget(WeekTimeCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update the calendar display date when the currentDate changes
    if (widget.currentDate != null &&
        oldWidget.currentDate != widget.currentDate) {
      print("TESTING DATE");
      print(widget.currentDate);
      _calendarController.displayDate = widget.currentDate!;
    }
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Appointment> appts = calendController.events.map((e) {
      print("TESTING APPOINTMENT");
      print(e.id);
      print(e.start);
      print(e.end);
      print(e.title);
      print(e.guests);

      return Appointment(
        id: e.id,
        startTime: e.start,
        endTime: e.end,
        subject: e.title,
        notes: e.guests,
        color: e.color.withOpacity(.18),
      );
    }).toList();

    final dataSource = EventDataSource(appts);

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool wide = constraints.maxWidth >= 720;
        final CalendarView view = wide
            ? (widget.showWeekend ? CalendarView.week : CalendarView.workWeek)
            : CalendarView.day;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: (widget.showWeekend ? 7 : 5) * 200,
            child: SfCalendar(
              controller: _calendarController, // Add controller
              view: view,
              dataSource: dataSource,
              initialDisplayDate: widget.currentDate ?? DateTime.now(),
              firstDayOfWeek: 1,
              allowViewNavigation: true,
              showCurrentTimeIndicator: true,
              headerStyle: const CalendarHeaderStyle(
                textAlign: TextAlign.center,
                textStyle: TextStyle(fontSize: 0, fontWeight: FontWeight.w600),
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
                startHour: widget.startHour.toDouble(),
                endHour: widget.endHour.toDouble(),
                timeInterval: const Duration(minutes: 60),
                timeFormat: 'h:mm a',
                timeRulerSize: 68,
                timeIntervalHeight: 150,
                timeIntervalWidth: 100,
                timeTextStyle: const TextStyle(fontSize: 12),
              ),
              appointmentBuilder: (context, details) {
                final appt = details.appointments.first as Appointment;

                return EventTile(appointment: appt);
              },
              onTap: (details) {
                Appointment tapped = details.appointments!.first as Appointment;
                String event = tapped.id.toString();
                print(event);
                // print(event.id.toString());
                Get.to(EditPage(selectedId: event));

                // print()
                // if (details.targetElement == CalendarElement.appointment &&
                //     details.appointments != null &&
                //     details.appointments!.isNotEmpty) {
                //   final Appointment tapped =
                //       details.appointments!.first as Appointment;
                //   final CalendarEvent event = tapped.id as CalendarEvent;
                //   widget.onEventTap?.call(event);
                //   print(event.id);
                // }
              },
            ),
          ),
        );
      },
    );
  }
}
