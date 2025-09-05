import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'event_card.dart';
import 'current_time_indicator.dart';
import 'event_popover.dart';

class CalendarGrid extends StatefulWidget {
  const CalendarGrid({super.key});

  @override
  State<CalendarGrid> createState() => _CalendarGridState();
}

class _CalendarGridState extends State<CalendarGrid> {
  final List<String> _timeSlots = [
    '9:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '1:00 PM',
    '2:00 PM',
    '3:00 PM',
  ];

  final List<String> _weekDays = [
    'GMT +05:00',
    '25 Apr, Monday',
    '26 Apr, Tuesday',
    '27 Apr, Wednesday',
    '28 Apr, Thursday',
    '29 May, Friday',
    '30 May, Saturday',
    '01 May, Sunday',
  ];

  // Sample events data
  final List<Map<String, dynamic>> _events = [
    {
      'id': '124553',
      'title': 'Consultation',
      'duration': 'Half day (9:00 AM - 12:00 PM)',
      'guests': 1000,
      'timeRemaining': 'In 3 hour',
      'day': 0, // Monday
      'startHour': 0, // 9:00 AM
      'endHour': 3, // 12:00 PM
      'customerName': 'Kristin Watson',
      'description':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do.',
      'hall': 'Shadiyana marriage hall',
      'timeRange': '10:00 AM - 2:00 PM',
      'eventDate': DateTime(2025, 6, 30),
    },
    {
      'id': '124554',
      'title': 'Consultation',
      'duration': 'Half day (9:00 AM - 12:00 PM)',
      'guests': 1000,
      'timeRemaining': '1 day',
      'day': 1, // Tuesday
      'startHour': 0,
      'endHour': 3,
      'customerName': 'John Smith',
      'description':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do.',
      'hall': 'Grand Ballroom',
      'timeRange': '9:00 AM - 12:00 PM',
      'eventDate': DateTime(2025, 6, 30),
    },
    {
      'id': '124555',
      'title': 'Consultation',
      'duration': 'Half day (9:00 AM - 12:00 PM)',
      'guests': 1000,
      'timeRemaining': '1 day',
      'day': 2, // Wednesday
      'startHour': 0,
      'endHour': 3,
      'customerName': 'Sarah Johnson',
      'description':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do.',
      'hall': 'Conference Hall',
      'timeRange': '9:00 AM - 12:00 PM',
      'eventDate': DateTime(2025, 6, 30),
    },
    {
      'id': '124556',
      'title': 'Consultation',
      'duration': 'Half day (9:00 AM - 12:00 PM)',
      'guests': 1000,
      'timeRemaining': '1 day',
      'day': 3, // Thursday
      'startHour': 0,
      'endHour': 3,
      'customerName': 'Mike Brown',
      'description':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do.',
      'hall': 'Event Center',
      'timeRange': '9:00 AM - 12:00 PM',
      'eventDate': DateTime(2025, 6, 30),
    },
    {
      'id': '124557',
      'title': 'Consultation',
      'duration': 'Half day (9:00 AM - 12:00 PM)',
      'guests': 1000,
      'timeRemaining': '1 day',
      'day': 4, // Friday
      'startHour': 0,
      'endHour': 3,
      'customerName': 'Emily Davis',
      'description':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do.',
      'hall': 'Banquet Hall',
      'timeRange': '9:00 AM - 12:00 PM',
      'eventDate': DateTime(2025, 6, 30),
    },
    {
      'id': '124558',
      'title': 'Consultation',
      'duration': 'Half day (9:00 AM - 12:00 PM)',
      'guests': 1000,
      'timeRemaining': '1 day',
      'day': 5, // Saturday
      'startHour': 0,
      'endHour': 3,
      'customerName': 'David Wilson',
      'description':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do.',
      'hall': 'Wedding Hall',
      'timeRange': '9:00 AM - 12:00 PM',
      'eventDate': DateTime(2025, 6, 30),
    },
    {
      'id': '124559',
      'title': 'Consultation',
      'duration': 'Half day (9:00 AM - 12:00 PM)',
      'guests': 1000,
      'timeRemaining': '1 day',
      'day': 6, // Sunday
      'startHour': 0,
      'endHour': 3,
      'customerName': 'Lisa Anderson',
      'description':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do.',
      'hall': 'Reception Hall',
      'timeRange': '9:00 AM - 12:00 PM',
      'eventDate': DateTime(2025, 6, 30),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: Column(
        children: [
          // Header row with days
          _buildHeaderRow(),

          // Divider
          const Divider(height: 1, color: AppColors.border),

          // Calendar grid
          Expanded(child: _buildCalendarGrid()),
        ],
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppColors.background,
      child: Row(
        children: _weekDays.map((day) {
          final bool isTimeColumn = day == _weekDays.first;
          return Expanded(
            child: Text(
              day,
              textAlign: isTimeColumn ? TextAlign.left : TextAlign.center,
              style: TextStyle(
                fontSize: isTimeColumn ? 12 : 14,
                fontWeight: FontWeight.w600,
                color: isTimeColumn
                    ? AppColors.textSecondary
                    : AppColors.textPrimary,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Time column
        Container(
          width: 100,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: const BoxDecoration(
            border: Border(right: BorderSide(color: AppColors.border)),
          ),
          child: Column(
            children: _timeSlots.map((time) {
              return Expanded(
                child: Container(
                  alignment: Alignment.topRight,
                  padding: const EdgeInsets.only(right: 8, top: 4),
                  child: Text(
                    time,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        // Calendar grid
        Expanded(
          child: Stack(
            children: [
              // Grid lines
              _buildGridLines(),

              // Events
              _buildEvents(),

              // Current time indicator
              _buildCurrentTimeIndicator(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGridLines() {
    return Column(
      children: List.generate(_timeSlots.length, (timeIndex) {
        return Expanded(
          child: Row(
            children: List.generate(_weekDays.length - 1, (dayIndex) {
              return Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      right: BorderSide(color: AppColors.border),
                      bottom: BorderSide(color: AppColors.border),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }

  Widget _buildEvents() {
    return Stack(
      children: _events.map((event) {
        final double left =
            (event['day'] * (MediaQuery.of(context).size.width - 100) / 7);
        final double width = (MediaQuery.of(context).size.width - 100) / 7;
        final double top =
            (event['startHour'] *
            (MediaQuery.of(context).size.height - 200) /
            _timeSlots.length);
        final double height =
            ((event['endHour'] - event['startHour']) *
            (MediaQuery.of(context).size.height - 200) /
            _timeSlots.length);

        return Positioned(
          left: left + 4,
          top: top + 4,
          width: width - 8,
          height: height - 8,
          child: GestureDetector(
            onTap: () => _showEventPopover(context, event),
            child: EventCard(
              title: event['title'],
              duration: event['duration'],
              guests: event['guests'],
              timeRemaining: event['timeRemaining'],
            ),
          ),
        );
      }).toList(),
    );
  }

  void _showEventPopover(BuildContext context, Map<String, dynamic> event) {
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
                bookingId: event['id'],
                customerName: event['customerName'],
                eventDescription: event['description'],
                hall: event['hall'],
                timeRange: event['timeRange'],
                eventDate: event['eventDate'],
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

  void _handleEditEvent(Map<String, dynamic> event) {
    // TODO: Implement edit functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit event: ${event['title']}'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _handleViewDetails(Map<String, dynamic> event) {
    // TODO: Implement view details functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('View details for: ${event['title']}'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  Widget _buildCurrentTimeIndicator() {
    return CurrentTimeIndicator(time: '12:00 PM', left: 0, right: 0);
  }
}
