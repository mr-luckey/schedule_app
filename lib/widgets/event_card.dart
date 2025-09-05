import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class EventCard extends StatelessWidget {
  final String title;
  final String duration;
  final int guests;
  final String timeRemaining;
  final VoidCallback? onTap;

  const EventCard({
    super.key,
    required this.title,
    required this.duration,
    required this.guests,
    required this.timeRemaining,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.primary200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primary700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              duration,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Guests: $guests',
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                timeRemaining,
                style: const TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
