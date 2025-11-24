import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schedule_app/controllers/booking_controller.dart';
import 'package:schedule_app/pages/Edit/EditController.dart';
import 'package:schedule_app/pages/schedule_page.dart';
import 'package:schedule_app/theme/app_colors.dart';

class EditReceiptScreen extends StatelessWidget {
  final EditController controller = Get.find<EditController>();

  EditReceiptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Booking Confirmation Receipt'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          width: 794, // A4 width in pixels at 96 DPI
          height: 1123, // A4 height in pixels at 96 DPI
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(56.7), // 15mm in pixels
              child: _buildReceiptContent(context),
            ),
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: ()async {
              // Print or share functionality
              bool success = await controller.completeEdit();
              if (success) {
                Get.offAll(()=>SchedulePage());
              } else {
                // Show error message if update fails
                Get.snackbar(
                    'Error',
                    'Failed to update order',
                    backgroundColor: Colors.red,
                    colorText: Colors.white
                );
              }
            },
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.arrow_forward, color: Colors.white),
          ),
          SizedBox(width: 20,),
          FloatingActionButton(
            onPressed: () {
              // Print or share functionality
              _printReceipt();
            },
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.print, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptContent(BuildContext context) {
    final menu = controller.menuForPackage(
      controller.selectedPackage.value,
      controller.guests.value > 0 ? controller.guests.value : 1,
    );
    print("TESTING RECEIPT MENU: $menu");
    // Calculate totals
    double foodSubtotal = 0;
    double servicesSubtotal = 0;

    for (var item in menu['Food Items']!) {
      foodSubtotal += (item['price'] as num).toDouble() * (item['qty'] as int);
    }

    for (var item in menu['Services']!) {
      servicesSubtotal +=
          (item['price'] as num).toDouble() * (item['qty'] as int);
    }

    double netAmount = foodSubtotal + servicesSubtotal;
    double serviceCharge = netAmount * 0.10;
    double discount = netAmount * 0.05;
    double subtotalAfterDiscount = netAmount + serviceCharge - discount;
    double vat = subtotalAfterDiscount * 0.20;
    double totalAmount = subtotalAfterDiscount + vat;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        _buildHeader(),
        const SizedBox(height: 12),

        // Receipt Info
        _buildReceiptInfo(),
        const SizedBox(height: 12),

        // Two Column Layout
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildCustomerInfo(),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildEventDetails(),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Food Items
        _buildFoodItemsSection(menu['Food Items']!),
        const SizedBox(height: 20),

        // Additional Services
        _buildServicesSection(menu['Services']!),
        const SizedBox(height: 20),

        // Subtotal Section
        _buildSubtotalSection(
          foodSubtotal,
          servicesSubtotal,
          netAmount,
          serviceCharge,
          discount,
          subtotalAfterDiscount,
          vat,
          totalAmount,
        ),
        const SizedBox(height: 20),

        // Footer
        _buildFooter(),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const Text(
          'Quaid E Azam Grand BallRoom.',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Times New Roman',
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 3),
        const Text(
          '123 Wedding Lane, London, EC1A 1BB\n'
              'Tel: +44-20-7123-4567 | Email: events@qahall.co.uk | VAT: GB123456789',
          style: TextStyle(
            fontSize: 10,
            fontFamily: 'Times New Roman',
            height: 1.3,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 2,
          color: Colors.black,
        ),
        const SizedBox(height: 8),
        const Text(
          'Booking Confirmation Receipt',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Times New Roman',
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildReceiptInfo() {
    String getCustomerInitials() {
      if (controller.nameController.text.isEmpty) return 'CUST';
      final names = controller.nameController.text
          .trim()
          .split(' ')
          .where((name) => name.isNotEmpty)
          .toList();
      if (names.isEmpty) return 'CUST';
      if (names.length == 1) {
        return names[0].isNotEmpty ? names[0][0].toUpperCase() : 'CUST';
      }
      final firstInitial = names[0].isNotEmpty ? names[0][0].toUpperCase() : '';
      final lastInitial = names.last.isNotEmpty
          ? names.last[0].toUpperCase()
          : '';
      return firstInitial + lastInitial;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Receipt No: WED-${DateFormat('yyyy-MM-dd').format(DateTime.now())}-001',
              style: const TextStyle(fontSize: 9, fontFamily: 'Times New Roman'),
            ),
            Text(
              'Date: ${_formatDate(DateTime.now())}',
              style: const TextStyle(fontSize: 9, fontFamily: 'Times New Roman'),
            ),
            Text(
              'Payment Method: Cash',
              style: const TextStyle(fontSize: 9, fontFamily: 'Times New Roman'),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'Account Manager: Emma Wilson',
              style: TextStyle(fontSize: 9, fontFamily: 'Times New Roman'),
            ),
            Text(
              'Reference: WEDDING-${getCustomerInitials()}-001',
              style: const TextStyle(fontSize: 9, fontFamily: 'Times New Roman'),
            ),
            const Text(
              'Status: CONFIRMED',
              style: TextStyle(fontSize: 9, fontFamily: 'Times New Roman'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCustomerInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Customer Information',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            fontFamily: 'Times New Roman',
          ),
        ),
        const SizedBox(height: 2),
        Container(
          width: double.infinity,
          height: 1,
          color: Colors.black,
        ),
        const SizedBox(height: 5),
        _buildInfoRow('Customer Name:', controller.nameController.text),
        _buildInfoRow('Email:', controller.emailController.text),
        _buildInfoRow('Contact:', controller.contactController.text),
        _buildInfoRow('Event Address:', controller.selectedCity.value),
      ],
    );
  }

  Widget _buildEventDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Event Details',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            fontFamily: 'Times New Roman',
          ),
        ),
        const SizedBox(height: 2),
        Container(
          width: double.infinity,
          height: 1,
          color: Colors.black,
        ),
        const SizedBox(height: 5),
        _buildInfoRow('Event Type:', controller.selectedEventType.value),
        _buildInfoRow('Date:', _formatDate(controller.selectedDate.value)),
        _buildInfoRow('Time:', '${_formatTime(controller.startTime.value)} - ${_formatTime(controller.endTime.value)}'),
        _buildInfoRow('Guests:', '${controller.guests.value} persons'),
        _buildInfoRow('Package:', controller.selectedPackage.value),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                fontFamily: 'Times New Roman',
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? 'Not set' : value,
              style: const TextStyle(
                fontSize: 9,
                fontFamily: 'Times New Roman',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodItemsSection(List<Map<String, dynamic>> foodItems) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Food Items',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            fontFamily: 'Times New Roman',
          ),
        ),
        const SizedBox(height: 2),
        Container(
          width: double.infinity,
          height: 1,
          color: Colors.black,
        ),
        const SizedBox(height: 5),
        _buildItemsTable(foodItems, isFood: true),
      ],
    );
  }

  Widget _buildServicesSection(List<Map<String, dynamic>> services) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Additional Services',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            fontFamily: 'Times New Roman',
          ),
        ),
        const SizedBox(height: 2),
        Container(
          width: double.infinity,
          height: 1,
          color: Colors.black,
        ),
        const SizedBox(height: 5),
        _buildServiceItemsTable(),
      ],
    );
  }

  Widget _buildItemsTable(List<Map<String, dynamic>> items, {bool isFood = true}) {
    return Table(
      border: TableBorder.all(color: Colors.black, width: 1),
      columnWidths: const {
        0: FlexColumnWidth(3.0),
        1: FlexColumnWidth(1.0),
        2: FlexColumnWidth(1.2),
        3: FlexColumnWidth(1.2),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey[200]),
          children: [
            Padding(
              padding: const EdgeInsets.all(3),
              child: Text(
                isFood ? 'Description' : 'Service Description',
                style: const TextStyle(
                  fontSize: 7,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Times New Roman',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3),
              child: Text(
                'Qty',
                style: const TextStyle(
                  fontSize: 7,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Times New Roman',
                ),
                textAlign: TextAlign.right,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3),
              child: Text(
                isFood ? 'Unit Price' : 'Rate',
                style: const TextStyle(
                  fontSize: 7,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Times New Roman',
                ),
                textAlign: TextAlign.right,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3),
              child: Text(
                'Amount',
                style: const TextStyle(
                  fontSize: 7,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Times New Roman',
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        ...items.map((item) => TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(3),
              child: Text(
                item['name']?.toString() ?? 'Unknown Item',
                style: const TextStyle(
                  fontSize: 8,
                  fontFamily: 'Times New Roman',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3),
              child: Text(
                (item['qty'] ?? 1).toString(),
                style: const TextStyle(
                  fontSize: 8,
                  fontFamily: 'Times New Roman',
                ),
                textAlign: TextAlign.right,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3),
              child: Text(
                '£${(item['price'] as num).toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 8,
                  fontFamily: 'Times New Roman',
                ),
                textAlign: TextAlign.right,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3),
              child: Text(
                '£${((item['price'] as num).toDouble() * (item['qty'] as int)).toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 8,
                  fontFamily: 'Times New Roman',
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        )).toList(),
      ],
    );
  }
  Widget _buildServiceItemsTable() {
    return Column(
      children: [
        // Header Row
        Container(
          decoration: BoxDecoration(color: Colors.grey[200]),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    'Service Description',
                    style: const TextStyle(
                      fontSize: 7,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Times New Roman',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3),
                child: Text(
                  'Amount',
                  style: const TextStyle(
                    fontSize: 7,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Times New Roman',
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        // Services List
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.selectedServiceItems.length,
            itemBuilder: (context, index) {
              final service = controller.selectedServiceItems[index];
              return Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: index < controller.selectedServiceItems.length - 1
                        ? BorderSide(color: Colors.black, width: 1)
                        : BorderSide.none,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: Text(
                          service.title,
                          style: const TextStyle(
                            fontSize: 8,
                            fontFamily: 'Times New Roman',
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3),
                      child: Text(
                        service.price,
                        style: const TextStyle(
                          fontSize: 8,
                          fontFamily: 'Times New Roman',
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  // Widget _buildServiceItemsTable() {
  //   return Table(
  //     border: TableBorder.all(color: Colors.black, width: 1),
  //     columnWidths: const {
  //       0: FlexColumnWidth(3.0),
  //       1: FlexColumnWidth(1.0),
  //       2: FlexColumnWidth(1.2),
  //       3: FlexColumnWidth(1.2),
  //     },
  //     defaultVerticalAlignment: TableCellVerticalAlignment.middle,
  //     children: [
  //       TableRow(
  //         decoration: BoxDecoration(color: Colors.grey[200]),
  //         children: [
  //           Padding(
  //             padding: const EdgeInsets.all(3),
  //             child: Text(
  //                'Service Description',
  //               style: const TextStyle(
  //                 fontSize: 7,
  //                 fontWeight: FontWeight.bold,
  //                 fontFamily: 'Times New Roman',
  //               ),
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.all(3),
  //             child: Text(
  //               'Qty',
  //               style: const TextStyle(
  //                 fontSize: 7,
  //                 fontWeight: FontWeight.bold,
  //                 fontFamily: 'Times New Roman',
  //               ),
  //               textAlign: TextAlign.right,
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.all(3),
  //             child: Text(
  //               'Rate',
  //               style: const TextStyle(
  //                 fontSize: 7,
  //                 fontWeight: FontWeight.bold,
  //                 fontFamily: 'Times New Roman',
  //               ),
  //               textAlign: TextAlign.right,
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.all(3),
  //             child: Text(
  //               'Amount',
  //               style: const TextStyle(
  //                 fontSize: 7,
  //                 fontWeight: FontWeight.bold,
  //                 fontFamily: 'Times New Roman',
  //               ),
  //               textAlign: TextAlign.right,
  //             ),
  //           ),
  //         ],
  //       ),
  //        TableRow(
  //         children: [
  //           Padding(
  //             padding: const EdgeInsets.all(3),
  //             child: Text(
  //               controller.selectedServiceItems.first.title,
  //               style: const TextStyle(
  //                 fontSize: 8,
  //                 fontFamily: 'Times New Roman',
  //               ),
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.all(3),
  //             child: Text(
  //               1.toString(),
  //               style: const TextStyle(
  //                 fontSize: 8,
  //                 fontFamily: 'Times New Roman',
  //               ),
  //               textAlign: TextAlign.right,
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.all(3),
  //             child: Text(
  //   controller.selectedServiceItems.first.price,
  //               style: const TextStyle(
  //                 fontSize: 8,
  //                 fontFamily: 'Times New Roman',
  //               ),
  //               textAlign: TextAlign.right,
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.all(3),
  //             child: Text(
  //               controller.selectedServiceItems.first.price,
  //               style: const TextStyle(
  //                 fontSize: 8,
  //                 fontFamily: 'Times New Roman',
  //               ),
  //               textAlign: TextAlign.right,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  Widget _buildSubtotalSection(
      double foodSubtotal,
      double servicesSubtotal,
      double netAmount,
      double serviceCharge,
      double discount,
      double subtotalAfterDiscount,
      double vat,
      double totalAmount,
      ) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Column(
          children: [
          _buildSubtotalRow('Food Items Subtotal:', controller.foodAndBeverageCost),
      _buildSubtotalRow('Services Subtotal:', controller.serviceCost),
      _buildSubtotalRow('Net Amount:', controller.foodAndBeverageCost+controller.serviceCost),
      _buildSubtotalRow('Discount:', controller.discountAmount.value),
      _buildSubtotalRow('Subtotal after Discount:', controller.totalAmount -controller.discountAmount.value),
      _buildSubtotalRow('VAT @ 20%:', controller.vat),
      Container(
        margin: const EdgeInsets.only(top: 5),
        padding: const EdgeInsets.only(top: 4),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.black, width: 2)),
      ),
      child: _buildSubtotalRow('TOTAL AMOUNT:', controller.totalAmount, isTotal: true),
    ),
    ],
    ),
    );
  }

  Widget _buildSubtotalRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 11 : 9,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontFamily: 'Times New Roman',
            ),
          ),
          Text(
            '£${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isTotal ? 11 : 9,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontFamily: 'Times New Roman',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 2,
          color: Colors.black,
        ),
        const SizedBox(height: 8),
         Text(
           'BOOKING CONFIRMED - PAYMENT DUE: 50% DEPOSIT BY ${DateFormat('dd-MM-yyyy').format(DateTime.now().add(const Duration(days: 15)))}',
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            fontFamily: 'Times New Roman',
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        const Text(
          'Balance payment due 7 days prior to event date',
          style: TextStyle(
            fontSize: 9,
            fontFamily: 'Times New Roman',
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          'Terms & Conditions: This booking is subject to our standard terms and conditions. '
              'Cancellation policy: 30 days notice required for full refund minus 10% administration fee. '
              'Final guest numbers must be confirmed 7 days prior to event. Additional charges may apply for changes made within 48 hours of event. '
              'All prices include VAT at current rate.',
          style: TextStyle(
            fontSize: 7,
            fontFamily: 'Times New Roman',
            height: 1.2,
          ),
          textAlign: TextAlign.justify,
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSignatureBox('Customer Signature'),
            _buildSignatureBox('Authorized Signature'),
          ],
        ),
      ],
    );
  }

  Widget _buildSignatureBox(String label) {
    return SizedBox(
      width: 150,
      child: Column(
        children: [
          Container(
            height: 20,
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black, width: 1)),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(
              fontSize: 8,
              fontFamily: 'Times New Roman',
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not set';
    final day = date.day;
    final month = date.month;
    final year = date.year;
    final suffixes = ['th', 'st', 'nd', 'rd', 'th', 'th', 'th', 'th', 'th', 'th'];
    final suffix = day % 10 <= suffixes.length - 1 ? suffixes[day % 10] : 'th';
    final months = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${day}$suffix ${months[month]} $year';
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return 'Not set';
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  void _printReceipt() {
    // Implement print functionality here
    // You can use packages like printing, pdf, or share_plus
    Get.snackbar(
      'Print Receipt',
      'Receipt printing functionality would be implemented here',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}