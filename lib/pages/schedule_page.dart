// import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'package:responsive_framework/responsive_framework.dart';
import 'package:intl/intl.dart';
import 'package:schedule_app/pages/Calender_Main/Sample_Data.dart';
import 'package:schedule_app/pages/Calender_Main/Week_Calender.dart';

import '../theme/app_colors.dart';
import '../widgets/sidebar.dart';
import '../widgets/calendar_grid.dart';
import '../pages/booking_page.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  // State variables from ScheduleHeader

  DateTime _currentDate = DateTime.now();
  String _selectedView = 'Week';
  bool showEmptyContainer = false; // New state variable to toggle container

  // Methods from ScheduleHeader
  void _goToToday() {
    setState(() {
      _currentDate = DateTime.now();
    });
  }

  void _navigateWeek(int direction) {
    setState(() {
      _currentDate = _currentDate.add(Duration(days: direction * 7));
    });
  }

  void _setView(String view) {
    setState(() {
      _selectedView = view;
    });
  }

  // Toggle function for the New Schedule button
  void _toggleEmptyContainer() {
    setState(() {
      showEmptyContainer = !showEmptyContainer;
    });
  }

  // Build method for the header content
  Widget _buildScheduleHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          // Title
          const Text(
            'Booking Schedule',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(width: 24),

          // Today button
          TextButton(
            onPressed: _goToToday,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text('Today'),
          ),

          const SizedBox(width: 16),

          // Date navigation
          Row(
            children: [
              IconButton(
                onPressed: () => _navigateWeek(-1),
                icon: const Icon(Icons.chevron_left),
                style: IconButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                ),
              ),
              Text(
                DateFormat('MMMM d, yyyy').format(_currentDate),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              IconButton(
                onPressed: () => _navigateWeek(1),
                icon: const Icon(Icons.chevron_right),
                style: IconButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                ),
              ),
            ],
          ),

          const Spacer(),

          // New Schedule button
          ElevatedButton.icon(
            onPressed: _toggleEmptyContainer,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('New Schedule'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),

          const SizedBox(width: 16),

          // View switcher
          Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildViewButton('Day'),
                _buildViewButton('Week'),
                _buildViewButton('Month'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewButton(String view) {
    final bool isSelected = _selectedView == view;
    return GestureDetector(
      onTap: () => _setView(view),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          view,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get.put(BookingController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: ResponsiveBreakpoints.builder(
        child: _buildLayout(context),
        breakpoints: const [
          Breakpoint(start: 0, end: 599, name: MOBILE),
          Breakpoint(start: 600, end: 1023, name: TABLET),
          Breakpoint(start: 1024, end: 1439, name: DESKTOP),
          Breakpoint(start: 1440, end: double.infinity, name: '4K'),
        ],
      ),
    );
  }

  Widget _buildLayout(BuildContext context) {
    final bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    final bool isTablet = ResponsiveBreakpoints.of(
      context,
    ).between(TABLET, DESKTOP);

    if (isMobile) {
      return _buildMobileLayout();
    } else if (isTablet) {
      return _buildTabletLayout();
    } else {
      return _buildDesktopLayout();
    }
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        // Header for mobile
        _buildScheduleHeader(),

        // Conditional rendering based on button state
        showEmptyContainer
            ? Expanded(
                child: Container(),
              ) // Empty container when button is pressed
            : const Expanded(child: CalendarGrid()), // Calendar grid for mobile
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      children: [
        // Sidebar for tablet (narrower)
        const SizedBox(width: 240, child: Sidebar()),

        // Main content
        Expanded(
          child: Column(
            children: [
              _buildScheduleHeader(),
              // Conditional rendering based on button state
              showEmptyContainer
                  ? Expanded(
                      child: Container(),
                    ) // Empty container when button is pressed
                  : Expanded(
                      child: WeekTimeCalendar(
                        events: events,
                        currentDate: _currentDate,
                        // initialWeek: DateTime(2025, 4, 28),
                        startHour: 9,
                        endHour: 15,
                        showWeekend: true,
                        onEventTap: (e) {
                          // handle tap
                        },
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Sidebar for desktop
        const Sidebar(),

        // Main content
        Expanded(
          child: Column(
            children: [
              _buildScheduleHeader(),
              // Conditional rendering based on button state
              showEmptyContainer
                  ? Expanded(
                      child: BookingPage(),
                    ) // Empty container when button is pressed
                  : Expanded(
                      child: WeekTimeCalendar(
                        events: events,
                        currentDate:
                            _currentDate, // Use the current date from state
                        startHour: 9,
                        endHour: 15,
                        showWeekend: true,
                        onEventTap: (e) {
                          // handle tap
                        },
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
