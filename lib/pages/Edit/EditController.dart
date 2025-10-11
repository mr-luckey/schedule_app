
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schedule_app/APIS/Api_Service.dart';
import 'package:schedule_app/pages/Edit/models/EditModel.dart';
import 'package:schedule_app/pages/Edit/models/MenuItem.dart' hide MenuItem;
import 'package:schedule_app/pages/Edit/models/model.dart';

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
  
  // Store raw API package data for accessing package_items
  final RxList<Map<String, dynamic>> rawApiPackages = <Map<String, dynamic>>[].obs;

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
  
  // Custom package menu (like booking controller)
  final Map<String, List<Map<String, dynamic>>> _customPackageMenu = {
    'Food Items': <Map<String, dynamic>>[],
    'Services': <Map<String, dynamic>>[],
  };

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
    print('🔄 Loading packages from API...');
    final packagesResult = await ApiService.getPackages();
    print('📦 Packages API response: $packagesResult');
    
    if (packagesResult['success'] == true) {
      final packagesData = packagesResult['data'];
      print('📦 Packages data: $packagesData');
      
      if (packagesData is List) {
        // Store raw API data for accessing package_items
        rawApiPackages.value = packagesData.cast<Map<String, dynamic>>();
        apiPackages.value = packagesData
            .map((pkgJson) => Package.fromJson(pkgJson))
            .toList();
        print('✅ Loaded ${apiPackages.length} packages from List format');
      } else if (packagesData is Map && packagesData['packages'] is List) {
        // Store raw API data for accessing package_items
        rawApiPackages.value = (packagesData['packages'] as List)
            .cast<Map<String, dynamic>>();
        apiPackages.value = (packagesData['packages'] as List)
            .map((pkgJson) => Package.fromJson(pkgJson))
            .toList();
        print('✅ Loaded ${apiPackages.length} packages from Map format');
      } else {
        print('❌ Unexpected packages data format: ${packagesData.runtimeType}');
      }
    } else {
      print('❌ Failed to load packages: ${packagesResult['error']}');
    }
    
    print('📦 Final packages count: ${apiPackages.length}');
    print('📦 Final raw packages count: ${rawApiPackages.length}');
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
  List<Package> get packages {
    print('📦 Getting packages: ${apiPackages.length} packages available');
    return apiPackages.toList();
  }

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

        // Debug: Print order packages data
        print('🔍 Order packages debug:');
        for (var pkg in currentOrderPackages) {
          print('  Package ID: ${pkg.packageId}');
          print('  Package Title: ${pkg.package?.title}');
          print('  Is Custom: ${pkg.isCustom}');
          print('  Amount: ${pkg.amount}');
        }

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

    // Package - Don't set here, let _initializePackageStateFromOrder handle it
    // This ensures custom packages are properly detected
    selectedPackage.value = '';
    selectedPackageId.value = '';
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

    // Case 1: User picked a different package -> push new package_id and items
    if (selectedPkgId.isNotEmpty &&
        selectedPkgId != currentPkgId &&
        !isCustomEditing.value) {
      // Check if the selected package is "Custom Package"
      final isCustomPackage = selectedPackage.value == 'Custom Package';
      
      // Get items for the new package
      final List<Map<String, dynamic>> packageItems = [];
      
      if (isCustomPackage) {
        // For custom package, send current selected items
        for (final m in selectedMenuItems) {
          packageItems.add({
            "menu_item_id": m.menuItemId?.toString() ?? '',
            "price": m.price,
            "no_of_gust": m.qty.toString(),
            "is_deleted": false,
          });
        }
        for (final s in selectedServiceItems) {
          packageItems.add({
            "menu_item_id": s.serviceId?.toString() ?? '',
            "price": s.price,
            "no_of_gust": s.qty.toString(),
            "is_deleted": false,
          });
        }
      }
      
      return [
        {
          if (pkg.id != null) "id": pkg.id,
          "package_id": selectedPkgId,
          "is_custom": isCustomPackage,
          if (packageItems.isNotEmpty) "order_package_items_attributes": packageItems,
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
        hasQuantityChange ||
        selectedPackage.value == 'Custom Package';

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
    print('🔄 setPackage called with: $packageTitle');
    print('🔄 Current package: ${selectedPackage.value}');
    print('🔄 Current custom editing: ${isCustomEditing.value}');
    
    // Save current package state before switching
    if (selectedPackage.value.isNotEmpty &&
        selectedPackage.value != packageTitle &&
        isCustomEditing.value) {
      print('🔄 Saving current package state before switching');
      _saveCurrentPackageState();
    }

    selectedPackage.value = packageTitle;
    print('🔄 New package set: $packageTitle');

    // Find and set the package ID - ensure we match by title exactly
    final packageData = apiPackages.firstWhere(
      (p) => p.title == packageTitle,
      orElse: () => Package(),
    );
    selectedPackageId.value = packageData.id?.toString() ?? '';
    print('🔄 Package ID set: ${selectedPackageId.value}');

    // Initialize edit state for this package if not exists
    if (!packageEdited.containsKey(packageTitle)) {
      packageEdited[packageTitle] = false;
    }

    // Check if we're loading an existing custom package from order
    final isExistingCustom =
        currentOrderPackages.isNotEmpty &&
        currentOrderPackages.first.isCustom == true &&
        currentOrderPackages.first.package?.title == packageTitle;

    print('🔄 Is existing custom: $isExistingCustom');
    print('🔄 Has custom selection: ${_customSelections.containsKey(packageTitle)}');

    // Load custom selection if exists or it's an existing custom package, otherwise load API package items
    if (_customSelections.containsKey(packageTitle) || isExistingCustom) {
      print('🔄 Loading custom menu');
      final customMenu =
          _customSelections[packageTitle] ?? _buildCustomMenuFromOrder();
      _updateSelectedItemsFromMenu(customMenu);
      packageEdited[packageTitle] = true;
      isCustomEditing.value = true;
    } else {
      print('🔄 Loading API package items');
      // Load API package items for the selected package and reset data
      _loadAndResetPackageData(packageTitle, guests.value);
    }
  }

  // Date and time setters
  void setDate(DateTime date) => selectedDate.value = date;
  void setStartTime(TimeOfDay time) => startTime.value = time;
  void setEndTime(TimeOfDay time) => endTime.value = time;
  void incrementGuests() {
    guests.value += 1;
    if (isCustomEditing.value && selectedPackage.value.isNotEmpty) {
      _updateFoodQuantitiesForCustomPackage(guests.value);
    }
  }

  void decrementGuests() {
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


  // Update selected items from menu
  void _updateSelectedItemsFromMenu(
    Map<String, List<Map<String, dynamic>>> menu,
  ) {
    print('🔄 _updateSelectedItemsFromMenu called');
    print('🔄 Menu data: ${menu['Food Items']?.length} food, ${menu['Services']?.length} services');
    
    // Clear current selections
    selectedMenuItems.clear();
    selectedServiceItems.clear();
    print('🔄 Cleared current selections');

    // Add food items
    for (var foodItem in menu['Food Items']!) {
      print('🔄 Adding food item: ${foodItem['name']}');
      selectedMenuItems.add(
        SelectedMenuItem(
          menuItemId: int.tryParse(foodItem['menu_item_id']?.toString() ?? '0') ?? 0,
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
      print('🔄 Adding service item: ${serviceItem['name']}');
      selectedServiceItems.add(
        SelectedServiceItem(
          serviceId: int.tryParse(serviceItem['menu_item_id']?.toString() ?? '0') ?? 0,
          title: serviceItem['name'],
          price: serviceItem['price'].toString(),
          qty: serviceItem['qty'],
          id: null, // Will be set by API
          isDeleted: false,
        ),
      );
    }

    print('🔄 Final counts - Food: ${selectedMenuItems.length}, Services: ${selectedServiceItems.length}');

    // Trigger UI update
    selectedMenuItems.refresh();
    selectedServiceItems.refresh();
    update();
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



  // Initialize package state when loading order
  void _initializePackageStateFromOrder() {
    print('🔄 _initializePackageStateFromOrder called');
    print('🔄 Current order packages: ${currentOrderPackages.length}');
    print('🔄 Available packages: ${packages.length}');
    
    if (currentOrderPackages.isNotEmpty) {
      final orderPackage = currentOrderPackages.first;
      final packageTitle = orderPackage.package?.title ?? '';
      final isCustom = orderPackage.isCustom ?? false;
      
      print('🔄 Order package title: $packageTitle');
      print('🔄 Order package isCustom: $isCustom');
      print('🔄 Order package ID: ${orderPackage.packageId}');
      
      if (isCustom) {
        print('🔄 Setting as Custom Package');
        // If package is custom, set as Custom Package
        selectedPackage.value = 'Custom Package';
        
        // Find custom package ID from API packages
        print('🔍 Available packages for custom lookup:');
        for (var pkg in packages) {
          print('  Package: ${pkg.title} (ID: ${pkg.id})');
        }
        
        final customPkg = packages.firstWhere(
          (pkg) => pkg.title == 'Custom Package',
          orElse: () => Package(),
        );
        selectedPackageId.value = customPkg.id?.toString() ?? '';
        
        print('🔄 Custom package ID found: ${selectedPackageId.value}');
        
        packageEdited['Custom Package'] = true;
        isCustomEditing.value = true;
        
        // Build custom selection from order items
        final customMenu = _buildCustomMenuFromOrder();
        _customSelections['Custom Package'] = customMenu;
      } else if (packageTitle.isNotEmpty) {
        print('🔄 Setting as regular package: $packageTitle');
        // Regular package
        selectedPackage.value = packageTitle;
        selectedPackageId.value = orderPackage.packageId?.toString() ?? '';
        packageEdited[packageTitle] = false;
        isCustomEditing.value = false;
      }
      
      print('🔄 Final selected package: ${selectedPackage.value}');
      print('🔄 Final selected package ID: ${selectedPackageId.value}');
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

  // ===========================================================================
  // CUSTOM PACKAGE METHODS (matching booking controller)
  // ===========================================================================

  /// Create or open custom package (like booking controller)
  void createOrOpenCustomPackage() {
    const customTitle = 'Custom Package';
    
    // Switch to custom package
    selectedPackage.value = customTitle;
    selectedPackageId.value = 'custom';
    isCustomEditing.value = true;
    
    update();
  }

  /// Update custom package items (like booking controller)
  void updateCustomPackageItems(
    String packageTitle,
    Map<String, List<Map<String, dynamic>>> newMenu,
  ) {
    if (packageTitle == 'Custom Package') {
      _customPackageMenu['Food Items'] = (newMenu['Food Items'] ?? [])
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
      _customPackageMenu['Services'] = (newMenu['Services'] ?? [])
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
    
    update();
  }

  /// Switch to custom package and update (like booking controller)
  void switchToCustomPackageAndUpdate(
    Map<String, List<Map<String, dynamic>>> currentMenu,
  ) {
    // Switch to custom package
    createOrOpenCustomPackage();
    
    // Update custom package with current menu
    updateCustomPackageItems('Custom Package', currentMenu);
    
    // Mark as edited
    isCustomEditing.value = true;
    
    // Refresh UI
    update();
  }

  /// Toggle edit mode (like booking controller)
  void toggleEditMode(bool editing) {
    isCustomEditing.value = editing;
  }

  /// Reset to original package (like booking controller)
  void resetToOriginalPackage() {
    if (selectedPackage.value.isEmpty) return;

    // Clear any custom selections
    _customPackageMenu['Food Items']!.clear();
    _customPackageMenu['Services']!.clear();
    
    // Reset to original package
    isCustomEditing.value = false;
    selectedPackage.value = ''; // Will be set to original package
    
    // Reload the original package menu
    final currentGuests = guests.value > 0 ? guests.value : 1;
    final originalMenu = _getOriginalPackageMenu(selectedPackage.value, currentGuests);
    
    // Update selected items from original menu
    _updateSelectedItemsFromMenu(originalMenu);
    
    update();
  }


  /// Get original package items for display (like booking controller)
  Map<String, List<Map<String, dynamic>>> getOriginalPackageItems() {
    if (currentOrderPackages.isEmpty) {
      return {'Food Items': [], 'Services': []};
    }

    final orderPackage = currentOrderPackages.first;
    final packageTitle = orderPackage.package?.title ?? '';
    
    if (packageTitle.isEmpty) {
      return {'Food Items': [], 'Services': []};
    }

    return _getOriginalPackageMenu(packageTitle, guests.value);
  }

  /// Check if currently in custom package mode
  bool get isInCustomPackageMode {
    return isCustomEditing.value && selectedPackage.value == 'Custom Package';
  }





  /// Load API package items and reset data (like booking controller)
  void _loadAndResetPackageData(String packageTitle, int guestCount) {
    print('🔄 _loadAndResetPackageData called for: $packageTitle with $guestCount guests');
    
    // First, copy current items to custom package if we have any
    if (selectedMenuItems.isNotEmpty || selectedServiceItems.isNotEmpty) {
      print('🔄 Copying current items to custom package');
      _copyCurrentItemsToCustomPackage();
    }

    // Load API package items for the selected package (like booking controller)
    print('🔄 Getting original package menu from API');
    final apiPackageItems = _getOriginalPackageMenu(packageTitle, guestCount);
    print('🔄 API package items loaded: ${apiPackageItems['Food Items']?.length} food, ${apiPackageItems['Services']?.length} services');
    
    // Reset to show API package items
    print('🔄 Updating selected items from menu');
    _updateSelectedItemsFromMenu(apiPackageItems);
    packageEdited[packageTitle] = false;
    isCustomEditing.value = false;
    
    print('🔄 Package data reset complete');
    update();
  }

  /// Copy current items to custom package (like booking controller)
  void _copyCurrentItemsToCustomPackage() {
    final currentMenu = {
      'Food Items': selectedMenuItems
          .map((item) => {
                'name': item.name,
                'price': item.price,
                'qty': item.qty,
                'menu_item_id': item.menuItemId,
                'id': item.id,
              })
          .toList(),
      'Services': selectedServiceItems
          .map((item) => {
                'name': item.title,
                'price': item.price,
                'qty': item.qty,
                'menu_item_id': item.serviceId,
                'id': item.id,
              })
          .toList(),
    };

    // Save to custom selections
    _customSelections[selectedPackage.value] = currentMenu;
    packageEdited[selectedPackage.value] = true;
  }

  /// Get original package menu (like booking controller)
  Map<String, List<Map<String, dynamic>>> _getOriginalPackageMenu(
    String packageTitle,
    int guestCount,
  ) {
    print('🔍 Getting original package menu for: $packageTitle');
    print('🔍 Available packages: ${rawApiPackages.map((p) => p['title']).toList()}');
    
    // Find the package in raw API data
    final pkg = rawApiPackages.firstWhere(
      (p) => p['title']?.toString() == packageTitle,
      orElse: () => <String, dynamic>{},
    );

    print('🔍 Found package: $pkg');

    if (pkg.isEmpty) {
      print('❌ Package not found in rawApiPackages');
      return {'Food Items': [], 'Services': []};
    }

    // Check what fields are available in the package
    print('🔍 Package keys: ${pkg.keys.toList()}');
    print('🔍 Package items field: ${pkg['items']}');
    print('🔍 Package package_items field: ${pkg['package_items']}');

    // Parse package items using the same logic as booking controller
    List<Map<String, dynamic>> rawItems = _parsePackageItems(pkg);
    print('✅ Parsed ${rawItems.length} items from package');
    
    if (rawItems.isEmpty) {
      print('❌ No items found in package data');
      return {'Food Items': [], 'Services': []};
    }
    
    final food = <Map<String, dynamic>>[];
    final services = <Map<String, dynamic>>[];

    for (var item in rawItems) {
      print('🔍 Processing item: $item');
      final name = item['name'] as String? ?? item['title'] as String? ?? 'Unknown Item';
      final price = (item['price'] as num?)?.toDouble() ?? 0.0;
      final qtyStored = (item['qty'] is int)
          ? item['qty'] as int
          : (item['qty'] is double ? (item['qty'] as double).toInt() : 1);

      // Check if it's a food item or service
      final isFood = _isFoodItem(name);
      final finalQty = isFood ? guestCount : qtyStored;

      final entry = {
        'name': name,
        'price': price,
        'qty': finalQty,
        'menu_item_id': item['menu_item_id'] ?? item['id'],
        'id': null, // Will be set when saved
      };

      print('🔍 Item processed: $entry (isFood: $isFood)');

      if (isFood) {
        food.add(Map<String, dynamic>.from(entry));
      } else {
        services.add(Map<String, dynamic>.from(entry));
      }
    }

    print('✅ Final result - Food: ${food.length}, Services: ${services.length}');
    return {'Food Items': food, 'Services': services};
  }

  /// Parse package items using the same logic as booking controller
  List<Map<String, dynamic>> _parsePackageItems(Map<String, dynamic> package) {
    try {
      final items = <Map<String, dynamic>>[];

      // Parse package_items from API response
      if (package['package_items'] is List) {
        for (var packageItem in package['package_items'] as List) {
          if (packageItem is Map<String, dynamic> &&
              packageItem['menu_item'] is Map<String, dynamic>) {
            final menuItem = packageItem['menu_item'] as Map<String, dynamic>;
            items.add({
              'name': menuItem['title']?.toString() ?? 'Unknown Item',
              'price': _parsePriceString(menuItem['price']?.toString()),
              'qty': 1,
              'menu_item_id': menuItem['id']?.toString(),
            });
          }
        }
      }
      // Fallback to existing parsing for other structures
      else if (package['items'] is List) {
        for (var item in package['items'] as List) {
          items.add({
            'name': item['name']?.toString(),
            'price': (item['price'] as num?)?.toDouble() ?? 0.0,
            'qty': (item['quantity'] as int?) ?? (item['qty'] as int?) ?? 1,
            'menu_item_id': (item['menu_item_id'] ?? item['id'])?.toString(),
          });
        }
      }

      return items;
    } catch (e) {
      print('❌ Error parsing package items: $e');
      return [];
    }
  }

  /// Parse price string (like booking controller)
  double _parsePriceString(String? priceStr) {
    if (priceStr == null) return 0.0;
    final cleaned = priceStr.replaceAll(RegExp(r'[^0-9.]'), '');
    if (cleaned.isEmpty) return 0.0;
    return double.tryParse(cleaned) ?? 0.0;
  }

  /// Check if an item is a food item (like booking controller)
  bool _isFoodItem(String itemName) {
    // Check if the item exists in food categories
    for (var category in apiMenuCategories) {
      if (category.menuItems != null) {
        for (var menuItem in category.menuItems!) {
          if (menuItem.title == itemName) {
            return true;
          }
        }
      }
    }
    return false;
  }
}

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
