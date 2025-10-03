// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:schedule_app/APIS/Api_Service.dart';
// // import 'package:schedule_app/pages/Edit/model.dart';
// // import 'package:schedule_app/pages/Edit/edit_order_body.dart' as body;
// // import 'dart:convert';
// // import 'package:shared_preferences/shared_preferences.dart';

// // class EditController extends GetxController {
// //   final Rx<EditOrderModel?> currentEditOrder = Rx<EditOrderModel?>(null);
// //   final RxBool isLoading = false.obs;
// //   final RxString errorMessage = ''.obs;

// //   // Add these to track current state of services and packages
// //   final RxList<OrderServices> currentOrderServices = <OrderServices>[].obs;
// //   final RxList<OrderPackages> currentOrderPackages = <OrderPackages>[].obs;

// //   // Persistence methods
// //   static String _prefsKeyForOrder(String orderId) => 'edit_menu_$orderId';

// //   Future<void> saveSelectionMenu(
// //     String orderId,
// //     Map<String, List<Map<String, dynamic>>> menu,
// //   ) async {
// //     try {
// //       final prefs = await SharedPreferences.getInstance();
// //       final jsonStr = jsonEncode(menu);
// //       await prefs.setString(_prefsKeyForOrder(orderId), jsonStr);
// //       print('💾 Saved menu selection for order: $orderId');
// //     } catch (e) {
// //       print('❌ Error saving menu selection: $e');
// //     }
// //   }

// //   Future<Map<String, List<Map<String, dynamic>>>?> _loadSelectionMenu(
// //     String orderId,
// //   ) async {
// //     try {
// //       final prefs = await SharedPreferences.getInstance();
// //       final jsonStr = prefs.getString(_prefsKeyForOrder(orderId));
// //       if (jsonStr == null || jsonStr.isEmpty) return null;

// //       final decoded = jsonDecode(jsonStr);
// //       if (decoded is Map<String, dynamic>) {
// //         final result = <String, List<Map<String, dynamic>>>{};
// //         for (final entry in decoded.entries) {
// //           final list = (entry.value as List)
// //               .map((e) => Map<String, dynamic>.from(e as Map))
// //               .toList();
// //           result[entry.key] = list;
// //         }
// //         print('📂 Loaded saved menu selection for order: $orderId');
// //         return result;
// //       }
// //     } catch (e) {
// //       print('❌ Error loading saved menu selection: $e');
// //     }
// //     return null;
// //   }

// //   Future<void> _applySavedSelection(String orderId) async {
// //     final saved = await _loadSelectionMenu(orderId);
// //     if (saved == null) return;

// //     // Build services from "Services"
// //     final List<OrderServices> services = [];
// //     for (final svc in (saved['Services'] ?? [])) {
// //       final dynamic rawId = svc['menu_item_id'] ?? svc['id'];
// //       final int? menuItemId = int.tryParse(rawId?.toString() ?? '');

// //       services.add(
// //         OrderServices(
// //           menuItemId: menuItemId,
// //           price:
// //               int.tryParse(
// //                 (svc['price'] is num)
// //                     ? (svc['price'] as num).toString()
// //                     : (svc['price']?.toString() ?? '0'),
// //               ) ??
// //               0,
// //           isDeleted: false,
// //           service: Service(
// //             id: menuItemId,
// //             title: svc['name']?.toString() ?? 'Service',
// //             price: (svc['price'] is num)
// //                 ? (svc['price'] as num).toString()
// //                 : (svc['price']?.toString() ?? '0'),
// //             description: '',
// //           ),
// //         ),
// //       );
// //     }

// //     // Build one package with items from "Food Items"
// //     final List<OrderPackageItems> items = [];
// //     for (final food in (saved['Food Items'] ?? [])) {
// //       final dynamic rawId = food['menu_item_id'] ?? food['id'];
// //       final int? menuItemId = int.tryParse(rawId?.toString() ?? '');
// //       final String qtyStr = (food['qty'] is int)
// //           ? (food['qty'] as int).toString()
// //           : (food['qty']?.toString() ?? '1');

// //       items.add(
// //         OrderPackageItems(
// //           menuItemId: menuItemId,
// //           price: (food['price'] is num)
// //               ? (food['price'] as num).toString()
// //               : (food['price']?.toString() ?? '0'),
// //           noOfGust: qtyStr,
// //           isDeleted: false,
// //           menuItem: Service(
// //             id: menuItemId,
// //             title: food['name']?.toString() ?? 'Food Item',
// //             price: (food['price'] is num)
// //                 ? (food['price'] as num).toString()
// //                 : (food['price']?.toString() ?? '0'),
// //             description: '',
// //           ),
// //         ),
// //       );
// //     }

// //     // Keep existing package meta if available, but replace items/amount
// //     OrderPackages base = currentOrderPackages.isNotEmpty
// //         ? currentOrderPackages.first
// //         : OrderPackages(packageId: 1, amount: '0', isCustom: true);

// //     final updatedPackage = OrderPackages(
// //       id: base.id,
// //       orderId: base.orderId,
// //       packageId: base.packageId ?? 1,
// //       amount: base.amount ?? '0',
// //       isCustom: true,
// //       package: base.package,
// //       orderPackageItems: items,
// //     );

// //     currentOrderServices.value = services;
// //     currentOrderPackages.value = [updatedPackage];

// //     print(
// //       '🔄 Applied saved selection: ${services.length} services, ${items.length} food items',
// //     );
// //   }

// //   // Load order data by ID
// //   Future<void> loadOrderById(String orderId) async {
// //     try {
// //       isLoading.value = true;
// //       errorMessage.value = '';

// //       print('🔄 Loading order data for ID: $orderId');

// //       final EditOrderModel? order = await ApiService.getOrderById(
// //         orderId.toString(),
// //       );

// //       if (order != null) {
// //         currentEditOrder.value = order;
// //         // Initialize current lists with data from server
// //         currentOrderServices.value = List.from(order.orderServices ?? []);
// //         currentOrderPackages.value = List.from(order.orderPackages ?? []);

// //         // Try to load any saved selection for this order
// //         await _applySavedSelection(orderId);

// //         print('✅ Order loaded successfully: ${order.id}');
// //         print(
// //           '📦 Loaded ${currentOrderServices.length} services and ${currentOrderPackages.length} packages',
// //         );

// //         // Debug print to see what we loaded
// //         if (currentOrderPackages.isNotEmpty) {
// //           print(
// //             '📦 First package items: ${currentOrderPackages.first.orderPackageItems?.length ?? 0}',
// //           );
// //           if (currentOrderPackages.first.orderPackageItems != null) {
// //             for (var item in currentOrderPackages.first.orderPackageItems!) {
// //               print('   - ${item.menuItem?.title} (Qty: ${item.noOfGust})');
// //             }
// //           }
// //         }
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

// //   // Update order with all data - USE THIS METHOD FOR UPDATE
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

// //       // Get the updated services and packages for API
// //       final orderServicesData = _getOrderServicesForApi();
// //       final orderPackagesData = _getOrderPackagesForApi();

// //       print('📦 Preparing update data for order: $orderId');
// //       print('   - Event Date: $formattedEventDate');
// //       print('   - Start Time: $formattedStartTime');
// //       print('   - End Time: $formattedEndTime');
// //       print('   - Guests: $noOfGust');
// //       print('   - Services count: ${orderServicesData.length}');
// //       print('   - Packages count: ${orderPackagesData.length}');

// //       if (orderPackagesData.isNotEmpty) {
// //         final firstPackage = orderPackagesData.first;
// //         final packageItems =
// //             firstPackage['order_package_items_attributes'] ?? [];
// //         print('   - Package items count: ${packageItems.length}');
// //         for (var item in packageItems) {
// //           print('     - ${item['menu_item_id']}: Qty ${item['no_of_gust']}');
// //         }
// //       }
// //       print('🔄 OrderServicesData: ${orderServicesData}');

// //       // Build request body using dedicated model
// //       final bodyOrderServices = orderServicesData.map((m) {
// //         print('🔄 m: ${m}');
// //         print('🔄 Building OrderServices: ${m['id']}');
// //         return body.OrderServices(
// //           id: m['id']?.toString(),
// //           orderId: m['order_id']?.toString(),
// //           menuItemId: m['menu_item_id']?.toString(),
// //           price: (m['price'] is num)
// //               ? (m['price'] as num).toInt()
// //               : int.tryParse(m['price']?.toString() ?? '0') ?? 0,
// //           isDeleted: m['is_deleted'] ?? false,
// //         );
// //       }).toList();
// //       print('🔄 bodyOrderServices: ${bodyOrderServices}');

// //       final bodyOrderPackages = orderPackagesData.map((pkg) {
// //         final itemsDyn = pkg['order_package_items_attributes'] ?? [];
// //         final items = itemsDyn.map<body.OrderPackageItems>((it) {
// //           return body.OrderPackageItems(
// //             id: it['id']?.toString(),
// //             orderPackageId: it['order_package_id']?.toString(),
// //             menuItemId: it['menu_item_id']?.toString(),
// //             price: it['price']?.toString(),
// //             noOfGust: it['no_of_gust']?.toString(),
// //             isDeleted: it['is_deleted'] ?? false,
// //           );
// //         }).toList();
// //         print("Test: ${pkg['id']}");
// //         return body.OrderPackages(
// //           id: pkg['id']?.toString(),
// //           orderId: pkg['order_id']?.toString(),
// //           packageId: pkg['package_id']?.toString(),
// //           amount: (pkg['amount'] ?? '0').toString(),
// //           isCustom: pkg['is_custom'] ?? false,
// //           orderPackageItems: items,
// //         );
// //       }).toList();

// //       final bodyOrder = body.Order(
// //         id: orderId.toString(),
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
// //         orderServices: bodyOrderServices,
// //         orderPackages: bodyOrderPackages,
// //       );

// //       final requestBody = body.EditOrderBody(order: bodyOrder).toJson();

// //       print('🔄 Sending PUT request to update order...');

// //       final response = await ApiService.updateOrder(
// //         orderId: orderId,
// //         EditOrderModel: requestBody,
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
// //       print('❌ Error updating order:Controller Screen $e');
// //       return false;
// //     } finally {
// //       isLoading.value = false;
// //     }
// //   }

// //   // Helper method to get order services for API - USES CURRENT STATE
// //   List<Map<dynamic, dynamic>> _getOrderServicesForApi() {
// //     return currentOrderServices
// //         .map((service) {
// //           final int? menuItemId = service.menuItemId ?? service.service?.id;
// //           if (menuItemId == null) {
// //             print(
// //               '⚠️ Service has no valid menu item ID: ${service.service?.title}',
// //             );
// //             return {};
// //           }

// //           final int? id = service.id;
// //           final int? orderId = currentEditOrder.value?.id;
// //           final int price =
// //               service.price ??
// //               (service.service?.price != null
// //                   ? int.tryParse(service.service!.price!) ?? 0
// //                   : 0);

// //           return {
// //             if (id != null) "id": id,
// //             if (orderId != null) "order_id": orderId,
// //             "menu_item_id": menuItemId,
// //             "price": price,
// //             "is_deleted": service.isDeleted ?? false,
// //           };
// //         })
// //         .where((item) => item.isNotEmpty)
// //         .toList();
// //   }

// //   // Helper method to get order packages for API - USES CURRENT STATE
// //   List<Map<dynamic, dynamic>> _getOrderPackagesForApi() {
// //     return currentOrderPackages
// //         .map((package) {
// //           final int? packageId = package.packageId ?? package.package?.id;
// //           if (packageId == null) {
// //             print('⚠️ Package has no package ID: ${package.package?.title}');
// //             return {};
// //           }

// //           final int? orderId = currentEditOrder.value?.id;
// //           final int? pkgId = package.id;

// //           // Convert package items
// //           final List<Map<String, dynamic>> packageItems = [];
// //           if (package.orderPackageItems != null) {
// //             for (var item in package.orderPackageItems!) {
// //               final int? menuItemId = item.menuItemId ?? item.menuItem?.id;
// //               if (menuItemId == null) {
// //                 print(
// //                   '⚠️ Package item has no valid menu item ID: ${item.menuItem?.title}',
// //                 );
// //                 continue;
// //               }

// //               final int? itemId = item.id;
// //               final int? orderPackageId = item.orderPackageId;
// //               final String priceStr =
// //                   item.price ?? (item.menuItem?.price ?? '0.0');
// //               final String qtyStr = item.noOfGust ?? '1';

// //               packageItems.add({
// //                 if (itemId != null) "id": itemId,
// //                 if (orderPackageId != null) "order_package_id": orderPackageId,
// //                 "menu_item_id": menuItemId,
// //                 "price": priceStr,
// //                 "no_of_gust": qtyStr,
// //                 "is_deleted": item.isDeleted ?? false,
// //               });
// //             }
// //           }

// //           return {
// //             if (pkgId != null) "id": pkgId,
// //             if (orderId != null) "order_id": orderId,
// //             "package_id": packageId,
// //             "amount":
// //                 package.amount ?? (package.package?.price?.toString() ?? "0.0"),
// //             "is_custom": package.isCustom ?? false,
// //             "order_package_items_attributes": packageItems,
// //           };
// //         })
// //         .where((item) => item.isNotEmpty)
// //         .toList();
// //   }

// //   // Clear current edit order
// //   void clearEditOrder() {
// //     currentEditOrder.value = null;
// //     currentOrderServices.clear();
// //     currentOrderPackages.clear();
// //     errorMessage.value = '';
// //   }

// //   // Getter for current order
// //   EditOrderModel? get editOrder => currentEditOrder.value;

// //   // Getter for current services and packages
// //   List<OrderServices> get services => currentOrderServices.toList();
// //   List<OrderPackages> get packages => currentOrderPackages.toList();

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
// //     if (currentOrderPackages.isEmpty) return '';
// //     return currentOrderPackages.first.package?.title ?? '';
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
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

// class EditController extends GetxController {
//   final Rx<EditOrderModel?> currentEditOrder = Rx<EditOrderModel?>(null);
//   final RxBool isLoading = false.obs;
//   final RxString errorMessage = ''.obs;

//   // Add these to track current state of services and packages
//   final RxList<OrderServices> currentOrderServices = <OrderServices>[].obs;
//   final RxList<OrderPackages> currentOrderPackages = <OrderPackages>[].obs;

//   // Persistence methods
//   static String _prefsKeyForOrder(String orderId) => 'edit_menu_$orderId';

//   Future<void> saveSelectionMenu(
//     String orderId,
//     Map<String, List<Map<String, dynamic>>> menu,
//   ) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final jsonStr = jsonEncode(menu);
//       await prefs.setString(_prefsKeyForOrder(orderId), jsonStr);
//       print('💾 Saved menu selection for order: $orderId');
//     } catch (e) {
//       print('❌ Error saving menu selection: $e');
//     }
//   }

//   Future<Map<String, List<Map<String, dynamic>>>?> _loadSelectionMenu(
//     String orderId,
//   ) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final jsonStr = prefs.getString(_prefsKeyForOrder(orderId));
//       if (jsonStr == null || jsonStr.isEmpty) return null;

//       final decoded = jsonDecode(jsonStr);
//       if (decoded is Map<String, dynamic>) {
//         final result = <String, List<Map<String, dynamic>>>{};
//         for (final entry in decoded.entries) {
//           final list = (entry.value as List)
//               .map((e) => Map<String, dynamic>.from(e as Map))
//               .toList();
//           result[entry.key] = list;
//         }
//         print('📂 Loaded saved menu selection for order: $orderId');
//         return result;
//       }
//     } catch (e) {
//       print('❌ Error loading saved menu selection: $e');
//     }
//     return null;
//   }

//   Future<void> _applySavedSelection(String orderId) async {
//     final saved = await _loadSelectionMenu(orderId);
//     if (saved == null) return;

//     // Build services from "Services"
//     final List<OrderServices> services = [];
//     for (final svc in (saved['Services'] ?? [])) {
//       final dynamic rawId = svc['menu_item_id'] ?? svc['id'];
//       final int? menuItemId = int.tryParse(rawId?.toString() ?? '');

//       services.add(
//         OrderServices(
//           menuItemId: menuItemId,
//           price:
//               int.tryParse(
//                 (svc['price'] is num)
//                     ? (svc['price'] as num).toString()
//                     : (svc['price']?.toString() ?? '0'),
//               ) ??
//               0,
//           isDeleted: false,
//           service: Service(
//             id: menuItemId,
//             title: svc['name']?.toString() ?? 'Service',
//             price: (svc['price'] is num)
//                 ? (svc['price'] as num).toString()
//                 : (svc['price']?.toString() ?? '0'),
//             description: '',
//           ),
//         ),
//       );
//     }

//     // Build one package with items from "Food Items"
//     final List<OrderPackageItems> items = [];
//     for (final food in (saved['Food Items'] ?? [])) {
//       final dynamic rawId = food['menu_item_id'] ?? food['id'];
//       final int? menuItemId = int.tryParse(rawId?.toString() ?? '');
//       final String qtyStr = (food['qty'] is int)
//           ? (food['qty'] as int).toString()
//           : (food['qty']?.toString() ?? '1');

//       items.add(
//         OrderPackageItems(
//           menuItemId: menuItemId,
//           price: (food['price'] is num)
//               ? (food['price'] as num).toString()
//               : (food['price']?.toString() ?? '0'),
//           noOfGust: qtyStr,
//           isDeleted: false,
//           menuItem: Service(
//             id: menuItemId,
//             title: food['name']?.toString() ?? 'Food Item',
//             price: (food['price'] is num)
//                 ? (food['price'] as num).toString()
//                 : (food['price']?.toString() ?? '0'),
//             description: '',
//           ),
//         ),
//       );
//     }

//     // Keep existing package meta if available, but replace items/amount
//     OrderPackages base = currentOrderPackages.isNotEmpty
//         ? currentOrderPackages.first
//         : OrderPackages(packageId: 1, amount: '0', isCustom: true);

//     final updatedPackage = OrderPackages(
//       id: base.id,
//       orderId: base.orderId,
//       packageId: base.packageId ?? 1,
//       amount: base.amount ?? '0',
//       isCustom: true,
//       package: base.package,
//       orderPackageItems: items,
//     );

//     currentOrderServices.value = services;
//     currentOrderPackages.value = [updatedPackage];

//     print(
//       '🔄 Applied saved selection: ${services.length} services, ${items.length} food items',
//     );
//   }

//   // Load order data by ID
//   Future<void> loadOrderById(String orderId) async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';

//       print('🔄 Loading order data for ID: $orderId');

//       final EditOrderModel? order = await ApiService.getOrderById(
//         orderId.toString(),
//       );

//       if (order != null) {
//         currentEditOrder.value = order;
//         // Initialize current lists with data from server
//         currentOrderServices.value = List.from(order.orderServices ?? []);
//         currentOrderPackages.value = List.from(order.orderPackages ?? []);

//         // Try to load any saved selection for this order
//         await _applySavedSelection(orderId);

//         print('✅ Order loaded successfully: ${order.id}');
//         print(
//           '📦 Loaded ${currentOrderServices.length} services and ${currentOrderPackages.length} packages',
//         );

//         // Debug print to see what we loaded
//         if (currentOrderPackages.isNotEmpty) {
//           print(
//             '📦 First package items: ${currentOrderPackages.first.orderPackageItems?.length ?? 0}',
//           );
//           if (currentOrderPackages.first.orderPackageItems != null) {
//             for (var item in currentOrderPackages.first.orderPackageItems!) {
//               print('   - ${item.menuItem?.title} (Qty: ${item.noOfGust})');
//             }
//           }
//         }
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

//   // NEW: Simplified updateOrder function following BookingController pattern
//   Future<bool> updateOrder({
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

//       // Get the updated services and packages for API
//       final orderServicesData = _getOrderServicesForApi();
//       final orderPackagesData = _getOrderPackagesForApi();

//       print('📦 Preparing update data for order: $orderId');
//       print('   - Event Date: $formattedEventDate');
//       print('   - Start Time: $formattedStartTime');
//       print('   - End Time: $formattedEndTime');
//       print('   - Guests: $noOfGust');
//       print('   - Services count: ${orderServicesData.length}');
//       print('   - Packages count: ${orderPackagesData.length}');

//       // Build the request body directly as Map (following BookingController pattern)
//       Map<String, dynamic> orderData = {
//         "order": {
//           "id": orderId,
//           "firstname": firstname,
//           "lastname": lastname,
//           "email": email,
//           "phone": phone,
//           "nin": nin,
//           "city_id": cityId,
//           "address": address,
//           "event_id": eventId,
//           "no_of_gust": noOfGust,
//           "event_date": formattedEventDate,
//           "event_time": formattedEventTime,
//           "start_time": formattedStartTime,
//           "end_time": formattedEndTime,
//           "requirement": requirement,
//           "is_inquiry": isInquiry,
//           "payment_method_id": paymentMethodId,
//           "order_services_attributes": orderServicesData,
//           "order_packages_attributes": orderPackagesData,
//         },
//       };

//       print('🔄 Sending PUT request to update order...');
//       print('📦 Request body: ${jsonEncode(orderData)}');

//       final response = await ApiService.updateOrder(
//         orderId: orderId,
//         EditOrderModel: orderData,
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

//   // Helper method to get order services for API - USES CURRENT STATE
//   List<Map<String, dynamic>> _getOrderServicesForApi() {
//     return currentOrderServices
//         .where((service) => service.isDeleted != true)
//         .map((service) {
//           final String? menuItemId = service.menuItemId?.toString();
//           if (menuItemId == null) {
//             print(
//               '⚠️ Service has no valid menu item ID: ${service.service?.title}',
//             );
//             return <String, dynamic>{};
//           }

//           final String? id = service.id?.toString();
//           final String? orderId = service.orderId?.toString();
//           final int price = service.price ?? 0;

//           return {
//             if (id != null && id.isNotEmpty) "id": id,
//             if (orderId != null && orderId.isNotEmpty) "order_id": orderId,
//             "menu_item_id": menuItemId,
//             "price": price,
//             "is_deleted": service.isDeleted ?? false,
//           };
//         })
//         .where((item) => item.isNotEmpty)
//         .toList();
//   }

//   // Helper method to get order packages for API - USES CURRENT STATE
//   List<Map<String, dynamic>> _getOrderPackagesForApi() {
//     return currentOrderPackages
//         .where((package) => package.isCustom != true)
//         .map((package) {
//           final String? packageId = package.packageId?.toString();
//           if (packageId == null) {
//             print('⚠️ Package has no package ID: ${package.package?.title}');
//             return <String, dynamic>{};
//           }

//           final String? orderId = package.orderId?.toString();
//           final String? pkgId = package.id?.toString();

//           // Convert package items
//           final List<Map<String, dynamic>> packageItems = [];
//           if (package.orderPackageItems != null) {
//             for (var item in package.orderPackageItems!) {
//               if (item.isDeleted == true) continue;

//               final String? menuItemId = item.menuItemId?.toString();
//               if (menuItemId == null) {
//                 print(
//                   '⚠️ Package item has no valid menu item ID: ${item.menuItem?.title}',
//                 );
//                 continue;
//               }

//               final String? itemId = item.id?.toString();
//               final String? orderPackageId = item.orderPackageId?.toString();
//               final String priceStr = item.price ?? '0';
//               final String qtyStr = item.noOfGust ?? '1';

//               packageItems.add({
//                 if (itemId != null && itemId.isNotEmpty) "id": itemId,
//                 if (orderPackageId != null && orderPackageId.isNotEmpty)
//                   "order_package_id": orderPackageId,
//                 "menu_item_id": menuItemId,
//                 "price": priceStr,
//                 "no_of_gust": qtyStr,
//                 "is_deleted": item.isDeleted ?? false,
//               });
//             }
//           }

//           return {
//             if (pkgId != null && pkgId.isNotEmpty) "id": pkgId,
//             if (orderId != null && orderId.isNotEmpty) "order_id": orderId,
//             "package_id": packageId,
//             "amount": package.amount ?? "0",
//             "is_custom": package.isCustom ?? false,
//             "order_package_items_attributes": packageItems,
//           };
//         })
//         .where((item) => item.isNotEmpty)
//         .toList();
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
//   List<OrderServices> get services => currentOrderServices.toList();
//   List<OrderPackages> get packages => currentOrderPackages.toList();

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
// EditController.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schedule_app/APIS/Api_Service.dart';
import 'package:schedule_app/pages/Edit/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditController extends GetxController {
  final Rx<EditOrderModel?> currentEditOrder = Rx<EditOrderModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Form controllers for Edit page
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final contactController = TextEditingController();
  final messageController = TextEditingController();
  final specialRequirementsController = TextEditingController();

  // Form data for Edit page
  final RxString selectedCity = ''.obs;
  final RxString selectedCityId = ''.obs;
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final Rx<TimeOfDay?> startTime = Rx<TimeOfDay?>(null);
  final Rx<TimeOfDay?> endTime = Rx<TimeOfDay?>(null);
  final RxInt guests = 1.obs;
  final RxString selectedEventType = ''.obs;
  final RxString selectedEventId = ''.obs;
  final RxString selectedPackage = ''.obs;
  final RxString selectedPackageId = ''.obs;

  // Menu data
  final RxList<OrderServices> currentOrderServices = <OrderServices>[].obs;
  final RxList<OrderPackages> currentOrderPackages = <OrderPackages>[].obs;

  // API Data for Edit page
  final RxList<Map<String, dynamic>> apiCities = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> apiEvents = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> apiPackages = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> apiMenuItems =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> apiServiceItems =
      <Map<String, dynamic>>[].obs;

  // Persistence
  static String _prefsKeyForOrder(String orderId) => 'edit_menu_$orderId';

  @override
  void onInit() {
    super.onInit();
    loadApiData();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    contactController.dispose();
    messageController.dispose();
    specialRequirementsController.dispose();
    super.onClose();
  }

  // Load API data for Edit page
  Future<void> loadApiData() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Load cities
      final citiesResult = await ApiService.getCities();
      if (citiesResult['success'] == true) {
        final citiesData = citiesResult['data'];
        if (citiesData is List) {
          apiCities.value = citiesData.cast<Map<String, dynamic>>();
        } else if (citiesData is Map && citiesData['cities'] is List) {
          apiCities.value = (citiesData['cities'] as List)
              .cast<Map<String, dynamic>>();
        }
      }

      // Load events
      final eventsResult = await ApiService.getEvents();
      if (eventsResult['success'] == true) {
        final eventsData = eventsResult['data'];
        if (eventsData is List) {
          apiEvents.value = eventsData.cast<Map<String, dynamic>>();
        } else if (eventsData is Map && eventsData['events'] is List) {
          apiEvents.value = (eventsData['events'] as List)
              .cast<Map<String, dynamic>>();
        }
      }

      // Load packages
      final packagesResult = await ApiService.getPackages();
      if (packagesResult['success'] == true) {
        final packagesData = packagesResult['data'];
        if (packagesData is List) {
          apiPackages.value = packagesData.cast<Map<String, dynamic>>();
        } else if (packagesData is Map && packagesData['packages'] is List) {
          apiPackages.value = (packagesData['packages'] as List)
              .cast<Map<String, dynamic>>();
        }
      }

      // Load menus
      final menusResult = await ApiService.getMenus();
      if (menusResult['success'] == true) {
        final menusData = menusResult['data'];
        if (menusData is List) {
          apiMenuItems.value = menusData.cast<Map<String, dynamic>>();
        }
      }

      // Load services
      final servicesResult = await ApiService.getServices();
      if (servicesResult['success'] == true) {
        final servicesData = servicesResult['data'];
        if (servicesData is List) {
          apiServiceItems.value = servicesData.cast<Map<String, dynamic>>();
        }
      }
    } catch (e) {
      errorMessage.value = 'Error loading data: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Get cities for dropdown
  List<String> get cities {
    return apiCities.map((city) {
      return city['name']?.toString() ??
          city['title']?.toString() ??
          'Unknown City';
    }).toList();
  }

  // Get event types for dropdown
  List<String> get eventTypes {
    return apiEvents.map((event) {
      return event['name']?.toString() ??
          event['title']?.toString() ??
          'Unknown Event';
    }).toList();
  }

  // Get packages for selection
  List<Map<String, dynamic>> get packages {
    return apiPackages.map((pkg) {
      return {
        'id': pkg['id']?.toString() ?? '',
        'title':
            pkg['name']?.toString() ??
            pkg['title']?.toString() ??
            'Unknown Package',
        'description': pkg['description']?.toString() ?? '',
        'price': pkg['price']?.toString() ?? pkg['amount']?.toString() ?? '0',
      };
    }).toList();
  }

  // Load order data by ID
  Future<void> loadOrderById(String orderId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final EditOrderModel? order = await ApiService.getOrderById(
        orderId.toString(),
      );

      if (order != null) {
        currentEditOrder.value = order;

        // Populate form data from order
        _populateFormFromOrder(order);

        // Initialize current lists with data from server
        currentOrderServices.value = List.from(order.orderServices ?? []);
        currentOrderPackages.value = List.from(order.orderPackages ?? []);

        print('✅ Order loaded successfully: ${order.id}');
      } else {
        errorMessage.value = 'Order not found';
      }
    } catch (e) {
      errorMessage.value = 'Failed to load order: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void _populateFormFromOrder(EditOrderModel order) {
    // Set personal information
    nameController.text = '${order.firstname ?? ''} ${order.lastname ?? ''}'
        .trim();
    emailController.text = order.email ?? '';
    contactController.text = order.phone ?? '';
    specialRequirementsController.text = order.requirement ?? '';

    // Set event details
    selectedEventType.value = order.event?.title ?? '';
    selectedEventId.value = order.eventId?.toString() ?? '';

    if (order.eventDate != null) {
      try {
        selectedDate.value = DateTime.parse(order.eventDate!);
      } catch (e) {
        print('Error parsing date: ${order.eventDate}');
      }
    }

    startTime.value = _parseTimeFromString(order.startTime);
    endTime.value = _parseTimeFromString(order.endTime);

    guests.value = int.tryParse(order.noOfGust ?? '1') ?? 1;

    // Set city
    if (order.city != null) {
      selectedCity.value = order.city!.name ?? '';
      selectedCityId.value = order.cityId?.toString() ?? '';
    }

    // Set package from first package
    if (order.orderPackages != null && order.orderPackages!.isNotEmpty) {
      final package = order.orderPackages!.first.package;
      if (package != null) {
        selectedPackage.value = package.title ?? '';
        selectedPackageId.value = package.id?.toString() ?? '';
      }
    }
  }

  TimeOfDay? _parseTimeFromString(String? timeString) {
    if (timeString == null) return null;
    try {
      final timePart = timeString.split('T')[1].substring(0, 5);
      final timeParts = timePart.split(':');
      if (timeParts.length >= 2) {
        final hour = int.parse(timeParts[0]);
        final minute = int.parse(timeParts[1]);
        return TimeOfDay(hour: hour, minute: minute);
      }
    } catch (e) {
      print('Error parsing time: $timeString');
    }
    return null;
  }

  // Replica of completeBooking logic from BookingController
  Future<bool> completeEdit() async {
    try {
      if (currentEditOrder.value == null) {
        errorMessage.value = 'No order data loaded';
        return false;
      }

      final orderId = currentEditOrder.value!.id!;

      // Get current menu structure from order services and packages
      final Map<String, List<Map<String, dynamic>>> currentMenu = {
        "Food Items": [],
        "Services": [],
      };

      // Process food items from packages
      if (currentOrderPackages.isNotEmpty) {
        for (var orderPackage in currentOrderPackages) {
          if (orderPackage.orderPackageItems != null) {
            for (var packageItem in orderPackage.orderPackageItems!) {
              if (packageItem.menuItem != null &&
                  !(packageItem.isDeleted ?? false)) {
                currentMenu["Food Items"]!.add({
                  "name": packageItem.menuItem!.title ?? "Unknown Item",
                  "price":
                      double.tryParse(packageItem.menuItem!.price ?? "0") ??
                      0.0,
                  "qty": int.tryParse(packageItem.noOfGust ?? "1") ?? 1,
                  "id": packageItem.menuItem!.id,
                  "menu_item_id": packageItem.menuItem!.id,
                });
              }
            }
          }
        }
      }

      // Process services
      for (var orderService in currentOrderServices) {
        if (orderService.service != null &&
            !(orderService.isDeleted ?? false)) {
          currentMenu["Services"]!.add({
            "name": orderService.service!.title ?? "Unknown Service",
            "price": double.tryParse(orderService.service!.price ?? "0") ?? 0.0,
            "qty": 1,
            "id": orderService.service!.id,
            "menu_item_id": orderService.service!.id,
          });
        }
      }

      // Prepare order services for API
      final orderServicesData = _getOrderServicesForApi();

      // Prepare order packages for API
      final orderPackagesData = _getOrderPackagesForApi();

      // Format dates and times for API
      String formatDateForApi(DateTime? date) {
        if (date == null) return '';
        return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      }

      String formatTimeForApi(TimeOfDay? time) {
        if (time == null) return '';
        return "2000-01-01T${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00.000Z";
      }

      // Prepare the complete order data matching API structure
      Map<String, dynamic> orderData = {
        "firstname": nameController.text.split(' ').first,
        "lastname": nameController.text.split(' ').length > 1
            ? nameController.text.split(' ').sublist(1).join(' ')
            : nameController.text,
        "email": emailController.text,
        "phone": contactController.text,
        "nin": "123456789", // You might want to make this dynamic
        "city_id": selectedCityId.value.isEmpty ? "1" : selectedCityId.value,
        "address": selectedCity.value,
        "event_id": selectedEventId.value.isEmpty ? "1" : selectedEventId.value,
        "no_of_gust": guests.value.toString(),
        "event_date": formatDateForApi(selectedDate.value),
        "event_time": formatTimeForApi(startTime.value),
        "start_time": formatTimeForApi(startTime.value),
        "end_time": formatTimeForApi(endTime.value),
        "requirement": specialRequirementsController.text.isEmpty
            ? "No special requirements"
            : specialRequirementsController.text,
        "payment_method_id": 1,
        "is_inquiry": currentEditOrder.value?.isInquiry ?? false,

        // Include order services if any
        if (orderServicesData.isNotEmpty)
          "order_services_attributes": orderServicesData,

        // Include order packages
        "order_packages_attributes": orderPackagesData,
      };

      print('Sending update order data: ${jsonEncode(orderData)}');

      // Send update to API
      final response = await ApiService.updateOrder(
        orderId: orderId,
        EditOrderModel: {
          "order": orderData,
        }, // Wrap in "order" if API requires it
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
    }
  }

  // Helper method to get order services for API
  List<Map<String, dynamic>> _getOrderServicesForApi() {
    return currentOrderServices
        .where((service) => service.isDeleted != true)
        .map((service) {
          final String? menuItemId = service.menuItemId?.toString();
          if (menuItemId == null) return <String, dynamic>{};

          final String? id = service.id?.toString();
          final int price = service.price ?? 0;

          return {
            if (id != null && id.isNotEmpty) "id": id,
            "menu_item_id": menuItemId,
            "price": price,
            "is_deleted": service.isDeleted ?? false,
          };
        })
        .where((item) => item.isNotEmpty)
        .toList();
  }

  // Helper method to get order packages for API
  List<Map<String, dynamic>> _getOrderPackagesForApi() {
    return currentOrderPackages
        .where((package) => package.isCustom != true)
        .map((package) {
          final String? packageId = package.packageId?.toString();
          if (packageId == null) return <String, dynamic>{};

          final String? pkgId = package.id?.toString();

          // Convert package items
          final List<Map<String, dynamic>> packageItems = [];
          if (package.orderPackageItems != null) {
            for (var item in package.orderPackageItems!) {
              if (item.isDeleted == true) continue;

              final String? menuItemId = item.menuItemId?.toString();
              if (menuItemId == null) continue;

              final String? itemId = item.id?.toString();
              final String priceStr = item.price ?? '0';
              final String qtyStr = item.noOfGust ?? '1';

              packageItems.add({
                if (itemId != null && itemId.isNotEmpty) "id": itemId,
                "menu_item_id": menuItemId,
                "price": priceStr,
                "no_of_gust": qtyStr,
                "is_deleted": item.isDeleted ?? false,
              });
            }
          }

          return {
            if (pkgId != null && pkgId.isNotEmpty) "id": pkgId,
            "package_id": packageId,
            "amount": package.amount ?? "0",
            "is_custom": package.isCustom ?? false,
            "order_package_items_attributes": packageItems,
          };
        })
        .where((item) => item.isNotEmpty)
        .toList();
  }

  // Form setters
  void setCity(String city) {
    selectedCity.value = city;
    final cityData = apiCities.firstWhere(
      (c) => (c['name']?.toString() ?? c['title']?.toString()) == city,
      orElse: () => {},
    );
    selectedCityId.value = cityData['id']?.toString() ?? '';
  }

  void setEventType(String eventType) {
    selectedEventType.value = eventType;
    final eventData = apiEvents.firstWhere(
      (e) => (e['name']?.toString() ?? e['title']?.toString()) == eventType,
      orElse: () => {},
    );
    selectedEventId.value = eventData['id']?.toString() ?? '';
  }

  void setPackage(String packageTitle) {
    selectedPackage.value = packageTitle;
    final packageData = packages.firstWhere(
      (p) => p['title'] == packageTitle,
      orElse: () => {},
    );
    selectedPackageId.value = packageData['id']?.toString() ?? '';
  }

  void setDate(DateTime date) => selectedDate.value = date;
  void setStartTime(TimeOfDay time) => startTime.value = time;
  void setEndTime(TimeOfDay time) => endTime.value = time;
  void setGuests(int count) => guests.value = count;
  void incrementGuests() => guests.value += 1;
  void decrementGuests() => guests.value = (guests.value - 1).clamp(1, 10000);

  // Helper methods
  List<String> splitName(String fullName) {
    final names = fullName.split(' ');
    if (names.length >= 2) {
      return [names[0], names.sublist(1).join(' ')];
    }
    return [fullName, ''];
  }

  // Clear current edit order
  void clearEditOrder() {
    currentEditOrder.value = null;
    currentOrderServices.clear();
    currentOrderPackages.clear();
    errorMessage.value = '';

    // Clear form
    nameController.clear();
    emailController.clear();
    contactController.clear();
    messageController.clear();
    specialRequirementsController.clear();
    selectedCity.value = '';
    selectedCityId.value = '';
    selectedDate.value = null;
    startTime.value = null;
    endTime.value = null;
    guests.value = 1;
    selectedEventType.value = '';
    selectedEventId.value = '';
    selectedPackage.value = '';
    selectedPackageId.value = '';
  }
}
