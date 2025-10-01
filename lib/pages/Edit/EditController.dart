// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:schedule_app/pages/Edit/editApi.dart';
// import 'package:schedule_app/pages/Edit/model.dart';
// // import 'package:schedule_app/APIS/EditApiService.dart';
// // import 'package:schedule_app/model/edit_order_model.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';

// class EditController extends GetxController {
//   final Rx<EditOrderModel?> currentEditOrder = Rx<EditOrderModel?>(null);
//   final RxBool isLoading = false.obs;
//   final RxString errorMessage = ''.obs;

//   // Load order data by ID
//   Future<void> loadOrderById(String orderId) async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';

//       print('🔄 Loading order data for ID: $orderId');

//       final EditOrderModel? order = await EditApiService.getOrderById(orderId);

//       if (order != null) {
//         currentEditOrder.value = order;
//         print('✅ Order loaded successfully: ${order.id}');
//         print('📝 Order details:');
//         print('   - Name: ${order.firstname} ${order.lastname}');
//         print('   - Email: ${order.email}');
//         print('   - Phone: ${order.phone}');
//         print('   - Event Date: ${order.eventDate}');
//         print('   - Start Time: ${order.startTime}');
//         print('   - End Time: ${order.endTime}');
//         print('   - Guests: ${order.noOfGust}');
//         print('   - Packages: ${order.orderPackages?.length}');
//       } else {
//         errorMessage.value = 'Order not found';
//         print('❌ Order not found for ID: $orderId');
//       }
//     } catch (e) {
//       errorMessage.value = 'Failed to load order: $e';
//       print('❌ Error loading order: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // Update order
//   Future<bool> updateOrder({
//     required int orderId,
//     required Map<String, dynamic> orderData,
//   }) async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';

//       print('🔄 Updating order: $orderId');

//       final response = await EditApiService.updateOrder(
//         orderId: orderId,
//         orderData: orderData,
//       );

//       if (response['success'] == true) {
//         print('✅ Order updated successfully');
//         // Reload the order to get updated data
//         await loadOrderById(orderId.toString());
//         return true;
//       } else {
//         errorMessage.value = response['error'] ?? 'Failed to update order';
//         print('❌ Order update failed: ${response['error']}');
//         return false;
//       }
//     } catch (e) {
//       errorMessage.value = 'Error updating order: $e';
//       print('❌ Error updating order: $e');
//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // Clear current edit order
//   void clearEditOrder() {
//     currentEditOrder.value = null;
//     errorMessage.value = '';
//   }

//   // Getter for current order
//   EditOrderModel? get editOrder => currentEditOrder.value;

//   // Helper methods to parse data for form
//   String getFullName() {
//     if (currentEditOrder.value == null) return '';
//     return '${currentEditOrder.value!.firstname ?? ''} ${currentEditOrder.value!.lastname ?? ''}'
//         .trim();
//   }

//   String getEventType() {
//     return currentEditOrder.value?.event?.title ?? '';
//   }

//   int getGuestsCount() {
//     if (currentEditOrder.value?.noOfGust == null) return 1;
//     return int.tryParse(currentEditOrder.value!.noOfGust!) ?? 1;
//   }

//   String getPackageTitle() {
//     if (currentEditOrder.value?.orderPackages == null ||
//         currentEditOrder.value!.orderPackages!.isEmpty) {
//       return '';
//     }
//     return currentEditOrder.value!.orderPackages!.first.package?.title ?? '';
//   }

//   DateTime? getEventDateTime() {
//     if (currentEditOrder.value?.eventDate == null) return null;
//     try {
//       return DateTime.parse(currentEditOrder.value!.eventDate!);
//     } catch (e) {
//       print('Error parsing date: ${currentEditOrder.value!.eventDate}');
//       return null;
//     }
//   }

//   TimeOfDay? getStartTime() {
//     if (currentEditOrder.value?.startTime == null) return null;
//     try {
//       final startTimeString = currentEditOrder.value!.startTime!;
//       print('🕒 Parsing start time: $startTimeString');

//       // Handle the format: "2000-01-01T16:00:00.000Z"
//       // Extract the time part after 'T' and before the seconds
//       final timePart = startTimeString
//           .split('T')[1]
//           .substring(0, 5); // Gets "16:00"
//       final timeParts = timePart.split(':');

//       if (timeParts.length >= 2) {
//         final hour = int.parse(timeParts[0]);
//         final minute = int.parse(timeParts[1]);

//         print('🕒 Parsed start time - Hour: $hour, Minute: $minute');
//         return TimeOfDay(hour: hour, minute: minute);
//       }
//     } catch (e) {
//       print('❌ Error parsing start time: ${currentEditOrder.value!.startTime}');
//       print('❌ Error details: $e');
//     }
//     return null;
//   }

//   TimeOfDay? getEndTime() {
//     if (currentEditOrder.value?.endTime == null) return null;
//     try {
//       final endTimeString = currentEditOrder.value!.endTime!;
//       print('🕒 Parsing end time: $endTimeString');

//       // Handle the format: "2000-01-01T18:00:00.000Z"
//       // Extract the time part after 'T' and before the seconds
//       final timePart = endTimeString
//           .split('T')[1]
//           .substring(0, 5); // Gets "18:00"
//       final timeParts = timePart.split(':');

//       if (timeParts.length >= 2) {
//         final hour = int.parse(timeParts[0]);
//         final minute = int.parse(timeParts[1]);

//         print('🕒 Parsed end time - Hour: $hour, Minute: $minute');
//         return TimeOfDay(hour: hour, minute: minute);
//       }
//     } catch (e) {
//       print('❌ Error parsing end time: ${currentEditOrder.value!.endTime}');
//       print('❌ Error details: $e');
//     }
//     return null;
//   }

//   // Helper method to format time for display
//   String formatTimeForDisplay(TimeOfDay? time) {
//     if (time == null) return 'Not set';
//     final now = DateTime.now();
//     final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
//     return DateFormat('hh:mm a').format(dt);
//   }

//   // Helper method to get the time range string
//   String getTimeRange() {
//     final start = getStartTime();
//     final end = getEndTime();

//     if (start == null && end == null) return 'Time not set';
//     if (start == null) return 'End: ${formatTimeForDisplay(end)}';
//     if (end == null) return 'Start: ${formatTimeForDisplay(start)}';

//     return '${formatTimeForDisplay(start)} - ${formatTimeForDisplay(end)}';
//   }

//   // Method to convert TimeOfDay back to API format
//   String formatTimeForApi(TimeOfDay time) {
//     // API expects format like "2000-01-01T16:00:00.000Z"
//     // We'll use the event date or current date as the date part
//     final eventDate = getEventDateTime() ?? DateTime.now();
//     final hourStr = time.hour.toString().padLeft(2, '0');
//     final minuteStr = time.minute.toString().padLeft(2, '0');

//     return '${eventDate.toIso8601String().split('T')[0]}T${hourStr}:${minuteStr}:00.000Z';
//   }
// }
// // class EditController extends GetxController {
// //   final Rx<EditOrderModel?> currentEditOrder = Rx<EditOrderModel?>(null);
// //   final RxBool isLoading = false.obs;
// //   final RxString errorMessage = ''.obs;

// //   // Load order data by ID
// //   Future<void> loadOrderById(String orderId) async {
// //     try {
// //       isLoading.value = true;
// //       errorMessage.value = '';

// //       print('🔄 Loading order data for ID: $orderId');

// //       final EditOrderModel? order = await EditApiService.getOrderById(orderId);

// //       if (order != null) {
// //         currentEditOrder.value = order;
// //         print('✅ Order loaded successfully: ${order.id}');
// //         print('📝 Order details:');
// //         print('   - Name: ${order.firstname} ${order.lastname}');
// //         print('   - Email: ${order.email}');
// //         print('   - Phone: ${order.phone}');
// //         print('   - Event Date: ${order.eventDate}');
// //         print('   - Guests: ${order.noOfGust}');
// //         print('   - Packages: ${order.orderPackages?.length}');
// //       } else {
// //         errorMessage.value = 'Order not found';
// //         print('❌ Order not found for ID: $orderId');
// //       }
// //     } catch (e) {
// //       errorMessage.value = 'Failed to load order: $e';
// //       print('❌ Error loading order: $e');
// //     } finally {
// //       isLoading.value = false;
// //     }
// //   }

// //   // Update order
// //   Future<bool> updateOrder({
// //     required int orderId,
// //     required Map<String, dynamic> orderData,
// //   }) async {
// //     try {
// //       isLoading.value = true;
// //       errorMessage.value = '';

// //       print('🔄 Updating order: $orderId');

// //       final response = await EditApiService.updateOrder(
// //         orderId: orderId,
// //         orderData: orderData,
// //       );

// //       if (response['success'] == true) {
// //         print('✅ Order updated successfully');
// //         // Reload the order to get updated data
// //         await loadOrderById(orderId.toString());
// //         return true;
// //       } else {
// //         errorMessage.value = response['error'] ?? 'Failed to update order';
// //         print('❌ Order update failed: ${response['error']}');
// //         return false;
// //       }
// //     } catch (e) {
// //       errorMessage.value = 'Error updating order: $e';
// //       print('❌ Error updating order: $e');
// //       return false;
// //     } finally {
// //       isLoading.value = false;
// //     }
// //   }

// //   // Clear current edit order
// //   void clearEditOrder() {
// //     currentEditOrder.value = null;
// //     errorMessage.value = '';
// //   }

// //   // Getter for current order
// //   EditOrderModel? get editOrder => currentEditOrder.value;

// //   // Helper methods to parse data for form
// //   String getFullName() {
// //     if (currentEditOrder.value == null) return '';
// //     return '${currentEditOrder.value!.firstname ?? ''} ${currentEditOrder.value!.lastname ?? ''}'
// //         .trim();
// //   }

// //   String getEventType() {
// //     return currentEditOrder.value?.event?.title ?? '';
// //   }

// //   int getGuestsCount() {
// //     if (currentEditOrder.value?.noOfGust == null) return 1;
// //     return int.tryParse(currentEditOrder.value!.noOfGust!) ?? 1;
// //   }

// //   String getPackageTitle() {
// //     if (currentEditOrder.value?.orderPackages == null ||
// //         currentEditOrder.value!.orderPackages!.isEmpty) {
// //       return '';
// //     }
// //     return currentEditOrder.value!.orderPackages!.first.package?.title ?? '';
// //   }

// //   DateTime? getEventDateTime() {
// //     if (currentEditOrder.value?.eventDate == null) return null;
// //     try {
// //       return DateTime.parse(currentEditOrder.value!.eventDate!);
// //     } catch (e) {
// //       print('Error parsing date: ${currentEditOrder.value!.eventDate}');
// //       return null;
// //     }
// //   }

// //   TimeOfDay? getStartTime() {
// //     if (currentEditOrder.value?.startTime == null) return null;
// //     try {
// //       final timeParts = currentEditOrder.value!.startTime!.split(':');
// //       if (timeParts.length >= 2) {
// //         return TimeOfDay(
// //           hour: int.parse(timeParts[0]),
// //           minute: int.parse(timeParts[1]),
// //         );
// //       }
// //     } catch (e) {
// //       print('Error parsing start time: ${currentEditOrder.value!.startTime}');
// //     }
// //     return null;
// //   }

// //   TimeOfDay? getEndTime() {
// //     if (currentEditOrder.value?.endTime == null) return null;
// //     try {
// //       final timeParts = currentEditOrder.value!.endTime!.split(':');
// //       if (timeParts.length >= 2) {
// //         return TimeOfDay(
// //           hour: int.parse(timeParts[0]),
// //           minute: int.parse(timeParts[1]),
// //         );
// //       }
// //     } catch (e) {
// //       print('Error parsing end time: ${currentEditOrder.value!.endTime}');
// //     }
// //     return null;
// //   }
// // }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:schedule_app/APIS/EditApiService.dart';
// import 'package:schedule_app/model/edit_order_model.dart';
import 'package:schedule_app/pages/Edit/editApi.dart';
import 'package:schedule_app/pages/Edit/model.dart';

class EditController extends GetxController {
  final Rx<EditOrderModel?> currentEditOrder = Rx<EditOrderModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Load order data by ID
  Future<void> loadOrderById(String orderId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('🔄 Loading order data for ID: $orderId');

      final EditOrderModel? order = await EditApiService.getOrderById(orderId);

      if (order != null) {
        currentEditOrder.value = order;
        print('✅ Order loaded successfully: ${order.id}');
        print('📝 Order details:');
        print('   - Name: ${order.firstname} ${order.lastname}');
        print('   - Email: ${order.email}');
        print('   - Phone: ${order.phone}');
        print('   - Event Date: ${order.eventDate}');
        print('   - Guests: ${order.noOfGust}');
        print('   - Packages: ${order.orderPackages?.length}');
      } else {
        errorMessage.value = 'Order not found';
        print('❌ Order not found for ID: $orderId');
      }
    } catch (e) {
      errorMessage.value = 'Failed to load order: $e';
      print('❌ Error loading order: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Update order
  Future<bool> updateOrder({
    required int orderId,
    required Map<String, dynamic> orderData,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('🔄 Updating order: $orderId');

      final response = await EditApiService.updateOrder(
        orderId: orderId,
        orderData: orderData,
      );

      if (response['success'] == true) {
        print('✅ Order updated successfully');
        // Reload the order to get updated data
        await loadOrderById(orderId.toString());
        return true;
      } else {
        errorMessage.value = response['error'] ?? 'Failed to update order';
        print('❌ Order update failed: ${response['error']}');
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Error updating order: $e';
      print('❌ Error updating order: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Clear current edit order
  void clearEditOrder() {
    currentEditOrder.value = null;
    errorMessage.value = '';
  }

  // Getter for current order
  EditOrderModel? get editOrder => currentEditOrder.value;

  // Helper methods to parse data for form
  String getFullName() {
    if (currentEditOrder.value == null) return '';
    return '${currentEditOrder.value!.firstname ?? ''} ${currentEditOrder.value!.lastname ?? ''}'
        .trim();
  }

  String getEventType() {
    return currentEditOrder.value?.event?.title ?? '';
  }

  int getGuestsCount() {
    if (currentEditOrder.value?.noOfGust == null) return 1;
    return int.tryParse(currentEditOrder.value!.noOfGust!) ?? 1;
  }

  String getPackageTitle() {
    if (currentEditOrder.value?.orderPackages == null ||
        currentEditOrder.value!.orderPackages!.isEmpty) {
      return '';
    }
    return currentEditOrder.value!.orderPackages!.first.package?.title ?? '';
  }

  DateTime? getEventDateTime() {
    if (currentEditOrder.value?.eventDate == null) return null;
    try {
      return DateTime.parse(currentEditOrder.value!.eventDate!);
    } catch (e) {
      print('Error parsing date: ${currentEditOrder.value!.eventDate}');
      return null;
    }
  }

  TimeOfDay? getStartTime() {
    if (currentEditOrder.value?.startTime == null) return null;
    try {
      final timeParts = currentEditOrder.value!.startTime!.split(':');
      if (timeParts.length >= 2) {
        return TimeOfDay(
          hour: int.parse(timeParts[0]),
          minute: int.parse(timeParts[1]),
        );
      }
    } catch (e) {
      print('Error parsing start time: ${currentEditOrder.value!.startTime}');
    }
    return null;
  }

  TimeOfDay? getEndTime() {
    if (currentEditOrder.value?.endTime == null) return null;
    try {
      final timeParts = currentEditOrder.value!.endTime!.split(':');
      if (timeParts.length >= 2) {
        return TimeOfDay(
          hour: int.parse(timeParts[0]),
          minute: int.parse(timeParts[1]),
        );
      }
    } catch (e) {
      print('Error parsing end time: ${currentEditOrder.value!.endTime}');
    }
    return null;
  }
}
