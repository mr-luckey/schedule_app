import 'package:flutter/material.dart';
import 'package:schedule_app/controllers/calender_controller.dart';
import 'package:schedule_app/model/event_model.dart';
import 'package:schedule_app/pages/Calender_Main/Sample_Data.dart';
import 'package:schedule_app/pages/Calender_Main/Week_Calender.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';
// import '../controllers/calendar_controller.dart';
import 'event_card.dart';
import 'event_popover.dart';

class CalendarGrid extends StatefulWidget {
  const CalendarGrid({super.key});

  @override
  State<CalendarGrid> createState() => _CalendarGridState();
}

class _CalendarGridState extends State<CalendarGrid> {
  final CalendarsController _calendarController = Get.put(CalendarsController());
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    // Trigger a rebuild once sample data finishes loading
    // eventsLoaded.then((_) {
    //   if (!mounted) return;
    //   setState(() {});
    // });
    _calendarController.loadEventsFromApi();
  }

  @override
  Widget build(BuildContext context) {
    // Debug: log event count every build
    // ignore: avoid_print
    print('🗓️ CalendarGrid build: events length = ${_calendarController.events.length}');
    return Container(
      color: AppColors.surface,
      child: Column(
        children: [
          // Calendar
          Expanded(
            child:
                // Obx(
                //   () =>
                TableCalendar(
                  firstDay: DateTime.now().subtract(const Duration(days: 365)),
                  lastDay: DateTime.now().add(const Duration(days: 365)),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
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
                  onFormatChanged: (format) {
                    if (!mounted) return;
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    if (!mounted) return;
                    setState(() {
                      _focusedDay = focusedDay;
                    });
                  },
                  // eventLoader: (day) {
                  //   // return _calendarController.getEventsForDay(day);
                  // },
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    markerDecoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    markerSize: 6,
                    outsideDaysVisible: false,
                  ),
                  headerStyle: HeaderStyle(
                    titleCentered: true,
                    formatButtonVisible: true,
                    formatButtonShowsNext: false,
                    formatButtonDecoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    formatButtonTextStyle: const TextStyle(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    weekendStyle: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, day, events) {
                      if (events.isNotEmpty) {
                        return Positioned(
                          right: 1,
                          bottom: 1,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                events.length.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      return null;
                    },
                  ),
                ),
          ),
          // ),

          // Events list for selected day
          if (_selectedDay != null) _buildEventsList(),
        ],
      ),
    );
  }

  Widget _buildEventsList() {
    // final events = [];
    return WeekTimeCalendar(
      //TODO: Need to make this widget when we will make rest of the tabs
      events: _calendarController.events,

      // initialWeek: DateTime(2025, 4, 28),
      startHour: 9,
      endHour: 23,
      showWeekend: true,
      onEventTap: (e) {
        // handle tap
      },
    );
  }

  void _showEventPopover(BuildContext context, Event event) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Stack(
          children: [
            // Backdrop
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(color: Colors.transparent),
              ),
            ),
            // Popover positioned in center
            Center(
              child: EventPopover(
                bookingId: event.id,
                customerName: event.customerName,
                eventDescription: event.specialRequirements.isNotEmpty
                    ? event.specialRequirements
                    : 'No special requirements',
                hall: event.hall,
                timeRange: event.timeRange,
                eventDate: event.startTime,
                onEdit: () {
                  Navigator.of(context).pop();
                  _handleEditEvent(event);
                },
                onViewDetails: () {
                  Navigator.of(context).pop();
                  _handleViewDetails(event);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleEditEvent(Event event) {
    // TODO: Implement edit functionality
    Get.snackbar(
      'Edit Event',
      'Edit functionality for ${event.title}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.primary,
    );
  }

  void _handleViewDetails(Event event) {
    // TODO: Implement view details functionality
    Get.snackbar(
      'Event Details',
      'View details for ${event.title}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.primary,
    );
  }
}
