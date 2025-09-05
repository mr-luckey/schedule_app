import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CurrentTimeIndicator extends StatelessWidget {
  final String time;
  final double left;
  final double right;

  const CurrentTimeIndicator({
    super.key,
    required this.time,
    required this.left,
    required this.right,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: left,
      right: right,
      child: Container(
        height: 2,
        decoration: const BoxDecoration(color: AppColors.currentTime),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: 2,
              color: AppColors.currentTime,
            ),
            Positioned(
              left: 0,
              top: -8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.textPrimary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  time,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
