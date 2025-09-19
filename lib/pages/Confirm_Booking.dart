import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schedule_app/pages/booking_page.dart';
import 'package:schedule_app/pages/schedule_page.dart';
import '../theme/app_colors.dart';

class BookingConfirmationPopup extends StatelessWidget {
  final String eventName;
  final String venue;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final int guests;
  final String package;
  final double totalAmount;
  final String customerName;
  final String customerEmail;

  const BookingConfirmationPopup({
    super.key,
    required this.eventName,
    required this.venue,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.guests,
    required this.package,
    required this.totalAmount,
    required this.customerName,
    required this.customerEmail,
    required Future<void> Function() onConfirm,
    required void Function() onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Text(
                  'Event Details',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Event Name
                    _buildDetailRow(
                      context,
                      title: 'Event Name',
                      value: eventName,
                    ),
                    const SizedBox(height: 16),

                    // Venue
                    _buildDetailRow(context, title: 'Venue:', value: venue),
                    const SizedBox(height: 16),

                    // Date & Time
                    _buildDetailRow(
                      context,
                      title: 'Date & Time:',
                      value:
                          '${_formatDate(date)} | ${startTime.format(context)} - ${endTime.format(context)}',
                    ),
                    const SizedBox(height: 16),

                    // Guests
                    _buildDetailRow(
                      context,
                      title: 'Guests:',
                      value:
                          '$guests ${guests == 1 ? 'Attendee' : 'Attendees'}',
                    ),
                    const SizedBox(height: 16),

                    // Package
                    _buildDetailRow(
                      context,
                      title: 'Select Package:',
                      value: package,
                    ),

                    const Divider(height: 40),

                    // Total Amount
                    Center(
                      child: Text(
                        'Total Amount: £${totalAmount.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Billing Information Header
                    Text(
                      'Billing Information',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Customer Name
                    _buildBillingInfoRow(
                      context,
                      title: 'Full Name',
                      value: customerName,
                    ),
                    const SizedBox(height: 8),

                    // Customer Email
                    _buildBillingInfoRow(
                      context,
                      title: 'Email',
                      value: customerEmail,
                    ),

                    const Divider(height: 40),

                    // Payment Methods
                    Text(
                      'Select Payment Method',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildPaymentMethod(
                      context,
                      title: 'Credit/Debit Card',
                      isSelected: true,
                    ),
                    const SizedBox(height: 8),

                    _buildPaymentMethod(context, title: 'Bank Transfer'),
                    const SizedBox(height: 8),

                    _buildPaymentMethod(context, title: 'JazzCash/Easypalsa'),
                    const SizedBox(height: 8),

                    _buildPaymentMethod(context, title: 'Cash Payment'),

                    const SizedBox(height: 24),

                    // Card Details
                    Text(
                      'Cardholder name',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),

                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter cardholder full name',
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Text(
                      'Card Number',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),

                    TextFormField(
                      decoration: InputDecoration(
                        hintText: '**** **** **** ****',
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Expiry Date',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'MM/YY',
                                  border: const OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'CVV',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText: '***',
                                  border: const OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Security note
                    Row(
                      children: [
                        Icon(
                          Icons.lock_outline,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Pay Securely',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Get.back(),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: BorderSide(color: AppColors.primary),
                            ),
                            child: Text(
                              'Cancel Payment',
                              style: TextStyle(color: AppColors.primary),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Get.to(SchedulePage());
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: AppColors.primary,
                            ),
                            child: const Text('Pay Now & Confirm Booking'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required String title,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildBillingInfoRow(
    BuildContext context, {
    required String title,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildPaymentMethod(
    BuildContext context, {
    required String title,
    bool isSelected = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.border,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Icon(
            isSelected
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${_getMonthName(date.month)} ${date.day}, ${date.year}';
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }
}

// Usage example:
// void showBookingConfirmation(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (context) => BookingConfirmationPopup(
//       eventName: 'Grand Ballroom, Islamabad Pakistan',
//       venue: 'Innovation hub, wedding hall A',
//       date: DateTime(2025, 11, 15),
//       startTime: const TimeOfDay(hour: 9, minute: 0),
//       endTime: const TimeOfDay(hour: 17, minute: 0),
//       guests: 1,
//       package: 'VIP Access Pass (Full Event)',
//       totalAmount: 25000,
//       customerName: 'Jane Doe',
//       customerEmail: 'example.doe@gmail.com',
//     ),
//   );
// }
