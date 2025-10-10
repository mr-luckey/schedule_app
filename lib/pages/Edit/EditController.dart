// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:schedule_app/APIS/Api_Service.dart';
// import 'package:schedule_app/pages/Edit/models/EditModel.dart';
// import 'package:schedule_app/pages/Edit/models/MenuItem.dart' hide MenuItem;
// import 'package:schedule_app/pages/Edit/models/model.dart';
// // import 'package:shared_preferences/shared_preferences.dart';

// class EditController extends GetxController {
//   // ===========================================================================
//   // SECTION 1: REACTIVE STATE VARIABLES
//   // ===========================================================================

//   // Current order being edited
//   final Rx<EditOrderModel?> currentEditOrder = Rx<EditOrderModel?>(null);
//   final RxBool isLoading = false.obs;
//   final RxString errorMessage = ''.obs;

//   // Form controllers
//   final nameController = TextEditingController();
//   final emailController = TextEditingController();
//   final contactController = TextEditingController();
//   final messageController = TextEditingController();
//   final specialRequirementsController = TextEditingController();

//   // Form reactive data
//   final RxString selectedCity = ''.obs;
//   final RxString selectedCityId = ''.obs;
//   final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
//   final Rx<TimeOfDay?> startTime = Rx<TimeOfDay?>(null);
//   final Rx<TimeOfDay?> endTime = Rx<TimeOfDay?>(null);
//   final RxInt guests = 1.obs;
//   final RxString selectedEventType = ''.obs;
//   final RxString selectedEventId = ''.obs;
//   final RxString selectedPackage = ''.obs;
//   final RxString selectedPackageId = ''.obs;

//   // Current order data from API
//   final RxList<OrderServices> currentOrderServices = <OrderServices>[].obs;
//   final RxList<OrderPackages> currentOrderPackages = <OrderPackages>[].obs;

//   // API Data collections
//   final RxList<City> apiCities = <City>[].obs;
//   final RxList<Event> apiEvents = <Event>[].obs;
//   final RxList<Package> apiPackages = <Package>[].obs;

//   // UPDATED: Menu data with categories
//   final RxList<MenuCategory> apiMenuCategories = <MenuCategory>[].obs;

//   // Services remain the same
//   final RxList<ServiceMode> apiServiceItems = <ServiceMode>[].obs;

//   // Selected items for UI
//   final RxList<SelectedMenuItem> selectedMenuItems = <SelectedMenuItem>[].obs;
//   final RxList<SelectedServiceItem> selectedServiceItems =
//       <SelectedServiceItem>[].obs;

//   // Edit mode flags
//   final RxBool isEditingItems = false.obs;
//   final RxBool isCustomEditing = false.obs;

//   // ===========================================================================
//   // SECTION 2: LIFECYCLE METHODS
//   // ===========================================================================

//   @override
//   void onInit() {
//     super.onInit();
//     loadApiData();
//     // _loadServiceItems();
//   }

//   @override
//   void onClose() {
//     // Dispose all text controllers
//     nameController.dispose();
//     emailController.dispose();
//     contactController.dispose();
//     messageController.dispose();
//     specialRequirementsController.dispose();
//     super.onClose();
//   }

//   // ===========================================================================
//   // SECTION 3: API DATA LOADING METHODS
//   // ===========================================================================

//   /// Loads all required API data for the edit page
//   Future<void> loadApiData() async {
//     isLoading.value = true;
//     errorMessage.value = '';

//     try {
//       await _loadCities();
//       await _loadEvents();
//       await _loadPackages();
//       await _loadMenuCategories(); // UPDATED: Load menu categories
//       await loadServiceItems();
//     } catch (e) {
//       errorMessage.value = 'Error loading data: $e';
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   /// Load cities from API
//   Future<void> _loadCities() async {
//     final citiesResult = await ApiService.getCities();
//     if (citiesResult['success'] == true) {
//       final citiesData = citiesResult['data'];
//       if (citiesData is List) {
//         apiCities.value = citiesData
//             .map((cityJson) => City.fromJson(cityJson))
//             .toList();
//       } else if (citiesData is Map && citiesData['cities'] is List) {
//         apiCities.value = (citiesData['cities'] as List)
//             .map((cityJson) => City.fromJson(cityJson))
//             .toList();
//       }
//     }
//   }

//   /// Load events from API
//   Future<void> _loadEvents() async {
//     final eventsResult = await ApiService.getEvents();
//     if (eventsResult['success'] == true) {
//       final eventsData = eventsResult['data'];
//       if (eventsData is List) {
//         apiEvents.value = eventsData
//             .map((eventJson) => Event.fromJson(eventJson))
//             .toList();
//       } else if (eventsData is Map && eventsData['events'] is List) {
//         apiEvents.value = (eventsData['events'] as List)
//             .map((eventJson) => Event.fromJson(eventJson))
//             .toList();
//       }
//     }
//   }

//   /// Load packages from API
//   Future<void> _loadPackages() async {
//     final packagesResult = await ApiService.getPackages();
//     if (packagesResult['success'] == true) {
//       final packagesData = packagesResult['data'];
//       if (packagesData is List) {
//         apiPackages.value = packagesData
//             .map((pkgJson) => Package.fromJson(pkgJson))
//             .toList();
//       } else if (packagesData is Map && packagesData['packages'] is List) {
//         apiPackages.value = (packagesData['packages'] as List)
//             .map((pkgJson) => Package.fromJson(pkgJson))
//             .toList();
//       }
//     }
//   }

//   /// UPDATED: Load menu categories with items from API
//   Future<void> _loadMenuCategories() async {
//     final menusResult = await ApiService.getMenus();
//     if (menusResult['success'] == true) {
//       final menusData = menusResult['data'];
//       if (menusData is List) {
//         apiMenuCategories.value = menusData
//             .map((categoryJson) => MenuCategory.fromJson(categoryJson))
//             .toList();
//       }
//     }
//   }

//   /// Load service items from API

//   ///
//   // Future<List<MenuItem>> _loadServiceItems() async {
//   //   final servicesResult = await ApiService.getServices();
//   final isLoadingServices = false.obs;
//   void _loadServiceItemsFallback(Map<String, dynamic> servicesResult) {
//     try {
//       final List<ServiceMode> fallbackServices = [];
//       final dynamic raw = servicesResult['data'];
//       final List<dynamic> serviceList = raw is List
//           ? List<dynamic>.from(raw)
//           : (raw is Map && raw['data'] is List)
//           ? List<dynamic>.from(raw['data'] as List)
//           : [];

//       for (var svc in serviceList) {
//         try {
//           final Map<String, dynamic> svcMap = Map<String, dynamic>.from(svc);
//           final service = ServiceMode.fromJson(svcMap);
//           fallbackServices.add(service);
//         } catch (inner) {
//           print('Skipping a service due to parse error: $inner');
//         }
//       }

//       apiServiceItems.assignAll(fallbackServices);
//     } catch (e) {
//       print('Fallback parsing also failed: $e');
//     }
//   }

//   // Method to load service items
//   Future<void> loadServiceItems() async {
//     try {
//       isLoadingServices(true);
//       final servicesResult = await ApiService.getServices();

//       if (servicesResult['success'] != true) {
//         print('Failed to load services: ${servicesResult['message']}');
//         return;
//       }

//       final dynamic raw = servicesResult['data'];
//       final List<dynamic> serviceList = raw is List
//           ? List<dynamic>.from(raw)
//           : (raw is Map && raw['data'] is List)
//           ? List<dynamic>.from(raw['data'] as List)
//           : [];

//       // Map to ServiceMode
//       final List<ServiceMode> serviceItems = serviceList
//           .map((e) => ServiceMode.fromJson(Map<String, dynamic>.from(e)))
//           .toList();

//       apiServiceItems.assignAll(serviceItems);

//       // Print loaded services for debugging
//       for (var service in serviceItems) {
//         print(
//           'Service: ${service.title}, Menu Items: ${service.menuItems?.length ?? 0}',
//         );
//       }
//       return apiServiceItems.assignAll(serviceItems);
//     } catch (e, st) {
//       print('Error loading services: $e\n$st');
//       // Fallback parsing if needed
//       _loadServiceItemsFallback(apiServiceItems as Map<String, dynamic>);
//     } finally {
//       isLoadingServices(false);
//     }
//   }

//   // ===========================================================================
//   // SECTION 4: DATA GETTERS FOR UI
//   // ===========================================================================

//   /// Get cities for dropdown
//   List<String> get cities {
//     return apiCities.map((city) => city.name ?? 'Unknown City').toList();
//   }

//   /// Get event types for dropdown
//   List<String> get eventTypes {
//     return apiEvents.map((event) => event.title ?? 'Unknown Event').toList();
//   }

//   /// Get packages for selection in UI format
//   List<Package> get packages => apiPackages.toList();

//   /// NEW: Get all menu items as a flat list (for backward compatibility)
//   List get allMenuItems {
//     return apiMenuCategories
//         .expand((category) => category.menuItems ?? [])
//         .toList();
//   }

//   /// NEW: Get menu categories for grouped display
//   List<MenuCategory> get menuCategories => apiMenuCategories.toList();

//   // ===========================================================================
//   // SECTION 5: ORDER LOADING AND POPULATION
//   // ===========================================================================

//   /// Load order data by ID for editing
//   Future<void> loadOrderById(String orderId) async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';

//       final EditOrderModel? order = await ApiService.getOrderById(
//         orderId.toString(),
//       );

//       if (order != null) {
//         currentEditOrder.value = order;
//         _populateFormFromOrder(order);

//         // Initialize current lists with data from server
//         currentOrderServices.value = List.from(order.orderServices ?? []);
//         currentOrderPackages.value = List.from(order.orderPackages ?? []);

//         // Build selected lists for UI
//         _buildSelectedListsFromCurrentOrder();

//         print('✅ Order loaded successfully: ${order.id}');
//       } else {
//         errorMessage.value = 'Order not found';
//       }
//     } catch (e) {
//       errorMessage.value = 'Failed to load order: $e';
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   /// Populate form fields from order model
//   void _populateFormFromOrder(EditOrderModel order) {
//     // Personal information
//     nameController.text = '${order.firstname ?? ''} ${order.lastname ?? ''}'
//         .trim();
//     emailController.text = order.email ?? '';
//     contactController.text = order.phone ?? '';
//     specialRequirementsController.text = order.requirement ?? '';

//     // Event details
//     selectedEventType.value = order.event?.title ?? '';
//     selectedEventId.value = order.eventId?.toString() ?? '';

//     // Date and time
//     if (order.eventDate != null && order.eventDate!.isNotEmpty) {
//       try {
//         selectedDate.value = DateTime.parse(order.eventDate!);
//       } catch (e) {
//         print('Error parsing date: ${order.eventDate}');
//       }
//     } else {
//       selectedDate.value = null;
//     }

//     startTime.value = _parseTimeFromString(order.startTime);
//     endTime.value = _parseTimeFromString(order.endTime);

//     guests.value = int.tryParse(order.noOfGust ?? '1') ?? 1;

//     // City
//     if (order.city != null) {
//       selectedCity.value = order.city!.name ?? '';
//       selectedCityId.value = order.cityId?.toString() ?? '';
//     } else {
//       selectedCity.value = '';
//       selectedCityId.value = '';
//     }

//     // Package
//     if (order.orderPackages != null && order.orderPackages!.isNotEmpty) {
//       final package = order.orderPackages!.first.package;
//       if (package != null) {
//         selectedPackage.value = package.title ?? '';
//         selectedPackageId.value = package.id?.toString() ?? '';
//       }
//     } else {
//       selectedPackage.value = '';
//       selectedPackageId.value = '';
//     }
//   }

//   /// Parse time string to TimeOfDay
//   TimeOfDay? _parseTimeFromString(String? timeString) {
//     if (timeString == null || timeString.isEmpty) return null;
//     try {
//       final timePart = timeString.split('T')[1].substring(0, 5);
//       final timeParts = timePart.split(':');
//       if (timeParts.length >= 2) {
//         final hour = int.parse(timeParts[0]);
//         final minute = int.parse(timeParts[1]);
//         return TimeOfDay(hour: hour, minute: minute);
//       }
//     } catch (e) {
//       print('Error parsing time: $timeString');
//     }
//     return null;
//   }

//   // ===========================================================================
//   // SECTION 6: SELECTED ITEMS MANAGEMENT
//   // ===========================================================================

//   /// Build selected lists from current order data
//   // void _buildSelectedListsFromCurrentOrder() {
//   //   selectedMenuItems.clear();
//   //   selectedServiceItems.clear();

//   //   // Build food items from packages (exclude service items)
//   //   for (var orderPackage in currentOrderPackages) {
//   //     if (orderPackage.orderPackageItems != null) {
//   //       for (var packageItem in orderPackage.orderPackageItems!) {
//   //         if (packageItem.menuItem != null &&
//   //             !(packageItem.isDeleted ?? false)) {
//   //           // Check if this is a service item by looking at the service items list
//   //           // If it exists in services, it's a service item, not a food item
//   //           bool isServiceItem = currentOrderServices.any(
//   //             (service) => service.service?.id == packageItem.menuItem?.id,
//   //           );

//   //           if (!isServiceItem) {
//   //             selectedMenuItems.add(
//   //               SelectedMenuItem(
//   //                 menuItemId: packageItem.menuItem!.id,
//   //                 name: packageItem.menuItem!.title ?? '',
//   //                 price: packageItem.menuItem!.price ?? '0',
//   //                 qty: int.tryParse(packageItem.noOfGust ?? '1') ?? 1,
//   //                 id: packageItem.id,
//   //                 isDeleted: packageItem.isDeleted ?? false,
//   //               ),
//   //             );
//   //           }
//   //         }
//   //       }
//   //     }
//   //   }

//   //   // Build services
//   //   for (var orderService in currentOrderServices) {
//   //     if (orderService.service != null && !(orderService.isDeleted ?? false)) {
//   //       selectedServiceItems.add(
//   //         SelectedServiceItem(
//   //           serviceId: orderService.service!.id,
//   //           title: orderService.service!.title ?? '',
//   //           price: orderService.service!.price ?? '0',
//   //           qty: 1,
//   //           id: orderService.id,
//   //           isDeleted: orderService.isDeleted ?? false,
//   //         ),
//   //       );
//   //     }
//   //   }
//   // }

//   /// Add menu item to selection
//   void addSelectedMenuItem({
//     required int? menuItemId,
//     required String name,
//     required String price,
//     int qty = 1,
//     int? id,
//   }) {
//     final exists = selectedMenuItems.any((m) => m.menuItemId == menuItemId);
//     if (!exists) {
//       selectedMenuItems.add(
//         SelectedMenuItem(
//           menuItemId: menuItemId,
//           name: name,
//           price: price,
//           qty: qty,
//           id: id,
//           isDeleted: false,
//         ),
//       );
//     }
//   }

//   /// Remove menu item from selection
//   void removeSelectedMenuItemByMenuItemId(int? menuItemId) {
//     selectedMenuItems.removeWhere((m) => m.menuItemId == menuItemId);
//   }

//   /// Clear all selected menu items
//   void clearSelectedMenuItems() => selectedMenuItems.clear();

//   /// Add service item to selection
//   void addSelectedServiceItem({
//     required int? serviceId,
//     required String title,
//     required String price,
//     int qty = 1,
//     int? id,
//   }) {
//     final exists = selectedServiceItems.any((s) => s.serviceId == serviceId);
//     if (!exists) {
//       selectedServiceItems.add(
//         SelectedServiceItem(
//           serviceId: serviceId,
//           title: title,
//           price: price,
//           qty: qty,
//           id: id,
//           isDeleted: false,
//         ),
//       );
//     }
//   }

//   /// Remove service item from selection
//   void removeSelectedServiceItemById(int? serviceId) {
//     selectedServiceItems.removeWhere((s) => s.serviceId == serviceId);
//   }

//   /// Clear all selected service items
//   void clearSelectedServiceItems() => selectedServiceItems.clear();

//   // ===========================================================================
//   // SECTION 7: ORDER UPDATE AND API COMMUNICATION
//   // ===========================================================================

//   /// Complete the edit process and update order via API
//   Future<bool> completeEdit() async {
//     try {
//       // Debug: snapshot incoming editable state
//       _debugPrintState('START completeEdit');
//       if (currentEditOrder.value == null) {
//         errorMessage.value = 'No order data loaded';
//         return false;
//       }

//       final orderId = currentEditOrder.value!.id!;
//       isLoading.value = true;
//       errorMessage.value = '';

//       // Update the model instance with form data
//       final updatedOrder = _prepareOrderForUpdate();

//       // Prepare API payload
//       final body = _prepareApiPayload(updatedOrder);

//       // Debug: outgoing payload
//       print('=== DEBUG: OUTGOING UPDATE PAYLOAD (order) ===');
//       try {
//         print(jsonEncode(body));
//       } catch (_) {}
//       print('Sending update order data: ${jsonEncode(body)}');

//       // Call API to update order
//       final response = await ApiService.updateOrder(
//         orderId: orderId,
//         EditOrderModel: body,
//       );

//       // Debug: response snapshot
//       print('=== DEBUG: UPDATE RESPONSE ===');
//       print(response);

//       if (response['success'] == true) {
//         print('✅ Order updated successfully');
//         // Reload to reflect server-side changes
//         await loadOrderById(orderId.toString());
//         _debugPrintState('AFTER reload - server state reloaded');
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

//   /// Prepare order model with updated form data
//   EditOrderModel _prepareOrderForUpdate() {
//     final order = currentEditOrder.value!;

//     // Name handling
//     final nameParts = splitName(nameController.text.trim());
//     order.firstname = nameParts[0];
//     order.lastname = nameParts[1];

//     // Contact information
//     order.email = emailController.text;
//     order.phone = contactController.text;
//     order.nin = order.nin ?? "123456789";

//     // Location and event
//     order.cityId = int.tryParse(selectedCityId.value) ?? order.cityId ?? 1;
//     order.address = selectedCity.value;
//     order.eventId = int.tryParse(selectedEventId.value) ?? order.eventId ?? 1;

//     // Event details
//     order.noOfGust = guests.value.toString();
//     order.requirement = specialRequirementsController.text.isEmpty
//         ? "No special requirements"
//         : specialRequirementsController.text;

//     // Date and time formatting
//     order.eventDate = _formatDateForApi(selectedDate.value);
//     order.eventTime = _formatTimeForApi(startTime.value);
//     order.startTime = _formatTimeForApi(startTime.value);
//     order.endTime = _formatTimeForApi(endTime.value);

//     // System fields
//     order.paymentMethodId = 1;
//     order.isInquiry = order.isInquiry ?? false;

//     // Debug: show the prepared order fields
//     print('=== DEBUG: _prepareOrderForUpdate ===');
//     print('firstname=' + (order.firstname ?? 'null'));
//     print('lastname=' + (order.lastname ?? 'null'));
//     print('email=' + (order.email ?? 'null'));
//     print('phone=' + (order.phone ?? 'null'));
//     print('cityId=' + (order.cityId?.toString() ?? 'null'));
//     print('address=' + (order.address ?? 'null'));
//     print('eventId=' + (order.eventId?.toString() ?? 'null'));
//     print('noOfGust=' + (order.noOfGust ?? 'null'));
//     print('requirement=' + (order.requirement ?? 'null'));
//     print('eventDate=' + (order.eventDate ?? 'null'));
//     print('startTime=' + (order.startTime ?? 'null'));
//     print('endTime=' + (order.endTime ?? 'null'));

//     return order;
//   }

//   /// Prepare API payload with order data and selected items
//   Map<String, dynamic> _prepareApiPayload(EditOrderModel order) {
//     final orderJson = order.toJson();

//     // Convert selected items to API format
//     orderJson['order_services_attributes'] = _getOrderServicesForApi();
//     orderJson['order_packages_attributes'] = _getOrderPackagesForApi();

//     // Debug: nested attributes preview
//     print('=== DEBUG: order_services_attributes ===');
//     try {
//       print(jsonEncode(orderJson['order_services_attributes']));
//     } catch (_) {}
//     print('=== DEBUG: order_packages_attributes ===');
//     try {
//       print(jsonEncode(orderJson['order_packages_attributes']));
//     } catch (_) {}

//     return {"order": orderJson};
//   }

//   void _debugPrintState(String stage) {
//     print('=== DEBUG: $stage ===');
//     print(
//       'currentEditOrder.id=' +
//           (currentEditOrder.value?.id?.toString() ?? 'null'),
//     );
//     print(
//       'name=' +
//           nameController.text +
//           ', email=' +
//           emailController.text +
//           ', phone=' +
//           contactController.text,
//     );
//     print('city=' + selectedCity.value + ' (id=' + selectedCityId.value + ')');
//     print(
//       'event=' +
//           selectedEventType.value +
//           ' (id=' +
//           selectedEventId.value +
//           ')',
//     );
//     print('date=' + (selectedDate.value?.toIso8601String() ?? 'null'));
//     try {
//       final ctx = Get.context ?? Get.overlayContext;
//       final st = startTime.value?.format(ctx!) ?? 'null';
//       final et = endTime.value?.format(ctx!) ?? 'null';
//       print('startTime=' + st + ', endTime=' + et);
//     } catch (_) {}
//     print('guests=' + guests.value.toString());
//     print(
//       'selectedPackage=' +
//           selectedPackage.value +
//           ' (id=' +
//           selectedPackageId.value +
//           ')',
//     );
//     print('selectedMenuItems.count=' + selectedMenuItems.length.toString());
//     for (final m in selectedMenuItems) {
//       print(
//         '  MENU id=' +
//             (m.menuItemId?.toString() ?? 'null') +
//             ' name=' +
//             m.name +
//             ' price=' +
//             m.price +
//             ' qty=' +
//             m.qty.toString(),
//       );
//     }
//     print(
//       'selectedServiceItems.count=' + selectedServiceItems.length.toString(),
//     );
//     for (final s in selectedServiceItems) {
//       print(
//         '  SERVICE id=' +
//             (s.serviceId?.toString() ?? 'null') +
//             ' title=' +
//             s.title +
//             ' price=' +
//             s.price +
//             ' qty=' +
//             s.qty.toString(),
//       );
//     }
//   }

//   /// Format date for API
//   String _formatDateForApi(DateTime? date) {
//     if (date == null) return '';
//     return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
//   }

//   /// Format time for API
//   String _formatTimeForApi(TimeOfDay? time) {
//     if (time == null) return '';
//     return "2000-01-01T${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00.000Z";
//   }

//   /// Build order_services_attributes from selected services, including deletions
//   List<Map<String, dynamic>> _getOrderServicesForApi() {
//     final List<Map<String, dynamic>> results = [];

//     // Index current services by menu_item_id for quick lookup
//     final Map<String, OrderServices> existingByMenuItemId = {
//       for (final svc in currentOrderServices)
//         if (svc.menuItemId != null) svc.menuItemId!.toString(): svc,
//     };

//     // Add/Update selected services
//     final Set<String> selectedIds = {};
//     for (final sel in selectedServiceItems) {
//       final key = (sel.serviceId?.toString() ?? '');
//       if (key.isEmpty) continue;
//       selectedIds.add(key);
//       final existing = existingByMenuItemId[key];
//       results.add({
//         if (existing?.id != null) "id": existing!.id,
//         "menu_item_id": key,
//         "price": sel.price,
//         "qty": sel.qty,
//         "is_deleted": false,
//       });
//     }

//     // Mark deletions for services that existed but are no longer selected
//     for (final entry in existingByMenuItemId.entries) {
//       if (!selectedIds.contains(entry.key)) {
//         final svc = entry.value;
//         results.add({
//           if (svc.id != null) "id": svc.id,
//           "menu_item_id": entry.key,
//           "price": (svc.price ?? '0').toString(),
//           "qty": 1,
//           "is_deleted": true,
//         });
//       }
//     }

//     return results;
//   }

//   /// Build order_packages_attributes using selected menu items for the existing package, including deletions
//   List<Map<String, dynamic>> _getOrderPackagesForApi() {
//     if (currentOrderPackages.isEmpty) return <Map<String, dynamic>>[];
//     final pkg = currentOrderPackages.first;
//     if (pkg.packageId == null) return <Map<String, dynamic>>[];

//     final String currentPkgId = pkg.packageId!.toString();
//     final String selectedPkgId = selectedPackageId.value;

//     // Case 1: User picked a different package -> push only package_id; let server attach defaults
//     if (selectedPkgId.isNotEmpty &&
//         selectedPkgId != currentPkgId &&
//         !isCustomEditing.value) {
//       return [
//         {
//           if (pkg.id != null) "id": pkg.id,
//           "package_id": selectedPkgId,
//           // amount and items omitted; server will apply package defaults
//           "is_custom": false,
//         },
//       ];
//     }

//     // Index existing package items by menu_item_id
//     final Map<String, dynamic> existingByMenuItemId = {};
//     if (pkg.orderPackageItems != null) {
//       for (final item in pkg.orderPackageItems!) {
//         if (item.menuItemId != null) {
//           existingByMenuItemId[item.menuItemId!.toString()] = item;
//         }
//       }
//     }

//     final List<Map<String, dynamic>> packageItems = [];
//     final Set<String> selectedIds = {};
//     final Set<String> existingIds = existingByMenuItemId.keys.toSet();
//     bool hasQuantityChange = false;

//     // Add/Update currently selected food items
//     for (final m in selectedMenuItems) {
//       final key = (m.menuItemId?.toString() ?? '');
//       if (key.isEmpty) continue;
//       selectedIds.add(key);
//       final existing = existingByMenuItemId[key];
//       // Track quantity change relative to existing item
//       if (existing != null) {
//         final String existingQtyStr = (existing.noOfGust ?? '1').toString();
//         final int existingQty = int.tryParse(existingQtyStr) ?? 1;
//         if (existingQty != m.qty) {
//           hasQuantityChange = true;
//         }
//       } else {
//         // New item added which didn't exist before
//         hasQuantityChange = true;
//       }
//       packageItems.add({
//         if (existing?.id != null) "id": existing.id,
//         "menu_item_id": key,
//         "price": m.price,
//         "no_of_gust": m.qty.toString(),
//         "is_deleted": false,
//       });
//     }

//     // Mark deletions for items removed from selection
//     for (final entry in existingByMenuItemId.entries) {
//       if (!selectedIds.contains(entry.key)) {
//         final item = entry.value;
//         packageItems.add({
//           if (item.id != null) "id": item.id,
//           "menu_item_id": entry.key,
//           "price": (item.price ?? '0').toString(),
//           "no_of_gust": (item.noOfGust ?? '1').toString(),
//           "is_deleted": true,
//         });
//       }
//     }

//     // Decide if this order's package should be treated as custom to prevent server from re-applying defaults
//     final bool itemsSetChanged =
//         selectedIds.length != existingIds.length ||
//         !selectedIds.containsAll(existingIds) ||
//         !existingIds.containsAll(selectedIds);
//     final bool shouldMarkCustom =
//         isCustomEditing.value ||
//         (pkg.isCustom ?? false) ||
//         itemsSetChanged ||
//         hasQuantityChange;

//     return [
//       {
//         if (pkg.id != null) "id": pkg.id,
//         "package_id": currentPkgId,
//         "amount": pkg.amount ?? "0",
//         "is_custom": shouldMarkCustom,
//         "order_package_items_attributes": packageItems,
//       },
//     ];
//   }

//   // ===========================================================================
//   // SECTION 8: FORM SETTERS AND HELPERS
//   // ===========================================================================

//   /// Set selected city and update ID
//   void setCity(String city) {
//     selectedCity.value = city;
//     final cityData = apiCities.firstWhere(
//       (c) => c.name == city,
//       orElse: () => City(),
//     );
//     selectedCityId.value = cityData.id?.toString() ?? '';
//   }

//   /// Set selected event type and update ID
//   void setEventType(String eventType) {
//     selectedEventType.value = eventType;
//     final eventData = apiEvents.firstWhere(
//       (e) => e.title == eventType,
//       orElse: () => Event(),
//     );
//     selectedEventId.value = eventData.id?.toString() ?? '';
//   }

//   /// Set selected package and update ID
//   // void setPackage(String packageTitle) {
//   //   selectedPackage.value = packageTitle;
//   //   final packageData = apiPackages.firstWhere(
//   //     (p) => p.title == packageTitle,
//   //     orElse: () => Package(),
//   //   );
//   //   selectedPackageId.value = packageData.id?.toString() ?? '';
//   // }

//   // Date and time setters
//   void setDate(DateTime date) => selectedDate.value = date;
//   void setStartTime(TimeOfDay time) => startTime.value = time;
//   void setEndTime(TimeOfDay time) => endTime.value = time;
//   // void setGuests(int count) => guests.value = count;
//   void incrementGuests() => guests.value += 1;
//   void decrementGuests() => guests.value = (guests.value - 1).clamp(1, 10000);

//   /// Split full name into first and last name
//   List<String> splitName(String fullName) {
//     final names = fullName.split(' ');
//     if (names.length >= 2) {
//       return [names[0], names.sublist(1).join(' ')];
//     }
//     return [fullName, ''];
//   }

//   // ===========================================================================
//   // SECTION 9: CLEANUP METHODS
//   // ===========================================================================

//   /// Clear all edit data and reset form
//   void clearEditOrder() {
//     currentEditOrder.value = null;
//     currentOrderServices.clear();
//     currentOrderPackages.clear();
//     selectedMenuItems.clear();
//     selectedServiceItems.clear();
//     errorMessage.value = '';

//     // Clear form controllers
//     nameController.clear();
//     emailController.clear();
//     contactController.clear();
//     messageController.clear();
//     specialRequirementsController.clear();

//     // Reset reactive values
//     selectedCity.value = '';
//     selectedCityId.value = '';
//     selectedDate.value = null;
//     startTime.value = null;
//     endTime.value = null;
//     guests.value = 1;
//     selectedEventType.value = '';
//     selectedEventId.value = '';
//     selectedPackage.value = '';
//     selectedPackageId.value = '';
//   }

//   // Add these methods to your EditController class

//   // Package state management
//   final Map<String, bool> packageEdited = {};
//   final Map<String, Map<String, List<Map<String, dynamic>>>> _customSelections =
//       {};

//   // Get current menu for package
//   Map<String, List<Map<String, dynamic>>> getCurrentMenu() {
//     return menuForPackage(
//       selectedPackage.value,
//       guests.value > 0 ? guests.value : 1,
//     );
//   }

//   void markPackageAsEdited() {
//     if (selectedPackage.value.isNotEmpty) {
//       packageEdited[selectedPackage.value] = true;
//       isCustomEditing.value = true;

//       // Save the current selection immediately when edited
//       final currentMenu = getCurrentMenu();
//       _customSelections[selectedPackage.value] = currentMenu;
//     }
//   }

//   bool hasPackageBeenModified() {
//     return packageEdited[selectedPackage.value] == true;
//   }

//   // Reset package to original state
//   void resetPackageToOriginal(String packageTitle) {
//     if (packageTitle.isEmpty) return;

//     // Clear any custom selections
//     _customSelections.remove(packageTitle);
//     packageEdited[packageTitle] = false;
//     isCustomEditing.value = false;

//     // Reload the original package menu
//     final currentGuests = guests.value > 0 ? guests.value : 1;
//     final originalMenu = _getOriginalPackageMenu(packageTitle, currentGuests);

//     // Update selected items from original menu
//     _updateSelectedItemsFromMenu(originalMenu);
//   }

//   // Get the original package menu without any customizations
//   Map<String, List<Map<String, dynamic>>> _getOriginalPackageMenu(
//     String packageTitle,
//     int guestCount,
//   ) {
//     final pkg = _findPackage(packageTitle);
//     if (pkg == null) {
//       return {'Food Items': [], 'Services': []};
//     }

//     final food = <Map<String, dynamic>>[];
//     final services = <Map<String, dynamic>>[];

//     // Get package items from API package structure
//     if (pkg.packageItems != null) {
//       for (var packageItem in pkg.packageItems!) {
//         if (packageItem.menuItem != null) {
//           final menuItem = packageItem.menuItem!;
//           final isFood = _isFoodItem(menuItem);
//           final qty = isFood ? guestCount : 1;

//           final entry = {
//             'name': menuItem.title ?? 'Unknown Item',
//             'price': menuItem.price ?? '0',
//             'qty': qty,
//             'menu_item_id': menuItem.id,
//             'id': menuItem.id,
//           };

//           if (isFood) {
//             food.add(entry);
//           } else {
//             services.add(entry);
//           }
//         }
//       }
//     }

//     return {'Food Items': food, 'Services': services};
//   }

//   // Check if menu item is food (not service)
//   bool _isFoodItem(Service menuItem) {
//     // Check if this item exists in food categories
//     for (var category in apiMenuCategories) {
//       if (category.menuItems != null) {
//         for (var foodItem in category.menuItems!) {
//           if (foodItem.id == menuItem.id) {
//             return true;
//           }
//         }
//       }
//     }
//     return false;
//   }

//   // Update selected items from menu
//   void _updateSelectedItemsFromMenu(
//     Map<String, List<Map<String, dynamic>>> menu,
//   ) {
//     // Clear current selections
//     selectedMenuItems.clear();
//     selectedServiceItems.clear();

//     // Add food items
//     for (var foodItem in menu['Food Items']!) {
//       selectedMenuItems.add(
//         SelectedMenuItem(
//           menuItemId: foodItem['menu_item_id'],
//           name: foodItem['name'],
//           price: foodItem['price'].toString(),
//           qty: foodItem['qty'],
//           id: null, // Will be set by API
//           isDeleted: false,
//         ),
//       );
//     }

//     // Add service items
//     for (var serviceItem in menu['Services']!) {
//       selectedServiceItems.add(
//         SelectedServiceItem(
//           serviceId: serviceItem['menu_item_id'],
//           title: serviceItem['name'],
//           price: serviceItem['price'].toString(),
//           qty: serviceItem['qty'],
//           id: null, // Will be set by API
//           isDeleted: false,
//         ),
//       );
//     }
//   }

//   // Enhanced setPackage method with state management
//   void setPackage(String packageTitle) {
//     // Save current package state before switching
//     if (selectedPackage.value.isNotEmpty &&
//         selectedPackage.value != packageTitle &&
//         isCustomEditing.value) {
//       _saveCurrentPackageState();
//     }

//     selectedPackage.value = packageTitle;

//     // Find and set the package ID
//     final packageData = apiPackages.firstWhere(
//       (p) => p.title == packageTitle,
//       orElse: () => Package(),
//     );
//     selectedPackageId.value = packageData.id?.toString() ?? '';

//     // Initialize edit state for this package if not exists
//     if (!packageEdited.containsKey(packageTitle)) {
//       packageEdited[packageTitle] = false;
//     }

//     // Load custom selection if exists, otherwise load original
//     if (_customSelections.containsKey(packageTitle)) {
//       final customMenu = _customSelections[packageTitle]!;
//       _updateSelectedItemsFromMenu(customMenu);
//       packageEdited[packageTitle] = true;
//       isCustomEditing.value = true;
//     } else {
//       // Load original package menu
//       final originalMenu = _getOriginalPackageMenu(packageTitle, guests.value);
//       _updateSelectedItemsFromMenu(originalMenu);
//       packageEdited[packageTitle] = false;
//       isCustomEditing.value = false;
//     }
//   }

//   // Save current package state
//   void _saveCurrentPackageState() {
//     if (selectedPackage.value.isEmpty) return;

//     final currentMenu = {
//       'Food Items': selectedMenuItems
//           .map(
//             (item) => {
//               'name': item.name,
//               'price': item.price,
//               'qty': item.qty,
//               'menu_item_id': item.menuItemId,
//               'id': item.id,
//             },
//           )
//           .toList(),
//       'Services': selectedServiceItems
//           .map(
//             (item) => {
//               'name': item.title,
//               'price': item.price,
//               'qty': item.qty,
//               'menu_item_id': item.serviceId,
//               'id': item.id,
//             },
//           )
//           .toList(),
//     };

//     _customSelections[selectedPackage.value] = currentMenu;
//     packageEdited[selectedPackage.value] = true;
//   }

//   // Enhanced setGuests to update food quantities
//   void setGuests(int count) {
//     final oldCount = guests.value;
//     guests.value = count;

//     // Update food quantities if package is edited
//     if (isCustomEditing.value && selectedPackage.value.isNotEmpty) {
//       for (int i = 0; i < selectedMenuItems.length; i++) {
//         selectedMenuItems[i] = SelectedMenuItem(
//           menuItemId: selectedMenuItems[i].menuItemId,
//           name: selectedMenuItems[i].name,
//           price: selectedMenuItems[i].price,
//           qty: count, // Update to new guest count
//           id: selectedMenuItems[i].id,
//           isDeleted: selectedMenuItems[i].isDeleted,
//         );
//       }
//       selectedMenuItems.refresh();

//       // Update custom selection
//       if (_customSelections.containsKey(selectedPackage.value)) {
//         for (var foodItem
//             in _customSelections[selectedPackage.value]!['Food Items']!) {
//           foodItem['qty'] = count;
//         }
//       }
//     }
//   }

//   // Enhanced menuForPackage method for edit screen
//   Map<String, List<Map<String, dynamic>>> menuForPackage(
//     String packageTitle,
//     int guestCount,
//   ) {
//     // If user has a saved custom selection for this package, use it
//     final saved = _customSelections[packageTitle];
//     final isEdited = packageEdited[packageTitle] == true;

//     if (saved != null && isEdited) {
//       // For edited packages, update food quantities based on guest count
//       final food = <Map<String, dynamic>>[];
//       final services = <Map<String, dynamic>>[];

//       // Update food items with new guest count
//       for (final item in (saved['Food Items'] ?? [])) {
//         final int qty = guestCount; // Always use current guest count for food
//         final normalized = Map<String, dynamic>.from(item);
//         normalized['qty'] = qty;
//         food.add(normalized);
//       }

//       // Keep service quantities as they were
//       for (final item in (saved['Services'] ?? [])) {
//         final int qty = (item['qty'] is int)
//             ? item['qty'] as int
//             : int.tryParse(item['qty']?.toString() ?? '') ?? 1;
//         final normalized = Map<String, dynamic>.from(item);
//         normalized['qty'] = qty;
//         services.add(normalized);
//       }

//       return {'Food Items': food, 'Services': services};
//     }

//     // Return original package menu
//     return _getOriginalPackageMenu(packageTitle, guestCount);
//   }

//   // Find package by title
//   Package? _findPackage(String title) {
//     try {
//       return apiPackages.firstWhere((p) => p.title == title);
//     } catch (e) {
//       return null;
//     }
//   }

//   // Check if package is API package (not custom)
//   bool _isApiPackage(String packageTitle) {
//     final pkg = _findPackage(packageTitle);
//     return pkg?.id != null && pkg!.id! > 0;
//   }

//   // Initialize package state when loading order
//   void _initializePackageStateFromOrder() {
//     if (currentOrderPackages.isNotEmpty) {
//       final orderPackage = currentOrderPackages.first;
//       final packageTitle = orderPackage.package?.title ?? '';

//       if (packageTitle.isNotEmpty) {
//         selectedPackage.value = packageTitle;
//         selectedPackageId.value = orderPackage.packageId?.toString() ?? '';

//         // Check if package is custom
//         final isCustom = orderPackage.isCustom ?? false;
//         packageEdited[packageTitle] = isCustom;
//         isCustomEditing.value = isCustom;

//         if (isCustom) {
//           // Build custom selection from order items
//           final customMenu = _buildCustomMenuFromOrder();
//           _customSelections[packageTitle] = customMenu;
//         }
//       }
//     }
//   }

//   // Build custom menu from order items
//   Map<String, List<Map<String, dynamic>>> _buildCustomMenuFromOrder() {
//     final food = <Map<String, dynamic>>[];
//     final services = <Map<String, dynamic>>[];

//     // Build from order package items
//     for (var orderPackage in currentOrderPackages) {
//       if (orderPackage.orderPackageItems != null) {
//         for (var packageItem in orderPackage.orderPackageItems!) {
//           if (packageItem.menuItem != null &&
//               !(packageItem.isDeleted ?? false)) {
//             final menuItem = packageItem.menuItem!;
//             final isService = currentOrderServices.any(
//               (service) => service.service?.id == menuItem.id,
//             );

//             final entry = {
//               'name': menuItem.title ?? 'Unknown Item',
//               'price': menuItem.price ?? '0',
//               'qty': int.tryParse(packageItem.noOfGust ?? '1') ?? 1,
//               'menu_item_id': menuItem.id,
//               'id': packageItem.id,
//             };

//             if (!isService) {
//               food.add(entry);
//             } else {
//               services.add(entry);
//             }
//           }
//         }
//       }
//     }

//     // Add services from order services
//     for (var orderService in currentOrderServices) {
//       if (orderService.service != null && !(orderService.isDeleted ?? false)) {
//         services.add({
//           'name': orderService.service!.title ?? 'Unknown Service',
//           'price': orderService.service!.price ?? '0',
//           'qty': 1,
//           'menu_item_id': orderService.service!.id,
//           'id': orderService.id,
//         });
//       }
//     }

//     return {'Food Items': food, 'Services': services};
//   }

//   // Update the _buildSelectedListsFromCurrentOrder method to call initialization
//   void _buildSelectedListsFromCurrentOrder() {
//     selectedMenuItems.clear();
//     selectedServiceItems.clear();

//     // Build food items from packages (exclude service items)
//     for (var orderPackage in currentOrderPackages) {
//       if (orderPackage.orderPackageItems != null) {
//         for (var packageItem in orderPackage.orderPackageItems!) {
//           if (packageItem.menuItem != null &&
//               !(packageItem.isDeleted ?? false)) {
//             bool isServiceItem = currentOrderServices.any(
//               (service) => service.service?.id == packageItem.menuItem?.id,
//             );

//             if (!isServiceItem) {
//               selectedMenuItems.add(
//                 SelectedMenuItem(
//                   menuItemId: packageItem.menuItem!.id,
//                   name: packageItem.menuItem!.title ?? '',
//                   price: packageItem.menuItem!.price ?? '0',
//                   qty: int.tryParse(packageItem.noOfGust ?? '1') ?? 1,
//                   id: packageItem.id,
//                   isDeleted: packageItem.isDeleted ?? false,
//                 ),
//               );
//             }
//           }
//         }
//       }
//     }

//     // Build services
//     for (var orderService in currentOrderServices) {
//       if (orderService.service != null && !(orderService.isDeleted ?? false)) {
//         selectedServiceItems.add(
//           SelectedServiceItem(
//             serviceId: orderService.service!.id,
//             title: orderService.service!.title ?? '',
//             price: orderService.service!.price ?? '0',
//             qty: 1,
//             id: orderService.id,
//             isDeleted: orderService.isDeleted ?? false,
//           ),
//         );
//       }
//     }

//     // Initialize package state after building lists
//     _initializePackageStateFromOrder();
//   }
// }

// // ===========================================================================
// // SUPPORTING MODELS FOR SELECTED ITEMS
// // ===========================================================================

// /// Model for selected menu items in UI
// class SelectedMenuItem {
//   final int? menuItemId;
//   final String name;
//   final String price;
//   final int qty;
//   final int? id;
//   final bool isDeleted;

//   SelectedMenuItem({
//     required this.menuItemId,
//     required this.name,
//     required this.price,
//     required this.qty,
//     this.id,
//     required this.isDeleted,
//   });

//   /// Convert to API format
//   Map<String, dynamic> toApiMap() {
//     return {
//       if (id != null) "id": id,
//       "menu_item_id": menuItemId?.toString() ?? '',
//       "price": price,
//       "qty": qty,
//       "is_deleted": isDeleted,
//     };
//   }
// }

// /// Model for selected service items in UI
// class SelectedServiceItem {
//   final int? serviceId;
//   final String title;
//   final String price;
//   final int qty;
//   final int? id;
//   final bool isDeleted;

//   SelectedServiceItem({
//     required this.serviceId,
//     required this.title,
//     required this.price,
//     required this.qty,
//     this.id,
//     required this.isDeleted,
//   });

//   /// Convert to API format
//   Map<String, dynamic> toApiMap() {
//     return {
//       if (id != null) "id": id,
//       "menu_item_id": serviceId?.toString() ?? '',
//       "price": price,
//       "qty": qty,
//       "is_deleted": isDeleted,
//     };
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schedule_app/APIS/Api_Service.dart';
import 'package:schedule_app/pages/Edit/models/EditModel.dart';
import 'package:schedule_app/pages/Edit/models/MenuItem.dart' hide MenuItem;
import 'package:schedule_app/pages/Edit/models/model.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class EditController extends GetxController {
  // ===========================================================================
  // SECTION 1: REACTIVE STATE VARIABLES
  // ===========================================================================

  // Current order being edited
  final Rx<EditOrderModel?> currentEditOrder = Rx<EditOrderModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Form controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final contactController = TextEditingController();
  final messageController = TextEditingController();
  final specialRequirementsController = TextEditingController();

  // Form reactive data
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

  // Current order data from API
  final RxList<OrderServices> currentOrderServices = <OrderServices>[].obs;
  final RxList<OrderPackages> currentOrderPackages = <OrderPackages>[].obs;

  // API Data collections
  final RxList<City> apiCities = <City>[].obs;
  final RxList<Event> apiEvents = <Event>[].obs;
  final RxList<Package> apiPackages = <Package>[].obs;

  // UPDATED: Menu data with categories
  final RxList<MenuCategory> apiMenuCategories = <MenuCategory>[].obs;

  // Services remain the same
  final RxList<ServiceMode> apiServiceItems = <ServiceMode>[].obs;

  // Selected items for UI
  final RxList<SelectedMenuItem> selectedMenuItems = <SelectedMenuItem>[].obs;
  final RxList<SelectedServiceItem> selectedServiceItems =
      <SelectedServiceItem>[].obs;

  // Edit mode flags
  final RxBool isEditingItems = false.obs;
  final RxBool isCustomEditing = false.obs;

  // ===========================================================================
  // SECTION 2: LIFECYCLE METHODS
  // ===========================================================================

  @override
  void onInit() {
    super.onInit();
    loadApiData();
    // _loadServiceItems();
  }

  @override
  void onClose() {
    // Dispose all text controllers
    nameController.dispose();
    emailController.dispose();
    contactController.dispose();
    messageController.dispose();
    specialRequirementsController.dispose();
    super.onClose();
  }

  // ===========================================================================
  // SECTION 3: API DATA LOADING METHODS
  // ===========================================================================

  /// Loads all required API data for the edit page
  Future<void> loadApiData() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      await _loadCities();
      await _loadEvents();
      await _loadPackages();
      await _loadMenuCategories(); // UPDATED: Load menu categories
      await loadServiceItems();
    } catch (e) {
      errorMessage.value = 'Error loading data: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Load cities from API
  Future<void> _loadCities() async {
    final citiesResult = await ApiService.getCities();
    if (citiesResult['success'] == true) {
      final citiesData = citiesResult['data'];
      if (citiesData is List) {
        apiCities.value = citiesData
            .map((cityJson) => City.fromJson(cityJson))
            .toList();
      } else if (citiesData is Map && citiesData['cities'] is List) {
        apiCities.value = (citiesData['cities'] as List)
            .map((cityJson) => City.fromJson(cityJson))
            .toList();
      }
    }
  }

  /// Load events from API
  Future<void> _loadEvents() async {
    final eventsResult = await ApiService.getEvents();
    if (eventsResult['success'] == true) {
      final eventsData = eventsResult['data'];
      if (eventsData is List) {
        apiEvents.value = eventsData
            .map((eventJson) => Event.fromJson(eventJson))
            .toList();
      } else if (eventsData is Map && eventsData['events'] is List) {
        apiEvents.value = (eventsData['events'] as List)
            .map((eventJson) => Event.fromJson(eventJson))
            .toList();
      }
    }
  }

  /// Load packages from API
  Future<void> _loadPackages() async {
    final packagesResult = await ApiService.getPackages();
    if (packagesResult['success'] == true) {
      final packagesData = packagesResult['data'];
      if (packagesData is List) {
        apiPackages.value = packagesData
            .map((pkgJson) => Package.fromJson(pkgJson))
            .toList();
      } else if (packagesData is Map && packagesData['packages'] is List) {
        apiPackages.value = (packagesData['packages'] as List)
            .map((pkgJson) => Package.fromJson(pkgJson))
            .toList();
      }
    }
  }

  /// UPDATED: Load menu categories with items from API
  Future<void> _loadMenuCategories() async {
    final menusResult = await ApiService.getMenus();
    if (menusResult['success'] == true) {
      final menusData = menusResult['data'];
      if (menusData is List) {
        apiMenuCategories.value = menusData
            .map((categoryJson) => MenuCategory.fromJson(categoryJson))
            .toList();
      }
    }
  }

  /// Load service items from API

  ///
  // Future<List<MenuItem>> _loadServiceItems() async {
  //   final servicesResult = await ApiService.getServices();
  final isLoadingServices = false.obs;
  void _loadServiceItemsFallback(Map<String, dynamic> servicesResult) {
    try {
      final List<ServiceMode> fallbackServices = [];
      final dynamic raw = servicesResult['data'];
      final List<dynamic> serviceList = raw is List
          ? List<dynamic>.from(raw)
          : (raw is Map && raw['data'] is List)
          ? List<dynamic>.from(raw['data'] as List)
          : [];

      for (var svc in serviceList) {
        try {
          final Map<String, dynamic> svcMap = Map<String, dynamic>.from(svc);
          final service = ServiceMode.fromJson(svcMap);
          fallbackServices.add(service);
        } catch (inner) {
          print('Skipping a service due to parse error: $inner');
        }
      }

      apiServiceItems.assignAll(fallbackServices);
    } catch (e) {
      print('Fallback parsing also failed: $e');
    }
  }

  // Method to load service items
  Future<void> loadServiceItems() async {
    try {
      isLoadingServices(true);
      final servicesResult = await ApiService.getServices();

      if (servicesResult['success'] != true) {
        print('Failed to load services: ${servicesResult['message']}');
        return;
      }

      final dynamic raw = servicesResult['data'];
      final List<dynamic> serviceList = raw is List
          ? List<dynamic>.from(raw)
          : (raw is Map && raw['data'] is List)
          ? List<dynamic>.from(raw['data'] as List)
          : [];

      // Map to ServiceMode
      final List<ServiceMode> serviceItems = serviceList
          .map((e) => ServiceMode.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      apiServiceItems.assignAll(serviceItems);

      // Print loaded services for debugging
      for (var service in serviceItems) {
        print(
          'Service: ${service.title}, Menu Items: ${service.menuItems?.length ?? 0}',
        );
      }
      return apiServiceItems.assignAll(serviceItems);
    } catch (e, st) {
      print('Error loading services: $e\n$st');
      // Fallback parsing if needed
      _loadServiceItemsFallback(apiServiceItems as Map<String, dynamic>);
    } finally {
      isLoadingServices(false);
    }
  }

  // ===========================================================================
  // SECTION 4: DATA GETTERS FOR UI
  // ===========================================================================

  /// Get cities for dropdown
  List<String> get cities {
    return apiCities.map((city) => city.name ?? 'Unknown City').toList();
  }

  /// Get event types for dropdown
  List<String> get eventTypes {
    return apiEvents.map((event) => event.title ?? 'Unknown Event').toList();
  }

  /// Get packages for selection in UI format
  List<Package> get packages => apiPackages.toList();

  /// NEW: Get all menu items as a flat list (for backward compatibility)
  List get allMenuItems {
    return apiMenuCategories
        .expand((category) => category.menuItems ?? [])
        .toList();
  }

  /// NEW: Get menu categories for grouped display
  List<MenuCategory> get menuCategories => apiMenuCategories.toList();

  // ===========================================================================
  // SECTION 5: ORDER LOADING AND POPULATION
  // ===========================================================================

  /// Load order data by ID for editing
  Future<void> loadOrderById(String orderId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final EditOrderModel? order = await ApiService.getOrderById(
        orderId.toString(),
      );

      if (order != null) {
        currentEditOrder.value = order;
        _populateFormFromOrder(order);

        // Initialize current lists with data from server
        currentOrderServices.value = List.from(order.orderServices ?? []);
        currentOrderPackages.value = List.from(order.orderPackages ?? []);

        // Build selected lists for UI
        _buildSelectedListsFromCurrentOrder();

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

  /// Populate form fields from order model
  void _populateFormFromOrder(EditOrderModel order) {
    // Personal information
    nameController.text = '${order.firstname ?? ''} ${order.lastname ?? ''}'
        .trim();
    emailController.text = order.email ?? '';
    contactController.text = order.phone ?? '';
    specialRequirementsController.text = order.requirement ?? '';

    // Event details
    selectedEventType.value = order.event?.title ?? '';
    selectedEventId.value = order.eventId?.toString() ?? '';

    // Date and time
    if (order.eventDate != null && order.eventDate!.isNotEmpty) {
      try {
        selectedDate.value = DateTime.parse(order.eventDate!);
      } catch (e) {
        print('Error parsing date: ${order.eventDate}');
      }
    } else {
      selectedDate.value = null;
    }

    startTime.value = _parseTimeFromString(order.startTime);
    endTime.value = _parseTimeFromString(order.endTime);

    guests.value = int.tryParse(order.noOfGust ?? '1') ?? 1;

    // City
    if (order.city != null) {
      selectedCity.value = order.city!.name ?? '';
      selectedCityId.value = order.cityId?.toString() ?? '';
    } else {
      selectedCity.value = '';
      selectedCityId.value = '';
    }

    // Package
    if (order.orderPackages != null && order.orderPackages!.isNotEmpty) {
      final package = order.orderPackages!.first.package;
      if (package != null) {
        selectedPackage.value = package.title ?? '';
        selectedPackageId.value = package.id?.toString() ?? '';
      }
    } else {
      selectedPackage.value = '';
      selectedPackageId.value = '';
    }
  }

  /// Parse time string to TimeOfDay
  TimeOfDay? _parseTimeFromString(String? timeString) {
    if (timeString == null || timeString.isEmpty) return null;
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

  // ===========================================================================
  // SECTION 6: SELECTED ITEMS MANAGEMENT
  // ===========================================================================

  /// Build selected lists from current order data
  void _buildSelectedListsFromCurrentOrder() {
    selectedMenuItems.clear();
    selectedServiceItems.clear();

    // Build food items from packages (exclude service items)
    for (var orderPackage in currentOrderPackages) {
      if (orderPackage.orderPackageItems != null) {
        for (var packageItem in orderPackage.orderPackageItems!) {
          if (packageItem.menuItem != null &&
              !(packageItem.isDeleted ?? false)) {
            // Check if this is a service item by looking at the service items list
            // If it exists in services, it's a service item, not a food item
            bool isServiceItem = currentOrderServices.any(
              (service) => service.service?.id == packageItem.menuItem?.id,
            );

            if (!isServiceItem) {
              selectedMenuItems.add(
                SelectedMenuItem(
                  menuItemId: packageItem.menuItem!.id,
                  name: packageItem.menuItem!.title ?? '',
                  price: packageItem.menuItem!.price ?? '0',
                  qty: int.tryParse(packageItem.noOfGust ?? '1') ?? 1,
                  id: packageItem.id,
                  isDeleted: packageItem.isDeleted ?? false,
                ),
              );
            }
          }
        }
      }
    }

    // Build services
    for (var orderService in currentOrderServices) {
      if (orderService.service != null && !(orderService.isDeleted ?? false)) {
        selectedServiceItems.add(
          SelectedServiceItem(
            serviceId: orderService.service!.id,
            title: orderService.service!.title ?? '',
            price: orderService.service!.price ?? '0',
            qty: 1,
            id: orderService.id,
            isDeleted: orderService.isDeleted ?? false,
          ),
        );
      }
    }

    // Initialize package state after building lists
    _initializePackageStateFromOrder();
  }

  /// Add menu item to selection
  void addSelectedMenuItem({
    required int? menuItemId,
    required String name,
    required String price,
    int qty = 1,
    int? id,
  }) {
    final exists = selectedMenuItems.any((m) => m.menuItemId == menuItemId);
    if (!exists) {
      selectedMenuItems.add(
        SelectedMenuItem(
          menuItemId: menuItemId,
          name: name,
          price: price,
          qty: qty,
          id: id,
          isDeleted: false,
        ),
      );
    }
  }

  /// Remove menu item from selection
  void removeSelectedMenuItemByMenuItemId(int? menuItemId) {
    selectedMenuItems.removeWhere((m) => m.menuItemId == menuItemId);
  }

  /// Clear all selected menu items
  void clearSelectedMenuItems() => selectedMenuItems.clear();

  /// Add service item to selection
  void addSelectedServiceItem({
    required int? serviceId,
    required String title,
    required String price,
    int qty = 1,
    int? id,
  }) {
    final exists = selectedServiceItems.any((s) => s.serviceId == serviceId);
    if (!exists) {
      selectedServiceItems.add(
        SelectedServiceItem(
          serviceId: serviceId,
          title: title,
          price: price,
          qty: qty,
          id: id,
          isDeleted: false,
        ),
      );
    }
  }

  /// Remove service item from selection
  void removeSelectedServiceItemById(int? serviceId) {
    selectedServiceItems.removeWhere((s) => s.serviceId == serviceId);
  }

  /// Clear all selected service items
  void clearSelectedServiceItems() => selectedServiceItems.clear();

  // ===========================================================================
  // SECTION 7: ORDER UPDATE AND API COMMUNICATION
  // ===========================================================================

  /// Complete the edit process and update order via API
  Future<bool> completeEdit() async {
    try {
      // Debug: snapshot incoming editable state
      _debugPrintState('START completeEdit');
      if (currentEditOrder.value == null) {
        errorMessage.value = 'No order data loaded';
        return false;
      }

      final orderId = currentEditOrder.value!.id!;
      isLoading.value = true;
      errorMessage.value = '';

      // Update the model instance with form data
      final updatedOrder = _prepareOrderForUpdate();

      // Prepare API payload
      final body = _prepareApiPayload(updatedOrder);

      // Debug: outgoing payload
      print('=== DEBUG: OUTGOING UPDATE PAYLOAD (order) ===');
      try {
        print(jsonEncode(body));
      } catch (_) {}
      print('Sending update order data: ${jsonEncode(body)}');

      // Call API to update order
      final response = await ApiService.updateOrder(
        orderId: orderId,
        EditOrderModel: body,
      );

      // Debug: response snapshot
      print('=== DEBUG: UPDATE RESPONSE ===');
      print(response);

      if (response['success'] == true) {
        print('✅ Order updated successfully');
        // Reload to reflect server-side changes
        await loadOrderById(orderId.toString());
        _debugPrintState('AFTER reload - server state reloaded');
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

  /// Prepare order model with updated form data
  EditOrderModel _prepareOrderForUpdate() {
    final order = currentEditOrder.value!;

    // Name handling
    final nameParts = splitName(nameController.text.trim());
    order.firstname = nameParts[0];
    order.lastname = nameParts[1];

    // Contact information
    order.email = emailController.text;
    order.phone = contactController.text;
    order.nin = order.nin ?? "123456789";

    // Location and event
    order.cityId = int.tryParse(selectedCityId.value) ?? order.cityId ?? 1;
    order.address = selectedCity.value;
    order.eventId = int.tryParse(selectedEventId.value) ?? order.eventId ?? 1;

    // Event details
    order.noOfGust = guests.value.toString();
    order.requirement = specialRequirementsController.text.isEmpty
        ? "No special requirements"
        : specialRequirementsController.text;

    // Date and time formatting
    order.eventDate = _formatDateForApi(selectedDate.value);
    order.eventTime = _formatTimeForApi(startTime.value);
    order.startTime = _formatTimeForApi(startTime.value);
    order.endTime = _formatTimeForApi(endTime.value);

    // System fields
    order.paymentMethodId = 1;
    order.isInquiry = order.isInquiry ?? false;

    // Debug: show the prepared order fields
    print('=== DEBUG: _prepareOrderForUpdate ===');
    print('firstname=' + (order.firstname ?? 'null'));
    print('lastname=' + (order.lastname ?? 'null'));
    print('email=' + (order.email ?? 'null'));
    print('phone=' + (order.phone ?? 'null'));
    print('cityId=' + (order.cityId?.toString() ?? 'null'));
    print('address=' + (order.address ?? 'null'));
    print('eventId=' + (order.eventId?.toString() ?? 'null'));
    print('noOfGust=' + (order.noOfGust ?? 'null'));
    print('requirement=' + (order.requirement ?? 'null'));
    print('eventDate=' + (order.eventDate ?? 'null'));
    print('startTime=' + (order.startTime ?? 'null'));
    print('endTime=' + (order.endTime ?? 'null'));

    return order;
  }

  /// Prepare API payload with order data and selected items
  Map<String, dynamic> _prepareApiPayload(EditOrderModel order) {
    final orderJson = order.toJson();

    // Convert selected items to API format
    orderJson['order_services_attributes'] = _getOrderServicesForApi();
    orderJson['order_packages_attributes'] = _getOrderPackagesForApi();

    // Debug: nested attributes preview
    print('=== DEBUG: order_services_attributes ===');
    try {
      print(jsonEncode(orderJson['order_services_attributes']));
    } catch (_) {}
    print('=== DEBUG: order_packages_attributes ===');
    try {
      print(jsonEncode(orderJson['order_packages_attributes']));
    } catch (_) {}

    return {"order": orderJson};
  }

  void _debugPrintState(String stage) {
    print('=== DEBUG: $stage ===');
    print(
      'currentEditOrder.id=' +
          (currentEditOrder.value?.id?.toString() ?? 'null'),
    );
    print(
      'name=' +
          nameController.text +
          ', email=' +
          emailController.text +
          ', phone=' +
          contactController.text,
    );
    print('city=' + selectedCity.value + ' (id=' + selectedCityId.value + ')');
    print(
      'event=' +
          selectedEventType.value +
          ' (id=' +
          selectedEventId.value +
          ')',
    );
    print('date=' + (selectedDate.value?.toIso8601String() ?? 'null'));
    try {
      final ctx = Get.context ?? Get.overlayContext;
      final st = startTime.value?.format(ctx!) ?? 'null';
      final et = endTime.value?.format(ctx!) ?? 'null';
      print('startTime=' + st + ', endTime=' + et);
    } catch (_) {}
    print('guests=' + guests.value.toString());
    print(
      'selectedPackage=' +
          selectedPackage.value +
          ' (id=' +
          selectedPackageId.value +
          ')',
    );
    print('selectedMenuItems.count=' + selectedMenuItems.length.toString());
    for (final m in selectedMenuItems) {
      print(
        '  MENU id=' +
            (m.menuItemId?.toString() ?? 'null') +
            ' name=' +
            m.name +
            ' price=' +
            m.price +
            ' qty=' +
            m.qty.toString(),
      );
    }
    print(
      'selectedServiceItems.count=' + selectedServiceItems.length.toString(),
    );
    for (final s in selectedServiceItems) {
      print(
        '  SERVICE id=' +
            (s.serviceId?.toString() ?? 'null') +
            ' title=' +
            s.title +
            ' price=' +
            s.price +
            ' qty=' +
            s.qty.toString(),
      );
    }
  }

  /// Format date for API
  String _formatDateForApi(DateTime? date) {
    if (date == null) return '';
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  /// Format time for API
  String _formatTimeForApi(TimeOfDay? time) {
    if (time == null) return '';
    return "2000-01-01T${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00.000Z";
  }

  /// Build order_services_attributes from selected services, including deletions
  List<Map<String, dynamic>> _getOrderServicesForApi() {
    final List<Map<String, dynamic>> results = [];

    // Index current services by menu_item_id for quick lookup
    final Map<String, OrderServices> existingByMenuItemId = {
      for (final svc in currentOrderServices)
        if (svc.menuItemId != null) svc.menuItemId!.toString(): svc,
    };

    // Add/Update selected services
    final Set<String> selectedIds = {};
    for (final sel in selectedServiceItems) {
      final key = (sel.serviceId?.toString() ?? '');
      if (key.isEmpty) continue;
      selectedIds.add(key);
      final existing = existingByMenuItemId[key];
      results.add({
        if (existing?.id != null) "id": existing!.id,
        "menu_item_id": key,
        "price": sel.price,
        "qty": sel.qty,
        "is_deleted": false,
      });
    }

    // Mark deletions for services that existed but are no longer selected
    for (final entry in existingByMenuItemId.entries) {
      if (!selectedIds.contains(entry.key)) {
        final svc = entry.value;
        results.add({
          if (svc.id != null) "id": svc.id,
          "menu_item_id": entry.key,
          "price": (svc.price ?? '0').toString(),
          "qty": 1,
          "is_deleted": true,
        });
      }
    }

    return results;
  }

  /// Build order_packages_attributes using selected menu items for the existing package, including deletions
  List<Map<String, dynamic>> _getOrderPackagesForApi() {
    if (currentOrderPackages.isEmpty) return <Map<String, dynamic>>[];
    final pkg = currentOrderPackages.first;
    if (pkg.packageId == null) return <Map<String, dynamic>>[];

    final String currentPkgId = pkg.packageId!.toString();
    final String selectedPkgId = selectedPackageId.value;

    // Case 1: User picked a different package -> push only package_id; let server attach defaults
    if (selectedPkgId.isNotEmpty &&
        selectedPkgId != currentPkgId &&
        !isCustomEditing.value) {
      return [
        {
          if (pkg.id != null) "id": pkg.id,
          "package_id": selectedPkgId,
          // amount and items omitted; server will apply package defaults
          "is_custom": false,
        },
      ];
    }

    // Index existing package items by menu_item_id
    final Map<String, dynamic> existingByMenuItemId = {};
    if (pkg.orderPackageItems != null) {
      for (final item in pkg.orderPackageItems!) {
        if (item.menuItemId != null) {
          existingByMenuItemId[item.menuItemId!.toString()] = item;
        }
      }
    }

    final List<Map<String, dynamic>> packageItems = [];
    final Set<String> selectedIds = {};
    final Set<String> existingIds = existingByMenuItemId.keys.toSet();
    bool hasQuantityChange = false;

    // Add/Update currently selected food items
    for (final m in selectedMenuItems) {
      final key = (m.menuItemId?.toString() ?? '');
      if (key.isEmpty) continue;
      selectedIds.add(key);
      final existing = existingByMenuItemId[key];
      // Track quantity change relative to existing item
      if (existing != null) {
        final String existingQtyStr = (existing.noOfGust ?? '1').toString();
        final int existingQty = int.tryParse(existingQtyStr) ?? 1;
        if (existingQty != m.qty) {
          hasQuantityChange = true;
        }
      } else {
        // New item added which didn't exist before
        hasQuantityChange = true;
      }
      packageItems.add({
        if (existing?.id != null) "id": existing.id,
        "menu_item_id": key,
        "price": m.price,
        "no_of_gust": m.qty.toString(),
        "is_deleted": false,
      });
    }

    // Mark deletions for items removed from selection
    for (final entry in existingByMenuItemId.entries) {
      if (!selectedIds.contains(entry.key)) {
        final item = entry.value;
        packageItems.add({
          if (item.id != null) "id": item.id,
          "menu_item_id": entry.key,
          "price": (item.price ?? '0').toString(),
          "no_of_gust": (item.noOfGust ?? '1').toString(),
          "is_deleted": true,
        });
      }
    }

    // Decide if this order's package should be treated as custom to prevent server from re-applying defaults
    final bool itemsSetChanged =
        selectedIds.length != existingIds.length ||
        !selectedIds.containsAll(existingIds) ||
        !existingIds.containsAll(selectedIds);
    final bool shouldMarkCustom =
        isCustomEditing.value ||
        (pkg.isCustom ?? false) ||
        itemsSetChanged ||
        hasQuantityChange;

    return [
      {
        if (pkg.id != null) "id": pkg.id,
        "package_id": currentPkgId,
        "amount": pkg.amount ?? "0",
        "is_custom": shouldMarkCustom,
        "order_package_items_attributes": packageItems,
      },
    ];
  }

  // ===========================================================================
  // SECTION 8: FORM SETTERS AND HELPERS
  // ===========================================================================

  /// Set selected city and update ID
  void setCity(String city) {
    selectedCity.value = city;
    final cityData = apiCities.firstWhere(
      (c) => c.name == city,
      orElse: () => City(),
    );
    selectedCityId.value = cityData.id?.toString() ?? '';
  }

  /// Set selected event type and update ID
  void setEventType(String eventType) {
    selectedEventType.value = eventType;
    final eventData = apiEvents.firstWhere(
      (e) => e.title == eventType,
      orElse: () => Event(),
    );
    selectedEventId.value = eventData.id?.toString() ?? '';
  }

  /// Set selected package and update ID
  void setPackage(String packageTitle) {
    // Save current package state before switching
    if (selectedPackage.value.isNotEmpty &&
        selectedPackage.value != packageTitle &&
        isCustomEditing.value) {
      _saveCurrentPackageState();
    }

    selectedPackage.value = packageTitle;

    // Find and set the package ID
    final packageData = apiPackages.firstWhere(
      (p) => p.title == packageTitle,
      orElse: () => Package(),
    );
    selectedPackageId.value = packageData.id?.toString() ?? '';

    // Initialize edit state for this package if not exists
    if (!packageEdited.containsKey(packageTitle)) {
      packageEdited[packageTitle] = false;
    }

    // Check if we're loading an existing custom package from order
    final isExistingCustom =
        currentOrderPackages.isNotEmpty &&
        currentOrderPackages.first.isCustom == true &&
        currentOrderPackages.first.package?.title == packageTitle;

    // Load custom selection if exists or it's an existing custom package, otherwise load original
    if (_customSelections.containsKey(packageTitle) || isExistingCustom) {
      final customMenu =
          _customSelections[packageTitle] ?? _buildCustomMenuFromOrder();
      _updateSelectedItemsFromMenu(customMenu);
      packageEdited[packageTitle] = true;
      isCustomEditing.value = true;
    } else {
      // Load original package menu
      final originalMenu = _getOriginalPackageMenu(packageTitle, guests.value);
      _updateSelectedItemsFromMenu(originalMenu);
      packageEdited[packageTitle] = false;
      isCustomEditing.value = false;
    }
  }

  // Date and time setters
  void setDate(DateTime date) => selectedDate.value = date;
  void setStartTime(TimeOfDay time) => startTime.value = time;
  void setEndTime(TimeOfDay time) => endTime.value = time;
  void incrementGuests() {
    final oldCount = guests.value;
    guests.value += 1;
    if (isCustomEditing.value && selectedPackage.value.isNotEmpty) {
      _updateFoodQuantitiesForCustomPackage(guests.value);
    }
  }

  void decrementGuests() {
    final oldCount = guests.value;
    guests.value = (guests.value - 1).clamp(1, 10000);
    if (isCustomEditing.value && selectedPackage.value.isNotEmpty) {
      _updateFoodQuantitiesForCustomPackage(guests.value);
    }
  }

  /// Split full name into first and last name
  List<String> splitName(String fullName) {
    final names = fullName.split(' ');
    if (names.length >= 2) {
      return [names[0], names.sublist(1).join(' ')];
    }
    return [fullName, ''];
  }

  // ===========================================================================
  // SECTION 9: CLEANUP METHODS
  // ===========================================================================

  /// Clear all edit data and reset form
  void clearEditOrder() {
    currentEditOrder.value = null;
    currentOrderServices.clear();
    currentOrderPackages.clear();
    selectedMenuItems.clear();
    selectedServiceItems.clear();
    errorMessage.value = '';

    // Clear form controllers
    nameController.clear();
    emailController.clear();
    contactController.clear();
    messageController.clear();
    specialRequirementsController.clear();

    // Reset reactive values
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

  // Add these methods to your EditController class

  // Package state management
  final Map<String, bool> packageEdited = {};
  final Map<String, Map<String, List<Map<String, dynamic>>>> _customSelections =
      {};

  // Get current menu for package
  Map<String, List<Map<String, dynamic>>> getCurrentMenu() {
    return menuForPackage(
      selectedPackage.value,
      guests.value > 0 ? guests.value : 1,
    );
  }

  void markPackageAsEdited() {
    if (selectedPackage.value.isNotEmpty) {
      packageEdited[selectedPackage.value] = true;
      isCustomEditing.value = true;

      // Save the current selection immediately when edited
      final currentMenu = getCurrentMenu();
      _customSelections[selectedPackage.value] = currentMenu;
    }
  }

  bool hasPackageBeenModified() {
    return packageEdited[selectedPackage.value] == true;
  }

  // Reset package to original state
  void resetPackageToOriginal(String packageTitle) {
    if (packageTitle.isEmpty) return;

    // Clear any custom selections
    _customSelections.remove(packageTitle);
    packageEdited[packageTitle] = false;
    isCustomEditing.value = false;

    // Reload the original package menu
    final currentGuests = guests.value > 0 ? guests.value : 1;
    final originalMenu = _getOriginalPackageMenu(packageTitle, currentGuests);

    // Update selected items from original menu
    _updateSelectedItemsFromMenu(originalMenu);
  }

  Map<String, List<Map<String, dynamic>>> _getOriginalPackageMenu(
    String packageTitle,
    int guestCount,
  ) {
    final pkg = _findPackage(packageTitle);
    if (pkg == null) {
      return {'Food Items': [], 'Services': []};
    }

    final food = <Map<String, dynamic>>[];
    final services = <Map<String, dynamic>>[];

    // Since Package model doesn't have packageItems, we need to get items differently
    // Option 1: Use current order package items if available
    if (currentOrderPackages.isNotEmpty) {
      final orderPackage = currentOrderPackages.firstWhere(
        (op) => op.package?.title == packageTitle,
        orElse: () => OrderPackages(),
      );

      if (orderPackage.orderPackageItems != null) {
        for (var packageItem in orderPackage.orderPackageItems!) {
          if (packageItem.menuItem != null &&
              !(packageItem.isDeleted ?? false)) {
            final menuItem = packageItem.menuItem!;
            final isFood = _isFoodItemById(menuItem.id);
            final qty = isFood ? guestCount : 1;

            final entry = {
              'name': menuItem.title ?? 'Unknown Item',
              'price': menuItem.price ?? '0',
              'qty': qty,
              'menu_item_id': menuItem.id,
              'id': menuItem.id,
            };

            if (isFood) {
              food.add(entry);
            } else {
              services.add(entry);
            }
          }
        }
      }
    } else {
      // Option 2: If no current order, create default items based on package type
      // This is a fallback - you might need to adjust based on your business logic
      // final defaultItems = _getDefaultPackageItems(packageTitle, guestCount);
      // food.addAll(defaultItems['Food Items']!);
      // services.addAll(defaultItems['Services']!);
    }

    return {'Food Items': food, 'Services': services};
  }

  // Get the original package menu without any customizations
  // Map<String, List<Map<String, dynamic>>> _getOriginalPackageMenu(
  //   String packageTitle,
  //   int guestCount,
  // ) {
  //   final pkg = _findPackage(packageTitle);
  //   if (pkg == null) {
  //     return {'Food Items': [], 'Services': []};
  //   }

  //   final food = <Map<String, dynamic>>[];
  //   final services = <Map<String, dynamic>>[];

  //   // FIXED: Better null safety and type checking
  //   if (pkg.packageItems != null && pkg.packageItems is List) {
  //     for (var packageItem in pkg.packageItems!) {
  //       // Add additional null checks
  //       if (packageItem?.menuItem != null) {
  //         final menuItem = packageItem!.menuItem!;

  //         // FIXED: Use ID-based check instead of type-based
  //         final isFood = _isFoodItemById(menuItem.id);
  //         final qty = isFood ? guestCount : 1;

  //         final entry = {
  //           'name': menuItem.title ?? 'Unknown Item',
  //           'price': menuItem.price ?? '0',
  //           'qty': qty,
  //           'menu_item_id': menuItem.id,
  //           'id': menuItem.id,
  //         };

  //         if (isFood) {
  //           food.add(entry);
  //         } else {
  //           services.add(entry);
  //         }
  //       }
  //     }
  //   }

  //   return {'Food Items': food, 'Services': services};
  // }

  // Add this helper method
  bool _isFoodItemById(int? menuItemId) {
    if (menuItemId == null) return false;

    // Check if this item exists in food categories
    for (var category in apiMenuCategories) {
      if (category.menuItems != null) {
        for (var foodItem in category.menuItems!) {
          if (foodItem.id == menuItemId) {
            return true;
          }
        }
      }
    }
    return false;
  }
  // Map<String, List<Map<String, dynamic>>> _getOriginalPackageMenu(
  //   String packageTitle,
  //   int guestCount,
  // ) {
  //   final pkg = _findPackage(packageTitle);
  //   if (pkg == null) {
  //     return {'Food Items': [], 'Services': []};
  //   }

  //   final food = <Map<String, dynamic>>[];
  //   final services = <Map<String, dynamic>>[];

  //   // Get package items from API package structure
  //   if (pkg.packageItems != null) {
  //     for (var packageItem in pkg.packageItems!) {
  //       if (packageItem.menuItem != null) {
  //         final menuItem = packageItem.menuItem!;
  //         final isFood = _isFoodItem(menuItem);
  //         final qty = isFood ? guestCount : 1;

  //         final entry = {
  //           'name': menuItem.title ?? 'Unknown Item',
  //           'price': menuItem.price ?? '0',
  //           'qty': qty,
  //           'menu_item_id': menuItem.id,
  //           'id': menuItem.id,
  //         };

  //         if (isFood) {
  //           food.add(entry);
  //         } else {
  //           services.add(entry);
  //         }
  //       }
  //     }
  //   }

  //   return {'Food Items': food, 'Services': services};
  // }

  // Check if menu item is food (not service)
  bool _isFoodItem(Service menuItem) {
    // Check if this item exists in food categories
    for (var category in apiMenuCategories) {
      if (category.menuItems != null) {
        for (var foodItem in category.menuItems!) {
          if (foodItem.id == menuItem.id) {
            return true;
          }
        }
      }
    }
    return false;
  }

  // Update selected items from menu
  void _updateSelectedItemsFromMenu(
    Map<String, List<Map<String, dynamic>>> menu,
  ) {
    // Clear current selections
    selectedMenuItems.clear();
    selectedServiceItems.clear();

    // Add food items
    for (var foodItem in menu['Food Items']!) {
      selectedMenuItems.add(
        SelectedMenuItem(
          menuItemId: foodItem['menu_item_id'],
          name: foodItem['name'],
          price: foodItem['price'].toString(),
          qty: foodItem['qty'],
          id: null, // Will be set by API
          isDeleted: false,
        ),
      );
    }

    // Add service items
    for (var serviceItem in menu['Services']!) {
      selectedServiceItems.add(
        SelectedServiceItem(
          serviceId: serviceItem['menu_item_id'],
          title: serviceItem['name'],
          price: serviceItem['price'].toString(),
          qty: serviceItem['qty'],
          id: null, // Will be set by API
          isDeleted: false,
        ),
      );
    }
  }

  // Save current package state
  void _saveCurrentPackageState() {
    if (selectedPackage.value.isEmpty) return;

    final currentMenu = {
      'Food Items': selectedMenuItems
          .map(
            (item) => {
              'name': item.name,
              'price': item.price,
              'qty': item.qty,
              'menu_item_id': item.menuItemId,
              'id': item.id,
            },
          )
          .toList(),
      'Services': selectedServiceItems
          .map(
            (item) => {
              'name': item.title,
              'price': item.price,
              'qty': item.qty,
              'menu_item_id': item.serviceId,
              'id': item.id,
            },
          )
          .toList(),
    };

    _customSelections[selectedPackage.value] = currentMenu;
    packageEdited[selectedPackage.value] = true;
  }

  void _updateFoodQuantitiesForCustomPackage(int newCount) {
    for (int i = 0; i < selectedMenuItems.length; i++) {
      selectedMenuItems[i] = SelectedMenuItem(
        menuItemId: selectedMenuItems[i].menuItemId,
        name: selectedMenuItems[i].name,
        price: selectedMenuItems[i].price,
        qty: newCount,
        id: selectedMenuItems[i].id,
        isDeleted: selectedMenuItems[i].isDeleted,
      );
    }
    selectedMenuItems.refresh();

    // Update custom selection cache
    if (_customSelections.containsKey(selectedPackage.value)) {
      for (var foodItem
          in _customSelections[selectedPackage.value]!['Food Items']!) {
        foodItem['qty'] = newCount;
      }
    }

    // Mark as edited when guest count changes for custom packages
    markPackageAsEdited();
  }

  void setGuests(int count) {
    final oldCount = guests.value;
    guests.value = count;

    // Scenario 1: If package is custom, update all food item quantities
    if (isCustomEditing.value && selectedPackage.value.isNotEmpty) {
      _updateFoodQuantitiesForCustomPackage(count);
    }
  }
  // Enhanced setGuests to update food quantities
  // void setGuests(int count) {
  //   final oldCount = guests.value;
  //   guests.value = count;

  //   // Update food quantities if package is edited
  //   if (isCustomEditing.value && selectedPackage.value.isNotEmpty) {
  //     for (int i = 0; i < selectedMenuItems.length; i++) {
  //       selectedMenuItems[i] = SelectedMenuItem(
  //         menuItemId: selectedMenuItems[i].menuItemId,
  //         name: selectedMenuItems[i].name,
  //         price: selectedMenuItems[i].price,
  //         qty: count, // Update to new guest count
  //         id: selectedMenuItems[i].id,
  //         isDeleted: selectedMenuItems[i].isDeleted,
  //       );
  //     }
  //     selectedMenuItems.refresh();

  //     // Update custom selection
  //     if (_customSelections.containsKey(selectedPackage.value)) {
  //       for (var foodItem
  //           in _customSelections[selectedPackage.value]!['Food Items']!) {
  //         foodItem['qty'] = count;
  //       }
  //     }
  //   }
  // }

  // Enhanced menuForPackage method for edit screen
  Map<String, List<Map<String, dynamic>>> menuForPackage(
    String packageTitle,
    int guestCount,
  ) {
    // If user has a saved custom selection for this package, use it
    final saved = _customSelections[packageTitle];
    final isEdited = packageEdited[packageTitle] == true;

    if (saved != null && isEdited) {
      // For edited packages, update food quantities based on guest count
      final food = <Map<String, dynamic>>[];
      final services = <Map<String, dynamic>>[];

      // Update food items with new guest count
      for (final item in (saved['Food Items'] ?? [])) {
        final int qty = guestCount; // Always use current guest count for food
        final normalized = Map<String, dynamic>.from(item);
        normalized['qty'] = qty;
        food.add(normalized);
      }

      // Keep service quantities as they were
      for (final item in (saved['Services'] ?? [])) {
        final int qty = (item['qty'] is int)
            ? item['qty'] as int
            : int.tryParse(item['qty']?.toString() ?? '') ?? 1;
        final normalized = Map<String, dynamic>.from(item);
        normalized['qty'] = qty;
        services.add(normalized);
      }

      return {'Food Items': food, 'Services': services};
    }

    // Return original package menu
    return _getOriginalPackageMenu(packageTitle, guestCount);
  }

  // Find package by title
  Package? _findPackage(String title) {
    try {
      return apiPackages.firstWhere((p) => p.title == title);
    } catch (e) {
      return null;
    }
  }

  // Check if package is API package (not custom)
  bool _isApiPackage(String packageTitle) {
    final pkg = _findPackage(packageTitle);
    return pkg?.id != null && pkg!.id! > 0;
  }

  // Initialize package state when loading order
  void _initializePackageStateFromOrder() {
    if (currentOrderPackages.isNotEmpty) {
      final orderPackage = currentOrderPackages.first;
      final packageTitle = orderPackage.package?.title ?? '';

      if (packageTitle.isNotEmpty) {
        selectedPackage.value = packageTitle;
        selectedPackageId.value = orderPackage.packageId?.toString() ?? '';

        // Check if package is custom
        final isCustom = orderPackage.isCustom ?? false;
        packageEdited[packageTitle] = isCustom;
        isCustomEditing.value = isCustom;

        if (isCustom) {
          // Build custom selection from order items
          final customMenu = _buildCustomMenuFromOrder();
          _customSelections[packageTitle] = customMenu;
        }
      }
    }
  }

  // Build custom menu from order items
  Map<String, List<Map<String, dynamic>>> _buildCustomMenuFromOrder() {
    final food = <Map<String, dynamic>>[];
    final services = <Map<String, dynamic>>[];

    // Build from order package items
    for (var orderPackage in currentOrderPackages) {
      if (orderPackage.orderPackageItems != null) {
        for (var packageItem in orderPackage.orderPackageItems!) {
          if (packageItem.menuItem != null &&
              !(packageItem.isDeleted ?? false)) {
            final menuItem = packageItem.menuItem!;
            final isService = currentOrderServices.any(
              (service) => service.service?.id == menuItem.id,
            );

            final entry = {
              'name': menuItem.title ?? 'Unknown Item',
              'price': menuItem.price ?? '0',
              'qty': int.tryParse(packageItem.noOfGust ?? '1') ?? 1,
              'menu_item_id': menuItem.id,
              'id': packageItem.id,
            };

            if (!isService) {
              food.add(entry);
            } else {
              services.add(entry);
            }
          }
        }
      }
    }

    // Add services from order services
    for (var orderService in currentOrderServices) {
      if (orderService.service != null && !(orderService.isDeleted ?? false)) {
        services.add({
          'name': orderService.service!.title ?? 'Unknown Service',
          'price': orderService.service!.price ?? '0',
          'qty': 1,
          'menu_item_id': orderService.service!.id,
          'id': orderService.id,
        });
      }
    }

    return {'Food Items': food, 'Services': services};
  }
}

// ===========================================================================
// SUPPORTING MODELS FOR SELECTED ITEMS
// ===========================================================================

/// Model for selected menu items in UI
class SelectedMenuItem {
  final int? menuItemId;
  final String name;
  final String price;
  final int qty;
  final int? id;
  final bool isDeleted;

  SelectedMenuItem({
    required this.menuItemId,
    required this.name,
    required this.price,
    required this.qty,
    this.id,
    required this.isDeleted,
  });

  /// Convert to API format
  Map<String, dynamic> toApiMap() {
    return {
      if (id != null) "id": id,
      "menu_item_id": menuItemId?.toString() ?? '',
      "price": price,
      "qty": qty,
      "is_deleted": isDeleted,
    };
  }
}

/// Model for selected service items in UI
class SelectedServiceItem {
  final int? serviceId;
  final String title;
  final String price;
  final int qty;
  final int? id;
  final bool isDeleted;

  SelectedServiceItem({
    required this.serviceId,
    required this.title,
    required this.price,
    required this.qty,
    this.id,
    required this.isDeleted,
  });

  /// Convert to API format
  Map<String, dynamic> toApiMap() {
    return {
      if (id != null) "id": id,
      "menu_item_id": serviceId?.toString() ?? '',
      "price": price,
      "qty": qty,
      "is_deleted": isDeleted,
    };
  }
}
