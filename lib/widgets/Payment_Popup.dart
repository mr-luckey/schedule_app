// // // import 'package:flutter/material.dart';

// // // class PaymentPopup extends StatelessWidget {
// // //   const PaymentPopup({super.key});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Dialog(
// // //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
// // //       insetPadding: const EdgeInsets.all(16),
// // //       child: LayoutBuilder(
// // //         builder: (context, constraints) {
// // //           bool isMobile = constraints.maxWidth < 700;

// // //           return Container(
// // //             padding: const EdgeInsets.all(20),
// // //             constraints: const BoxConstraints(maxWidth: 900, minHeight: 500),
// // //             child: isMobile
// // //                 ? SingleChildScrollView(
// // //                     child: Column(
// // //                       children: [
// // //                         _eventDetails(),
// // //                         const SizedBox(height: 20),
// // //                         _paymentSection(context),
// // //                       ],
// // //                     ),
// // //                   )
// // //                 : Row(
// // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // //                     children: [
// // //                       Expanded(flex: 2, child: _eventDetails()),
// // //                       const SizedBox(width: 20),
// // //                       Expanded(flex: 3, child: _paymentSection(context)),
// // //                     ],
// // //                   ),
// // //           );
// // //         },
// // //       ),
// // //     );
// // //   }

// // //   // Left side (Event Details)
// // //   Widget _eventDetails() {
// // //     return Container(
// // //       padding: const EdgeInsets.all(20),
// // //       decoration: BoxDecoration(
// // //         color: Colors.green.shade50,
// // //         borderRadius: BorderRadius.circular(16),
// // //       ),
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           _eventItem(
// // //             Icons.event,
// // //             "Event Name",
// // //             "Grand Ballroom, Islamabad Pakistan",
// // //           ),
// // //           _eventItem(Icons.place, "Venue", "Innovation hub, wedding hall A"),
// // //           _eventItem(
// // //             Icons.access_time,
// // //             "Date & Time",
// // //             "November 15, 2025 | 09:00 AM - 05:00 PM",
// // //           ),
// // //           _eventItem(Icons.people, "Guests", "1 Attendee"),
// // //           _eventItem(
// // //             Icons.card_membership,
// // //             "Select Package",
// // //             "VIP Access Pass (Full Event)",
// // //           ),
// // //           const SizedBox(height: 10),
// // //           Text(
// // //             "Total Amount:",
// // //             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// // //           ),
// // //           const SizedBox(height: 5),
// // //           Text(
// // //             "£25,000",
// // //             style: TextStyle(
// // //               fontSize: 18,
// // //               fontWeight: FontWeight.bold,
// // //               color: Colors.green.shade700,
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Widget _eventItem(IconData icon, String title, String subtitle) {
// // //     return Padding(
// // //       padding: const EdgeInsets.only(bottom: 12.0),
// // //       child: Row(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           Icon(icon, color: Colors.green),
// // //           const SizedBox(width: 10),
// // //           Expanded(
// // //             child: Column(
// // //               crossAxisAlignment: CrossAxisAlignment.start,
// // //               children: [
// // //                 Text(
// // //                   title,
// // //                   style: const TextStyle(
// // //                     fontWeight: FontWeight.bold,
// // //                     fontSize: 14,
// // //                   ),
// // //                 ),
// // //                 Text(subtitle, style: const TextStyle(fontSize: 13)),
// // //               ],
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   // Right side (Payment + Billing)
// // //   Widget _paymentSection(BuildContext context) {
// // //     return Column(
// // //       crossAxisAlignment: CrossAxisAlignment.start,
// // //       children: [
// // //         const Text(
// // //           "Select Payment Method",
// // //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// // //         ),
// // //         const SizedBox(height: 10),
// // //         Wrap(
// // //           spacing: 12,
// // //           runSpacing: 12,
// // //           children: [
// // //             _paymentOption(Icons.credit_card, "Credit/Debit Card"),
// // //             _paymentOption(Icons.account_balance, "Bank Transfer"),
// // //             _paymentOption(Icons.phone_android, "JazzCash/Easypaisa"),
// // //             _paymentOption(Icons.attach_money, "Cash Payment"),
// // //           ],
// // //         ),
// // //         const SizedBox(height: 20),

// // //         const Text(
// // //           "Billing Information",
// // //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// // //         ),
// // //         const SizedBox(height: 10),

// // //         // Card Details
// // //         TextField(
// // //           decoration: InputDecoration(
// // //             labelText: "Cardholder name",
// // //             border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
// // //           ),
// // //         ),
// // //         const SizedBox(height: 12),
// // //         TextField(
// // //           decoration: InputDecoration(
// // //             labelText: "Card Number",
// // //             border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
// // //           ),
// // //         ),
// // //         const SizedBox(height: 12),
// // //         Row(
// // //           children: [
// // //             Expanded(
// // //               child: TextField(
// // //                 decoration: InputDecoration(
// // //                   labelText: "Expiry Date",
// // //                   border: OutlineInputBorder(
// // //                     borderRadius: BorderRadius.circular(8),
// // //                   ),
// // //                 ),
// // //               ),
// // //             ),
// // //             const SizedBox(width: 12),
// // //             Expanded(
// // //               child: TextField(
// // //                 decoration: InputDecoration(
// // //                   labelText: "CVV",
// // //                   border: OutlineInputBorder(
// // //                     borderRadius: BorderRadius.circular(8),
// // //                   ),
// // //                 ),
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //         const SizedBox(height: 12),

// // //         Row(
// // //           children: const [
// // //             Icon(Icons.verified_user, color: Colors.green, size: 20),
// // //             SizedBox(width: 6),
// // //             Text("Pay Securely", style: TextStyle(color: Colors.green)),
// // //           ],
// // //         ),
// // //         const SizedBox(height: 20),

// // //         // Billing Info
// // //         const Text(
// // //           "Billing Information",
// // //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// // //         ),
// // //         const SizedBox(height: 10),
// // //         TextField(
// // //           decoration: InputDecoration(
// // //             labelText: "Full Name",
// // //             border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
// // //           ),
// // //         ),
// // //         const SizedBox(height: 12),
// // //         TextField(
// // //           decoration: InputDecoration(
// // //             labelText: "Email",
// // //             border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
// // //           ),
// // //         ),
// // //         const SizedBox(height: 20),

// // //         Row(
// // //           children: [
// // //             Expanded(
// // //               child: OutlinedButton(
// // //                 onPressed: () => Navigator.pop(context),
// // //                 child: const Text("Cancel Payment"),
// // //               ),
// // //             ),
// // //             const SizedBox(width: 12),
// // //             Expanded(
// // //               child: ElevatedButton(
// // //                 style: ElevatedButton.styleFrom(
// // //                   backgroundColor: Colors.green,
// // //                   padding: const EdgeInsets.symmetric(vertical: 14),
// // //                   shape: RoundedRectangleBorder(
// // //                     borderRadius: BorderRadius.circular(10),
// // //                   ),
// // //                 ),
// // //                 onPressed: () {},
// // //                 child: const Text("Pay Now & Confirm Booking"),
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ],
// // //     );
// // //   }

// // //   Widget _paymentOption(IconData icon, String title) {
// // //     return Container(
// // //       width: 160,
// // //       padding: const EdgeInsets.all(14),
// // //       decoration: BoxDecoration(
// // //         border: Border.all(color: Colors.grey.shade300),
// // //         borderRadius: BorderRadius.circular(12),
// // //       ),
// // //       child: Row(
// // //         children: [
// // //           Icon(icon, color: Colors.green),
// // //           const SizedBox(width: 8),
// // //           Flexible(
// // //             child: Text(
// // //               title,
// // //               style: const TextStyle(fontSize: 14),
// // //               overflow: TextOverflow.ellipsis,
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }
// // import 'package:flutter/material.dart';
// // import 'package:intl/intl.dart';

// // class PaymentPopup extends StatelessWidget {
// //   final String eventName;
// //   final String venue;
// //   final DateTime date;
// //   final TimeOfDay startTime;
// //   final TimeOfDay endTime;
// //   final int guests;
// //   final String package;
// //   final double totalAmount;
// //   final String customerName;
// //   final String customerEmail;
// //   final VoidCallback onConfirm;
// //   final VoidCallback onCancel;

// //   const PaymentPopup({
// //     super.key,
// //     required this.eventName,
// //     required this.venue,
// //     required this.date,
// //     required this.startTime,
// //     required this.endTime,
// //     required this.guests,
// //     required this.package,
// //     required this.totalAmount,
// //     required this.customerName,
// //     required this.customerEmail,
// //     required this.onConfirm,
// //     required this.onCancel,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return Dialog(
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
// //       insetPadding: const EdgeInsets.all(16),
// //       child: LayoutBuilder(
// //         builder: (context, constraints) {
// //           bool isMobile = constraints.maxWidth < 700;

// //           return Container(
// //             padding: const EdgeInsets.all(20),
// //             constraints: const BoxConstraints(maxWidth: 900, minHeight: 500),
// //             child: isMobile
// //                 ? SingleChildScrollView(
// //                     child: Column(
// //                       children: [
// //                         _eventDetails(context),
// //                         const SizedBox(height: 20),
// //                         _paymentSection(context),
// //                       ],
// //                     ),
// //                   )
// //                 : Row(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Expanded(flex: 2, child: _eventDetails(context)),
// //                       const SizedBox(width: 20),
// //                       Expanded(flex: 3, child: _paymentSection(context)),
// //                     ],
// //                   ),
// //           );
// //         },
// //       ),
// //     );
// //   }

// //   // Left side (Event Details)
// //   Widget _eventDetails(BuildContext context) {
// //     String formattedDate = DateFormat("MMMM dd, yyyy").format(date);
// //     String formattedTime =
// //         "${_formatTimeOfDay(context, startTime)} - ${_formatTimeOfDay(context, endTime)}";

// //     return Container(
// //       padding: const EdgeInsets.all(20),
// //       decoration: BoxDecoration(
// //         color: Colors.green.shade50,
// //         borderRadius: BorderRadius.circular(16),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           _eventItem(Icons.event, "Event Name", eventName),
// //           _eventItem(Icons.place, "Venue", venue),
// //           _eventItem(
// //             Icons.access_time,
// //             "Date & Time",
// //             "$formattedDate | $formattedTime",
// //           ),
// //           _eventItem(Icons.people, "Guests", "$guests Attendee(s)"),
// //           _eventItem(Icons.card_membership, "Select Package", package),
// //           const SizedBox(height: 10),
// //           const Text(
// //             "Total Amount:",
// //             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// //           ),
// //           const SizedBox(height: 5),
// //           Text(
// //             "£${totalAmount.toStringAsFixed(0)}",
// //             style: TextStyle(
// //               fontSize: 18,
// //               fontWeight: FontWeight.bold,
// //               color: Colors.green.shade700,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   // Helper method to format TimeOfDay
// //   String _formatTimeOfDay(BuildContext context, TimeOfDay time) {
// //     final now = DateTime.now();
// //     final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
// //     final format = DateFormat.jm(); // Use the current locale's time format
// //     return format.format(dt);
// //   }

// //   Widget _eventItem(IconData icon, String title, String subtitle) {
// //     return Padding(
// //       padding: const EdgeInsets.only(bottom: 12.0),
// //       child: Row(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Icon(icon, color: Colors.green),
// //           const SizedBox(width: 10),
// //           Expanded(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   title,
// //                   style: const TextStyle(
// //                     fontWeight: FontWeight.bold,
// //                     fontSize: 14,
// //                   ),
// //                 ),
// //                 Text(subtitle, style: const TextStyle(fontSize: 13)),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   // Right side (Payment + Billing)
// //   Widget _paymentSection(BuildContext context) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         const Text(
// //           "Select Payment Method",
// //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// //         ),
// //         const SizedBox(height: 10),
// //         Wrap(
// //           spacing: 12,
// //           runSpacing: 12,
// //           children: [
// //             _paymentOption(Icons.credit_card, "Credit/Debit Card"),
// //             _paymentOption(Icons.account_balance, "Bank Transfer"),
// //             _paymentOption(Icons.phone_android, "JazzCash/Easypaisa"),
// //             _paymentOption(Icons.attach_money, "Cash Payment"),
// //           ],
// //         ),
// //         const SizedBox(height: 20),

// //         const Text(
// //           "Billing Information",
// //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// //         ),
// //         const SizedBox(height: 10),

// //         // Card Details
// //         TextField(
// //           decoration: InputDecoration(
// //             labelText: "Cardholder name",
// //             border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
// //           ),
// //         ),
// //         const SizedBox(height: 12),
// //         TextField(
// //           decoration: InputDecoration(
// //             labelText: "Card Number",
// //             border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
// //           ),
// //         ),
// //         const SizedBox(height: 12),
// //         Row(
// //           children: [
// //             Expanded(
// //               child: TextField(
// //                 decoration: InputDecoration(
// //                   labelText: "Expiry Date",
// //                   border: OutlineInputBorder(
// //                     borderRadius: BorderRadius.circular(8),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(width: 12),
// //             Expanded(
// //               child: TextField(
// //                 decoration: InputDecoration(
// //                   labelText: "CVV",
// //                   border: OutlineInputBorder(
// //                     borderRadius: BorderRadius.circular(8),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //         const SizedBox(height: 12),

// //         Row(
// //           children: const [
// //             Icon(Icons.verified_user, color: Colors.green, size: 20),
// //             SizedBox(width: 6),
// //             Text("Pay Securely", style: TextStyle(color: Colors.green)),
// //           ],
// //         ),
// //         const SizedBox(height: 20),

// //         const Text(
// //           "Billing Information",
// //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// //         ),
// //         const SizedBox(height: 10),
// //         TextField(
// //           controller: TextEditingController(text: customerName),
// //           decoration: InputDecoration(
// //             labelText: "Full Name",
// //             border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
// //           ),
// //         ),
// //         const SizedBox(height: 12),
// //         TextField(
// //           controller: TextEditingController(text: customerEmail),
// //           decoration: InputDecoration(
// //             labelText: "Email",
// //             border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
// //           ),
// //         ),
// //         const SizedBox(height: 20),

// //         Row(
// //           children: [
// //             Expanded(
// //               child: OutlinedButton(
// //                 onPressed: onCancel,
// //                 child: const Text("Cancel Payment"),
// //               ),
// //             ),
// //             const SizedBox(width: 12),
// //             Expanded(
// //               child: ElevatedButton(
// //                 style: ElevatedButton.styleFrom(
// //                   backgroundColor: Colors.green,
// //                   padding: const EdgeInsets.symmetric(vertical: 14),
// //                   shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(10),
// //                   ),
// //                 ),
// //                 onPressed: onConfirm,
// //                 child: const Text("Pay Now & Confirm Booking"),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _paymentOption(IconData icon, String title) {
// //     return Container(
// //       width: 160,
// //       padding: const EdgeInsets.all(14),
// //       decoration: BoxDecoration(
// //         border: Border.all(color: Colors.grey.shade300),
// //         borderRadius: BorderRadius.circular(12),
// //       ),
// //       child: Row(
// //         children: [
// //           Icon(icon, color: Colors.green),
// //           const SizedBox(width: 8),
// //           Flexible(
// //             child: Text(
// //               title,
// //               style: const TextStyle(fontSize: 14),
// //               overflow: TextOverflow.ellipsis,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:schedule_app/pages/Booking_Success.dart';
// import 'package:schedule_app/theme/app_colors.dart';

// // class PaymentPopup extends StatefulWidget {
// //   final String eventName;
// //   final String venue;
// //   final DateTime date;
// //   final TimeOfDay startTime;
// //   final TimeOfDay endTime;
// //   final int guests;
// //   final String package;
// //   final double totalAmount;
// //   final String customerName;
// //   final String customerEmail;
// //   final VoidCallback onConfirm;
// //   final VoidCallback onCancel;

// //   const PaymentPopup({
// //     super.key,
// //     required this.eventName,
// //     required this.venue,
// //     required this.date,
// //     required this.startTime,
// //     required this.endTime,
// //     required this.guests,
// //     required this.package,
// //     required this.totalAmount,
// //     required this.customerName,
// //     required this.customerEmail,
// //     required this.onConfirm,
// //     required this.onCancel,
// //   });

// //   @override
// //   State<PaymentPopup> createState() => _PaymentPopupState();
// // }

// // class _PaymentPopupState extends State<PaymentPopup> {
// //   int _selectedPaymentMethod = 0;
// //   final TextEditingController _cardNameController = TextEditingController();
// //   final TextEditingController _cardNumberController = TextEditingController();
// //   final TextEditingController _expiryDateController = TextEditingController();
// //   final TextEditingController _cvvController = TextEditingController();
// //   final TextEditingController _bankAccountController = TextEditingController();
// //   final TextEditingController _phoneNumberController = TextEditingController();

// //   @override
// //   void dispose() {
// //     _cardNameController.dispose();
// //     _cardNumberController.dispose();
// //     _expiryDateController.dispose();
// //     _cvvController.dispose();
// //     _bankAccountController.dispose();
// //     _phoneNumberController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Dialog(
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
// //       insetPadding: const EdgeInsets.all(16),
// //       child: LayoutBuilder(
// //         builder: (context, constraints) {
// //           bool isMobile = constraints.maxWidth < 700;

// //           return Container(
// //             padding: const EdgeInsets.all(20),
// //             constraints: const BoxConstraints(maxWidth: 900, minHeight: 500),
// //             color: Colors.white, // White background
// //             child: isMobile
// //                 ? SingleChildScrollView(
// //                     child: Column(
// //                       children: [
// //                         _eventDetails(context),
// //                         const SizedBox(height: 20),
// //                         _paymentSection(context),
// //                       ],
// //                     ),
// //                   )
// //                 : Row(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Expanded(flex: 2, child: _eventDetails(context)),
// //                       const SizedBox(width: 20),
// //                       Expanded(flex: 3, child: _paymentSection(context)),
// //                     ],
// //                   ),
// //           );
// //         },
// //       ),
// //     );
// //   }

// //   // Left side (Event Details)
// //   Widget _eventDetails(BuildContext context) {
// //     String formattedDate = DateFormat("MMMM dd, yyyy").format(widget.date);
// //     String formattedTime =
// //         "${_formatTimeOfDay(context, widget.startTime)} - ${_formatTimeOfDay(context, widget.endTime)}";

// //     return Container(
// //       padding: const EdgeInsets.all(20),
// //       decoration: BoxDecoration(
// //         color: Colors.grey.shade100, // Light gray background
// //         borderRadius: BorderRadius.circular(16),
// //         border: Border.all(color: Colors.grey.shade300),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           _eventItem(Icons.event, "Event Name", widget.eventName),
// //           _eventItem(Icons.place, "Venue", widget.venue),
// //           _eventItem(
// //             Icons.access_time,
// //             "Date & Time",
// //             "$formattedDate | $formattedTime",
// //           ),
// //           _eventItem(Icons.people, "Guests", "${widget.guests} Attendee(s)"),
// //           _eventItem(Icons.card_membership, "Select Package", widget.package),
// //           const SizedBox(height: 10),
// //           const Text(
// //             "Total Amount:",
// //             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// //           ),
// //           const SizedBox(height: 5),
// //           Text(
// //             "£${widget.totalAmount.toStringAsFixed(0)}",
// //             style: const TextStyle(
// //               fontSize: 18,
// //               fontWeight: FontWeight.bold,
// //               color: AppColors.primary, // Blue color for amount
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   // Helper method to format TimeOfDay
// //   String _formatTimeOfDay(BuildContext context, TimeOfDay time) {
// //     final now = DateTime.now();
// //     final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
// //     final format = DateFormat.jm(); // Use the current locale's time format
// //     return format.format(dt);
// //   }

// //   Widget _eventItem(IconData icon, String title, String subtitle) {
// //     return Padding(
// //       padding: const EdgeInsets.only(bottom: 12.0),
// //       child: Row(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Icon(icon, color: AppColors.primary), // Blue icons
// //           const SizedBox(width: 10),
// //           Expanded(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   title,
// //                   style: const TextStyle(
// //                     fontWeight: FontWeight.bold,
// //                     fontSize: 14,
// //                   ),
// //                 ),
// //                 Text(subtitle, style: const TextStyle(fontSize: 13)),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   // Right side (Payment + Billing)
// //   Widget _paymentSection(BuildContext context) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         const Text(
// //           "Select Payment Method",
// //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// //         ),
// //         const SizedBox(height: 10),

// //         // Payment method options
// //         _buildPaymentOptions(),
// //         const SizedBox(height: 20),

// //         // Show different input fields based on selected payment method
// //         _buildPaymentInputs(),
// //         const SizedBox(height: 20),

// //         const Text(
// //           "Billing Information",
// //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// //         ),
// //         const SizedBox(height: 10),

// //         TextField(
// //           controller: TextEditingController(text: widget.customerName),
// //           decoration: InputDecoration(
// //             labelText: "Full Name",
// //             border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
// //           ),
// //         ),
// //         const SizedBox(height: 12),

// //         TextField(
// //           controller: TextEditingController(text: widget.customerEmail),
// //           decoration: InputDecoration(
// //             labelText: "Email",
// //             border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
// //           ),
// //         ),
// //         const SizedBox(height: 20),

// //         Row(
// //           children: [
// //             Expanded(
// //               child: OutlinedButton(
// //                 onPressed: widget.onCancel,
// //                 style: OutlinedButton.styleFrom(
// //                   padding: const EdgeInsets.symmetric(vertical: 14),
// //                   side: const BorderSide(color: AppColors.primary),
// //                 ),
// //                 child: const Text(
// //                   "Cancel Payment",
// //                   style: TextStyle(color: AppColors.primary),
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(width: 12),
// //             Expanded(
// //               child: ElevatedButton(
// //                 style: ElevatedButton.styleFrom(
// //                   backgroundColor: AppColors.primary,
// //                   padding: const EdgeInsets.symmetric(vertical: 14),
// //                   shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(10),
// //                   ),
// //                 ),
// //                 onPressed: widget.onConfirm,
// //                 child: const Text("Pay Now & Confirm Booking"),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildPaymentOptions() {
// //     return Column(
// //       children: [
// //         // Credit/Debit Card
// //         _paymentOption(0, Icons.credit_card, "Credit/Debit Card"),
// //         const SizedBox(height: 8),

// //         // Bank Transfer
// //         _paymentOption(1, Icons.account_balance, "Bank Transfer"),
// //         const SizedBox(height: 8),

// //         // JazzCash/Easypaisa
// //         _paymentOption(2, Icons.phone_android, "JazzCash/Easypaisa"),
// //         const SizedBox(height: 8),

// //         // Cash Payment
// //         _paymentOption(3, Icons.attach_money, "Cash Payment"),
// //       ],
// //     );
// //   }

// //   Widget _paymentOption(int index, IconData icon, String title) {
// //     return GestureDetector(
// //       onTap: () {
// //         setState(() {
// //           _selectedPaymentMethod = index;
// //         });
// //       },
// //       child: Container(
// //         padding: const EdgeInsets.all(14),
// //         decoration: BoxDecoration(
// //           color: _selectedPaymentMethod == index
// //               ? AppColors.primary.withOpacity(0.1)
// //               : Colors.grey.shade100,
// //           border: Border.all(
// //             color: _selectedPaymentMethod == index
// //                 ? AppColors.primary
// //                 : Colors.grey.shade300,
// //             width: _selectedPaymentMethod == index ? 1.5 : 1,
// //           ),
// //           borderRadius: BorderRadius.circular(12),
// //         ),
// //         child: Row(
// //           children: [
// //             Icon(
// //               icon,
// //               color: _selectedPaymentMethod == index
// //                   ? AppColors.primary
// //                   : Colors.grey,
// //             ),
// //             const SizedBox(width: 8),
// //             Text(
// //               title,
// //               style: TextStyle(
// //                 fontSize: 14,
// //                 color: _selectedPaymentMethod == index
// //                     ? AppColors.primary
// //                     : Colors.black,
// //                 fontWeight: _selectedPaymentMethod == index
// //                     ? FontWeight.bold
// //                     : FontWeight.normal,
// //               ),
// //             ),
// //             const Spacer(),
// //             if (_selectedPaymentMethod == index)
// //               const Icon(
// //                 Icons.check_circle,
// //                 color: AppColors.primary,
// //                 size: 20,
// //               ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildPaymentInputs() {
// //     switch (_selectedPaymentMethod) {
// //       case 0: // Credit/Debit Card
// //         return Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             TextField(
// //               controller: _cardNameController,
// //               decoration: InputDecoration(
// //                 labelText: "Cardholder name",
// //                 border: OutlineInputBorder(
// //                   borderRadius: BorderRadius.circular(8),
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(height: 12),
// //             TextField(
// //               controller: _cardNumberController,
// //               decoration: InputDecoration(
// //                 labelText: "Card Number",
// //                 border: OutlineInputBorder(
// //                   borderRadius: BorderRadius.circular(8),
// //                 ),
// //               ),
// //               keyboardType: TextInputType.number,
// //             ),
// //             const SizedBox(height: 12),
// //             Row(
// //               children: [
// //                 Expanded(
// //                   child: TextField(
// //                     controller: _expiryDateController,
// //                     decoration: InputDecoration(
// //                       labelText: "Expiry Date (MM/YY)",
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(8),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //                 const SizedBox(width: 12),
// //                 Expanded(
// //                   child: TextField(
// //                     controller: _cvvController,
// //                     decoration: InputDecoration(
// //                       labelText: "CVV",
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(8),
// //                       ),
// //                     ),
// //                     keyboardType: TextInputType.number,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 12),
// //             Row(
// //               children: const [
// //                 Icon(Icons.verified_user, color: AppColors.primary, size: 20),
// //                 SizedBox(width: 6),
// //                 Text(
// //                   "Pay Securely",
// //                   style: TextStyle(color: AppColors.primary),
// //                 ),
// //               ],
// //             ),
// //           ],
// //         );

// //       case 1: // Bank Transfer
// //         return Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             TextField(
// //               controller: _bankAccountController,
// //               decoration: InputDecoration(
// //                 labelText: "Bank Account Number",
// //                 border: OutlineInputBorder(
// //                   borderRadius: BorderRadius.circular(8),
// //                 ),
// //               ),
// //               keyboardType: TextInputType.number,
// //             ),
// //             const SizedBox(height: 12),
// //             const Text(
// //               "Please transfer the amount to our bank account:\n\n"
// //               "Bank: ABC Bank\n"
// //               "Account #: 1234-5678-9012\n"
// //               "IBAN: PK36ABCD1234567890123456",
// //               style: TextStyle(fontSize: 14),
// //             ),
// //           ],
// //         );

// //       case 2: // JazzCash/Easypaisa
// //         return Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             TextField(
// //               controller: _phoneNumberController,
// //               decoration: InputDecoration(
// //                 labelText: "Phone Number",
// //                 border: OutlineInputBorder(
// //                   borderRadius: BorderRadius.circular(8),
// //                 ),
// //               ),
// //               keyboardType: TextInputType.phone,
// //             ),
// //             const SizedBox(height: 12),
// //             const Text(
// //               "Instructions:\n"
// //               "1. Open your JazzCash/Easypaisa app\n"
// //               "2. Send money to phone number: 0312-3456789\n"
// //               "3. Add your phone number in the reference",
// //               style: TextStyle(fontSize: 14),
// //             ),
// //           ],
// //         );

// //       case 3: // Cash Payment
// //         return const Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(
// //               "Cash Payment Instructions:\n\n"
// //               "Please bring the exact amount to the venue on the day of the event. "
// //               "Our staff will collect the payment and provide you with a receipt.",
// //               style: TextStyle(fontSize: 14),
// //             ),
// //           ],
// //         );

// //       default:
// //         return Container();
// //     }
// //   }
// // }
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:schedule_app/theme/app_colors.dart';
// // import 'package:schedule_app/widgets/booking_success_screen.dart'; // Import the success screen

// class PaymentPopup extends StatefulWidget {
//   final String eventName;
//   final String venue;
//   final DateTime date;
//   final TimeOfDay startTime;
//   final TimeOfDay endTime;
//   final int guests;
//   final String package;
//   final double totalAmount;
//   final String customerName;
//   final String customerEmail;
//   final VoidCallback onConfirm;
//   final VoidCallback onCancel;

//   const PaymentPopup({
//     super.key,
//     required this.eventName,
//     required this.venue,
//     required this.date,
//     required this.startTime,
//     required this.endTime,
//     required this.guests,
//     required this.package,
//     required this.totalAmount,
//     required this.customerName,
//     required this.customerEmail,
//     required this.onConfirm,
//     required this.onCancel,
//   });

//   @override
//   State<PaymentPopup> createState() => _PaymentPopupState();
// }

// class _PaymentPopupState extends State<PaymentPopup> {
//   int _selectedPaymentMethod = 0;
//   final TextEditingController _cardNameController = TextEditingController();
//   final TextEditingController _cardNumberController = TextEditingController();
//   final TextEditingController _expiryDateController = TextEditingController();
//   final TextEditingController _cvvController = TextEditingController();
//   final TextEditingController _bankAccountController = TextEditingController();
//   final TextEditingController _phoneNumberController = TextEditingController();

//   bool _isProcessing = false;
//   bool _showSuccessScreen = false;

//   @override
//   void dispose() {
//     _cardNameController.dispose();
//     _cardNumberController.dispose();
//     _expiryDateController.dispose();
//     _cvvController.dispose();
//     _bankAccountController.dispose();
//     _phoneNumberController.dispose();
//     super.dispose();
//   }

//   void _handlePaymentConfirmation() async {
//     setState(() {
//       _isProcessing = true;
//     });

//     // Simulate payment processing
//     await Future.delayed(const Duration(seconds: 2));

//     setState(() {
//       _isProcessing = false;
//       _showSuccessScreen = true;
//     });

//     // Call the original onConfirm callback
//     widget.onConfirm();
//   }

//   void _handleSuccessScreenFinish() {
//     setState(() {
//       _showSuccessScreen = false;
//     });
//     // You might want to navigate away or reset the form here
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_showSuccessScreen) {
//       return Dialog(
//         insetPadding: const EdgeInsets.all(16),
//         child: BookingSuccessScreen(onFinish: _handleSuccessScreenFinish),
//       );
//     }

//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       insetPadding: const EdgeInsets.all(16),
//       child: LayoutBuilder(
//         builder: (context, constraints) {
//           bool isMobile = constraints.maxWidth < 700;

//           return Container(
//             padding: const EdgeInsets.all(20),
//             constraints: const BoxConstraints(maxWidth: 900, minHeight: 500),
//             color: Colors.white,
//             child: _isProcessing
//                 ? const Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         CircularProgressIndicator(
//                           valueColor: AlwaysStoppedAnimation<Color>(
//                             AppColors.primary,
//                           ),
//                         ),
//                         SizedBox(height: 20),
//                         Text(
//                           "Processing your payment...",
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: AppColors.primary,
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//                 : isMobile
//                 ? SingleChildScrollView(
//                     child: Column(
//                       children: [
//                         _eventDetails(context),
//                         const SizedBox(height: 20),
//                         _paymentSection(context),
//                       ],
//                     ),
//                   )
//                 : Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Expanded(flex: 2, child: _eventDetails(context)),
//                       const SizedBox(width: 20),
//                       Expanded(flex: 3, child: _paymentSection(context)),
//                     ],
//                   ),
//           );
//         },
//       ),
//     );
//   }

//   // Left side (Event Details)
//   Widget _eventDetails(BuildContext context) {
//     String formattedDate = DateFormat("MMMM dd, yyyy").format(widget.date);
//     String formattedTime =
//         "${_formatTimeOfDay(context, widget.startTime)} - ${_formatTimeOfDay(context, widget.endTime)}";

//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade100,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _eventItem(Icons.event, "Event Name", widget.eventName),
//           _eventItem(Icons.place, "Venue", widget.venue),
//           _eventItem(
//             Icons.access_time,
//             "Date & Time",
//             "$formattedDate | $formattedTime",
//           ),
//           _eventItem(Icons.people, "Guests", "${widget.guests} Attendee(s)"),
//           _eventItem(Icons.card_membership, "Select Package", widget.package),
//           const SizedBox(height: 10),
//           const Text(
//             "Total Amount:",
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 5),
//           Text(
//             "£${widget.totalAmount.toStringAsFixed(0)}",
//             style: const TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: AppColors.primary,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Helper method to format TimeOfDay
//   String _formatTimeOfDay(BuildContext context, TimeOfDay time) {
//     final now = DateTime.now();
//     final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
//     final format = DateFormat.jm();
//     return format.format(dt);
//   }

//   Widget _eventItem(IconData icon, String title, String subtitle) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, color: AppColors.primary),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14,
//                   ),
//                 ),
//                 Text(subtitle, style: const TextStyle(fontSize: 13)),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Right side (Payment + Billing)
//   Widget _paymentSection(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Select Payment Method",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 10),

//         // Payment method options
//         _buildPaymentOptions(),
//         const SizedBox(height: 20),

//         // Show different input fields based on selected payment method
//         _buildPaymentInputs(),
//         const SizedBox(height: 20),

//         const Text(
//           "Billing Information",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 10),

//         TextField(
//           controller: TextEditingController(text: widget.customerName),
//           decoration: InputDecoration(
//             labelText: "Full Name",
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//           ),
//         ),
//         const SizedBox(height: 12),

//         TextField(
//           controller: TextEditingController(text: widget.customerEmail),
//           decoration: InputDecoration(
//             labelText: "Email",
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//           ),
//         ),
//         const SizedBox(height: 20),

//         Row(
//           children: [
//             Expanded(
//               child: OutlinedButton(
//                 onPressed: widget.onCancel,
//                 style: OutlinedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   side: const BorderSide(color: AppColors.primary),
//                 ),
//                 child: const Text(
//                   "Cancel Payment",
//                   style: TextStyle(color: AppColors.primary),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primary,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 onPressed: _handlePaymentConfirmation,
//                 child: const Text("Pay Now & Confirm Booking"),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildPaymentOptions() {
//     return Column(
//       children: [
//         // Credit/Debit Card
//         _paymentOption(0, Icons.credit_card, "Credit/Debit Card"),
//         const SizedBox(height: 8),

//         // Bank Transfer
//         _paymentOption(1, Icons.account_balance, "Bank Transfer"),
//         const SizedBox(height: 8),

//         // JazzCash/Easypaisa
//         _paymentOption(2, Icons.phone_android, "JazzCash/Easypaisa"),
//         const SizedBox(height: 8),

//         // Cash Payment
//         _paymentOption(3, Icons.attach_money, "Cash Payment"),
//       ],
//     );
//   }

//   Widget _paymentOption(int index, IconData icon, String title) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _selectedPaymentMethod = index;
//         });
//       },
//       child: Container(
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           color: _selectedPaymentMethod == index
//               ? AppColors.primary.withOpacity(0.1)
//               : Colors.grey.shade100,
//           border: Border.all(
//             color: _selectedPaymentMethod == index
//                 ? AppColors.primary
//                 : Colors.grey.shade300,
//             width: _selectedPaymentMethod == index ? 1.5 : 1,
//           ),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Row(
//           children: [
//             Icon(
//               icon,
//               color: _selectedPaymentMethod == index
//                   ? AppColors.primary
//                   : Colors.grey,
//             ),
//             const SizedBox(width: 8),
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 14,
//                 color: _selectedPaymentMethod == index
//                     ? AppColors.primary
//                     : Colors.black,
//                 fontWeight: _selectedPaymentMethod == index
//                     ? FontWeight.bold
//                     : FontWeight.normal,
//               ),
//             ),
//             const Spacer(),
//             if (_selectedPaymentMethod == index)
//               const Icon(
//                 Icons.check_circle,
//                 color: AppColors.primary,
//                 size: 20,
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPaymentInputs() {
//     switch (_selectedPaymentMethod) {
//       case 0: // Credit/Debit Card
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextField(
//               controller: _cardNameController,
//               decoration: InputDecoration(
//                 labelText: "Cardholder name",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: _cardNumberController,
//               decoration: InputDecoration(
//                 labelText: "Card Number",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               keyboardType: TextInputType.number,
//             ),
//             const SizedBox(height: 12),
//             Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _expiryDateController,
//                     decoration: InputDecoration(
//                       labelText: "Expiry Date (MM/YY)",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: TextField(
//                     controller: _cvvController,
//                     decoration: InputDecoration(
//                       labelText: "CVV",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     keyboardType: TextInputType.number,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             Row(
//               children: const [
//                 Icon(Icons.verified_user, color: AppColors.primary, size: 20),
//                 SizedBox(width: 6),
//                 Text(
//                   "Pay Securely",
//                   style: TextStyle(color: AppColors.primary),
//                 ),
//               ],
//             ),
//           ],
//         );

//       case 1: // Bank Transfer
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextField(
//               controller: _bankAccountController,
//               decoration: InputDecoration(
//                 labelText: "Bank Account Number",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               keyboardType: TextInputType.number,
//             ),
//             const SizedBox(height: 12),
//             const Text(
//               "Please transfer the amount to our bank account:\n\n"
//               "Bank: ABC Bank\n"
//               "Account #: 1234-5678-9012\n"
//               "IBAN: PK36ABCD1234567890123456",
//               style: TextStyle(fontSize: 14),
//             ),
//           ],
//         );

//       case 2: // JazzCash/Easypaisa
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextField(
//               controller: _phoneNumberController,
//               decoration: InputDecoration(
//                 labelText: "Phone Number",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               keyboardType: TextInputType.phone,
//             ),
//             const SizedBox(height: 12),
//             const Text(
//               "Instructions:\n"
//               "1. Open your JazzCash/Easypaisa app\n"
//               "2. Send money to phone number: 0312-3456789\n"
//               "3. Add your phone number in the reference",
//               style: TextStyle(fontSize: 14),
//             ),
//           ],
//         );

//       case 3: // Cash Payment
//         return const Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Cash Payment Instructions:\n\n"
//               "Please bring the exact amount to the venue on the day of the event. "
//               "Our staff will collect the payment and provide you with a receipt.",
//               style: TextStyle(fontSize: 14),
//             ),
//           ],
//         );

//       default:
//         return Container();
//     }
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  final TextEditingController _cardNameController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _bankAccountController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  bool _isProcessing = false;
  bool _showSuccessScreen = false;
  Timer? _processingTimer;

  @override
  void dispose() {
    // Cancel any ongoing timers
    _processingTimer?.cancel();

    // Dispose all controllers
    _cardNameController.dispose();
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _bankAccountController.dispose();
    _phoneNumberController.dispose();

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

      // Call the original onConfirm callback
      widget.onConfirm();
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

  // Left side (Event Details)
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

  // Helper method to format TimeOfDay
  String _formatTimeOfDay(BuildContext context, TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final format = DateFormat.jm();
    return format.format(dt);
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

  // Right side (Payment + Billing)
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

        // Payment method options
        _buildPaymentOptions(),
        const SizedBox(height: 20),

        // Show different input fields based on selected payment method
        _buildPaymentInputs(),
        const SizedBox(height: 20),

        const Text(
          "Billing Information",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),

        TextField(
          controller: TextEditingController(text: widget.customerName),
          decoration: InputDecoration(
            labelText: "Full Name",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
        ),
        const SizedBox(height: 12),

        TextField(
          controller: TextEditingController(text: widget.customerEmail),
          decoration: InputDecoration(
            labelText: "Email",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
        ),
        const SizedBox(height: 20),

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
                onPressed: _handlePaymentConfirmation,
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
        // Credit/Debit Card
        _paymentOption(0, Icons.credit_card, "Credit/Debit Card"),
        const SizedBox(height: 8),

        // Bank Transfer
        _paymentOption(1, Icons.account_balance, "Bank Transfer"),
        const SizedBox(height: 8),

        // JazzCash/Easypaisa
        _paymentOption(2, Icons.phone_android, "JazzCash/Easypaisa"),
        const SizedBox(height: 8),

        // Cash Payment
        _paymentOption(3, Icons.attach_money, "Cash Payment"),
      ],
    );
  }

  Widget _paymentOption(int index, IconData icon, String title) {
    return GestureDetector(
      onTap: () {
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

  Widget _buildPaymentInputs() {
    switch (_selectedPaymentMethod) {
      case 0: // Credit/Debit Card
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _cardNameController,
              decoration: InputDecoration(
                labelText: "Cardholder name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _cardNumberController,
              decoration: InputDecoration(
                labelText: "Card Number",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _expiryDateController,
                    decoration: InputDecoration(
                      labelText: "Expiry Date (MM/YY)",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _cvvController,
                    decoration: InputDecoration(
                      labelText: "CVV",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: const [
                Icon(Icons.verified_user, color: AppColors.primary, size: 20),
                SizedBox(width: 6),
                Text(
                  "Pay Securely",
                  style: TextStyle(color: AppColors.primary),
                ),
              ],
            ),
          ],
        );

      case 1: // Bank Transfer
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _bankAccountController,
              decoration: InputDecoration(
                labelText: "Bank Account Number",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            const Text(
              "Please transfer the amount to our bank account:\n\n"
              "Bank: ABC Bank\n"
              "Account #: 1234-5678-9012\n"
              "IBAN: PK36ABCD1234567890123456",
              style: TextStyle(fontSize: 14),
            ),
          ],
        );

      case 2: // JazzCash/Easypaisa
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            const Text(
              "Instructions:\n"
              "1. Open your JazzCash/Easypaisa app\n"
              "2. Send money to phone number: 0312-3456789\n"
              "3. Add your phone number in the reference",
              style: TextStyle(fontSize: 14),
            ),
          ],
        );

      case 3: // Cash Payment
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Cash Payment Instructions:\n\n"
              "Please bring the exact amount to the venue on the day of the event. "
              "Our staff will collect the payment and provide you with a receipt.",
              style: TextStyle(fontSize: 14),
            ),
          ],
        );

      default:
        return Container();
    }
  }
}

// Success Screen as a private class within the same file
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
    // Auto navigate after 5 seconds
    _autoCloseTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        widget.onFinish();
      }
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
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
          // Circle with confetti & thumbs up
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
              Positioned(
                top: 8,
                child: Icon(
                  Icons.auto_awesome,
                  color: Colors.purple[300],
                  size: 20,
                ),
              ),
              Positioned(
                right: 12,
                top: 20,
                child: const Icon(Icons.star, color: Colors.orange, size: 18),
              ),
              Positioned(
                left: 16,
                bottom: 20,
                child: const Icon(Icons.star, color: Colors.green, size: 16),
              ),
              Positioned(
                bottom: 8,
                right: 18,
                child: Icon(
                  Icons.auto_awesome,
                  color: Colors.pink[300],
                  size: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Title
          const Text(
            "Booking Completed Successfully",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // Subtitle
          const Text(
            "Your booking has been confirmed and payment has been processed successfully.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 24),

          // Manual close button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _autoCloseTimer?.cancel();
                widget.onFinish();
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
