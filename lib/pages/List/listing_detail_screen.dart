import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:hallmanagementsystem/controllers/home_controller.dart';
import 'package:intl/intl.dart';
import 'package:schedule_app/pages/List/home_controller.dart';
import 'package:schedule_app/pages/List/order_model%20(1).dart';
import 'package:schedule_app/pages/List/payment_controller.dart';
// import '../controllers/payment_controller.dart';
// import '../models/order_model.dart';


class ListingDetailScreen extends StatelessWidget {
  final OrderList order;

   ListingDetailScreen({Key? key, required this.order}) : super(key: key);
  final PaymentController paymentController = Get.put(PaymentController());
  final HomeController homeController = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildHeader(),
                  _buildContent(paymentController),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: const BoxDecoration(
        color: Color(0xFF10B981),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${order.firstname ?? ''} ${order.lastname ?? ''}',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${order.event?.title ?? 'Wedding'} - ${_formatDate(order.eventDate)}',
                      style: TextStyle(
                        fontSize: 17.6,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                label: Text(
                  'Back',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15.2,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent(PaymentController paymentController) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailSection(),
          const SizedBox(height: 40),
          if (order.orderPackages != null && order.orderPackages!.isNotEmpty)
            _buildFoodTable(),
          const SizedBox(height: 40),
          if (order.orderServices != null && order.orderServices!.isNotEmpty )
            _buildServicesTable(),

          _buildPricingSummary(),
          const SizedBox(height: 30),
          _buildPaymentPanel(paymentController),
        ],
      ),
    );
  }

  Widget _buildDetailSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Event Information',
          style: TextStyle(
            color: const Color(0xFF1A202C),
            fontSize: 20.8,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: const Color(0xFFE2E8F0), width: 2),
            ),
          ),
          padding: const EdgeInsets.only(bottom: 10),
        ),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            return Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
                _buildDetailCard('Customer Name', '${order.firstname ?? ''} ${order.lastname ?? ''}', constraints.maxWidth),
                _buildDetailCard('Event Date', _formatDate(order.eventDate), constraints.maxWidth),
                _buildDetailCard('Time', '${homeController.formatTime(order.startTime!) ?? ''} - ${homeController.formatTime(order.endTime!) ?? ''}', constraints.maxWidth),
                _buildDetailCard('Guests', '${order.noOfGust ?? '0'} persons', constraints.maxWidth),
                _buildDetailCard('Package', order.orderPackages?.first.package?.title ?? 'N/A', constraints.maxWidth),
                _buildDetailCard('Venue', '${order.address ?? ''}, ${order.city?.name ?? ''}', constraints.maxWidth),
                _buildDetailCard('Contact', order.phone ?? 'N/A', constraints.maxWidth),
                _buildDetailCard('Email', order.email ?? 'N/A', constraints.maxWidth),
                _buildDetailCard('Reference', 'ORDER-${order.id}', constraints.maxWidth),
                _buildDetailCard('Payment Method', order.paymentMethod?.title ?? 'N/A', constraints.maxWidth),
                _buildDetailCard('Status', order.isInquiry == true ? 'INQUIRY' : 'BOOKING', constraints.maxWidth),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildDetailCard(String label, String value, double maxWidth) {
    double cardWidth = maxWidth < 600 ? maxWidth : (maxWidth - 40) / 3;

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF718096),
              fontSize: 12.8,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              color: const Color(0xFF1A202C),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodTable() {
    // First, let's collect all unique menu items to avoid duplicates
    List<Map<String, dynamic>> foodItems = [];

    // Check if orderPackages exists and has data
    if (order.orderPackages != null && order.orderPackages!.isNotEmpty) {
      // Iterate through each package
      for (var orderPackage in order.orderPackages!) {
        print("Processing Package: ${orderPackage.package?.title}");
        print("Package Items Count: ${orderPackage.orderPackageItems?.length ?? 0}");

        // Check if this package has items
        if (orderPackage.orderPackageItems != null &&
            orderPackage.orderPackageItems!.isNotEmpty) {

          // Add each item from this package
          for (var packageItem in orderPackage.orderPackageItems!) {
            final menuItem = packageItem.menuItem;
            final menuItemTitle = menuItem?.title ?? 'Unknown Item';
            final menuItemId = menuItem?.id;

            // Parse price - try packageItem.price first, then menuItem.price
            double rate = 0;
            if (packageItem.price != null && packageItem.price!.isNotEmpty) {
              rate = double.tryParse(packageItem.price!) ?? 0;
            } else if (menuItem?.price != null && menuItem!.price!.isNotEmpty) {
              rate = double.tryParse(menuItem.price!) ?? 0;
            }

            // Parse quantity from packageItem.noOfGust
            int qty = 1;
            if (packageItem.noOfGust != null && packageItem.noOfGust!.isNotEmpty) {
              qty = int.tryParse(packageItem.noOfGust!) ?? 1;
            }

            double amount = rate * qty;

            print("  Item: $menuItemTitle, ID: $menuItemId, Qty: $qty, Rate: $rate, Amount: $amount");

            // Add to list (avoiding duplicates based on menu item ID and quantity)
            bool isDuplicate = foodItems.any((item) =>
            item['id'] == menuItemId &&
                item['title'] == menuItemTitle &&
                item['qty'] == qty
            );

            if (!isDuplicate) {
              foodItems.add({
                'id': menuItemId,
                'title': menuItemTitle,
                'qty': qty,
                'rate': rate,
                'amount': amount,
              });
            }
          }
        }
      }
    }

    print("Total Unique Food Items to Display: ${foodItems.length}");

    // If no items found, show a message
    if (foodItems.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Food Menu',
            style: TextStyle(
              color: const Color(0xFF1A202C),
              fontSize: 20.8,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFB),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Text(
              'No food items available',
              style: TextStyle(
                color: const Color(0xFF718096),
                fontSize: 14.4,
              ),
            ),
          ),
        ],
      );
    }

    // Build the table with collected items
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Food Menu',
          style: TextStyle(
            color: const Color(0xFF1A202C),
            fontSize: 20.8,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: const Color(0xFFE2E8F0), width: 2),
            ),
          ),
          padding: const EdgeInsets.only(bottom: 10),
        ),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE2E8F0)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Table(
            border: TableBorder(
              horizontalInside: BorderSide(color: const Color(0xFFF1F3F5)),
            ),
            columnWidths: const {
              0: FlexColumnWidth(3),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
            },
            children: [
              // Header Row
              TableRow(
                decoration: const BoxDecoration(
                  color: Color(0xFFF8FAFB),
                ),
                children: [
                  _buildTableHeader('Item'),
                  _buildTableHeader('Quantity'),
                  _buildTableHeader('Unit Price'),
                  _buildTableHeader('Total'),
                ],
              ),
              // Data Rows
              ...foodItems.map((item) {
                return TableRow(
                  children: [
                    _buildTableCell(item['title']),
                    _buildTableCell(item['qty'].toString()),
                    _buildTableCell('£${item['rate'].toStringAsFixed(2)}'),
                    _buildTableCell('£${item['amount'].toStringAsFixed(2)}'),
                  ],
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }

// Helper method for table headers
  Widget _buildTableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Text(
        text,
        style: TextStyle(
          color: const Color(0xFF4A5568),
          fontWeight: FontWeight.w600,
          fontSize: 13.6,
        ),
      ),
    );
  }

// Helper method for table cells
  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.4,
          color: const Color(0xFF1A202C),
        ),
      ),
    );
  }

  Widget _buildServicesTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional Services',
          style: TextStyle(
            color: const Color(0xFF1A202C),
            fontSize: 20.8,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: const Color(0xFFE2E8F0), width: 2),
            ),
          ),
          padding: const EdgeInsets.only(bottom: 10),
        ),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE2E8F0)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Table(
            border: TableBorder(
              horizontalInside: BorderSide(color: const Color(0xFFF1F3F5)),
            ),
            columnWidths: const {
              0: FlexColumnWidth(3),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
            },
            children: [
              TableRow(
                decoration: const BoxDecoration(
                  color: Color(0xFFF8FAFB),
                ),
                children: [
                  _buildTableHeader('Service'),
                  _buildTableHeader('Quantity'),
                  _buildTableHeader('Rate'),
                  _buildTableHeader('Amount'),
                ],
              ),
              ...order.orderServices!.map((service) {
                double rate = double.tryParse(service.price.toString() ?? '0') ?? 0;
                //TODO: Handle  quantity gracefully
                int qty = 1;
                // int qty = int.tryParse(service.quantity ?? '1') ?? 1;
                double amount = rate * qty;

                return TableRow(
                  children: [
                    _buildTableCell(service.service?.title ?? ''),
                    _buildTableCell(qty.toString()),
                    _buildTableCell('£${rate.toStringAsFixed(2)}'),
                    _buildTableCell('£${amount.toStringAsFixed(2)}'),
                  ],
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }



  Widget _buildPricingSummary() {
    double servicesTotal = 0;
    if (order.orderServices != null) {
      for (var service in order.orderServices!) {
        double rate = double.tryParse(service.price.toString() ?? '0') ?? 0;
        //TODO: Handle quantity gracefully
        int qty = 1;
        // int qty = int.tryParse(service.quantity ?? '1') ?? 1;
        servicesTotal += rate * qty;
      }
    }

    double packagesTotal = 0;
    if (order.orderPackages != null) {
      for (var package in order.orderPackages!) {
        packagesTotal += double.tryParse(package.package?.price.toString() ?? '0') ?? 0;
      }
    }

    double netAmount = servicesTotal + packagesTotal;
    double serviceCharge = netAmount * 0.10;
    double discount = netAmount * 0.05;
    double subtotalAfterDiscount = netAmount + serviceCharge - discount;
    double vat = subtotalAfterDiscount * 0.20;
    double totalAmount = subtotalAfterDiscount + vat;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pricing Summary',
          style: TextStyle(
            color: const Color(0xFF1A202C),
            fontSize: 20.8,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: const Color(0xFFE2E8F0), width: 2),
            ),
          ),
          padding: const EdgeInsets.only(bottom: 10),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFB),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            children: [
              _buildPriceRow('Services Subtotal:', '£${servicesTotal.toStringAsFixed(2)}'),
              _buildPriceRow('Packages Subtotal:', '£${packagesTotal.toStringAsFixed(2)}'),
              _buildPriceRow('Net Amount:', '£${netAmount.toStringAsFixed(2)}'),
              _buildPriceRow('Service Charge (10%):', '£${serviceCharge.toStringAsFixed(2)}'),
              _buildPriceRow('Early Booking Discount (5%):', '-£${discount.toStringAsFixed(2)}'),
              _buildPriceRow('Subtotal after Discount:', '£${subtotalAfterDiscount.toStringAsFixed(2)}'),
              _buildPriceRow('VAT @ 20%:', '£${vat.toStringAsFixed(2)}'),
              _buildTotalRow('TOTAL AMOUNT:', '£${totalAmount.toStringAsFixed(2)}'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, String amount) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: const Color(0xFFE2E8F0)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 15.2),
          ),
          Text(
            amount,
            style: TextStyle(fontSize: 15.2, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, String amount) {
    return Container(
      padding: const EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: const Color(0xFF10B981), width: 2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 19.2,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF10B981),
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 19.2,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF10B981),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentPanel(PaymentController controller) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFD1FAE5),
            const Color(0xFFA7F3D0),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF10B981), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Received',
            style: TextStyle(
              color: const Color(0xFF065F46),
              fontSize: 19.2,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment Amount (£)',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF065F46),
                        fontSize: 14.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: controller.amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '0.00',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: const Color(0xFF10B981), width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: const Color(0xFF10B981), width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: const Color(0xFF10B981), width: 2),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment Type',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF065F46),
                        fontSize: 14.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(() => DropdownButtonFormField<String>(
                      value: controller.paymentType.value.isEmpty ? null : controller.paymentType.value,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: const Color(0xFF10B981), width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: const Color(0xFF10B981), width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: const Color(0xFF10B981), width: 2),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                      hint: Text('Select Type'),
                      items: [
                        DropdownMenuItem(value: 'second', child: Text('Second Payment')),
                        DropdownMenuItem(value: 'intermediate', child: Text('Intermediate Payment')),
                        DropdownMenuItem(value: 'final', child: Text('Final Payment')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          controller.paymentType.value = value;
                        }
                      },
                    )),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'N/A';
    try {
      DateTime date = DateTime.parse(dateStr);
      return DateFormat('EEEE, MMMM d, y').format(date);
    } catch (e) {
      return dateStr;
    }
  }
}