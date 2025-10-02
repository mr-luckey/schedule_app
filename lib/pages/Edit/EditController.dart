// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:schedule_app/APIS/Api_Service.dart';
// // import 'package:schedule_app/pages/Edit/editApi.dart';
// // // import 'package:schedule_app/APIS/EditApiService.dart';
// // // import 'package:schedule_app/model/edit_order_model.dart';
// // import 'package:schedule_app/pages/Edit/model.dart';

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

// //       final EditOrderModel? order = await ApiService.getOrderById(orderId);

// //       if (order != null) {
// //         currentEditOrder.value = order;
// //         print('✅ Order loaded successfully: ${order.id}');
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

// //   // Update order with all data
// //   Future<bool> updateOrderWithData({
// //     required String firstname,
// //     required String lastname,
// //     required String email,
// //     required String phone,
// //     required String nin,
// //     required int cityId,
// //     required String address,
// //     required int eventId,
// //     required String noOfGust,
// //     required DateTime eventDate,
// //     required TimeOfDay startTime,
// //     required TimeOfDay endTime,
// //     required String requirement,
// //     required bool isInquiry,
// //     required int paymentMethodId,
// //     required List<Map<String, dynamic>> orderServices,
// //     required List<Map<String, dynamic>> orderPackages,
// //   }) async {
// //     try {
// //       isLoading.value = true;
// //       errorMessage.value = '';

// //       if (currentEditOrder.value == null) {
// //         errorMessage.value = 'No order data loaded';
// //         return false;
// //       }

// //       final orderId = currentEditOrder.value!.id!;

// //       // Format dates and times for API
// //       final formattedEventDate = ApiService.formatDateForApi(eventDate);
// //       final formattedEventTime = ApiService.formatTimeOfDayForApi(
// //         startTime,
// //         eventDate,
// //       );
// //       final formattedStartTime = ApiService.formatTimeOfDayForApi(
// //         startTime,
// //         eventDate,
// //       );
// //       final formattedEndTime = ApiService.formatTimeOfDayForApi(
// //         endTime,
// //         eventDate,
// //       );

// //       print('📦 Preparing update data for order: $orderId');
// //       print('   - Event Date: $formattedEventDate');
// //       print('   - Start Time: $formattedStartTime');
// //       print('   - End Time: $formattedEndTime');
// //       print('   - Guests: $noOfGust');

// //       // Prepare the order data according to your example
// //       final orderData = ApiService.formatUpdateOrderData(
// //         orderId: orderId,
// //         firstname: firstname,
// //         lastname: lastname,
// //         email: email,
// //         phone: phone,
// //         nin: nin,
// //         cityId: cityId,
// //         address: address,
// //         eventId: eventId,
// //         noOfGust: noOfGust,
// //         eventDate: formattedEventDate,
// //         eventTime: formattedEventTime,
// //         startTime: formattedStartTime,
// //         endTime: formattedEndTime,
// //         requirement: requirement,
// //         isInquiry: isInquiry,
// //         paymentMethodId: paymentMethodId,
// //         orderServices: orderServices,
// //         orderPackages: orderPackages,
// //       );

// //       print('🔄 Sending PUT request to update order...');

// //       final response = await ApiService.updateOrder(
// //         orderId: orderId.toString(),
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

// //   // Simplified update method that uses current order data and form data
// //   Future<bool> updateOrderFromForm({
// //     required String firstname,
// //     required String lastname,
// //     required String email,
// //     required String phone,
// //     required DateTime eventDate,
// //     required TimeOfDay startTime,
// //     required TimeOfDay endTime,
// //     required int guests,

// //     // required OrderPackage,
// //     required String requirement,
// //   }) async {
// //     if (currentEditOrder.value == null) {
// //       errorMessage.value = 'No order data loaded';
// //       return false;
// //     }

// //     final order = currentEditOrder.value!;

// //     // Use existing data for fields not in the form
// //     return await updateOrderWithData(
// //       firstname: firstname,
// //       lastname: lastname,
// //       email: email,
// //       phone: phone,
// //       nin: order.nin ?? '123456789', // Default value if not available
// //       cityId: order.cityId ?? 1,
// //       address: order.address ?? 'Address not provided',
// //       eventId: order.eventId ?? 1,
// //       noOfGust: guests.toString(),
// //       eventDate: eventDate,
// //       startTime: startTime,
// //       endTime: endTime,
// //       requirement: requirement,
// //       isInquiry: order.isInquiry ?? false,
// //       paymentMethodId: order.paymentMethodId ?? 1,
// //       orderServices: _getOrderServices(),
// //       orderPackages: _getOrderPackages(),
// //     );
// //   }

// //   // Helper method to get order services (you can modify this based on your data)
// //   List<Map<String, dynamic>> _getOrderServices() {
// //     if (currentEditOrder.value?.orderServices == null) {
// //       return [];
// //     }

// //     // Convert order services to the required format
// //     return currentEditOrder.value!.orderServices!.map((service) {
// //       return {
// //         "id": service.id,
// //         "order_id": currentEditOrder.value!.id,
// //         "menu_item_id": service.menuItemId ?? 1,
// //         "price": service.price ?? "0.0",
// //         "is_deleted": service.isDeleted ?? false,
// //       };
// //     }).toList();
// //   }

// //   // Helper method to get order packages (you can modify this based on your data)
// //   List<Map<String, dynamic>> _getOrderPackages() {
// //     if (currentEditOrder.value?.orderPackages == null) {
// //       return [];
// //     }

// //     return currentEditOrder.value!.orderPackages!.map((package) {
// //       return {
// //         "id": package.id,
// //         "order_id": currentEditOrder.value!.id,
// //         "package_id": package.packageId ?? 1,
// //         "amount": package.amount ?? "0.0",
// //         "is_custom": package.isCustom ?? false,
// //         "order_package_items":
// //             package.orderPackageItems?.map((item) {
// //               return {
// //                 "id": item.id,
// //                 "order_package_id": package.id,
// //                 "menu_item_id": item.menuItemId ?? 1,
// //                 "price": item.price ?? "0.0",
// //                 "no_of_gust": item.noOfGust ?? "1",
// //                 "is_deleted": item.isDeleted ?? false,
// //               };
// //             }).toList() ??
// //             [],
// //       };
// //     }).toList();
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

// //   List<String> splitName(String fullName) {
// //     final names = fullName.split(' ');
// //     if (names.length >= 2) {
// //       return [names[0], names.sublist(1).join(' ')];
// //     }
// //     return [fullName, ''];
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
// //       final startTimeString = currentEditOrder.value!.startTime!;
// //       print('🕒 Parsing start time: $startTimeString');

// //       // Handle the format: "2000-01-01T16:00:00.000Z"
// //       final timePart = startTimeString.split('T')[1].substring(0, 5);
// //       final timeParts = timePart.split(':');

// //       if (timeParts.length >= 2) {
// //         final hour = int.parse(timeParts[0]);
// //         final minute = int.parse(timeParts[1]);

// //         return TimeOfDay(hour: hour, minute: minute);
// //       }
// //     } catch (e) {
// //       print('❌ Error parsing start time: ${currentEditOrder.value!.startTime}');
// //     }
// //     return null;
// //   }

// //   TimeOfDay? getEndTime() {
// //     if (currentEditOrder.value?.endTime == null) return null;
// //     try {
// //       final endTimeString = currentEditOrder.value!.endTime!;
// //       print('🕒 Parsing end time: $endTimeString');

// //       // Handle the format: "2000-01-01T18:00:00.000Z"
// //       final timePart = endTimeString.split('T')[1].substring(0, 5);
// //       final timeParts = timePart.split(':');

// //       if (timeParts.length >= 2) {
// //         final hour = int.parse(timeParts[0]);
// //         final minute = int.parse(timeParts[1]);

// //         return TimeOfDay(hour: hour, minute: minute);
// //       }
// //     } catch (e) {
// //       print('❌ Error parsing end time: ${currentEditOrder.value!.endTime}');
// //     }
// //     return null;
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:schedule_app/APIS/Api_Service.dart';
// import 'package:schedule_app/pages/Edit/model.dart';

// class EditController extends GetxController {
//   final Rx<EditOrderModel?> currentEditOrder = Rx<EditOrderModel?>(null);
//   final RxBool isLoading = false.obs;
//   final RxString errorMessage = ''.obs;

//   // Add these to track current state of services and packages
//   final RxList<OrderService> currentOrderServices = <OrderService>[].obs;
//   final RxList<OrderPackage> currentOrderPackages = <OrderPackage>[].obs;

//   // Load order data by ID
//   Future<void> loadOrderById(String orderId) async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';

//       print('🔄 Loading order data for ID: $orderId');

//       final EditOrderModel? order = await ApiService.getOrderById(orderId);

//       if (order != null) {
//         currentEditOrder.value = order;
//         // Initialize current lists with data from server
//         currentOrderServices.value = List.from(order.orderServices ?? []);
//         currentOrderPackages.value = List.from(order.orderPackages ?? []);
//         print('✅ Order loaded successfully: ${order.id}');
//         print(
//           '📦 Loaded ${currentOrderServices.length} services and ${currentOrderPackages.length} packages',
//         );
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

//   // Add new service to current list
//   void addService(OrderService service) {
//     currentOrderServices.add(service);
//     print(
//       '✅ Added new service. Total services: ${currentOrderServices.length}',
//     );
//   }

//   // Remove service from current list
//   void removeService(OrderService service) {
//     currentOrderServices.remove(service);
//     print('✅ Removed service. Total services: ${currentOrderServices.length}');
//   }

//   // Add new package to current list
//   void addPackage(OrderPackage package) {
//     currentOrderPackages.add(package);
//     print(
//       '✅ Added new package. Total packages: ${currentOrderPackages.length}',
//     );
//   }

//   // Remove package from current list
//   void removePackage(OrderPackage package) {
//     currentOrderPackages.remove(package);
//     print('✅ Removed package. Total packages: ${currentOrderPackages.length}');
//   }

//   // Update existing service

//   //TODO:Update Service
//   void updateService(int index, OrderService updatedService) {
//     if (index >= 0 && index < currentOrderServices.length) {
//       currentOrderServices[index] = updatedService;
//     }
//   }

//   // Update existing package
//   void updatePackage(int index, OrderPackage updatedPackage) {
//     if (index >= 0 && index < currentOrderPackages.length) {
//       currentOrderPackages[index] = updatedPackage;
//     }
//   }

//   // Update order with all data - USE THIS METHOD FOR UPDATE
//   Future<bool> updateOrderWithData({
//     required String firstname,
//     required String lastname,
//     required String email,
//     required String phone,
//     required String nin,
//     required int cityId,
//     required String address,
//     required int eventId,
//     required String noOfGust,
//     required DateTime eventDate,
//     required TimeOfDay startTime,
//     required TimeOfDay endTime,
//     required String requirement,
//     required bool isInquiry,
//     required int paymentMethodId,
//   }) async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';

//       if (currentEditOrder.value == null) {
//         errorMessage.value = 'No order data loaded';
//         return false;
//       }

//       final orderId = currentEditOrder.value!.id!;

//       // Format dates and times for API
//       final formattedEventDate = ApiService.formatDateForApi(eventDate);
//       final formattedEventTime = ApiService.formatTimeOfDayForApi(
//         startTime,
//         eventDate,
//       );
//       final formattedStartTime = ApiService.formatTimeOfDayForApi(
//         startTime,
//         eventDate,
//       );
//       final formattedEndTime = ApiService.formatTimeOfDayForApi(
//         endTime,
//         eventDate,
//       );
//       final orderServicesData = _getOrderServicesForApi();
//       final orderPackagesData = _getOrderPackagesForApi();
//       print('📦 Preparing update data for order: $orderId');
//       print('   - Event Date: $formattedEventDate');
//       print('   - Start Time: $formattedStartTime');
//       print('   - End Time: $formattedEndTime');
//       print('   - Guests: $noOfGust');
//       print('   - Services count: ${currentOrderServices.length}');
//       print('   - Packages count: ${currentOrderPackages.length}');
//       print(
//         '   - Packages count: ${currentOrderPackages.first.orderPackageItems!.first.menuItem!.title}',
//       );
//       print('   - Packages count: ${orderPackagesData.first}');

//       // Use the current lists that include any modifications

//       //FIXME: Here is the issue in this function
//       // Prepare the order data according to your example
//       final orderData = ApiService.formatUpdateOrderData(
//         orderId: orderId,
//         firstname: firstname,
//         lastname: lastname,
//         email: email,
//         phone: phone,
//         nin: nin,
//         cityId: cityId,
//         address: address,
//         eventId: eventId,
//         noOfGust: noOfGust,
//         eventDate: formattedEventDate,
//         eventTime: formattedEventTime,
//         startTime: formattedStartTime,
//         endTime: formattedEndTime,
//         requirement: requirement,
//         isInquiry: isInquiry,
//         paymentMethodId: paymentMethodId,
//         orderServices: orderServicesData,
//         orderPackages: orderPackagesData,
//       );

//       print('🔄 Sending PUT request to update order...');

//       final response = await ApiService.updateOrder(
//         orderId: orderId.toString(),
//         orderData: orderData, //TODO:the attribute where its passing data to api
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

//   //TODO: Data Passing by this function
//   // Helper method to get order services for API - USES CURRENT STATE
//   List<Map<String, dynamic>> _getOrderServicesForApi() {
//     // Convert current services to the required format
//     return currentOrderServices.map((service) {
//       return {
//         "id": service.id,
//         "order_id": currentEditOrder.value!.id,
//         "menu_item_id": service.menuItemId ?? service.menuItem?.id ?? 1,
//         "price": service.price ?? "0.0",
//         "is_deleted": service.isDeleted ?? false,
//         // Include menu_item if needed by your API
//         if (service.menuItem != null) "menu_item": service.menuItem!.toJson(),
//       };
//     }).toList();
//   }

//   // Helper method to get order packages for API - USES CURRENT STATE
//   List<Map<String, dynamic>> _getOrderPackagesForApi() {
//     return currentOrderPackages.map((package) {
//       return {
//         "id": package.id,
//         "order_id": currentEditOrder.value!.id,
//         "package_id": package.packageId ?? package.package?.id ?? 1,
//         "amount": package.amount ?? "0.0",
//         "is_custom": package.isCustom ?? false,
//         "order_package_items":
//             package.orderPackageItems?.map((item) {
//               return {
//                 "id": item.id,
//                 "order_package_id": package.id,
//                 "menu_item_id": item.menuItemId ?? item.menuItem?.id ?? 1,
//                 "price": item.price ?? "0.0",
//                 "no_of_gust": item.noOfGust ?? "1",
//                 "is_deleted": item.isDeleted ?? false,
//                 // Include menu_item if needed by your API
//                 if (item.menuItem != null) "menu_item": item.menuItem!.toJson(),
//               };
//             }).toList() ??
//             [],
//         // Include package if needed by your API
//         if (package.package != null) "package": package.package!.toJson(),
//       };
//     }).toList();
//   }

//   // Simplified update method that uses current order data and form data
//   Future<bool> updateOrderFromForm({
//     required String firstname,
//     required String lastname,
//     required String email,
//     required String phone,
//     required DateTime eventDate,
//     required TimeOfDay startTime,
//     required TimeOfDay endTime,
//     required int guests,
//     required String requirement,
//   }) async {
//     if (currentEditOrder.value == null) {
//       errorMessage.value = 'No order data loaded';
//       return false;
//     }

//     final order = currentEditOrder.value!;

//     // Use existing data for fields not in the form, but use CURRENT services and packages
//     return await updateOrderWithData(
//       firstname: firstname,
//       lastname: lastname,
//       email: email,
//       phone: phone,
//       nin: order.nin ?? '123456789',
//       cityId: order.cityId ?? 1,
//       address: order.address ?? 'Address not provided',
//       eventId: order.eventId ?? 1,
//       noOfGust: guests.toString(),
//       eventDate: eventDate,
//       startTime: startTime,
//       endTime: endTime,
//       requirement: requirement,
//       isInquiry: order.isInquiry ?? false,
//       paymentMethodId: order.paymentMethodId ?? 1,
//     );
//   }

//   // Clear current edit order
//   void clearEditOrder() {
//     currentEditOrder.value = null;
//     currentOrderServices.clear();
//     currentOrderPackages.clear();
//     errorMessage.value = '';
//   }

//   // Getter for current order
//   EditOrderModel? get editOrder => currentEditOrder.value;

//   // Getter for current services and packages
//   List<OrderService> get services => currentOrderServices.toList();
//   List<OrderPackage> get packages => currentOrderPackages.toList();

//   // Helper methods to parse data for form
//   String getFullName() {
//     if (currentEditOrder.value == null) return '';
//     return '${currentEditOrder.value!.firstname ?? ''} ${currentEditOrder.value!.lastname ?? ''}'
//         .trim();
//   }

//   List<String> splitName(String fullName) {
//     final names = fullName.split(' ');
//     if (names.length >= 2) {
//       return [names[0], names.sublist(1).join(' ')];
//     }
//     return [fullName, ''];
//   }

//   String getEventType() {
//     return currentEditOrder.value?.event?.title ?? '';
//   }

//   int getGuestsCount() {
//     if (currentEditOrder.value?.noOfGust == null) return 1;
//     return int.tryParse(currentEditOrder.value!.noOfGust!) ?? 1;
//   }

//   String getPackageTitle() {
//     if (currentOrderPackages.isEmpty) return '';
//     return currentOrderPackages.first.package?.title ?? '';
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
//       final timePart = startTimeString.split('T')[1].substring(0, 5);
//       final timeParts = timePart.split(':');

//       if (timeParts.length >= 2) {
//         final hour = int.parse(timeParts[0]);
//         final minute = int.parse(timeParts[1]);

//         return TimeOfDay(hour: hour, minute: minute);
//       }
//     } catch (e) {
//       print('❌ Error parsing start time: ${currentEditOrder.value!.startTime}');
//     }
//     return null;
//   }

//   TimeOfDay? getEndTime() {
//     if (currentEditOrder.value?.endTime == null) return null;
//     try {
//       final endTimeString = currentEditOrder.value!.endTime!;
//       print('🕒 Parsing end time: $endTimeString');

//       // Handle the format: "2000-01-01T18:00:00.000Z"
//       final timePart = endTimeString.split('T')[1].substring(0, 5);
//       final timeParts = timePart.split(':');

//       if (timeParts.length >= 2) {
//         final hour = int.parse(timeParts[0]);
//         final minute = int.parse(timeParts[1]);

//         return TimeOfDay(hour: hour, minute: minute);
//       }
//     } catch (e) {
//       print('❌ Error parsing end time: ${currentEditOrder.value!.endTime}');
//     }
//     return null;
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schedule_app/APIS/Api_Service.dart';
import 'package:schedule_app/pages/Edit/model.dart';

class EditController extends GetxController {
  final Rx<EditOrderModel?> currentEditOrder = Rx<EditOrderModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Add these to track current state of services and packages
  final RxList<OrderService> currentOrderServices = <OrderService>[].obs;
  final RxList<OrderPackage> currentOrderPackages = <OrderPackage>[].obs;

  // Load order data by ID
  Future<void> loadOrderById(String orderId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('🔄 Loading order data for ID: $orderId');

      final EditOrderModel? order = await ApiService.getOrderById(orderId);

      if (order != null) {
        currentEditOrder.value = order;
        // Initialize current lists with data from server
        currentOrderServices.value = List.from(order.orderServices ?? []);
        currentOrderPackages.value = List.from(order.orderPackages ?? []);
        print('✅ Order loaded successfully: ${order.id}');
        print(
          '📦 Loaded ${currentOrderServices.length} services and ${currentOrderPackages.length} packages',
        );

        // Debug print to see what we loaded
        if (currentOrderPackages.isNotEmpty) {
          print(
            '📦 First package items: ${currentOrderPackages.first.orderPackageItems?.length ?? 0}',
          );
          if (currentOrderPackages.first.orderPackageItems != null) {
            for (var item in currentOrderPackages.first.orderPackageItems!) {
              print('   - ${item.menuItem?.title} (Qty: ${item.noOfGust})');
            }
          }
        }
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

  // Add new service to current list
  void addService(OrderService service) {
    currentOrderServices.add(service);
    print(
      '✅ Added new service. Total services: ${currentOrderServices.length}',
    );
  }

  // Remove service from current list
  void removeService(OrderService service) {
    currentOrderServices.remove(service);
    print('✅ Removed service. Total services: ${currentOrderServices.length}');
  }

  // Add new package to current list
  void addPackage(OrderPackage package) {
    currentOrderPackages.add(package);
    print(
      '✅ Added new package. Total packages: ${currentOrderPackages.length}',
    );
  }

  // Remove package from current list
  void removePackage(OrderPackage package) {
    currentOrderPackages.remove(package);
    print('✅ Removed package. Total packages: ${currentOrderPackages.length}');
  }

  // Update existing service
  void updateService(int index, OrderService updatedService) {
    if (index >= 0 && index < currentOrderServices.length) {
      currentOrderServices[index] = updatedService;
    }
  }

  // Update existing package
  void updatePackage(int index, OrderPackage updatedPackage) {
    if (index >= 0 && index < currentOrderPackages.length) {
      currentOrderPackages[index] = updatedPackage;
    }
  }

  // Update order with all data - USE THIS METHOD FOR UPDATE
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

      // Get the updated services and packages for API
      final orderServicesData = _getOrderServicesForApi();
      final orderPackagesData = _getOrderPackagesForApi();

      print('📦 Preparing update data for order: $orderId');
      print('   - Event Date: $formattedEventDate');
      print('   - Start Time: $formattedStartTime');
      print('   - End Time: $formattedEndTime');
      print('   - Guests: $noOfGust');
      print('   - Services count: ${orderServicesData.length}');
      print('   - Packages count: ${orderPackagesData.length}');

      if (orderPackagesData.isNotEmpty) {
        final firstPackage = orderPackagesData.first;
        final List<dynamic> packageItems =
            (firstPackage['order_package_items_attributes'] ??
                    firstPackage['order_package_items'] ??
                    [])
                as List<dynamic>;
        print('   - Package items count: ${packageItems.length}');
        for (var item in packageItems) {
          print('     - ${item['menu_item_id']}: Qty ${item['no_of_gust']}');
        }
      }

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
        orderServices: orderServicesData,
        orderPackages: orderPackagesData,
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

  // Helper method to get order services for API - USES CURRENT STATE
  List<Map<dynamic, dynamic>> _getOrderServicesForApi() {
    return currentOrderServices
        .map((service) {
          final String? menuItemIdStr =
              service.menuItemId ?? service.menuItem?.id;
          final int? menuItemIdInt = int.tryParse(
            menuItemIdStr?.toString() ?? '',
          );
          if (menuItemIdInt == null) {
            print(
              '⚠️ Service has no valid menu item ID: ${service.menuItem?.title}',
            );
            return {};
          }

          final int? idInt = int.tryParse(service.id ?? '');
          final int? orderIdInt = currentEditOrder.value?.id;
          final num priceNum =
              num.tryParse(service.price ?? service.menuItem?.price ?? '0') ??
              0;

          return {
            if (idInt != null) "id": idInt,
            if (orderIdInt != null) "order_id": orderIdInt,
            "menu_item_id": menuItemIdInt,
            // Keep price numeric; server can accept numeric in attributes
            "price": priceNum,
            "is_deleted": service.isDeleted ?? false,
          };
        })
        .where((item) => item.isNotEmpty)
        .toList();
  }

  // Helper method to get order packages for API - USES CURRENT STATE
  List<Map<dynamic, dynamic>> _getOrderPackagesForApi() {
    return currentOrderPackages
        .map((package) {
          final int? packageIdInt = package.packageId ?? package.package?.id;
          if (packageIdInt == null) {
            print('⚠️ Package has no package ID: ${package.package?.title}');
            return {};
          }

          final int? orderIdInt = currentEditOrder.value?.id;
          final int? pkgIdInt = package.id;

          // Convert package items
          final List<Map<String, dynamic>> packageItems = [];
          if (package.orderPackageItems != null) {
            for (var item in package.orderPackageItems!) {
              final int? menuItemIdInt =
                  item.menuItemId ?? int.tryParse(item.menuItem?.id ?? '');
              if (menuItemIdInt == null) {
                print(
                  '⚠️ Package item has no valid menu item ID: ${item.menuItem?.title}',
                );
                continue;
              }

              final int? itemIdInt = int.tryParse(item.id ?? '');
              final int? orderPackageIdInt = item.orderPackageId ?? pkgIdInt;
              final String priceStr =
                  item.price ?? (item.menuItem?.price ?? '0.0');
              final String qtyStr = item.noOfGust ?? '1';

              packageItems.add({
                if (itemIdInt != null) "id": itemIdInt,
                if (orderPackageIdInt != null)
                  "order_package_id": orderPackageIdInt,
                "menu_item_id": menuItemIdInt,
                "price": priceStr,
                "no_of_gust": qtyStr,
                "is_deleted": item.isDeleted ?? false,
              });
            }
          }

          return {
            if (pkgIdInt != null) "id": pkgIdInt,
            if (orderIdInt != null) "order_id": orderIdInt,
            "package_id": packageIdInt,
            "amount": package.amount ?? (package.package?.price ?? "0.0"),
            "is_custom": package.isCustom ?? false,
            // Use *_attributes for nested updates
            "order_package_items_attributes": packageItems,
          };
        })
        .where((item) => item.isNotEmpty)
        .toList();
  }

  // Clear current edit order
  void clearEditOrder() {
    currentEditOrder.value = null;
    currentOrderServices.clear();
    currentOrderPackages.clear();
    errorMessage.value = '';
  }

  // Getter for current order
  EditOrderModel? get editOrder => currentEditOrder.value;

  // Getter for current services and packages
  List<OrderService> get services => currentOrderServices.toList();
  List<OrderPackage> get packages => currentOrderPackages.toList();

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
    if (currentOrderPackages.isEmpty) return '';
    return currentOrderPackages.first.package?.title ?? '';
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
