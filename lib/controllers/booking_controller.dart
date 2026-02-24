import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:schedule_app/APIS/Api_Service.dart';
import 'package:schedule_app/pages/schedule_page.dart';
import 'package:schedule_app/widgets/Payment_Popup.dart';

import '../model/discount_model.dart';
import 'package:schedule_app/model/order/order_model.dart';

class BookingController extends GetxController {
  // Form controllers
  final RxList<Map<String, dynamic>> apiMenuItems =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> apiServiceItems =
      <Map<String, dynamic>>[].obs;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final contactController = TextEditingController();
  final messageController = TextEditingController();
  final specialRequirementsController = TextEditingController();
  final advancePaymentController = TextEditingController();
  RxBool isDiscountApplied = false.obs;

  // Form data
  final RxString selectedCity = ''.obs;
  final RxString selectedCityId = ''.obs;
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final Rx<TimeOfDay?> startTime = Rx<TimeOfDay?>(null);
  final Rx<TimeOfDay?> endTime = Rx<TimeOfDay?>(null);
  final Rx<String?> selectedTimeSlot = Rx<String?>(null);
  final List<String> timeSlots = [
    '11:00 AM - 1:00 PM',
    '1:00 PM - 3:00 PM',
    '5:00 PM - 7:00 PM',
    '7:00 PM - 9:00 PM',
  ];
  final RxInt guests = 1.obs;
  RxDouble advancePayment = 0.0.obs;
  final RxString selectedEventType = ''.obs;
  final RxString selectedEventId = ''.obs;
  final RxBool isPackageEditing = false.obs;
  final RxString selectedPackage = ''.obs;
  final RxString selectedPackageId = ''.obs;

  RxDouble discountAmount = 0.0.obs;
  // Prepare order services from the services in the menu
  List<Map<String, dynamic>> orderServices = [];

  // Form validation
  final RxBool isFormValid = false.obs;
  final RxInt confirmPressCount = 0.obs;

  // Store custom package menu separately
  final Map<String, List<Map<String, dynamic>>> _customPackageMenu = {
    'Food Items': [],
    'Services': [],
  };

  // API Data
  final RxList<Map<String, dynamic>> apiCities = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> apiEvents = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> apiPackages = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  var discounts = <Discount>[].obs;
  var selectedDiscount = Rx<Discount?>(null);

  @override
  void onInit() {
    super.onInit();
    loadApiData();

    // Listen to form changes for validation
    ever(selectedCity, (_) => validateBooking());
    ever(selectedDate, (_) => validateBooking());
    ever(selectedDate, (_) => validateBooking());
    ever(selectedTimeSlot, (_) => validateBooking());
    ever(guests, (_) => validateBooking());
    ever(selectedEventType, (_) => validateBooking());
    ever(selectedPackage, (_) => validateBooking());

    nameController.addListener(validateBooking);
    emailController.addListener(validateBooking);
    contactController.addListener(validateBooking);
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

  Future<void> getDiscounts() async {
    try {
      print("Getting discounts");
      isLoading.value = true;

      // Get headers with authentication token
      final Map<String, String> headers = await ApiService.getHeaders();

      final response = await http.get(
        Uri.parse(ApiService.getDiscounts),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final List<Discount> fetchedDiscounts = jsonData
            .map((discountJson) => Discount.fromJson(discountJson))
            .toList();

        discounts.value = [
          Discount(id: 0, title: "No Discount", val: "0.00", isPercent: false),
          ...fetchedDiscounts,
        ];

        // Set first discount as selected by default
        if (discounts.isNotEmpty) {
          selectedDiscount.value = discounts.first;
        }

        print("Successfully fetched ${discounts.length} discounts");
      } else {
        print("Error fetching discounts: Status code ${response.statusCode}");
        print("Response body: ${response.body}");
        discounts.value = [];
      }
    } catch (e) {
      print("Error fetching discounts: $e");
      discounts.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  void setSelectedDiscount(Discount? discount) {
    selectedDiscount.value = discount;
  }

  // Helper method to get discount value for calculations
  double getDiscountValue() {
    if (selectedDiscount.value == null) return 0.0;

    final discount = selectedDiscount.value!;
    if (discount.isPercent == true) {
      return double.tryParse(discount.val ?? '0') ?? 0.0;
    } else {
      // For fixed amount discounts
      return double.tryParse(discount.val ?? '0') ?? 0.0;
    }
  }

  // Load data from APIs
  Future<void> loadApiData() async {
    isLoading.value = true;
    errorMessage.value = '';
    getDiscounts();
    try {
      // Load menus
      final menusResult = await ApiService.getMenus();
      if (menusResult['success'] == true) {
        final menusData = menusResult['data'];
        if (menusData is List) {
          apiMenuItems.value = menusData.cast<Map<String, dynamic>>();
        } else {
          apiMenuItems.value = [];
        }
      } else {
        errorMessage.value += '\nFailed to load menus: ${menusResult['error']}';
      }

      // Load services
      final servicesResult = await ApiService.getServices();
      if (servicesResult['success'] == true) {
        final servicesData = servicesResult['data'];
        if (servicesData is List) {
          apiServiceItems.value = servicesData.cast<Map<String, dynamic>>();
        } else {
          apiServiceItems.value = [];
        }
      } else {
        errorMessage.value +=
            '\nFailed to load services: ${servicesResult['error']}';
      }

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
      } else {
        errorMessage.value = 'Failed to load cities: ${citiesResult['error']}';
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
      } else {
        errorMessage.value +=
            '\nFailed to load events: ${eventsResult['error']}';
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
      } else {
        errorMessage.value +=
            '\nFailed to load packages: ${packagesResult['error']}';
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
        'items': _parsePackageItems(pkg),
        'editable': pkg['editable'] ?? false,
      };
    }).toList();
  }

  List<Map<String, dynamic>> _parsePackageItems(Map<String, dynamic> package) {
    try {
      final items = <Map<String, dynamic>>[];

      // Parse nested package_titles from new API response
      if (package['package_titles'] is List) {
        for (var packageTitleObj in package['package_titles'] as List) {
          final pTitle = packageTitleObj['name']?.toString() ?? 'Default';
          final maxItem = packageTitleObj['max_item'];
          if (packageTitleObj['package_items'] is List) {
            for (var packageItem in packageTitleObj['package_items'] as List) {
              if (packageItem is Map<String, dynamic> &&
                  packageItem['menu_item'] is Map<String, dynamic>) {
                final menuItem =
                    packageItem['menu_item'] as Map<String, dynamic>;
                items.add({
                  'name': menuItem['title']?.toString() ?? 'Unknown Item',
                  'price': _parsePriceString(menuItem['price']?.toString()),
                  'qty': 1,
                  'menu_item_id': menuItem['id']?.toString(),
                  'packageTitle': pTitle,
                  'maxItem': maxItem,
                });
              }
            }
          }
        }
      }
      // Fallback: Parse direct package_items from legacy API response
      else if (package['package_items'] is List) {
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
          });
        }
      }

      return items;
    } catch (e) {
      return [];
    }
  }

  List<String> validateBooking() {
    final List<String> errors = [];

    if (nameController.text.trim().isEmpty) {
      errors.add("Customer name is required");
    }
    if (emailController.text.trim().isEmpty) {
      errors.add("Email address is required");
    }

    final contactValue = contactController.text.trim();
    final hasValidContact =
        contactValue.isNotEmpty &&
        contactValue.replaceAll(RegExp(r'[^0-9]'), '').length >= 8;
    if (!hasValidContact) {
      errors.add("A valid contact number is required");
    }

    if (selectedCity.value.isEmpty) {
      errors.add("Venue selection is required");
    }
    if (selectedEventType.value.isEmpty) {
      errors.add("Event type is required");
    }
    if (selectedDate.value == null) {
      errors.add("Event date is required");
    }
    if (startTime.value == null || endTime.value == null) {
      errors.add("Time slot selection is required");
    }
    if (guests.value <= 0) {
      errors.add("Number of guests must be at least 1");
    }
    if (selectedPackage.value.isEmpty) {
      errors.add("Package selection is required");
    }

    // Check minimum items for categories
    if (menu.containsKey('Food Items') && menu['Food Items'] != null) {
      final Map<String, List<Map<String, dynamic>>> itemsByTitle = {};
      for (var dish in menu['Food Items']!) {
        final title = dish['packageTitle']?.toString() ?? 'Other';
        itemsByTitle.putIfAbsent(title, () => []).add(dish);
      }

      for (var entry in itemsByTitle.entries) {
        final title = entry.key;
        final items = entry.value;

        if (title != 'Other' &&
            items.isNotEmpty &&
            items.first['minItem'] != null) {
          final minItem = int.tryParse(items.first['minItem'].toString()) ?? 0;
          if (items.length < minItem) {
            errors.add(
              "$title requires at least $minItem item(s). You have selected ${items.length}.",
            );
          }
        }
      }
    }

    // Still maintain the reactive bool for UI that might depend on it immediately
    isFormValid.value = errors.isEmpty;

    return errors;
  }

  // Form setters
  void updateName(String value) => nameController.text = value;
  void updateEmail(String value) => emailController.text = value;
  void updateContact(String value) => contactController.text = value;
  void updateMessage(String value) => messageController.text = value;
  void updateSpecialRequirements(String value) =>
      specialRequirementsController.text = value;

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
    // Always reset to original package when selecting
    selectedPackage.value = packageTitle;

    final packageData = packages.firstWhere(
      (p) => p['title'] == packageTitle,
      orElse: () => {},
    );
    selectedPackageId.value = packageData['id']?.toString() ?? '';

    // Reset editing state when switching packages
    isPackageEditing.value = false;
  }

  void setDate(DateTime date) => selectedDate.value = date;

  void setTimeSlot(String? slot) {
    selectedTimeSlot.value = slot;
    if (slot == '11:00 AM - 1:00 PM') {
      startTime.value = const TimeOfDay(hour: 11, minute: 0);
      endTime.value = const TimeOfDay(hour: 13, minute: 0);
    } else if (slot == '1:00 PM - 3:00 PM') {
      startTime.value = const TimeOfDay(hour: 13, minute: 0);
      endTime.value = const TimeOfDay(hour: 15, minute: 0);
    } else if (slot == '5:00 PM - 7:00 PM') {
      startTime.value = const TimeOfDay(hour: 17, minute: 0);
      endTime.value = const TimeOfDay(hour: 19, minute: 0);
    } else if (slot == '7:00 PM - 9:00 PM') {
      startTime.value = const TimeOfDay(hour: 19, minute: 0);
      endTime.value = const TimeOfDay(hour: 21, minute: 0);
    } else {
      startTime.value = null;
      endTime.value = null;
    }
  }

  void setStartTime(TimeOfDay time) => startTime.value = time;
  void setEndTime(TimeOfDay time) => endTime.value = time;
  void setGuests(int count) => guests.value = count;
  void incrementGuests() => guests.value += 1;
  void decrementGuests() => guests.value = (guests.value - 1).clamp(1, 10000);

  // --- Pricing helpers ---
  double _parsePriceString(String? priceStr) {
    if (priceStr == null) return 0.0;
    final cleaned = priceStr.replaceAll(RegExp(r'[^0-9.]'), '');
    if (cleaned.isEmpty) return 0.0;
    return double.tryParse(cleaned) ?? 0.0;
  }

  double calculateSubtotal() {
    if (selectedPackage.value.isEmpty) return 0.0;

    if (selectedPackage.value == 'Custom Package') {
      // For custom package, always calculate from items
      return calculateSubtotalFromItems();
    } else {
      // For regular packages, use package price
      final pkg = _findPackage(selectedPackage.value);
      if (pkg == null) return 0.0;
      final packagePrice = _parsePriceString(pkg['price']?.toString());
      return packagePrice * guests.value;
    }
  }

  double calculateServicesCost() {
    final menu = menuForPackage(
      selectedPackage.value,
      guests.value > 0 ? guests.value : 1,
    );

    double servicesCost = 0.0;
    for (var service in menu['Services']!) {
      servicesCost +=
          (service['price'] as num).toDouble() * (service['qty'] as int);
    }
    return servicesCost;
  }

  double calculateSubtotalFromItems() {
    Map<String, List<Map<String, dynamic>>> menu;

    // For custom packages, use _customPackageMenu directly
    if (selectedPackage.value == 'Custom Package') {
      menu = _customPackageMenu;
    } else {
      menu = menuForPackage(
        selectedPackage.value,
        guests.value > 0 ? guests.value : 1,
      );
    }

    double total = 0.0;

    final Map<String, List<Map<String, dynamic>>> itemsByTitle = {};
    for (var item in menu['Food Items']!) {
      final title = item['packageTitle']?.toString() ?? 'Other';
      itemsByTitle.putIfAbsent(title, () => []).add(item);
    }

    for (var entry in itemsByTitle.entries) {
      final title = entry.key;
      final items = entry.value;

      int maxItem = 999;
      if (title != 'Other' &&
          items.isNotEmpty &&
          items.first['maxItem'] != null) {
        maxItem = int.tryParse(items.first['maxItem'].toString()) ?? 999;
      }

      for (int i = 0; i < items.length; i++) {
        final item = items[i];
        if (title != 'Other' && i < maxItem) {
          // Included
          continue;
        }
        total += (item['price'] as num).toDouble() * (item['qty'] as int);
      }
    }
    return total;
  }

  double calculateTax() {
    return calculateSubtotal() * 0.08;
  }

  double calculateTotal() => calculateSubtotal() + calculateTax();

  String getTimeRange(BuildContext context) {
    if (startTime.value != null && endTime.value != null) {
      return '${startTime.value!.format(context)} - ${endTime.value!.format(context)}';
    } else if (startTime.value != null) {
      return '${startTime.value!.format(context)} - TBD';
    } else if (endTime.value != null) {
      return 'TBD - ${endTime.value!.format(context)}';
    } else {
      return 'TBD';
    }
  }

  bool isCurrentPackageCustomized() {
    return isPackageEditing.value && selectedPackage.value == 'Custom Package';
  }

  String getPackageDisplay() {
    final subtotal = calculateSubtotal();
    final perGuestCost = (subtotal / (guests.value > 0 ? guests.value : 1))
        .toStringAsFixed(0);

    if (selectedPackage.value == 'Custom Package') {
      return 'Custom Package - Â£$perGuestCost/Guest';
    } else {
      return '${selectedPackage.value} (Â£$perGuestCost/Guest)';
    }
  }

  // Confirmation UI
  Future<void> showBookingConfirmation() async {
    if (!isFormValid.value) {
      // Validation is handled in the UI layer
      return;
    }

    // Check availability before showing payment popup
    final isAvailable = await checkAvailability();
    if (!isAvailable) {
      // Error dialog is shown in checkAvailability
      return;
    }

    Get.dialog(
      PaymentPopup(
        eventName: selectedEventType.value,
        venue: selectedCity.value,
        date: selectedDate.value!,
        startTime: startTime.value!,
        endTime: endTime.value!,
        guests: guests.value,
        package: selectedPackage.value,
        totalAmount: totalAmount,
        customerName: nameController.text,
        customerEmail: emailController.text,
        onConfirm: completeBooking,
        onCancel: cancelBookingPopup,
      ),
    );
  }

  Future<bool> checkAvailability() async {
    isLoading.value = true;
    try {
      print("DEBUG: Starting availability check");
      final List<OrderModel> existingOrders = await ApiService.fetchOrders();
      print("DEBUG: Fetched ${existingOrders.length} orders");

      // Filter orders for the selected date
      final String selectedDateStr =
          "${selectedDate.value!.year}-${selectedDate.value!.month.toString().padLeft(2, '0')}-${selectedDate.value!.day.toString().padLeft(2, '0')}";
      print("DEBUG: Checking for date: $selectedDateStr");

      final ordersOnDate = existingOrders.where((order) {
        if (order.eventDate == null) return false;
        String orderDateStr = order.eventDate!;
        if (orderDateStr.contains('T')) {
          orderDateStr = orderDateStr.split('T')[0];
        }
        return orderDateStr == selectedDateStr;
      }).toList();

      print("DEBUG: Found ${ordersOnDate.length} orders on selected date");

      // Check for time overlap
      bool hasConflict = false;

      if (ordersOnDate.isNotEmpty) {
        final double newStart =
            startTime.value!.hour + startTime.value!.minute / 60.0;
        final double newEnd =
            endTime.value!.hour + endTime.value!.minute / 60.0;

        print("DEBUG: New booking time: $newStart - $newEnd");

        for (final order in ordersOnDate) {
          // Skip if the existing order is an inquiry (inquiries don't block anything)
          if (order.isInquiry == true) {
            continue;
          }

          String? sTime = order.startTime ?? order.eventTime;
          String? eTime = order.endTime;

          if (sTime != null && eTime != null) {
            try {
              DateTime orderStartDt = DateTime.parse(sTime);
              DateTime orderEndDt = DateTime.parse(eTime);

              double orderStart =
                  orderStartDt.hour + orderStartDt.minute / 60.0;
              double orderEnd = orderEndDt.hour + orderEndDt.minute / 60.0;

              print(
                "DEBUG: Order ${order.id} numeric: $orderStart - $orderEnd",
              );

              if (newStart < orderEnd && newEnd > orderStart) {
                print("DEBUG: Conflict detected with Order ${order.id}");
                hasConflict = true;
                break;
              }
            } catch (e) {
              print("DEBUG: Error parsing order time: $e");
            }
          }
        }
      }

      isLoading.value = false;

      if (hasConflict) {
        Get.dialog(
          Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Get.back(),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.red,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Time Slot Unavailable",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "This time slot is already booked. Please choose another time.",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Close"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        return false;
      }
      return true;
    } catch (e) {
      print("Error checking availability: $e");
      isLoading.value = false;
      // On error, maybe allow to proceed or show error?
      // Proceeding might cause double booking, safer to block or warn.
      // For now, let's treat error as available but log it, or allow user to retry.
      // Or show error dialog.
      Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
                const Icon(Icons.error_outline, color: Colors.orange, size: 48),
                const SizedBox(height: 16),
                const Text(
                  "Connection Error",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text("Could not check availability: $e"),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  child: const Text("Close"),
                ),
              ],
            ),
          ),
        ),
      );
      return false;
    }
  }

  late Map<String, List<Map<String, dynamic>>> menu;

  double get foodAndBeverageCost {
    // Check if package is custom (either currently editing or was edited and saved as custom)
    if (selectedPackage.value == 'Custom Package' ||
        (isPackageEditing.value && selectedPackage.value == 'Custom Package')) {
      return _calculateTotalFromItems();
    } else {
      final pkg = packages.firstWhere(
        (p) => p['title'] == selectedPackage.value,
        orElse: () => {},
      );
      final packagePrice = _parsePriceString(pkg['price']?.toString());
      final guestCount = guests.value;

      // Calculate additional cost from items exceeding maxItem
      double additionalCost = 0.0;
      final Map<String, List<Map<String, dynamic>>> itemsByTitle = {};

      if (menu.containsKey('Food Items') && menu['Food Items'] != null) {
        for (var dish in menu['Food Items']!) {
          final title = dish['packageTitle']?.toString() ?? 'Other';
          itemsByTitle.putIfAbsent(title, () => []).add(dish);
        }

        for (var entry in itemsByTitle.entries) {
          final title = entry.key;
          final items = entry.value;

          int maxItem = 999;
          if (title != 'Other' &&
              items.isNotEmpty &&
              items.first['maxItem'] != null) {
            maxItem = int.tryParse(items.first['maxItem'].toString()) ?? 999;
          }

          for (int i = 0; i < items.length; i++) {
            final dish = items[i];
            if (title != 'Other' && i < maxItem) {
              continue;
            }
            final price = (dish['price'] as num).toDouble();
            additionalCost += price * guestCount;
          }
        }
      }

      return (packagePrice * guestCount) + additionalCost;
    }
  }

  double _calculateTotalFromItems() {
    double total = 0.0;

    final Map<String, List<Map<String, dynamic>>> itemsByTitle = {};
    for (var dish in menu['Food Items']!) {
      final title = dish['packageTitle']?.toString() ?? 'Other';
      itemsByTitle.putIfAbsent(title, () => []).add(dish);
    }

    for (var entry in itemsByTitle.entries) {
      final title = entry.key;
      final items = entry.value;

      int maxItem = 999;
      if (title != 'Other' &&
          items.isNotEmpty &&
          items.first['maxItem'] != null) {
        maxItem = int.tryParse(items.first['maxItem'].toString()) ?? 999;
      }

      for (int i = 0; i < items.length; i++) {
        final dish = items[i];
        if (title != 'Other' && i < maxItem) {
          // Included
          continue;
        }
        final price = (dish['price'] as num).toDouble();
        // Additional items are multiplied by total guest count, NOT item qty
        total += price * guests.value;
      }
    }
    return total;
  }

  double get serviceCost {
    double total = 0.0;
    for (var service in menu['Services']!) {
      total += (service['price'] as num).toDouble() * (service['qty'] as int);
    }
    return total;
  }

  double get vat => 0.20 * foodAndBeverageCost;
  double get totalAmount =>
      (foodAndBeverageCost + serviceCost + vat) - discountAmount.value;

  void calculateDiscount(Discount discount) {
    if (discount.isPercent == true) {
      discountAmount.value =
          (double.parse(discount.val!) / 100) *
          (foodAndBeverageCost + serviceCost + vat);

      // Apply discount logic here
    } else if (discount.isPercent == false) {
      discountAmount.value = (double.parse(discount.val!));
      // Apply discount logic here
    }
  }

  Future<void> completeBooking() async {
    try {
      if (!isFormValid.value) {
        return;
      }

      isLoading.value = true;

      // Availability check is now done in showBookingConfirmation.
      // We proceed to create the order.

      // Get the current menu for the selected package (this includes UI modifications)
      final menu = this.menu;
      final bool isCustomFlag = selectedPackage.value == 'Custom Package';

      // Prepare order services from the services in the menu
      List<Map<String, dynamic>> servicesToProcess = menu['Services'] ?? [];

      for (var service in servicesToProcess) {
        final serviceItem = apiServiceItems
            .expand(
              (category) => (category['menu_items'] as List<dynamic>? ?? []),
            )
            .firstWhere(
              (item) => item['title'] == service['name'],
              orElse: () => null,
            );

        if (serviceItem != null) {
          orderServices.add({
            "menu_item_id": serviceItem['id'],
            "price": service['price'].toString(),
          });
        }
      }

      // Prepare order packages with items
      List<Map<String, dynamic>> orderPackages = [];

      // Get package details
      final packageData = apiPackages.firstWhere(
        (pkg) => pkg['id'].toString() == selectedPackageId.value,
        orElse: () => {},
      );

      // Handle custom packages or regular packages
      if (selectedPackage.value == 'Custom Package' || packageData.isNotEmpty) {
        List<Map<String, dynamic>> packageItems = [];

        int? _resolveMenuItemId(Map<String, dynamic> entry) {
          final dynamic direct = entry['menu_item_id'] ?? entry['id'];
          if (direct != null) {
            final parsed = int.tryParse(direct.toString());
            if (parsed != null) return parsed;
          }
          final String name = entry['name']?.toString() ?? '';
          // Search in foods
          final foodFound = apiMenuItems
              .expand((cat) => (cat['menu_items'] as List<dynamic>? ?? []))
              .cast<Map>()
              .firstWhere(
                (it) => (it['title']?.toString() ?? '') == name,
                orElse: () => {},
              );
          if (foodFound.isNotEmpty) {
            return int.tryParse(foodFound['id']?.toString() ?? '');
          }
          // Search in services
          final svcFound = apiServiceItems
              .expand((cat) => (cat['menu_items'] as List<dynamic>? ?? []))
              .cast<Map>()
              .firstWhere(
                (it) => (it['title']?.toString() ?? '') == name,
                orElse: () => {},
              );
          if (svcFound.isNotEmpty) {
            return int.tryParse(svcFound['id']?.toString() ?? '');
          }
          return null;
        }

        void _addEntryToPackageItems(
          Map<String, dynamic> entry, {
          required bool isFood,
          bool isExtra = false,
        }) {
          final int? menuItemId = _resolveMenuItemId(entry);
          if (menuItemId == null) return;
          final num priceNum = (entry['price'] as num?) ?? 0;
          final int qty = (entry['qty'] is int)
              ? entry['qty'] as int
              : int.tryParse(entry['qty']?.toString() ?? '') ??
                    (isFood ? guests.value : 1);
          packageItems.add({
            "menu_item_id": menuItemId,
            "price": priceNum.toString(),
            "no_of_gust": qty.toString(),
            "is_deleted": false,
            "is_extra": isExtra,
          });
        }

        List<Map<String, dynamic>> foodItems = menu['Food Items'] ?? [];

        // Group by packageTitle to identify extras
        final Map<String, List<Map<String, dynamic>>> itemsByTitle = {};
        for (var dish in foodItems) {
          final title = dish['packageTitle']?.toString() ?? 'Other';
          itemsByTitle.putIfAbsent(title, () => []).add(dish);
        }

        for (var entry in itemsByTitle.entries) {
          final title = entry.key;
          final items = entry.value;

          int maxItem = 999;
          if (title != 'Other' &&
              items.isNotEmpty &&
              items.first['maxItem'] != null) {
            maxItem = int.tryParse(items.first['maxItem'].toString()) ?? 999;
          }

          for (int i = 0; i < items.length; i++) {
            final dish = items[i];
            bool isExtra = (title == 'Other' || i >= maxItem);
            _addEntryToPackageItems(dish, isFood: true, isExtra: isExtra);
          }
        }

        // Get custom package ID from API packages
        String? customPackageId;
        if (selectedPackage.value == 'Custom Package') {
          final customPkg = apiPackages.firstWhere(
            (pkg) =>
                (pkg['name']?.toString() ?? pkg['title']?.toString()) ==
                'Custom Package',
            orElse: () => {},
          );
          customPackageId = customPkg['id']?.toString();
          // If not found, use the selectedPackageId which should already be set correctly
          if (customPackageId == null || customPackageId.isEmpty) {
            customPackageId = selectedPackageId.value;
          }
        }

        orderPackages.add({
          "package_id": selectedPackage.value == 'Custom Package'
              ? customPackageId
              : selectedPackageId.value,
          "amount": calculateTotal().toStringAsFixed(2),
          "is_custom": isCustomFlag,
          "order_package_items_attributes": packageItems,
        });
      }

      // Format dates properly for API
      String formatDateForApi(DateTime? date) {
        if (date == null) return '';
        return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      }

      String formatTimeForApi(TimeOfDay? time) {
        if (time == null) return '';
        return "2000-01-01T${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00.000Z";
      }

      // Prepare the complete order data matching your API structure
      Map<String, dynamic> orderData = {
        "firstname": nameController.text.split(' ').first,
        "lastname": nameController.text.split(' ').length > 1
            ? nameController.text.split(' ').sublist(1).join(' ')
            : nameController.text,
        "email": emailController.text,
        "phone": contactController.text,
        "nin": "123456789",
        "city_id": selectedCityId.value,
        "address": selectedCity.value,
        "event_id": selectedEventId.value,
        "no_of_gust": guests.value.toString(),
        "event_date": formatDateForApi(selectedDate.value),
        "event_time": formatTimeForApi(startTime.value),
        "start_time": formatTimeForApi(startTime.value),
        "end_time": formatTimeForApi(endTime.value),
        "requirement": specialRequirementsController.text.isEmpty
            ? "No special requirements"
            : specialRequirementsController.text,
        "payment_method_id": 1,
        "total_amount": totalAmount,
        "service_amount": serviceCost,
        "food_beverage_amount": foodAndBeverageCost,
        "discount_amount": discountAmount.value,
        "discount_id": selectedDiscount.value?.id == 0
            ? null
            : selectedDiscount.value?.id.toString(),
        "discount": selectedDiscount.value?.id == 0
            ? null
            : selectedDiscount.value,

        "is_inquiry": false,
        // Include order services if any
        if (orderServices.isNotEmpty)
          "order_services_attributes": orderServices,
        // Include order packages
        "order_packages_attributes": orderPackages,
      };

      print('Sending order data: ${jsonEncode(orderData)}');

      // Send order to API
      final result = await ApiService.createOrder(
        orderData: orderData,
        token: ApiService.bearerToken,
      );

      if (result['success'] == true) {
        confirmPressCount.value = 0;
        Get.back(); // Close popup

        // Success - navigation will show the confirmation

        // Clear form after successful booking
        clearForm();
        Get.to(() => SchedulePage());
      } else {
        throw Exception(result['error'] ?? 'Failed to create order');
      }
    } catch (e) {
      Get.back();
      // Error handling - can be shown in UI if needed
      print('Failed to save booking: $e');
    }
  }

  Future<void> completeInquiryBooking() async {
    try {
      if (!isFormValid.value) {
        // Validation is handled in the UI layer
        return;
      }

      // Check availability before proceeding
      // Inquiries are blocked by Bookings, but not by other Inquiries.
      // checkAvailability() now handles this by ignoring existing inquiries.
      final isAvailable = await checkAvailability();
      if (!isAvailable) {
        // Error dialog is shown in checkAvailability
        return;
      }

      // Get the current menu for the selected package (this includes UI modifications)
      final menu = this.menu;
      final bool isCustomFlag = selectedPackage.value == 'Custom Package';

      // For custom packages, use _customPackageMenu services
      List<Map<String, dynamic>> servicesToProcess = menu['Services'] ?? [];

      for (var service in servicesToProcess) {
        final serviceItem = apiServiceItems
            .expand(
              (category) => (category['menu_items'] as List<dynamic>? ?? []),
            )
            .firstWhere(
              (item) => item['title'] == service['name'],
              orElse: () => null,
            );

        if (serviceItem != null) {
          orderServices.add({
            "menu_item_id": serviceItem['id'],
            "price": service['price'].toString(),
          });
        }
      }

      // Prepare order packages with items
      List<Map<String, dynamic>> orderPackages = [];

      // Get package details
      final packageData = apiPackages.firstWhere(
        (pkg) => pkg['id'].toString() == selectedPackageId.value,
        orElse: () => {},
      );

      if (packageData.isNotEmpty) {
        List<Map<String, dynamic>> packageItems = [];

        int? _resolveMenuItemId(Map<String, dynamic> entry) {
          final dynamic direct = entry['menu_item_id'] ?? entry['id'];
          if (direct != null) {
            final parsed = int.tryParse(direct.toString());
            if (parsed != null) return parsed;
          }
          final String name = entry['name']?.toString() ?? '';
          // Search in foods
          final foodFound = apiMenuItems
              .expand((cat) => (cat['menu_items'] as List<dynamic>? ?? []))
              .cast<Map>()
              .firstWhere(
                (it) => (it['title']?.toString() ?? '') == name,
                orElse: () => {},
              );
          if (foodFound.isNotEmpty) {
            return int.tryParse(foodFound['id']?.toString() ?? '');
          }
          // Search in services
          final svcFound = apiServiceItems
              .expand((cat) => (cat['menu_items'] as List<dynamic>? ?? []))
              .cast<Map>()
              .firstWhere(
                (it) => (it['title']?.toString() ?? '') == name,
                orElse: () => {},
              );
          if (svcFound.isNotEmpty) {
            return int.tryParse(svcFound['id']?.toString() ?? '');
          }
          return null;
        }

        void _addEntryToPackageItems(
          Map<String, dynamic> entry, {
          required bool isFood,
          bool isExtra = false,
        }) {
          final int? menuItemId = _resolveMenuItemId(entry);
          if (menuItemId == null) return;
          final num priceNum = (entry['price'] as num?) ?? 0;
          final int qty = (entry['qty'] is int)
              ? entry['qty'] as int
              : int.tryParse(entry['qty']?.toString() ?? '') ??
                    (isFood ? guests.value : 1);
          packageItems.add({
            "menu_item_id": menuItemId,
            "price": priceNum.toString(),
            "no_of_gust": qty.toString(),
            "is_deleted": false,
            "is_extra": isExtra,
          });
        }

        List<Map<String, dynamic>> foodItems = menu['Food Items'] ?? [];

        // Group by packageTitle to identify extras
        final Map<String, List<Map<String, dynamic>>> itemsByTitle = {};
        for (var dish in foodItems) {
          final title = dish['packageTitle']?.toString() ?? 'Other';
          itemsByTitle.putIfAbsent(title, () => []).add(dish);
        }

        for (var entry in itemsByTitle.entries) {
          final title = entry.key;
          final items = entry.value;

          int maxItem = 999;
          if (title != 'Other' &&
              items.isNotEmpty &&
              items.first['maxItem'] != null) {
            maxItem = int.tryParse(items.first['maxItem'].toString()) ?? 999;
          }

          for (int i = 0; i < items.length; i++) {
            final dish = items[i];
            bool isExtra = (title == 'Other' || i >= maxItem);
            _addEntryToPackageItems(dish, isFood: true, isExtra: isExtra);
          }
        }

        orderPackages.add({
          "package_id": selectedPackageId.value,
          "amount": calculateSubtotal().toStringAsFixed(2),
          "is_custom": isCustomFlag,
          "order_package_items_attributes": packageItems,
        });
      }

      // Format dates properly for API
      String formatDateForApi(DateTime? date) {
        if (date == null) return '';
        return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      }

      String formatTimeForApi(TimeOfDay? time) {
        if (time == null) return '';
        return "2000-01-01T${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00.000Z";
      }

      // Prepare the complete order data matching your API structure
      //TODO add discounts
      Map<String, dynamic> orderData = {
        "firstname": nameController.text.split(' ').first,
        "lastname": nameController.text.split(' ').length > 1
            ? nameController.text.split(' ').sublist(1).join(' ')
            : nameController.text,
        "email": emailController.text,
        "phone": contactController.text,
        "is_inquiry": true,
        "nin": "123456789",
        "city_id": selectedCityId.value,
        "address": selectedCity.value,
        "event_id": selectedEventId.value,
        "no_of_gust": guests.value.toString(),
        "event_date": formatDateForApi(selectedDate.value),
        "event_time": formatTimeForApi(startTime.value),
        "start_time": formatTimeForApi(startTime.value),
        "end_time": formatTimeForApi(endTime.value),
        "requirement": specialRequirementsController.text.isEmpty
            ? "No special requirements"
            : specialRequirementsController.text,
        "payment_method_id": 1,
        "total_amount": totalAmount,
        "service_amount": serviceCost,
        "food_beverage_amount": foodAndBeverageCost,
        "discount_amount": discountAmount.value.toString() ?? 0.0,
        "discount_id": selectedDiscount.value?.id == 0
            ? null
            : selectedDiscount.value?.id.toString(),
        "discount": selectedDiscount.value?.id == 0
            ? null
            : selectedDiscount.value,
        // Include order services if any
        if (orderServices.isNotEmpty)
          "order_services_attributes": orderServices,
        // Include order packages
        "order_packages_attributes": orderPackages,
      };

      print('Sending order data: ${jsonEncode(orderData)}');

      // Send order to API
      final result = await ApiService.createOrder(
        orderData: orderData,
        token: ApiService.bearerToken,
      );

      if (result['success'] == true) {
        confirmPressCount.value = 0;
        Get.back(); // Close popup

        // Success - navigation handles confirmation

        // Clear form after successful inquiry
        clearForm();
        Get.back();
      } else {
        throw Exception(result['error'] ?? 'Failed to create inquiry');
      }
    } catch (e) {
      Get.back();
      // Error handling
      print('Failed to send inquiry: $e');
    }
  }

  void clearForm() {
    nameController.clear();
    emailController.clear();
    contactController.clear();
    messageController.clear();
    specialRequirementsController.clear();
    selectedCity.value = '';
    selectedCityId.value = '';
    selectedDate.value = null;
    selectedDate.value = null;
    selectedTimeSlot.value = null;
    startTime.value = null;
    endTime.value = null;
    guests.value = 1;
    selectedEventType.value = '';
    selectedEventId.value = '';
    selectedPackage.value = '';
    selectedPackageId.value = '';
    isPackageEditing.value = false;
    confirmPressCount.value = 0;
    _customPackageMenu['Food Items']!.clear();
    _customPackageMenu['Services']!.clear();
  }

  void cancelBookingPopup() {
    confirmPressCount.value = 0;
    Get.back();
  }

  void cancelBooking() {
    confirmPressCount.value = 0;
    Get.back();
  }

  // ---------------------------
  // Package & menu related
  // ---------------------------

  Map<String, dynamic>? _findPackage(String title) {
    final idx = packages.indexWhere((p) => p['title'] == title);
    if (idx == -1) return null;
    return packages[idx];
  }

  Map<String, List<Map<String, dynamic>>> menuForPackage(
    String packageTitle,
    int guestCount,
  ) {
    // If it's custom package and we're editing, return custom menu
    if (packageTitle == 'Custom Package' && isPackageEditing.value) {
      return _customPackageMenu;
    }

    // If it's custom package but not editing, return empty menu
    if (packageTitle == 'Custom Package') {
      return {
        'Food Items': <Map<String, dynamic>>[],
        'Services': <Map<String, dynamic>>[],
      };
    }

    // Otherwise return original package menu
    return _getOriginalPackageMenu(packageTitle, guestCount);
  }

  Map<String, List<Map<String, dynamic>>> _getOriginalPackageMenu(
    String packageTitle,
    int guestCount,
  ) {
    final pkg = _findPackage(packageTitle);
    if (pkg == null) {
      return {'Food Items': [], 'Services': []};
    }

    final List<Map<String, dynamic>> rawItems = ((pkg['items'] ?? []) as List)
        .map((i) => Map<String, dynamic>.from(i as Map))
        .toList();

    final food = <Map<String, dynamic>>[];
    final services = <Map<String, dynamic>>[];

    for (var item in rawItems) {
      final name = item['name'] as String;
      final price = (item['price'] as num).toDouble();
      final qtyStored = (item['qty'] is int)
          ? item['qty'] as int
          : (item['qty'] is double ? (item['qty'] as double).toInt() : 1);

      final isFood = masterAvailableFood.any((f) => f['name'] == name);
      final finalQty = isFood ? guestCount : qtyStored;

      final entry = {
        'name': name,
        'price': price,
        'qty': finalQty,
        'menu_item_id': item['menu_item_id'] ?? item['id'],
        'id': item['id'],
        'packageTitle': item['packageTitle'],
        'maxItem': item['maxItem'],
      };

      if (isFood) {
        food.add(Map<String, dynamic>.from(entry));
      } else {
        services.add(Map<String, dynamic>.from(entry));
      }
    }

    return {'Food Items': food, 'Services': services};
  }

  void toggleEditMode(bool editing) {
    isPackageEditing.value = editing;
  }

  List<Map<String, dynamic>> get masterAvailableFood {
    if (apiMenuItems.isNotEmpty) {
      final List<Map<String, dynamic>> allFoodItems = [];

      for (var category in apiMenuItems) {
        if (category['menu_items'] is List) {
          for (var item in category['menu_items'] as List) {
            allFoodItems.add({
              "name": item['title']?.toString() ?? 'Unknown Item',
              "price": _parsePriceString(item['price']?.toString()),
              "id": item['id']?.toString(),
              "category": category['title']?.toString() ?? 'Uncategorized',
              "menu_item_id": item['id']?.toString(),
            });
          }
        }
      }

      return allFoodItems;
    }

    return [];
  }

  List<Map<String, dynamic>> get masterAvailableServices {
    if (apiServiceItems.isNotEmpty) {
      final List<Map<String, dynamic>> allServiceItems = [];

      for (var category in apiServiceItems) {
        if (category['menu_items'] is List) {
          for (var item in category['menu_items'] as List) {
            allServiceItems.add({
              "name": item['title']?.toString() ?? 'Unknown Service',
              "price": _parsePriceString(item['price']?.toString()),
              "id": item['id']?.toString(),
              "category": category['title']?.toString() ?? 'Uncategorized',
              "menu_item_id": item['id']?.toString(),
            });
          }
        }
      }

      return allServiceItems;
    }

    return [];
  }

  void createOrOpenCustomPackage() {
    const customTitle = 'Custom Package';

    // Find custom package ID from API packages
    final customPkg = apiPackages.firstWhere(
      (pkg) =>
          (pkg['name']?.toString() ?? pkg['title']?.toString()) == customTitle,
      orElse: () => {},
    );
    final customPackageId = customPkg['id']?.toString() ?? '';

    // Switch to custom package
    selectedPackage.value = customTitle;
    selectedPackageId.value = customPackageId;
    isPackageEditing.value = true;

    update();
  }

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

  void switchToCustomPackageAndUpdate(
    Map<String, List<Map<String, dynamic>>> currentMenu,
  ) {
    // Switch to custom package
    createOrOpenCustomPackage();

    // Update custom package with current menu
    updateCustomPackageItems('Custom Package', currentMenu);

    // Mark as edited
    isPackageEditing.value = true;

    // Refresh UI
    update();
  }

  // Inquiry flow
  bool _validateInquiry() {
    return selectedDate.value != null &&
        startTime.value != null &&
        endTime.value != null &&
        guests.value > 0 &&
        selectedEventType.value.isNotEmpty;
  }

  void showInquiry() {
    if (!_validateInquiry()) {
      // Validation is handled in the UI layer
      return;
    }

    Get.dialog(
      AlertDialog(
        title: const Text('Send Inquiry'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Event: ${selectedEventType.value}'),
            const SizedBox(height: 6),
            Text(
              'Date: ${selectedDate.value!.day}/${selectedDate.value!.month}/${selectedDate.value!.year}',
            ),
            const SizedBox(height: 6),
            Text(
              'Time: ${startTime.value!.format(Get.context!)} - ${endTime.value!.format(Get.context!)}',
            ),
            const SizedBox(height: 6),
            Text('Guests: ${guests.value}'),
            const SizedBox(height: 6),
            Text('Package: ${selectedPackage.value}'),
            const SizedBox(height: 8),
            const Text(
              'Name, email and city are optional for inquiry. We will contact you for details.',
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _sendInquiry();
            },
            child: const Text('Send Inquiry'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _sendInquiry() {
    // Inquiry confirmation - navigation handles UI feedback
  }

  // Test methods
  Future<void> testOrderData() async {
    try {
      if (!isFormValid.value) {
        // Validation is handled in the UI layer
        return;
      }

      Get.dialog(
        AlertDialog(
          title: Text('Test Order Data'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'This is the data that will be sent to the API:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text('Name: ${nameController.text}'),
                Text('Email: ${emailController.text}'),
                Text('Phone: ${contactController.text}'),
                Text(
                  'City: ${selectedCity.value} (ID: ${selectedCityId.value})',
                ),
                Text(
                  'Event: ${selectedEventType.value} (ID: ${selectedEventId.value})',
                ),
                Text(
                  'Package: ${selectedPackage.value} (ID: ${selectedPackageId.value})',
                ),
                Text('Guests: ${guests.value}'),
                Text('Date: ${selectedDate.value}'),
                Text(
                  'Time: ${startTime.value?.format(Get.context!)} - ${endTime.value?.format(Get.context!)}',
                ),
                Text('Requirements: ${specialRequirementsController.text}'),
                SizedBox(height: 10),
                Text('Subtotal: Â£${calculateSubtotal().toStringAsFixed(2)}'),
                Text('Total: Â£${calculateTotal().toStringAsFixed(2)}'),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    await completeBooking();
                    Get.to(() => SchedulePage());
                  },
                  child: Text('Send Actual Order'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          ],
        ),
      );
    } catch (e) {
      print('Error preparing test data: $e');
    }
  }

  Future<void> testInquiryData() async {
    try {
      if (!isFormValid.value) {
        // Validation is handled in the UI layer
        return;
      }

      Get.dialog(
        AlertDialog(
          title: Text('Test Inquiry Data'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'This is the data that will be sent to the API:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text('Name: ${nameController.text}'),
                Text('Email: ${emailController.text}'),
                Text('Phone: ${contactController.text}'),
                Text(
                  'City: ${selectedCity.value} (ID: ${selectedCityId.value})',
                ),
                Text(
                  'Event: ${selectedEventType.value} (ID: ${selectedEventId.value})',
                ),
                Text(
                  'Package: ${selectedPackage.value} (ID: ${selectedPackageId.value})',
                ),
                Text('Guests: ${guests.value}'),
                Text('Date: ${selectedDate.value}'),
                Text(
                  'Time: ${startTime.value?.format(Get.context!)} - ${endTime.value?.format(Get.context!)}',
                ),
                Text('Requirements: ${specialRequirementsController.text}'),
                SizedBox(height: 10),
                Text('Subtotal: ${calculateSubtotal().toStringAsFixed(2)}'),
                Text('Total: ${calculateTotal().toStringAsFixed(2)}'),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    await completeInquiryBooking();
                  },
                  child: Text('Send Actual Inquiry'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          ],
        ),
      );
    } catch (e) {
      print('Error preparing test data: $e');
    }
  }
}
