import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:hallmanagementsystem/controllers/home_controller.dart';
import 'package:intl/intl.dart';
import 'package:schedule_app/pages/List/home_controller.dart';
import 'package:schedule_app/pages/List/listing_detail_screen.dart';
import 'package:schedule_app/pages/List/order_model%20(1).dart';

// import '../models/order_model.dart';
// import '../views/listing_detail_screen.dart';


class ListingScreen extends StatelessWidget {
  const ListingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1400),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                   _buildStatsRow(controller),
                  _buildDataTable(controller),
                  _buildLegend(),
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
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Booking Schedule',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A202C),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Wedding Management System',
            style: TextStyle(
              fontSize: 15.2,
              color: const Color(0xFF718096),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(HomeController controller) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFB),
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = 4;
          if (constraints.maxWidth < 640) {
            crossAxisCount = 1;
          } else if (constraints.maxWidth < 1024) {
            crossAxisCount = 2;
          }

          return GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 2.8,
            children: [
              _buildStatCard(
                controller.orders.length.toString(),
                'Total Bookings',
              ),
              _buildStatCard(
                //TODO: Calculate upcoming bookings within the next 7 days
                // controller.upcomingCount.toString(),
                10.toString(),
                'Upcoming This Month',
              ),
              _buildStatCard(
                //TODO: Calculate total guests from all bookings
                1500.toString(),
                // controller.totalGuests.toString(),
                'Total Guests',
              ),
              _buildStatCard(
                //TODO: Calculate total revenue from all bookings
                5000.toString(),
                // '£${controller.totalRevenue.toStringAsFixed(2)}',
                'Total Revenue',
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String number, String label) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            number,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF10B981),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 13.6,
              color: const Color(0xFF718096),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable(HomeController controller) {
    return Obx(() => Container(
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: Get.width > 1400 ? 1400 : Get.width - 40,
          ),
          child: DataTable(
            showCheckboxColumn: false,
            headingRowColor: MaterialStateProperty.all(const Color(0xFFF8FAFB)),
            headingRowHeight: 56,
            dataRowHeight: 72,
            columnSpacing: 16,
            horizontalMargin: 16,
            dividerThickness: 0,
            columns: [
              DataColumn(
                label: _buildColumnHeader('CUSTOMER NAMES'),
              ),
              DataColumn(
                label: _buildColumnHeader('WEDDING DATE'),
              ),
              DataColumn(
                label: _buildColumnHeader('GUESTS'),
              ),
              DataColumn(
                label: _buildColumnHeader('PACKAGE'),
              ),
              DataColumn(
                label: _buildColumnHeader('VENUE'),
              ),
              DataColumn(
                label: _buildColumnHeader('AMOUNT'),
                numeric: true,
              ),
              DataColumn(
                label: _buildColumnHeader('STATUS'),
              ),
            ],
            rows: controller.orders.asMap().entries.map((entry) {
              int index = entry.key;
              OrderList order = entry.value;
              //TODO: Determine if the wedding is within the next 7 days
              bool isUpcoming = false;
              // bool isUpcoming = controller.isUpcomingWedding(order);

              return DataRow(
                color: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered)) {
                      return const Color(0xFFF8FAFB);
                    }
                    if (isUpcoming) {
                      return const Color(0xFFD1FAE5);
                    }
                    return null;
                  },
                ),
                onSelectChanged: (_) {
                  Get.to(() => ListingDetailScreen(order: order));
                },
                cells: [
                  DataCell(_buildCoupleNames(order, isUpcoming)),
                  DataCell(_buildWeddingDate(order,controller)),
                  DataCell(Center(child: _buildGuestCount(order))),
                  DataCell(Center(child: _buildPackageType(order))),
                  DataCell(_buildVenue(order)),
                  DataCell(_buildAmount(order)),
                  DataCell(Center(child: _buildStatus(order))),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    ));
  }

  Widget _buildColumnHeader(String text) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 12.8,
        color: const Color(0xFF4A5568),
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildCoupleNames(OrderList order, bool isUpcoming) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '${order.firstname ?? ''} ${order.lastname ?? ''}',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A202C),
              fontSize: 15.2,
            ),
          ),
        ),
        if (isUpcoming)
          Container(
            margin: const EdgeInsets.only(left: 8),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'URGENT',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11.2,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildWeddingDate(OrderList order,HomeController controller) {
    if (order.eventDate == null) return const SizedBox();

    DateTime date = DateTime.parse(order.eventDate!);
    String formattedDate = DateFormat('EEEE, MMMM d, y').format(date);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          formattedDate,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: const Color(0xFF4A5568),
            fontSize: 14.4,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          '${controller.formatTime(order.startTime!)?? ''} - ${controller.formatTime(order.endTime!) ?? ''}',
          style: TextStyle(
            color: const Color(0xFF718096),
            fontSize: 12.8,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildGuestCount(OrderList order) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF10B981),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        order.noOfGust ?? '0',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 13.6,
        ),
      ),
    );
  }

  Widget _buildPackageType(OrderList order) {
    // Assuming package info might be in orderPackages
    String packageType = 'default'; // default
    Color bgColor = const Color(0xFFD1FAE5);
    Color textColor = const Color(0xFF065F46);

    if (order.orderPackages != null && order.orderPackages!.isNotEmpty) {
      String? packageName = order.orderPackages!.first.package?.title?.toLowerCase();
      if (packageName != null) {
        packageType = packageName;
        // if (packageName.contains('luxury')) {
        //   packageType = 'luxury';
        //   bgColor = const Color(0xFFDDD6FE);
        //   textColor = const Color(0xFF5B21B6);
        // } else if (packageName.contains('classic')) {
        //   packageType = 'classic';
        //   bgColor = const Color(0xFFBFDBFE);
        //   textColor = const Color(0xFF1E40AF);
        // }
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        packageType.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildVenue(OrderList order) {
    return Text(
      '${order.address ?? ''}, ${order.city?.name ?? ''}',
      style: TextStyle(
        color: const Color(0xFF4A5568),
        fontSize: 13.6,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildAmount(OrderList order) {
    // Calculate total from orderServices and orderPackages
    double total = 0;
    if (order.orderServices != null) {
      for (var service in order.orderServices!) {
        total += (double.tryParse(service.price.toString() ?? '0') ?? 0) ;
            // * (int.tryParse(service.quantity ?? '1') ?? 1);
      }
    }
    if (order.orderPackages != null) {
      for (var package in order.orderPackages!) {
        total += double.tryParse(package.package?.price.toString() ?? '0') ?? 0;
      }
    }

    return Text(
      '£${total.toStringAsFixed(2)}',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: const Color(0xFF1A202C),
        fontSize: 15.2,
      ),
    );
  }

  Widget _buildStatus(OrderList order) {
    String status = order.isInquiry == true ? 'inquiry' : 'booking';
    Color bgColor = status == 'booking'
        ? const Color(0xFFD1FAE5)
        : const Color(0xFFFED7AA);
    Color textColor = status == 'booking'
        ? const Color(0xFF065F46)
        : const Color(0xFF92400E);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      margin: const EdgeInsets.all(30),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Wrap(
        spacing: 30,
        runSpacing: 15,
        children: [
          _buildLegendItem(
            'Urgent: Wedding within 7 days',
            const Color(0xFFD1FAE5),
            const Color(0xFF10B981),
          ),
          _buildLegendItem(
            'Regular Bookings',
            Colors.white,
            const Color(0xFFCBD5E0),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String text, Color bgColor, Color borderColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 13.6,
            color: const Color(0xFF4A5568),
          ),
        ),
      ],
    );
  }
}