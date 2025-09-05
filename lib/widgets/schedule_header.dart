import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';
import '../pages/booking_page.dart';

class ScheduleHeader extends StatefulWidget {
  const ScheduleHeader({super.key});

  @override
  State<ScheduleHeader> createState() => _ScheduleHeaderState();
}

class _ScheduleHeaderState extends State<ScheduleHeader> {
  DateTime _currentDate = DateTime.now();
  String _selectedView = 'Week';

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

  @override
  Widget build(BuildContext context) {
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
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const BookingPage()),
              );
            },
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
}
