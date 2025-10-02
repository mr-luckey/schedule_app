import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:schedule_app/controllers/booking_controller.dart';
import 'package:schedule_app/pages/schedule_page.dart';
import 'package:schedule_app/theme/app_colors.dart';

class PaymentPopup extends StatefulWidget {
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
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const PaymentPopup({
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
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  State<PaymentPopup> createState() => _PaymentPopupState();
}

class _PaymentPopupState extends State<PaymentPopup> {
  int _selectedPaymentMethod = 0;

  bool _isProcessing = false;
  bool _showSuccessScreen = false;
  Timer? _processingTimer;

  @override
  void dispose() {
    _processingTimer?.cancel();
    super.dispose();
  }

  void _handlePaymentConfirmation() {
    if (!mounted) return;

    setState(() {
      _isProcessing = true;
    });

    _processingTimer = Timer(const Duration(seconds: 10), () {
      if (!mounted) return;

      setState(() {
        _isProcessing = false;
        _showSuccessScreen = true;
      });

      widget.onConfirm();
      // Get.to(SchedulePage());
    });
  }

  void _handleSuccessScreenFinish() {
    if (!mounted) return;

    setState(() {
      _showSuccessScreen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showSuccessScreen) {
      return Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: _BookingSuccessScreen(onFinish: _handleSuccessScreenFinish),
      );
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 700;

          return Container(
            padding: const EdgeInsets.all(20),
            constraints: const BoxConstraints(maxWidth: 900, minHeight: 500),
            color: Colors.white,
            child: _isProcessing
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Processing your payment...",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  )
                : isMobile
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        _eventDetails(context),
                        const SizedBox(height: 20),
                        _paymentSection(context),
                      ],
                    ),
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: _eventDetails(context)),
                      const SizedBox(width: 20),
                      Expanded(flex: 3, child: _paymentSection(context)),
                    ],
                  ),
          );
        },
      ),
    );
  }

  // Event details (left panel)
  Widget _eventDetails(BuildContext context) {
    String formattedDate = DateFormat("MMMM dd, yyyy").format(widget.date);
    String formattedTime =
        "${_formatTimeOfDay(context, widget.startTime)} - ${_formatTimeOfDay(context, widget.endTime)}";

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _eventItem(Icons.event, "Event Name", widget.eventName),
          _eventItem(Icons.place, "Venue", widget.venue),
          _eventItem(
            Icons.access_time,
            "Date & Time",
            "$formattedDate | $formattedTime",
          ),
          _eventItem(Icons.people, "Guests", "${widget.guests} Attendee(s)"),
          _eventItem(Icons.card_membership, "Select Package", widget.package),
          const SizedBox(height: 10),
          const Text(
            "Total Amount:",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            "£${widget.totalAmount.toStringAsFixed(0)}",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimeOfDay(BuildContext context, TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat.jm().format(dt);
  }

  Widget _eventItem(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Payment section (right panel)
  Widget _paymentSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select Payment Method",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),

        _buildPaymentOptions(),
        const SizedBox(height: 30),

        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: widget.onCancel,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: AppColors.primary),
                ),
                child: const Text(
                  "Cancel Payment",
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Get.find<BookingController>().completeBooking();
                  Get.back();
                  // Get.back();
                },
                // _handlePaymentConfirmation,
                child: const Text("Pay Now & Confirm Booking"),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentOptions() {
    return Column(
      children: [
        _paymentOption(0, Icons.credit_card, "Credit/Debit Card"),
        const SizedBox(height: 8),
        _paymentOption(1, Icons.account_balance, "Bank Transfer"),
        const SizedBox(height: 8),
        _paymentOption(2, Icons.attach_money, "Cash Payment"),
      ],
    );
  }

  Widget _paymentOption(int index, IconData icon, String title) {
    return GestureDetector(
      onTap: () {
        if (!mounted) return;
        setState(() {
          _selectedPaymentMethod = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _selectedPaymentMethod == index
              ? AppColors.primary.withOpacity(0.1)
              : Colors.grey.shade100,
          border: Border.all(
            color: _selectedPaymentMethod == index
                ? AppColors.primary
                : Colors.grey.shade300,
            width: _selectedPaymentMethod == index ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: _selectedPaymentMethod == index
                  ? AppColors.primary
                  : Colors.grey,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: _selectedPaymentMethod == index
                    ? AppColors.primary
                    : Colors.black,
                fontWeight: _selectedPaymentMethod == index
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
            ),
            const Spacer(),
            if (_selectedPaymentMethod == index)
              const Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

// Success Screen (unchanged)
class _BookingSuccessScreen extends StatefulWidget {
  final VoidCallback onFinish;

  const _BookingSuccessScreen({required this.onFinish});

  @override
  State<_BookingSuccessScreen> createState() => __BookingSuccessScreenState();
}

class __BookingSuccessScreenState extends State<_BookingSuccessScreen> {
  Timer? _autoCloseTimer;

  @override
  void initState() {
    super.initState();
    _autoCloseTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) widget.onFinish();
    });
  }

  @override
  void dispose() {
    _autoCloseTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFE8F9F1),
                ),
              ),
              const Icon(Icons.thumb_up, color: Colors.green, size: 60),
            ],
          ),
          const SizedBox(height: 30),
          const Text(
            "Booking Completed Successfully",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            "Your booking has been confirmed and payment has been processed successfully.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _autoCloseTimer?.cancel();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text("Done"),
            ),
          ),
        ],
      ),
    );
  }
}
