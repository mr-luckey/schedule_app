import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schedule_app/controllers/booking_controller.dart';
import 'package:schedule_app/pages/booking_page.dart';
import '../theme/app_colors.dart';

class BookingSummary extends StatelessWidget {
  const BookingSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookingController>();

    return Container(
      width: 320,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Booking Summary',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 24),

            // Booking Information
            _buildInfoRow('Hall:', controller.selectedPackage.value),
            _buildInfoRow(
              'Date & Time:',
              controller.selectedDate.value != null
                  ? '${DateFormat('MMMM d, yyyy').format(controller.selectedDate.value!)} at ${controller.getTimeRange(context)}'
                  : 'TBD',
            ),
            _buildInfoRow('Guests:', controller.guests.value.toString()),
            _buildInfoRow('Package:', controller.getPackageDisplay()),

            const SizedBox(height: 24),

            // Cost Breakdown
            Text(
              'Cost Breakdown',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 12),

            _buildCostRow(
              'Subtotal:',
              '\$${controller.calculateSubtotal().toStringAsFixed(2)}',
            ),
            _buildCostRow(
              'Tax (8%):',
              '\$${controller.calculateTax().toStringAsFixed(2)}',
            ),

            const Divider(height: 24),

            _buildCostRow(
              'Total Cost:',
              '\$${controller.calculateTotal().toStringAsFixed(2)}',
              isTotal: true,
            ),

            const SizedBox(height: 24),

            // Confirmation Details
            Text(
              'Instant confirmation will be sent via email or SMS. Secure booking with modification or cancellation allowed up to 48 hours before event.',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),

            const SizedBox(height: 16),

            // Confirmation Pills
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Instant Confirmation',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Secure Booking',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Action Buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: controller.showBookingConfirmation,
                icon: const Icon(Icons.check, size: 18),
                label: const Text('Confirm Booking'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: controller.cancelBooking,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  side: const BorderSide(color: AppColors.border),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Cancel'),
              ),
            ),

            const SizedBox(height: 24),

            // Additional Notes
            Text(
              'Confirmation will be sent within 15 minutes.',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Icon(Icons.phone, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Text(
                  'For urgent bookings, call: (55) 123-3456',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Icon(Icons.lock, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Text(
                  'Secure & hassle-free booking process.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Builder(
      builder: (context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 80,
              child: Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostRow(String label, String value, {bool isTotal = false}) {
    return Builder(
      builder: (context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isTotal
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
                fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isTotal ? AppColors.primary : AppColors.textPrimary,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
