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

    // Build food items from packages
    for (var orderPackage in currentOrderPackages) {
      if (orderPackage.orderPackageItems != null) {
        for (var packageItem in orderPackage.orderPackageItems!) {
          if (packageItem.menuItem != null &&
              !(packageItem.isDeleted ?? false)) {
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

      print('Sending update order data: ${jsonEncode(body)}');

      // Call API to update order
      final response = await ApiService.updateOrder(
        orderId: orderId,
        EditOrderModel: body,
      );

      if (response['success'] == true) {
        print('✅ Order updated successfully');
        // Reload to reflect server-side changes
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

    return order;
  }

  /// Prepare API payload with order data and selected items
  Map<String, dynamic> _prepareApiPayload(EditOrderModel order) {
    final orderJson = order.toJson();

    // Convert selected items to API format
    orderJson['order_services_attributes'] = _getOrderServicesForApi();
    orderJson['order_packages_attributes'] = _getOrderPackagesForApi();

    return {"order": orderJson};
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

  /// Convert selected menu items to API format
  List<Map<String, dynamic>> _getOrderServicesForApi() {
    if (selectedMenuItems.isNotEmpty) {
      return selectedMenuItems.map((item) => item.toApiMap()).toList();
    }

    // Fallback to current order services
    return currentOrderServices
        .where((service) => service.isDeleted != true)
        .map((service) {
          if (service.menuItemId == null) return <String, dynamic>{};

          return {
            if (service.id != null) "id": service.id,
            "menu_item_id": service.menuItemId,
            "price": service.price ?? 0,
            "is_deleted": service.isDeleted ?? false,
          };
        })
        .where((item) => item.isNotEmpty)
        .toList();
  }

  /// Convert selected service items to API format
  List<Map<String, dynamic>> _getOrderPackagesForApi() {
    if (selectedServiceItems.isNotEmpty) {
      return selectedServiceItems.map((item) => item.toApiMap()).toList();
    }

    // Fallback to current order packages
    return currentOrderPackages
        .where((package) => package.isCustom != true)
        .map((package) {
          if (package.packageId == null) return <String, dynamic>{};

          // Convert package items
          final List<Map<String, dynamic>> packageItems = [];
          if (package.orderPackageItems != null) {
            for (var item in package.orderPackageItems!) {
              if (item.isDeleted == true) continue;
              if (item.menuItemId == null) continue;

              packageItems.add({
                if (item.id != null) "id": item.id,
                "menu_item_id": item.menuItemId,
                "price": item.price ?? '0',
                "no_of_gust": item.noOfGust ?? '1',
                "is_deleted": item.isDeleted ?? false,
              });
            }
          }

          return {
            if (package.id != null) "id": package.id,
            "package_id": package.packageId,
            "amount": package.amount ?? "0",
            "is_custom": package.isCustom ?? false,
            "order_package_items_attributes": packageItems,
          };
        })
        .where((item) => item.isNotEmpty)
        .toList();
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
    selectedPackage.value = packageTitle;
    final packageData = apiPackages.firstWhere(
      (p) => p.title == packageTitle,
      orElse: () => Package(),
    );
    selectedPackageId.value = packageData.id?.toString() ?? '';
  }

  // Date and time setters
  void setDate(DateTime date) => selectedDate.value = date;
  void setStartTime(TimeOfDay time) => startTime.value = time;
  void setEndTime(TimeOfDay time) => endTime.value = time;
  void setGuests(int count) => guests.value = count;
  void incrementGuests() => guests.value += 1;
  void decrementGuests() => guests.value = (guests.value - 1).clamp(1, 10000);

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
