import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schedule_app/APIS/Api_Service.dart';
import 'package:schedule_app/pages/Edit/editApi.dart';
// import 'package:schedule_app/APIS/EditApiService.dart';
// import 'package:schedule_app/model/edit_order_model.dart';
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

      final EditOrderModel? order = await ApiService.getOrderById(orderId);

      if (order != null) {
        currentEditOrder.value = order;
        print('✅ Order loaded successfully: ${order.id}');
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

  // Update order with all data
  Future<bool> updateOrderWithData({
    required String firstname,
    required String lastname,
    required String email,
    required String phone,
    required String nin,
    required int cityId,
    required String address,
    required int eventId,
    required String noOfGust,
    required DateTime eventDate,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    required String requirement,
    required bool isInquiry,
    required int paymentMethodId,
    required List<Map<String, dynamic>> orderServices,
    required List<Map<String, dynamic>> orderPackages,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      if (currentEditOrder.value == null) {
        errorMessage.value = 'No order data loaded';
        return false;
      }

      final orderId = currentEditOrder.value!.id!;

      // Format dates and times for API
      final formattedEventDate = ApiService.formatDateForApi(eventDate);
      final formattedEventTime = ApiService.formatTimeOfDayForApi(
        startTime,
        eventDate,
      );
      final formattedStartTime = ApiService.formatTimeOfDayForApi(
        startTime,
        eventDate,
      );
      final formattedEndTime = ApiService.formatTimeOfDayForApi(
        endTime,
        eventDate,
      );

      print('📦 Preparing update data for order: $orderId');
      print('   - Event Date: $formattedEventDate');
      print('   - Start Time: $formattedStartTime');
      print('   - End Time: $formattedEndTime');
      print('   - Guests: $noOfGust');

      // Prepare the order data according to your example
      final orderData = ApiService.formatUpdateOrderData(
        orderId: orderId,
        firstname: firstname,
        lastname: lastname,
        email: email,
        phone: phone,
        nin: nin,
        cityId: cityId,
        address: address,
        eventId: eventId,
        noOfGust: noOfGust,
        eventDate: formattedEventDate,
        eventTime: formattedEventTime,
        startTime: formattedStartTime,
        endTime: formattedEndTime,
        requirement: requirement,
        isInquiry: isInquiry,
        paymentMethodId: paymentMethodId,
        orderServices: orderServices,
        orderPackages: orderPackages,
      );

      print('🔄 Sending PUT request to update order...');

      final response = await ApiService.updateOrder(
        orderId: orderId.toString(),
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

  // Simplified update method that uses current order data and form data
  Future<bool> updateOrderFromForm({
    required String firstname,
    required String lastname,
    required String email,
    required String phone,
    required DateTime eventDate,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    required int guests,
    required OrderPackage,

    required String requirement,
  }) async {
    if (currentEditOrder.value == null) {
      errorMessage.value = 'No order data loaded';
      return false;
    }

    final order = currentEditOrder.value!;

    // Use existing data for fields not in the form
    return await updateOrderWithData(
      firstname: firstname,
      lastname: lastname,
      email: email,
      phone: phone,
      nin: order.nin ?? '123456789', // Default value if not available
      cityId: order.cityId ?? 1,
      address: order.address ?? 'Address not provided',
      eventId: order.eventId ?? 1,
      noOfGust: guests.toString(),
      eventDate: eventDate,
      startTime: startTime,
      endTime: endTime,
      requirement: requirement,
      isInquiry: order.isInquiry ?? false,
      paymentMethodId: order.paymentMethodId ?? 1,
      orderServices: _getOrderServices(),
      orderPackages: _getOrderPackages(),
    );
  }

  // Helper method to get order services (you can modify this based on your data)
  List<Map<String, dynamic>> _getOrderServices() {
    if (currentEditOrder.value?.orderServices == null) {
      return [];
    }

    // Convert order services to the required format
    return currentEditOrder.value!.orderServices!.map((service) {
      return {
        "id": service['id'],
        "order_id": currentEditOrder.value!.id,
        "menu_item_id": service['menu_item_id'] ?? 1,
        "price": service['price'] ?? 0,
        "is_deleted": service['is_deleted'] ?? false,
      };
    }).toList();
  }

  // Helper method to get order packages (you can modify this based on your data)
  List<Map<String, dynamic>> _getOrderPackages() {
    if (currentEditOrder.value?.orderPackages == null) {
      return [];
    }

    return currentEditOrder.value!.orderPackages!.map((package) {
      return {
        "id": package.id,
        "order_id": currentEditOrder.value!.id,
        "package_id": package.packageId ?? 1,
        "amount": package.amount ?? "0.0",
        "is_custom": package.isCustom ?? false,
        "order_package_items":
            package.orderPackageItems?.map((item) {
              return {
                "id": item.id,
                "order_package_id": package.id,
                "menu_item_id": item.menuItemId ?? 1,
                "price": item.price ?? "0.0",
                "no_of_gust": item.noOfGust ?? "1",
                "is_deleted": item.isDeleted ?? false,
              };
            }).toList() ??
            [],
      };
    }).toList();
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

  List<String> splitName(String fullName) {
    final names = fullName.split(' ');
    if (names.length >= 2) {
      return [names[0], names.sublist(1).join(' ')];
    }
    return [fullName, ''];
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
      final startTimeString = currentEditOrder.value!.startTime!;
      print('🕒 Parsing start time: $startTimeString');

      // Handle the format: "2000-01-01T16:00:00.000Z"
      final timePart = startTimeString.split('T')[1].substring(0, 5);
      final timeParts = timePart.split(':');

      if (timeParts.length >= 2) {
        final hour = int.parse(timeParts[0]);
        final minute = int.parse(timeParts[1]);

        return TimeOfDay(hour: hour, minute: minute);
      }
    } catch (e) {
      print('❌ Error parsing start time: ${currentEditOrder.value!.startTime}');
    }
    return null;
  }

  TimeOfDay? getEndTime() {
    if (currentEditOrder.value?.endTime == null) return null;
    try {
      final endTimeString = currentEditOrder.value!.endTime!;
      print('🕒 Parsing end time: $endTimeString');

      // Handle the format: "2000-01-01T18:00:00.000Z"
      final timePart = endTimeString.split('T')[1].substring(0, 5);
      final timeParts = timePart.split(':');

      if (timeParts.length >= 2) {
        final hour = int.parse(timeParts[0]);
        final minute = int.parse(timeParts[1]);

        return TimeOfDay(hour: hour, minute: minute);
      }
    } catch (e) {
      print('❌ Error parsing end time: ${currentEditOrder.value!.endTime}');
    }
    return null;
  }
}
