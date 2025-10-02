// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:webview_flutter/webview_flutter.dart';

// // // ---------------- Popup Widget ----------------
// // class BookingReceiptPopup extends StatelessWidget {
// //   final String htmlContent;

// //   const BookingReceiptPopup({super.key, required this.htmlContent});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Dialog(
// //       insetPadding: const EdgeInsets.all(16),
// //       child: SizedBox(
// //         width: double.maxFinite,
// //         height: MediaQuery.of(context).size.height * 0.9,
// //         child: WebViewWidget(
// //           controller: WebViewController()
// //             ..setJavaScriptMode(JavaScriptMode.unrestricted)
// //             ..loadHtmlString(htmlContent),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // ---------------- Booking Controller Stub ----------------
// // // Replace with your existing BookingController
// // class BookingController extends GetxController {
// //   final nameController = TextEditingController(text: "Sarah & Michael Johnson");
// //   final emailController = TextEditingController(
// //     text: "sarah.johnson@email.com",
// //   );
// //   final contactController = TextEditingController(text: "+44-789-123-4567");
// //   final selectedCity = "Royal Gardens Hotel, London".obs;
// //   final selectedEventType = "Wedding Reception".obs;
// //   final selectedDate = DateTime(2025, 10, 12).obs;
// //   final startTime = const TimeOfDay(hour: 18, minute: 0).obs;
// //   final endTime = const TimeOfDay(hour: 23, minute: 30).obs;
// //   final guests = 120.obs;
// //   final selectedPackage = "Premium Wedding Package".obs;

// //   double calculateTotal() => 7963.20;

// //   String getTimeRange(BuildContext context) {
// //     return "${startTime.value.format(context)} - ${endTime.value.format(context)}";
// //   }
// // }

// // // ---------------- Show Booking Confirmation ----------------
// // void showBookingConfirmation(BookingController controller) {
// //   // Exact HTML template you provided (trimmed for brevity here)
// //   String htmlTemplate = """
// // <!DOCTYPE html>
// // <html lang="en">
// // <head>
// // <meta charset="UTF-8">
// // <meta name="viewport" content="width=device-width, initial-scale=1.0">
// // <title>Booking Confirmation Receipt - A4</title>
// // <style>
// // * { margin: 0; padding: 0; box-sizing: border-box; }
// // body { font-family: 'Times New Roman', serif; background-color: white; color: #000; line-height: 1.2; font-size: 12px; }
// // .receipt-container { width: 210mm; height: 297mm; margin: 0 auto; background: white; border: 2px solid #000; padding: 15mm; overflow: hidden; }
// // .header { text-align: center; border-bottom: 2px solid #000; padding-bottom: 8px; margin-bottom: 12px; }
// // .company-name { font-size: 20px; font-weight: bold; margin-bottom: 3px; text-transform: uppercase; }
// // .company-details { font-size: 10px; margin-bottom: 8px; line-height: 1.3; }
// // .receipt-title { font-size: 16px; font-weight: bold; text-transform: uppercase; margin-top: 8px; }
// // </style>
// // </head>
// // <body>
// // <div class="receipt-container">
// //   <div class="header">
// //     <div class="company-name">Premium Event Catering Ltd.</div>
// //     <div class="company-details">
// //       123 Wedding Lane, London, EC1A 1BB<br>
// //       Tel: +44-20-7123-4567 | Email: events@premiumcatering.co.uk | VAT: GB123456789
// //     </div>
// //     <div class="receipt-title">Booking Confirmation Receipt</div>
// //   </div>

// //   <div>
// //     <strong>Customer:</strong> {{customerName}}<br>
// //     <strong>Email:</strong> {{customerEmail}}<br>
// //     <strong>Contact:</strong> {{customerContact}}<br>
// //     <strong>Event:</strong> {{eventType}}<br>
// //     <strong>Date:</strong> {{eventDate}}<br>
// //     <strong>Time:</strong> {{eventTime}}<br>
// //     <strong>Guests:</strong> {{guests}} persons<br>
// //     <strong>Package:</strong> {{package}}<br>
// //     <strong>Total:</strong> £{{total}}
// //   </div>
// // </div>
// // </body>
// // </html>
// // """;

// //   // Replace placeholders with controller values
// //   String filledHtml = htmlTemplate
// //       .replaceAll("{{customerName}}", controller.nameController.text)
// //       .replaceAll("{{customerEmail}}", controller.emailController.text)
// //       .replaceAll("{{customerContact}}", controller.contactController.text)
// //       .replaceAll("{{eventType}}", controller.selectedEventType.value)
// //       .replaceAll(
// //         "{{eventDate}}",
// //         "${controller.selectedDate.value.day}/${controller.selectedDate.value.month}/${controller.selectedDate.value.year}",
// //       )
// //       .replaceAll(
// //         "{{eventTime}}",
// //         controller.getTimeRange(Get.context ?? Get.overlayContext!),
// //       )
// //       .replaceAll("{{guests}}", controller.guests.value.toString())
// //       .replaceAll("{{package}}", controller.selectedPackage.value)
// //       .replaceAll("{{total}}", controller.calculateTotal().toStringAsFixed(2));

// //   Get.dialog(
// //     BookingReceiptPopup(htmlContent: filledHtml),
// //     barrierDismissible: false,
// //   );
// // }
// import 'package:flutter/material.dart';

// class ReceiptWidget extends StatelessWidget {
//   final TextEditingController nameController;
//   final TextEditingController emailController;
//   final TextEditingController contactController;

//   // Simple primitive values to avoid coupling to GetX in this widget.
//   final String selectedCity;
//   final String selectedEventType;
//   final String selectedPackage;
//   final DateTime? selectedDate;
//   final TimeOfDay? startTime;
//   final TimeOfDay? endTime;
//   final int guests;

//   /// A function that returns the menu map exactly like your HTML code expects:
//   /// Map<String, List<Map<String, dynamic>>> with keys "Food Items" and "Services".
//   final Map<String, List<Map<String, dynamic>>> Function(
//       String package, int guests) menuForPackage;

//   /// Called when user taps cancel (top-right ✕).
//   final VoidCallback? onCancel;

//   /// Called when user taps Close button.
//   final VoidCallback? onClose;

//   const ReceiptWidget({
//     super.key,
//     required this.nameController,
//     required this.emailController,
//     required this.contactController,
//     required this.selectedCity,
//     required this.selectedEventType,
//     required this.selectedPackage,
//     required this.selectedDate,
//     required this.startTime,
//     required this.endTime,
//     required this.guests,
//     required this.menuForPackage,
//     this.onCancel,
//     this.onClose,
//   });

//   String _formatDate(DateTime? date) {
//     if (date == null) return 'Not set';
//     final day = date.day;
//     final month = date.month;
//     final year = date.year;
//     final suffixes = [
//       'th',
//       'st',
//       'nd',
//       'rd',
//       'th',
//       'th',
//       'th',
//       'th',
//       'th',
//       'th',
//     ];
//     final suffix = (day % 10) <= suffixes.length - 1
//         ? suffixes[day % 10]
//         : 'th';
//     final months = [
//       '',
//       'January',
//       'February',
//       'March',
//       'April',
//       'May',
//       'June',
//       'July',
//       'August',
//       'September',
//       'October',
//       'November',
//       'December',
//     ];
//     return '$day$suffix ${months[month]} $year';
//   }

//   String _formatTime(TimeOfDay? time) {
//     if (time == null) return 'Not set';
//     final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
//     final minute = time.minute.toString().padLeft(2, '0');
//     final period = time.period == DayPeriod.am ? 'AM' : 'PM';
//     return '$hour:$minute $period';
//   }

//   String _getCustomerInitials() {
//     final text = nameController.text.trim();
//     if (text.isEmpty) return 'CUST';
//     final parts = text.split(' ').where((p) => p.isNotEmpty).toList();
//     if (parts.isEmpty) return 'CUST';
//     if (parts.length == 1) return parts[0][0].toUpperCase();
//     final first = parts.first[0].toUpperCase();
//     final last = parts.last[0].toUpperCase();
//     return '$first$last';
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Obtain menu for given package & guests (same as your HTML).
//     final menu = menuForPackage(selectedPackage, guests > 0 ? guests : 1);
//     final foodItems = menu['Food Items'] ?? <Map<String, dynamic>>[];
//     final services = menu['Services'] ?? <Map<String, dynamic>>[];

//     double foodSubtotal = 0;
//     for (final item in foodItems) {
//       final price = (item['price'] as num).toDouble();
//       final qty = (item['qty'] as int);
//       foodSubtotal += price * qty;
//     }

//     double servicesSubtotal = 0;
//     for (final item in services) {
//       final price = (item['price'] as num).toDouble();
//       final qty = (item['qty'] as int);
//       servicesSubtotal += price * qty;
//     }

//     final netAmount = foodSubtotal + servicesSubtotal;
//     final serviceCharge = netAmount * 0.10;
//     final discount = netAmount * 0.05;
//     final subtotalAfterDiscount = netAmount + serviceCharge - discount;
//     final vat = subtotalAfterDiscount * 0.20;
//     final totalAmount = subtotalAfterDiscount + vat;

//     // Build UI
//     return Scaffold(
//       backgroundColor: const Color(0xFFF0F0F0),
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Center(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(10),
//                 child: Container(
//                   // approximate A4-like canvas with border and padding
//                   width: 800, // good desktop width; adjust to your needs
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     border: Border.all(width: 2, color: Colors.black),
//                   ),
//                   padding: const EdgeInsets.all(24),
//                   child: DefaultTextStyle(
//                     style: const TextStyle(
//                       fontFamily: 'Times New Roman',
//                       fontSize: 12,
//                       color: Colors.black,
//                       height: 1.2,
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         // Header
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text(
//                               'Premium Event Catering Ltd.',
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                                 letterSpacing: 0.5,
//                                 // uppercase matching original
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               '123 Wedding Lane, London, EC1A 1BB\n'
//                               'Tel: +44-20-7123-4567 | Email: events@premiumcatering.co.uk | VAT: GB123456789',
//                               textAlign: TextAlign.center,
//                               style: const TextStyle(fontSize: 10, height: 1.3),
//                             ),
//                             const SizedBox(height: 8),
//                             Text(
//                               'Booking Confirmation Receipt',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),

//                         const SizedBox(height: 12),
//                         // Receipt info (two columns)
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text('Receipt No: WED-${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}-001',
//                                     style: const TextStyle(fontSize: 9)),
//                                 const SizedBox(height: 4),
//                                 Text('Date: ${_formatDate(DateTime.now())}',
//                                     style: const TextStyle(fontSize: 9)),
//                                 const SizedBox(height: 4),
//                                 Text('Payment Method: Bank Transfer',
//                                     style: const TextStyle(fontSize: 9)),
//                               ],
//                             ),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 Text('Account Manager: Emma Wilson', style: const TextStyle(fontSize: 9)),
//                                 const SizedBox(height: 4),
//                                 Text('Reference: WEDDING-${_getCustomerInitials()}-001', style: const TextStyle(fontSize: 9)),
//                                 const SizedBox(height: 4),
//                                 Text('Status: CONFIRMED', style: const TextStyle(fontSize: 9)),
//                               ],
//                             ),
//                           ],
//                         ),

//                         const SizedBox(height: 12),
//                         // Two-column: Customer Information + Event Details
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // Left column
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Container(
//                                     padding: const EdgeInsets.only(bottom: 6),
//                                     decoration: const BoxDecoration(
//                                       border: Border(
//                                         bottom: BorderSide(color: Colors.black, width: 1),
//                                       ),
//                                     ),
//                                     child: const Text(
//                                       'Customer Information',
//                                       style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
//                                     ),
//                                   ),
//                                   const SizedBox(height: 6),
//                                   Table(
//                                     columnWidths: const {
//                                       0: FixedColumnWidth(140),
//                                       1: FlexColumnWidth(),
//                                     },
//                                     defaultVerticalAlignment: TableCellVerticalAlignment.top,
//                                     children: [
//                                       TableRow(children: [
//                                         const Padding(
//                                           padding: EdgeInsets.symmetric(vertical: 2),
//                                           child: Text('Customer Name:'),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.symmetric(vertical: 2),
//                                           child: Text(nameController.text),
//                                         ),
//                                       ]),
//                                       TableRow(children: [
//                                         const Padding(
//                                           padding: EdgeInsets.symmetric(vertical: 2),
//                                           child: Text('Email:'),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.symmetric(vertical: 2),
//                                           child: Text(emailController.text),
//                                         ),
//                                       ]),
//                                       TableRow(children: [
//                                         const Padding(
//                                           padding: EdgeInsets.symmetric(vertical: 2),
//                                           child: Text('Contact:'),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.symmetric(vertical: 2),
//                                           child: Text(contactController.text),
//                                         ),
//                                       ]),
//                                       TableRow(children: [
//                                         const Padding(
//                                           padding: EdgeInsets.symmetric(vertical: 2),
//                                           child: Text('Event Address:'),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.symmetric(vertical: 2),
//                                           child: Text(selectedCity),
//                                         ),
//                                       ]),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),

//                             const SizedBox(width: 10),

//                             // Right column
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Container(
//                                     padding: const EdgeInsets.only(bottom: 6),
//                                     decoration: const BoxDecoration(
//                                       border: Border(
//                                         bottom: BorderSide(color: Colors.black, width: 1),
//                                       ),
//                                     ),
//                                     child: const Text(
//                                       'Event Details',
//                                       style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
//                                     ),
//                                   ),
//                                   const SizedBox(height: 6),
//                                   Table(
//                                     columnWidths: const {
//                                       0: FixedColumnWidth(140),
//                                       1: FlexColumnWidth(),
//                                     },
//                                     children: [
//                                       TableRow(children: [
//                                         const Padding(
//                                           padding: EdgeInsets.symmetric(vertical: 2),
//                                           child: Text('Event Type:'),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.symmetric(vertical: 2),
//                                           child: Text(selectedEventType),
//                                         ),
//                                       ]),
//                                       TableRow(children: [
//                                         const Padding(
//                                           padding: EdgeInsets.symmetric(vertical: 2),
//                                           child: Text('Date:'),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.symmetric(vertical: 2),
//                                           child: Text(_formatDate(selectedDate)),
//                                         ),
//                                       ]),
//                                       TableRow(children: [
//                                         const Padding(
//                                           padding: EdgeInsets.symmetric(vertical: 2),
//                                           child: Text('Time:'),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.symmetric(vertical: 2),
//                                           child: Text('${_formatTime(startTime)} - ${_formatTime(endTime)}'),
//                                         ),
//                                       ]),
//                                       TableRow(children: [
//                                         const Padding(
//                                           padding: EdgeInsets.symmetric(vertical: 2),
//                                           child: Text('Guests:'),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.symmetric(vertical: 2),
//                                           child: Text('$guests persons'),
//                                         ),
//                                       ]),
//                                       TableRow(children: [
//                                         const Padding(
//                                           padding: EdgeInsets.symmetric(vertical: 2),
//                                           child: Text('Package:'),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.symmetric(vertical: 2),
//                                           child: Text(selectedPackage),
//                                         ),
//                                       ]),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),

//                         const SizedBox(height: 12),
//                         // Food Items Table
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.only(bottom: 6),
//                               decoration: const BoxDecoration(
//                                 border: Border(
//                                   bottom: BorderSide(color: Colors.black, width: 1),
//                                 ),
//                               ),
//                               child: const Text(
//                                 'Food Items',
//                                 style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             Table(
//                               border: TableBorder.all(color: Colors.black, width: 1),
//                               columnWidths: const {
//                                 0: FlexColumnWidth(5),
//                                 1: FlexColumnWidth(2),
//                                 2: FlexColumnWidth(2),
//                                 3: FlexColumnWidth(2),
//                               },
//                               children: [
//                                 // header row
//                                 TableRow(children: [
//                                   Container(
//                                       padding: const EdgeInsets.all(6),
//                                       color: const Color(0xFFF0F0F0),
//                                       child: const Text('Description', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
//                                   Container(
//                                       padding: const EdgeInsets.all(6),
//                                       color: const Color(0xFFF0F0F0),
//                                       child: const Text('Qty', textAlign: TextAlign.right, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
//                                   Container(
//                                       padding: const EdgeInsets.all(6),
//                                       color: const Color(0xFFF0F0F0),
//                                       child: const Text('Unit Price', textAlign: TextAlign.right, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
//                                   Container(
//                                       padding: const EdgeInsets.all(6),
//                                       color: const Color(0xFFF0F0F0),
//                                       child: const Text('Amount', textAlign: TextAlign.right, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
//                                 ]),
//                                 // item rows
//                                 ...foodItems.map((item) {
//                                   final price = (item['price'] as num).toDouble();
//                                   final qty = (item['qty'] as int);
//                                   final amount = price * qty;
//                                   return TableRow(children: [
//                                     Padding(padding: const EdgeInsets.all(6), child: Text(item['name'].toString())),
//                                     Padding(padding: const EdgeInsets.all(6), child: Text(qty.toString(), textAlign: TextAlign.right)),
//                                     Padding(padding: const EdgeInsets.all(6), child: Text('£${price.toStringAsFixed(2)}', textAlign: TextAlign.right)),
//                                     Padding(padding: const EdgeInsets.all(6), child: Text('£${amount.toStringAsFixed(2)}', textAlign: TextAlign.right)),
//                                   ]);
//                                 }),
//                               ],
//                             ),
//                           ],
//                         ),

//                         const SizedBox(height: 12),
//                         // Services Table
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.only(bottom: 6),
//                               decoration: const BoxDecoration(
//                                 border: Border(
//                                   bottom: BorderSide(color: Colors.black, width: 1),
//                                 ),
//                               ),
//                               child: const Text(
//                                 'Additional Services',
//                                 style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             Table(
//                               border: TableBorder.all(color: Colors.black, width: 1),
//                               columnWidths: const {
//                                 0: FlexColumnWidth(5),
//                                 1: FlexColumnWidth(2),
//                                 2: FlexColumnWidth(2),
//                                 3: FlexColumnWidth(2),
//                               },
//                               children: [
//                                 TableRow(children: [
//                                   Container(
//                                       padding: const EdgeInsets.all(6),
//                                       color: const Color(0xFFF0F0F0),
//                                       child: const Text('Service Description', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
//                                   Container(
//                                       padding: const EdgeInsets.all(6),
//                                       color: const Color(0xFFF0F0F0),
//                                       child: const Text('Qty', textAlign: TextAlign.right, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
//                                   Container(
//                                       padding: const EdgeInsets.all(6),
//                                       color: const Color(0xFFF0F0F0),
//                                       child: const Text('Rate', textAlign: TextAlign.right, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
//                                   Container(
//                                       padding: const EdgeInsets.all(6),
//                                       color: const Color(0xFFF0F0F0),
//                                       child: const Text('Amount', textAlign: TextAlign.right, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
//                                 ]),
//                                 ...services.map((item) {
//                                   final price = (item['price'] as num).toDouble();
//                                   final qty = (item['qty'] as int);
//                                   final amount = price * qty;
//                                   return TableRow(children: [
//                                     Padding(padding: const EdgeInsets.all(6), child: Text(item['name'].toString())),
//                                     Padding(padding: const EdgeInsets.all(6), child: Text(qty.toString(), textAlign: TextAlign.right)),
//                                     Padding(padding: const EdgeInsets.all(6), child: Text('£${price.toStringAsFixed(2)}', textAlign: TextAlign.right)),
//                                     Padding(padding: const EdgeInsets.all(6), child: Text('£${amount.toStringAsFixed(2)}', textAlign: TextAlign.right)),
//                                   ]);
//                                 }),
//                               ],
//                             ),
//                           ],
//                         ),

//                         const SizedBox(height: 12),
//                         // Subtotal section
//                         Container(
//                           padding: const EdgeInsets.all(8),
//                           decoration: BoxDecoration(border: Border.all(color: Colors.black)),
//                           child: Column(
//                             children: [
//                               _subtotalRow('Food Items Subtotal:', '£${foodSubtotal.toStringAsFixed(2)}'),
//                               _subtotalRow('Services Subtotal:', '£${servicesSubtotal.toStringAsFixed(2)}'),
//                               _subtotalRow('Net Amount:', '£${netAmount.toStringAsFixed(2)}'),
//                               _subtotalRow('Service Charge (10%):', '£${serviceCharge.toStringAsFixed(2)}'),
//                               _subtotalRow('Early Booking Discount (5%):', '-£${discount.toStringAsFixed(2)}'),
//                               _subtotalRow('Subtotal after Discount:', '£${subtotalAfterDiscount.toStringAsFixed(2)}'),
//                               _subtotalRow('VAT @ 20%:', '£${vat.toStringAsFixed(2)}'),
//                               const Divider(height: 8, thickness: 2),
//                               _subtotalRow('TOTAL AMOUNT:', '£${totalAmount.toStringAsFixed(2)}', isTotal: true),
//                             ],
//                           ),
//                         ),

//                         const SizedBox(height: 12),
//                         // Footer with payment note, terms, signatures
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text(
//                               'BOOKING CONFIRMED - PAYMENT DUE: 50% DEPOSIT BY ${_formatDate(selectedDate?.subtract(const Duration(days: 14)))}',
//                               style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
//                               textAlign: TextAlign.center,
//                             ),
//                             const SizedBox(height: 4),
//                             const Text('Balance payment due 7 days prior to event date', style: TextStyle(fontSize: 9)),
//                             const SizedBox(height: 8),
//                             const Text(
//                               'Terms & Conditions: This booking is subject to our standard terms and conditions. Cancellation policy: 30 days notice required for full refund minus 10% administration fee. Final guest numbers must be confirmed 7 days prior to event. Additional charges may apply for changes made within 48 hours of event. All prices include VAT at current rate.',
//                               style: TextStyle(fontSize: 8),
//                               textAlign: TextAlign.justify,
//                             ),
//                             const SizedBox(height: 12),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Column(
//                                   children: [
//                                     Container(height: 20, width: 150, decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black)))),
//                                     const SizedBox(height: 4),
//                                     const Text('Customer Signature', style: TextStyle(fontSize: 8)),
//                                   ],
//                                 ),
//                                 Column(
//                                   children: [
//                                     Container(height: 20, width: 150, decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black)))),
//                                     const SizedBox(height: 4),
//                                     const Text('Authorized Signature', style: TextStyle(fontSize: 8)),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 20),
//                             ElevatedButton(
//                               onPressed: onClose,
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: const Color(0xFF28A745),
//                                 padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                                 textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                               ),
//                               child: const Text('Close'),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//             // Cancel icon top-right
//             Positioned(
//               top: 12,
//               right: 12,
//               child: GestureDetector(
//                 onTap: onCancel,
//                 child: const CircleAvatar(
//                   radius: 16,
//                   backgroundColor: Colors.white,
//                   child: Text(
//                     '✕',
//                     style: TextStyle(color: Colors.red, fontSize: 18),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _subtotalRow(String left, String right, {bool isTotal = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(left, style: TextStyle(fontSize: isTotal ? 11 : 9, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
//           Text(right, style: TextStyle(fontSize: isTotal ? 11 : 9, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
//         ],
//       ),
//     );
//   }
// }
