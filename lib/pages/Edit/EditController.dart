import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schedule_app/APIS/Api_Service.dart';
import 'package:schedule_app/pages/Edit/models/model.dart';
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

  // Selected items lists (new)
  final RxList<Map<String, dynamic>> selectedMenuItems =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> selectedServiceItems =
      <Map<String, dynamic>>[].obs; // services

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

      // Load packages from api to show as options..
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

      // Load menus list from api to show the item for choice
      final menusResult = await ApiService.getMenus();
      if (menusResult['success'] == true) {
        final menusData = menusResult['data'];
        if (menusData is List) {
          apiMenuItems.value = menusData.cast<Map<String, dynamic>>();
        }
      }

      // Load services list from api to show the items for choice
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

  // Get cities for dropdown from api to show
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
  } //TODO: Until here i am getting data from api to show

  // Load order data by ID then add deatils or remove details to add edited order
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

        // build selected lists so UI can reflect current selections
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

  // Set UI fields from model
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

    // Set city
    if (order.city != null) {
      selectedCity.value = order.city!.name ?? '';
      selectedCityId.value = order.cityId?.toString() ?? '';
    } else {
      selectedCity.value = '';
      selectedCityId.value = '';
    }

    // Set package from first package
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

  // Selected-items helpers (add/remove/clear)
  void addSelectedMenuItem({
    required dynamic menuItemId,
    String? name,
    String? price,
    int qty = 1,
    dynamic id,
  }) {
    final exists = selectedMenuItems.any(
      (m) => m['menu_item_id'].toString() == menuItemId.toString(),
    );
    if (!exists) {
      selectedMenuItems.add({
        "menu_item_id": menuItemId,
        "name": name ?? '',
        "price": price ?? '0',
        "qty": qty,
        if (id != null) "id": id,
        "is_deleted": false,
      });
    }
  }

  void removeSelectedMenuItemByMenuItemId(dynamic menuItemId) {
    selectedMenuItems.removeWhere(
      (m) => m['menu_item_id'].toString() == menuItemId.toString(),
    );
  }

  void clearSelectedMenuItems() => selectedMenuItems.clear();

  void addSelectedServiceItem({
    required dynamic serviceId,
    String? title,
    String? price,
    int qty = 1,
    dynamic id,
  }) {
    final exists = selectedServiceItems.any(
      (s) => s['menu_item_id'].toString() == serviceId.toString(),
    );
    if (!exists) {
      selectedServiceItems.add({
        "menu_item_id": serviceId,
        "title": title ?? '',
        "price": price ?? '0',
        "qty": qty,
        if (id != null) "id": id,
        "is_deleted": false,
      });
    }
  }

  void removeSelectedServiceItemById(dynamic serviceId) {
    selectedServiceItems.removeWhere(
      (s) => s['menu_item_id'].toString() == serviceId.toString(),
    );
  }

  void clearSelectedServiceItems() => selectedServiceItems.clear();

  /// Build selected lists from the currently loaded order (call after loadOrderById)
  void _buildSelectedListsFromCurrentOrder() {
    selectedMenuItems.clear();
    selectedServiceItems.clear();

    // Build food items from packages (same logic you used earlier)
    for (var orderPackage in currentOrderPackages) {
      if (orderPackage.orderPackageItems != null) {
        for (var packageItem in orderPackage.orderPackageItems!) {
          if (packageItem.menuItem != null &&
              !(packageItem.isDeleted ?? false)) {
            selectedMenuItems.add({
              "menu_item_id": packageItem.menuItem!.id,
              "name": packageItem.menuItem!.title ?? '',
              "price": packageItem.menuItem!.price ?? '0',
              "qty": int.tryParse(packageItem.noOfGust ?? '1') ?? 1,
              "id": packageItem.id,
              "is_deleted": packageItem.isDeleted ?? false,
            });
          }
        }
      }
    }

    // Build services
    for (var orderService in currentOrderServices) {
      if (orderService.service != null && !(orderService.isDeleted ?? false)) {
        selectedServiceItems.add({
          "menu_item_id": orderService.service!.id,
          "title": orderService.service!.title ?? '',
          "price": orderService.service!.price ?? '0',
          "qty": 1,
          "id": orderService.id,
          "is_deleted": orderService.isDeleted ?? false,
        });
      }
    }
  }

  // Replace your existing completeEdit() with this:
  Future<bool> completeEdit() async {
    try {
      if (currentEditOrder.value == null) {
        errorMessage.value = 'No order data loaded';
        return false;
      }

      final orderId = currentEditOrder.value!.id!;
      isLoading.value = true;
      errorMessage.value = '';

      // Helper formatters (kept from your original)
      String formatDateForApi(DateTime? date) {
        if (date == null) return '';
        return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      }

      String formatTimeForApi(TimeOfDay? time) {
        if (time == null) return '';
        return "2000-01-01T${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00.000Z";
      }

      // Get the model instance and update its fields from the form
      final edit = currentEditOrder.value!;

      // Name split logic (keeps your existing behavior)
      final nameParts = splitName(nameController.text.trim());
      edit.firstname = nameParts[0];
      edit.lastname = nameParts[1];

      // Basic contact info
      edit.email = emailController.text;
      edit.phone = contactController.text;

      // Keep existing nin if present; or keep your fallback (you can change)
      edit.nin = edit.nin ?? "123456789";

      // Numeric IDs (convert string -> int when possible)
      edit.cityId = int.tryParse(selectedCityId.value) ?? edit.cityId ?? 1;
      edit.address = selectedCity.value;
      edit.eventId = int.tryParse(selectedEventId.value) ?? edit.eventId ?? 1;

      // Guests and requirement
      edit.noOfGust = guests.value.toString();
      edit.requirement = specialRequirementsController.text.isEmpty
          ? "No special requirements"
          : specialRequirementsController.text;

      // Dates and times (store as formatted strings as your model expects)
      edit.eventDate = formatDateForApi(selectedDate.value);
      edit.eventTime = formatTimeForApi(startTime.value);
      edit.startTime = formatTimeForApi(startTime.value);
      edit.endTime = formatTimeForApi(endTime.value);

      // Payment / inquiry flags
      edit.paymentMethodId = 1;
      // preserve existing isInquiry if present
      edit.isInquiry = edit.isInquiry ?? false;

      // Attach the current order services & packages (these are model instances)
      // Ensure currentOrderServices/currentOrderPackages are the same model types as the model file.
      edit.orderServices = List<OrderServices>.from(currentOrderServices);
      edit.orderPackages = List<OrderPackages>.from(currentOrderPackages);

      // Prepare payload lists from selected items (fallback to helpers if empty)
      final List<Map<String, dynamic>> orderServicesData =
          selectedMenuItems.isNotEmpty
          ? selectedMenuItems.map((m) {
              return {
                if (m['id'] != null) "id": m['id'],
                "menu_item_id": m['menu_item_id']?.toString() ?? '',
                "price": m['price']?.toString() ?? '0',
                "qty": m['qty'] ?? 1,
                "is_deleted": m['is_deleted'] ?? false,
              };
            }).toList()
          : _getOrderServicesForApi();

      final List<Map<String, dynamic>> orderPackagesData =
          selectedServiceItems.isNotEmpty
          ? selectedServiceItems.map((s) {
              return {
                if (s['id'] != null) "id": s['id'],
                "menu_item_id": s['menu_item_id']?.toString() ?? '',
                "price": s['price']?.toString() ?? '0',
                "qty": s['qty'] ?? 1,
                "is_deleted": s['is_deleted'] ?? false,
              };
            }).toList()
          : _getOrderPackagesForApi();

      // Build final body from model.toJson() and inject the selected lists (override)
      final Map<String, dynamic> editJson = edit.toJson();
      editJson['order_services_attributes'] = orderServicesData;
      editJson['order_packages_attributes'] = orderPackagesData;
      final body = {"order": editJson};

      print('Sending update order data: ${jsonEncode(body)}');

      // Call API (keeps your parameter name the same)
      final response = await ApiService.updateOrder(
        orderId: orderId,
        EditOrderModel: body,
      );

      if (response['success'] == true) {
        print('✅ Order updated successfully');
        // reload to reflect any server-side mutations
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

  // Helper method to get order services for API (existing)
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

  // Helper method to get order packages for API (existing)
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

              final int? itemId = item.id;
              final String priceStr = item.price ?? '0';
              final String qtyStr = item.noOfGust ?? '1';

              packageItems.add({
                if (itemId != null) "id": itemId,
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
    selectedMenuItems.clear();
    selectedServiceItems.clear();
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
