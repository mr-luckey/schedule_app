// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:schedule_app/APIS/Api_Service.dart';
// import 'package:schedule_app/pages/Edit/model.dart';
// import 'package:schedule_app/pages/Edit/edit_order_body.dart' as body;
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

//       if (orderPackagesData.isNotEmpty) {
//         final firstPackage = orderPackagesData.first;
//         final packageItems =
//             firstPackage['order_package_items_attributes'] ?? [];
//         print('   - Package items count: ${packageItems.length}');
//         for (var item in packageItems) {
//           print('     - ${item['menu_item_id']}: Qty ${item['no_of_gust']}');
//         }
//       }
//       print('🔄 OrderServicesData: ${orderServicesData}');

//       // Build request body using dedicated model
//       final bodyOrderServices = orderServicesData.map((m) {
//         print('🔄 m: ${m}');
//         print('🔄 Building OrderServices: ${m['id']}');
//         return body.OrderServices(
//           id: m['id']?.toString(),
//           orderId: m['order_id']?.toString(),
//           menuItemId: m['menu_item_id']?.toString(),
//           price: (m['price'] is num)
//               ? (m['price'] as num).toInt()
//               : int.tryParse(m['price']?.toString() ?? '0') ?? 0,
//           isDeleted: m['is_deleted'] ?? false,
//         );
//       }).toList();
//       print('🔄 bodyOrderServices: ${bodyOrderServices}');

//       final bodyOrderPackages = orderPackagesData.map((pkg) {
//         final itemsDyn = pkg['order_package_items_attributes'] ?? [];
//         final items = itemsDyn.map<body.OrderPackageItems>((it) {
//           return body.OrderPackageItems(
//             id: it['id']?.toString(),
//             orderPackageId: it['order_package_id']?.toString(),
//             menuItemId: it['menu_item_id']?.toString(),
//             price: it['price']?.toString(),
//             noOfGust: it['no_of_gust']?.toString(),
//             isDeleted: it['is_deleted'] ?? false,
//           );
//         }).toList();
//         print("Test: ${pkg['id']}");
//         return body.OrderPackages(
//           id: pkg['id']?.toString(),
//           orderId: pkg['order_id']?.toString(),
//           packageId: pkg['package_id']?.toString(),
//           amount: (pkg['amount'] ?? '0').toString(),
//           isCustom: pkg['is_custom'] ?? false,
//           orderPackageItems: items,
//         );
//       }).toList();

//       final bodyOrder = body.Order(
//         id: orderId.toString(),
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
//         orderServices: bodyOrderServices,
//         orderPackages: bodyOrderPackages,
//       );

//       final requestBody = body.EditOrderBody(order: bodyOrder).toJson();

//       print('🔄 Sending PUT request to update order...');

//       final response = await ApiService.updateOrder(
//         orderId: orderId,
//         EditOrderModel: requestBody,
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
//       print('❌ Error updating order:Controller Screen $e');
//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // Helper method to get order services for API - USES CURRENT STATE
//   List<Map<dynamic, dynamic>> _getOrderServicesForApi() {
//     return currentOrderServices
//         .map((service) {
//           final int? menuItemId = service.menuItemId ?? service.service?.id;
//           if (menuItemId == null) {
//             print(
//               '⚠️ Service has no valid menu item ID: ${service.service?.title}',
//             );
//             return {};
//           }

//           final int? id = service.id;
//           final int? orderId = currentEditOrder.value?.id;
//           final int price =
//               service.price ??
//               (service.service?.price != null
//                   ? int.tryParse(service.service!.price!) ?? 0
//                   : 0);

//           return {
//             if (id != null) "id": id,
//             if (orderId != null) "order_id": orderId,
//             "menu_item_id": menuItemId,
//             "price": price,
//             "is_deleted": service.isDeleted ?? false,
//           };
//         })
//         .where((item) => item.isNotEmpty)
//         .toList();
//   }

//   // Helper method to get order packages for API - USES CURRENT STATE
//   List<Map<dynamic, dynamic>> _getOrderPackagesForApi() {
//     return currentOrderPackages
//         .map((package) {
//           final int? packageId = package.packageId ?? package.package?.id;
//           if (packageId == null) {
//             print('⚠️ Package has no package ID: ${package.package?.title}');
//             return {};
//           }

//           final int? orderId = currentEditOrder.value?.id;
//           final int? pkgId = package.id;

//           // Convert package items
//           final List<Map<String, dynamic>> packageItems = [];
//           if (package.orderPackageItems != null) {
//             for (var item in package.orderPackageItems!) {
//               final int? menuItemId = item.menuItemId ?? item.menuItem?.id;
//               if (menuItemId == null) {
//                 print(
//                   '⚠️ Package item has no valid menu item ID: ${item.menuItem?.title}',
//                 );
//                 continue;
//               }

//               final int? itemId = item.id;
//               final int? orderPackageId = item.orderPackageId;
//               final String priceStr =
//                   item.price ?? (item.menuItem?.price ?? '0.0');
//               final String qtyStr = item.noOfGust ?? '1';

//               packageItems.add({
//                 if (itemId != null) "id": itemId,
//                 if (orderPackageId != null) "order_package_id": orderPackageId,
//                 "menu_item_id": menuItemId,
//                 "price": priceStr,
//                 "no_of_gust": qtyStr,
//                 "is_deleted": item.isDeleted ?? false,
//               });
//             }
//           }

//           return {
//             if (pkgId != null) "id": pkgId,
//             if (orderId != null) "order_id": orderId,
//             "package_id": packageId,
//             "amount":
//                 package.amount ?? (package.package?.price?.toString() ?? "0.0"),
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
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schedule_app/APIS/Api_Service.dart';
import 'package:schedule_app/pages/Edit/model.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class EditController extends GetxController {
  final Rx<EditOrderModel?> currentEditOrder = Rx<EditOrderModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Add these to track current state of services and packages
  final RxList<OrderServices> currentOrderServices = <OrderServices>[].obs;
  final RxList<OrderPackages> currentOrderPackages = <OrderPackages>[].obs;

  // Persistence methods
  static String _prefsKeyForOrder(String orderId) => 'edit_menu_$orderId';

  Future<void> saveSelectionMenu(
    String orderId,
    Map<String, List<Map<String, dynamic>>> menu,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = jsonEncode(menu);
      await prefs.setString(_prefsKeyForOrder(orderId), jsonStr);
      print('💾 Saved menu selection for order: $orderId');
    } catch (e) {
      print('❌ Error saving menu selection: $e');
    }
  }

  Future<Map<String, List<Map<String, dynamic>>>?> _loadSelectionMenu(
    String orderId,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_prefsKeyForOrder(orderId));
      if (jsonStr == null || jsonStr.isEmpty) return null;

      final decoded = jsonDecode(jsonStr);
      if (decoded is Map<String, dynamic>) {
        final result = <String, List<Map<String, dynamic>>>{};
        for (final entry in decoded.entries) {
          final list = (entry.value as List)
              .map((e) => Map<String, dynamic>.from(e as Map))
              .toList();
          result[entry.key] = list;
        }
        print('📂 Loaded saved menu selection for order: $orderId');
        return result;
      }
    } catch (e) {
      print('❌ Error loading saved menu selection: $e');
    }
    return null;
  }

  Future<void> _applySavedSelection(String orderId) async {
    final saved = await _loadSelectionMenu(orderId);
    if (saved == null) return;

    // Build services from "Services"
    final List<OrderServices> services = [];
    for (final svc in (saved['Services'] ?? [])) {
      final dynamic rawId = svc['menu_item_id'] ?? svc['id'];
      final int? menuItemId = int.tryParse(rawId?.toString() ?? '');

      services.add(
        OrderServices(
          menuItemId: menuItemId,
          price:
              int.tryParse(
                (svc['price'] is num)
                    ? (svc['price'] as num).toString()
                    : (svc['price']?.toString() ?? '0'),
              ) ??
              0,
          isDeleted: false,
          service: Service(
            id: menuItemId,
            title: svc['name']?.toString() ?? 'Service',
            price: (svc['price'] is num)
                ? (svc['price'] as num).toString()
                : (svc['price']?.toString() ?? '0'),
            description: '',
          ),
        ),
      );
    }

    // Build one package with items from "Food Items"
    final List<OrderPackageItems> items = [];
    for (final food in (saved['Food Items'] ?? [])) {
      final dynamic rawId = food['menu_item_id'] ?? food['id'];
      final int? menuItemId = int.tryParse(rawId?.toString() ?? '');
      final String qtyStr = (food['qty'] is int)
          ? (food['qty'] as int).toString()
          : (food['qty']?.toString() ?? '1');

      items.add(
        OrderPackageItems(
          menuItemId: menuItemId,
          price: (food['price'] is num)
              ? (food['price'] as num).toString()
              : (food['price']?.toString() ?? '0'),
          noOfGust: qtyStr,
          isDeleted: false,
          menuItem: Service(
            id: menuItemId,
            title: food['name']?.toString() ?? 'Food Item',
            price: (food['price'] is num)
                ? (food['price'] as num).toString()
                : (food['price']?.toString() ?? '0'),
            description: '',
          ),
        ),
      );
    }

    // Keep existing package meta if available, but replace items/amount
    OrderPackages base = currentOrderPackages.isNotEmpty
        ? currentOrderPackages.first
        : OrderPackages(packageId: 1, amount: '0', isCustom: true);

    final updatedPackage = OrderPackages(
      id: base.id,
      orderId: base.orderId,
      packageId: base.packageId ?? 1,
      amount: base.amount ?? '0',
      isCustom: true,
      package: base.package,
      orderPackageItems: items,
    );

    currentOrderServices.value = services;
    currentOrderPackages.value = [updatedPackage];

    print(
      '🔄 Applied saved selection: ${services.length} services, ${items.length} food items',
    );
  }

  // Load order data by ID
  Future<void> loadOrderById(String orderId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('🔄 Loading order data for ID: $orderId');

      final EditOrderModel? order = await ApiService.getOrderById(
        orderId.toString(),
      );

      if (order != null) {
        currentEditOrder.value = order;
        // Initialize current lists with data from server
        currentOrderServices.value = List.from(order.orderServices ?? []);
        currentOrderPackages.value = List.from(order.orderPackages ?? []);

        // Try to load any saved selection for this order
        await _applySavedSelection(orderId);

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

  // NEW: Simplified updateOrder function following BookingController pattern
  Future<bool> updateOrder({
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

      // Build the request body directly as Map (following BookingController pattern)
      Map<String, dynamic> orderData = {
        "order": {
          "id": orderId,
          "firstname": firstname,
          "lastname": lastname,
          "email": email,
          "phone": phone,
          "nin": nin,
          "city_id": cityId,
          "address": address,
          "event_id": eventId,
          "no_of_gust": noOfGust,
          "event_date": formattedEventDate,
          "event_time": formattedEventTime,
          "start_time": formattedStartTime,
          "end_time": formattedEndTime,
          "requirement": requirement,
          "is_inquiry": isInquiry,
          "payment_method_id": paymentMethodId,
          "order_services_attributes": orderServicesData,
          "order_packages_attributes": orderPackagesData,
        },
      };

      print('🔄 Sending PUT request to update order...');
      print('📦 Request body: ${jsonEncode(orderData)}');

      final response = await ApiService.updateOrder(
        orderId: orderId,
        EditOrderModel: orderData,
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
  List<Map<String, dynamic>> _getOrderServicesForApi() {
    return currentOrderServices
        .where((service) => service.isDeleted != true)
        .map((service) {
          final String? menuItemId = service.menuItemId?.toString();
          if (menuItemId == null) {
            print(
              '⚠️ Service has no valid menu item ID: ${service.service?.title}',
            );
            return <String, dynamic>{};
          }

          final String? id = service.id?.toString();
          final String? orderId = service.orderId?.toString();
          final int price = service.price ?? 0;

          return {
            if (id != null && id.isNotEmpty) "id": id,
            if (orderId != null && orderId.isNotEmpty) "order_id": orderId,
            "menu_item_id": menuItemId,
            "price": price,
            "is_deleted": service.isDeleted ?? false,
          };
        })
        .where((item) => item.isNotEmpty)
        .toList();
  }

  // Helper method to get order packages for API - USES CURRENT STATE
  List<Map<String, dynamic>> _getOrderPackagesForApi() {
    return currentOrderPackages
        .where((package) => package.isCustom != true)
        .map((package) {
          final String? packageId = package.packageId?.toString();
          if (packageId == null) {
            print('⚠️ Package has no package ID: ${package.package?.title}');
            return <String, dynamic>{};
          }

          final String? orderId = package.orderId?.toString();
          final String? pkgId = package.id?.toString();

          // Convert package items
          final List<Map<String, dynamic>> packageItems = [];
          if (package.orderPackageItems != null) {
            for (var item in package.orderPackageItems!) {
              if (item.isDeleted == true) continue;

              final String? menuItemId = item.menuItemId?.toString();
              if (menuItemId == null) {
                print(
                  '⚠️ Package item has no valid menu item ID: ${item.menuItem?.title}',
                );
                continue;
              }

              final String? itemId = item.id?.toString();
              final String? orderPackageId = item.orderPackageId?.toString();
              final String priceStr = item.price ?? '0';
              final String qtyStr = item.noOfGust ?? '1';

              packageItems.add({
                if (itemId != null && itemId.isNotEmpty) "id": itemId,
                if (orderPackageId != null && orderPackageId.isNotEmpty)
                  "order_package_id": orderPackageId,
                "menu_item_id": menuItemId,
                "price": priceStr,
                "no_of_gust": qtyStr,
                "is_deleted": item.isDeleted ?? false,
              });
            }
          }

          return {
            if (pkgId != null && pkgId.isNotEmpty) "id": pkgId,
            if (orderId != null && orderId.isNotEmpty) "order_id": orderId,
            "package_id": packageId,
            "amount": package.amount ?? "0",
            "is_custom": package.isCustom ?? false,
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
  List<OrderServices> get services => currentOrderServices.toList();
  List<OrderPackages> get packages => currentOrderPackages.toList();

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
