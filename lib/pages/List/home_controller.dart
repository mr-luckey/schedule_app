import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:hallmanagementsystem/constants/apis.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:schedule_app/APIS/Api_Service.dart';
import 'package:schedule_app/pages/List/order_model%20(1).dart';
import 'package:shared_preferences/shared_preferences.dart';
// import '../models/order_model.dart';

enum CalendarViewType { monthly, weekly, daily }

class HomeController extends GetxController {
  var currentView = CalendarViewType.monthly.obs;
  var currentTab = 'booking'.obs;
  var isLoading = false.obs;
  var orders = <OrderList>[].obs;
  var selectedDate = DateTime.now().obs;
  var showBookingForm = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  void changeView(CalendarViewType viewType) {
    currentView.value = viewType;
  }

  void changeTab(String tab) {
    currentTab.value = tab;
  }

  void openBookingForm() {
    showBookingForm.value = true;
    // resetForm();
  }

  void closeBookingForm() {
    showBookingForm.value = false;
  }
Future<void> fetchOrders() async {
  try {
    isLoading.value = true;
    final List<OrderList> fetchedOrders = await ApiService.fetchOrders();
    orders.assignAll(fetchedOrders);
    print('Successfully loaded ${orders.length} orders');
  } catch (e) {
    Get.snackbar(
      'Error',
      'Failed to fetch orders: $e',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    print('Failed to fetch orders: $e');
  } finally {
    isLoading.value = false;
  }
}
  // Future<void> fetchOrders() async {
  //   try {
  //     isLoading.value = true;
  //     final prefs = await SharedPreferences.getInstance();
  //     final token = prefs.getString('user_token');

  //     final response = await http.get(
  //       Uri.parse(ApiService.getOrders),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       final responseData = json.decode(response.body);

  //       // Handle different response structures
  //       List<dynamic> ordersList = [];

  //       if (responseData is List) {
  //         ordersList = responseData;
  //       } else if (responseData is Map<String, dynamic>) {
  //         // Check common keys for data
  //         if (responseData['data'] is List) {
  //           ordersList = responseData['data'];
  //         } else if (responseData['orders'] is List) {
  //           ordersList = responseData['orders'];
  //         } else if (responseData['results'] is List) {
  //           ordersList = responseData['results'];
  //         } else {
  //           // If it's a single order object, wrap it in a list
  //           ordersList = [responseData];
  //         }
  //       }

  //       // Parse orders with better error handling
  //       final List<OrderList> parsedOrders = [];
  //       for (var item in ordersList) {
  //         try {
  //           if (item is Map<String, dynamic>) {
  //             final order = OrderList.fromJson(item);
  //             parsedOrders.add(order);
  //           }
  //         } catch (e) {
  //           print('Error parsing order: $e');
  //           print('Problematic order data: $item');
  //           // Continue with other orders even if one fails
  //         }
  //       }

  //       orders.assignAll(parsedOrders);
  //       print('Successfully loaded ${orders.length} orders');

  //     } else {
  //       Get.snackbar(
  //         'Error',
  //         'Failed to fetch orders: ${response.statusCode}',
  //         backgroundColor: Colors.red,
  //         colorText: Colors.white,
  //       );
  //       print('Failed to fetch orders: ${response.statusCode}');
  //       print('Response body: ${response.body}');
  //     }
  //   } catch (e) {
  //     Get.snackbar(
  //       'Error',
  //       'Failed to fetch orders: $e',
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //     );
  //     print('Failed to fetch orders: $e');
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  // Get orders for a specific date
  List<OrderList> getOrdersForDate(DateTime date) {
    return orders.where((order) {
      try {
        if (order.eventDate == null) return false;

        final orderDate = DateTime.parse(order.eventDate!);
        return orderDate.year == date.year &&
            orderDate.month == date.month &&
            orderDate.day == date.day;
      } catch (e) {
        print('Error parsing eventDate for order ${order.id}: $e');
        return false;
      }
    }).toList();
  }

  // Get orders for a specific date and time slot
  List<OrderList> getOrdersForTimeSlot(DateTime date, int hour) {
    return getOrdersForDate(date).where((order) {
      try {
        if (order.startTime == null) return false;

        final startTime = DateTime.parse(order.startTime!);
        return startTime.hour == hour;
      } catch (e) {
        print('Error parsing startTime for order ${order.id}: $e');
        return false;
      }
    }).toList();
  }

  // Get orders for a specific hour in weekly view
  List<OrderList> getOrdersForHour(DateTime date, int hour) {
    return getOrdersForDate(date).where((order) {
      try {
        if (order.startTime == null) return false;
        final startTime = DateTime.parse(order.startTime!);
        return startTime.hour == hour;
      } catch (e) {
        return false;
      }
    }).toList();
  }

// Format time for display - improved version
  String formatTime(String timeString) {
    try {
      if (timeString.isEmpty) return 'N/A';

      final time = DateTime.parse(timeString);
      final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
      final period = time.hour < 12 ? 'AM' : 'PM';
      final minute = time.minute.toString().padLeft(2, '0');
      return '$hour:$minute $period';
    } catch (e) {
      print('Error formatting time: $timeString, error: $e');

      // Try to extract time from the string manually
      try {
        final timePart = timeString.split('T')[1].split('.')[0]; // Get "14:05:00" from "2000-01-01T14:05:00.000Z"
        final parts = timePart.split(':');
        if (parts.length >= 2) {
          final hour = int.parse(parts[0]);
          final minute = parts[1];
          final displayHour = hour % 12 == 0 ? 12 : hour % 12;
          final period = hour < 12 ? 'AM' : 'PM';
          return '$displayHour:$minute $period';
        }
      } catch (e2) {
        print('Manual time parsing also failed: $e2');
      }

      return timeString;
    }
  }

  // Get orders for a specific week
  List<OrderList> getOrdersForWeek(DateTime startOfWeek) {
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return orders.where((order) {
      try {
        if (order.eventDate == null) return false;

        final orderDate = DateTime.parse(order.eventDate!);
        return orderDate.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
            orderDate.isBefore(endOfWeek.add(const Duration(days: 1)));
      } catch (e) {
        print('Error parsing eventDate for weekly view order ${order.id}: $e');
        return false;
      }
    }).toList();
  }

  // Helper method to convert time slot string to hour
  int _convertTimeSlotToHour(String timeSlot) {
    try {
      final time = timeSlot.toLowerCase();
      final cleanTime = time.replaceAll(RegExp(r'[^0-9apm]'), '');

      if (cleanTime.contains('pm')) {
        final hourStr = cleanTime.replaceAll('pm', '');
        final hour = int.tryParse(hourStr) ?? 0;
        return hour == 12 ? 12 : hour + 12;
      } else if (cleanTime.contains('am')) {
        final hourStr = cleanTime.replaceAll('am', '');
        final hour = int.tryParse(hourStr) ?? 0;
        return hour == 12 ? 0 : hour;
      }

      return int.tryParse(cleanTime) ?? 0;
    } catch (e) {
      print('Error converting time slot: $timeSlot, error: $e');
      return 0;
    }
  }

  // Safe check for isInquiry with null handling
  bool getIsInquiry(OrderList order) {
    return order.isInquiry ?? false;
  }

  // Get color based on inquiry status
  Color getOrderColor(OrderList order) {
    return getIsInquiry(order) ? Colors.red : Colors.green;
  }

  // Get background color based on inquiry status
  Color getOrderBackgroundColor(OrderList order) {
    return getIsInquiry(order) ? const Color(0xFFFECACA) : const Color(0xFFDCFCE7);
  }

  // Get border color based on inquiry status
  Color getOrderBorderColor(OrderList order) {
    return getIsInquiry(order) ? const Color(0xFFFCA5A5) : const Color(0xFF86EFAC);
  }

  // Filter orders based on confirmed/inquiry status
  List<OrderList> getFilteredOrders(List<OrderList> ordersToFilter) {
    return ordersToFilter.where((order) {
      if (currentTab.value == 'booking') {
        return !getIsInquiry(order); // Show only confirmed orders
      } else {
        return getIsInquiry(order); // Show only inquiry orders
      }
    }).toList();
  }


}