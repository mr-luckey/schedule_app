// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:schedule_app/APIS/Api_Service.dart';
// import 'package:schedule_app/model/event_model.dart';
// import 'package:schedule_app/pages/Recipt/bookingrecipt.dart';
// import 'package:schedule_app/pages/schedule_page.dart';
// import 'package:schedule_app/widgets/Payment_Popup.dart';
// // import 'package:schedule_app/services/api_service.dart';

// class BookingController extends GetxController {
//   // Form controllers
//   final RxList<Map<String, dynamic>> apiMenuItems =
//       <Map<String, dynamic>>[].obs;
//   final RxList<Map<String, dynamic>> apiServiceItems =
//       <Map<String, dynamic>>[].obs;
//   final nameController = TextEditingController();
//   final emailController = TextEditingController();
//   final contactController = TextEditingController();
//   final messageController = TextEditingController();
//   final specialRequirementsController = TextEditingController();
//   // Add this to your BookingController class
//   Map<String, List<Map<String, dynamic>>> getCurrentMenu() {
//     return menuForPackage(
//       selectedPackage.value,
//       guests.value > 0 ? guests.value : 1,
//     );
//   }

//   void markPackageAsEdited() {
//     if (selectedPackage.value.isNotEmpty) {
//       packageEdited[selectedPackage.value] = true;
//       isPackageEditing.value = true;

//       // Save the current selection immediately when edited
//       final currentMenu = getCurrentMenu();
//       _customSelections[selectedPackage.value] = currentMenu;
//       _saveSelectionToPrefs(selectedPackage.value, currentMenu);
//     }
//   }

//   bool hasPackageBeenModified() {
//     return packageEdited[selectedPackage.value] == true;
//   }
//   // void markPackageAsEdited() {
//   //   if (selectedPackage.value.isNotEmpty) {
//   //     packageEdited[selectedPackage.value] = true;
//   //     isPackageEditing.value = true;

//   //     // Save the current selection immediately when edited
//   //     final currentMenu = getCurrentMenu();
//   //     _customSelections[selectedPackage.value] = currentMenu;
//   //     _saveSelectionToPrefs(selectedPackage.value, currentMenu);
//   //   }
//   // }

//   // Form data
//   final RxString selectedCity = ''.obs;
//   final RxString selectedCityId = ''.obs; // Store city ID for API
//   final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
//   final Rx<TimeOfDay?> startTime = Rx<TimeOfDay?>(null);
//   final Rx<TimeOfDay?> endTime = Rx<TimeOfDay?>(null);
//   final RxInt guests = 1.obs;
//   final RxString selectedEventType = ''.obs;
//   final RxString selectedEventId = ''.obs; // Store event ID for API
//   final RxBool isPackageEditing = false.obs;
//   // selectedPackage is the title string
//   final RxString selectedPackage = ''.obs;
//   final RxString selectedPackageId = ''.obs; // Store package ID for API

//   // Form validation
//   final RxBool isFormValid = false.obs;

//   // Track confirm button presses
//   final RxInt confirmPressCount = 0.obs;

//   // Track whether a package has been edited (committed) by the user.
//   final Map<String, bool> packageEdited = {};

//   // Persisted per-package custom selections (Food Items/Services -> items)
//   final Map<String, Map<String, List<Map<String, dynamic>>>> _customSelections =
//       {};

//   static String _prefsKeyForPackage(String title) => 'menu_selection_\$title';

//   Future<void> _saveSelectionToPrefs(
//     String packageTitle,
//     Map<String, List<Map<String, dynamic>>> menu,
//   ) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final jsonStr = jsonEncode(menu);
//       await prefs.setString(_prefsKeyForPackage(packageTitle), jsonStr);
//     } catch (_) {}
//   }

//   Future<Map<String, List<Map<String, dynamic>>>?> _loadSelectionFromPrefs(
//     String packageTitle,
//   ) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final jsonStr = prefs.getString(_prefsKeyForPackage(packageTitle));
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
//         return result;
//       }
//     } catch (_) {}
//     return null;
//   }

//   // API Data
//   final RxList<Map<String, dynamic>> apiCities = <Map<String, dynamic>>[].obs;
//   final RxList<Map<String, dynamic>> apiEvents = <Map<String, dynamic>>[].obs;
//   final RxList<Map<String, dynamic>> apiPackages = <Map<String, dynamic>>[].obs;
//   final RxBool isLoading = false.obs;
//   final RxString errorMessage = ''.obs;

//   @override
//   void onInit() {
//     super.onInit();

//     // Load data from APIs
//     loadApiData();

//     // initialize packageEdited map for existing packages
//     ever(apiPackages, (packages) {
//       for (var p in packages) {
//         final title = p['title'] as String? ?? p['name'] as String? ?? '';
//         if (title.isNotEmpty) {
//           packageEdited[title] = false;
//         }
//       }
//     });

//     // Listen to form changes for validation
//     ever(selectedCity, (_) => _validateForm());
//     ever(selectedDate, (_) => _validateForm());
//     ever(startTime, (_) => _validateForm());
//     ever(endTime, (_) => _validateForm());
//     ever(guests, (_) => _validateForm());
//     ever(selectedEventType, (_) => _validateForm());
//     ever(selectedPackage, (_) => _validateForm());

//     nameController.addListener(_validateForm);
//     emailController.addListener(_validateForm);
//   }

//   @override
//   void onClose() {
//     nameController.dispose();
//     emailController.dispose();
//     contactController.dispose();
//     messageController.dispose();
//     specialRequirementsController.dispose();
//     super.onClose();
//   }

//   // Load data from APIs
//   Future<void> loadApiData() async {
//     isLoading.value = true;
//     errorMessage.value = '';

//     try {
//       // Load cities
//       final menusResult = await ApiService.getMenus();
//       if (menusResult['success'] == true) {
//         final menusData = menusResult['data'];
//         if (menusData is List) {
//           apiMenuItems.value = menusData.cast<Map<String, dynamic>>();
//         } else {
//           apiMenuItems.value = [];
//         }
//       } else {
//         errorMessage.value += '\nFailed to load menus: ${menusResult['error']}';
//       }

//       final servicesResult = await ApiService.getServices();
//       if (servicesResult['success'] == true) {
//         final servicesData = servicesResult['data'];
//         if (servicesData is List) {
//           apiServiceItems.value = servicesData.cast<Map<String, dynamic>>();
//         } else {
//           apiServiceItems.value = [];
//         }
//       } else {
//         errorMessage.value +=
//             '\nFailed to load services: ${servicesResult['error']}';
//       }
//       final citiesResult = await ApiService.getCities();
//       if (citiesResult['success'] == true) {
//         final citiesData = citiesResult['data'];
//         if (citiesData is List) {
//           apiCities.value = citiesData.cast<Map<String, dynamic>>();
//         } else if (citiesData is Map && citiesData['cities'] is List) {
//           apiCities.value = (citiesData['cities'] as List)
//               .cast<Map<String, dynamic>>();
//         }
//       } else {
//         errorMessage.value = 'Failed to load cities: ${citiesResult['error']}';
//       }

//       // Load events
//       final eventsResult = await ApiService.getEvents();
//       if (eventsResult['success'] == true) {
//         final eventsData = eventsResult['data'];
//         if (eventsData is List) {
//           apiEvents.value = eventsData.cast<Map<String, dynamic>>();
//         } else if (eventsData is Map && eventsData['events'] is List) {
//           apiEvents.value = (eventsData['events'] as List)
//               .cast<Map<String, dynamic>>();
//         }
//       } else {
//         errorMessage.value +=
//             '\nFailed to load events: ${eventsResult['error']}';
//       }

//       // Load packages
//       final packagesResult = await ApiService.getPackages();
//       if (packagesResult['success'] == true) {
//         final packagesData = packagesResult['data'];
//         if (packagesData is List) {
//           apiPackages.value = packagesData.cast<Map<String, dynamic>>();
//         } else if (packagesData is Map && packagesData['packages'] is List) {
//           apiPackages.value = (packagesData['packages'] as List)
//               .cast<Map<String, dynamic>>();
//         }
//       } else {
//         errorMessage.value +=
//             '\nFailed to load packages: ${packagesResult['error']}';
//       }
//     } catch (e) {
//       errorMessage.value = 'Error loading data: $e';
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // Get cities for dropdown
//   List<String> get cities {
//     return apiCities.map((city) {
//       return city['name']?.toString() ??
//           city['title']?.toString() ??
//           'Unknown City';
//     }).toList();
//   }

//   // Get event types for dropdown
//   List<String> get eventTypes {
//     return apiEvents.map((event) {
//       return event['name']?.toString() ??
//           event['title']?.toString() ??
//           'Unknown Event';
//     }).toList();
//   }

//   // Get packages for selection
//   List<Map<String, dynamic>> get packages {
//     return apiPackages.map((pkg) {
//       return {
//         'id': pkg['id']?.toString() ?? '',
//         'title':
//             pkg['name']?.toString() ??
//             pkg['title']?.toString() ??
//             'Unknown Package',
//         'description': pkg['description']?.toString() ?? '',
//         'price': pkg['price']?.toString() ?? pkg['amount']?.toString() ?? '0',
//         'items': _parsePackageItems(pkg),
//         'editable': pkg['editable'] ?? false,
//       };
//     }).toList();
//   }

//   List<Map<String, dynamic>> _parsePackageItems(Map<String, dynamic> package) {
//     try {
//       final items = <Map<String, dynamic>>[];

//       // Parse package_items from API response
//       if (package['package_items'] is List) {
//         for (var packageItem in package['package_items'] as List) {
//           if (packageItem is Map<String, dynamic> &&
//               packageItem['menu_item'] is Map<String, dynamic>) {
//             final menuItem = packageItem['menu_item'] as Map<String, dynamic>;
//             items.add({
//               'name': menuItem['title']?.toString() ?? 'Unknown Item',
//               'price': _parsePriceString(menuItem['price']?.toString()),
//               'qty':
//                   1, // Base quantity - will be multiplied by guest count later
//               'menu_item_id': menuItem['id']?.toString(),
//             });
//           }
//         }
//       }
//       // Fallback to existing parsing for other structures
//       else if (package['items'] is List) {
//         for (var item in package['items'] as List) {
//           items.add({
//             'name': item['name']?.toString(),
//             'price': (item['price'] as num?)?.toDouble() ?? 0.0,
//             'qty': (item['quantity'] as int?) ?? (item['qty'] as int?) ?? 1,
//           });
//         }
//       }

//       return items;
//     } catch (e) {
//       return [];
//     }
//   }

//   String generateReceiptHTML() {
//     // Get the current menu for the selected package
//     final menu = menuForPackage(
//       selectedPackage.value,
//       guests.value > 0 ? guests.value : 1,
//     );

//     // Calculate totals
//     double foodSubtotal = 0;
//     double servicesSubtotal = 0;

//     for (var item in menu['Food Items']!) {
//       foodSubtotal += (item['price'] as num).toDouble() * (item['qty'] as int);
//     }

//     for (var item in menu['Services']!) {
//       servicesSubtotal +=
//           (item['price'] as num).toDouble() * (item['qty'] as int);
//     }

//     double netAmount = foodSubtotal + servicesSubtotal;
//     double serviceCharge = netAmount * 0.10;
//     double discount = netAmount * 0.05;
//     double subtotalAfterDiscount = netAmount + serviceCharge - discount;
//     double vat = subtotalAfterDiscount * 0.20;
//     double totalAmount = subtotalAfterDiscount + vat;

//     // Format date and time
//     String formatDate(DateTime? date) {
//       if (date == null) return 'Not set';
//       final day = date.day;
//       final month = date.month;
//       final year = date.year;
//       final suffixes = [
//         'th',
//         'st',
//         'nd',
//         'rd',
//         'th',
//         'th',
//         'th',
//         'th',
//         'th',
//         'th',
//       ];
//       final suffix = day % 10 <= suffixes.length - 1
//           ? suffixes[day % 10]
//           : 'th';
//       final months = [
//         '',
//         'January',
//         'February',
//         'March',
//         'April',
//         'May',
//         'June',
//         'July',
//         'August',
//         'September',
//         'October',
//         'November',
//         'December',
//       ];
//       return '${day}$suffix ${months[month]} $year';
//     }

//     String formatTime(TimeOfDay? time) {
//       if (time == null) return 'Not set';
//       final hour = time.hourOfPeriod;
//       final minute = time.minute.toString().padLeft(2, '0');
//       final period = time.period == DayPeriod.am ? 'AM' : 'PM';
//       return '$hour:$minute $period';
//     }

//     // Generate food items HTML
//     String foodItemsHTML = '';
//     for (var item in menu['Food Items']!) {
//       foodItemsHTML +=
//           '''
//         <tr>
//           <td>${item['name']}</td>
//           <td>${item['qty']}</td>
//           <td>£${(item['price'] as num).toStringAsFixed(2)}</td>
//           <td>£${((item['price'] as num).toDouble() * (item['qty'] as int)).toStringAsFixed(2)}</td>
//         </tr>
//       ''';
//     }

//     // Generate services HTML
//     String servicesHTML = '';
//     for (var item in menu['Services']!) {
//       servicesHTML +=
//           '''
//         <tr>
//           <td>${item['name']}</td>
//           <td>${item['qty']}</td>
//           <td>£${(item['price'] as num).toStringAsFixed(2)}</td>
//           <td>£${((item['price'] as num).toDouble() * (item['qty'] as int)).toStringAsFixed(2)}</td>
//         </tr>
//       ''';
//     }

//     // Generate customer initials for reference
//     String getCustomerInitials() {
//       if (nameController.text.isEmpty) return 'CUST';
//       final names = nameController.text
//           .trim()
//           .split(' ')
//           .where((name) => name.isNotEmpty)
//           .toList();
//       if (names.isEmpty) return 'CUST';
//       if (names.length == 1) {
//         return names[0].isNotEmpty ? names[0][0].toUpperCase() : 'CUST';
//       }
//       final firstInitial = names[0].isNotEmpty ? names[0][0].toUpperCase() : '';
//       final lastInitial = names.last.isNotEmpty
//           ? names.last[0].toUpperCase()
//           : '';
//       return firstInitial + lastInitial;
//     }

//     return '''
// <!DOCTYPE html>
// <html lang="en">
// <head>
//     <meta charset="UTF-8">
//     <meta name="viewport" content="width=device-width, initial-scale=1.0">
//     <title>Booking Confirmation Receipt - A4</title>
//     <style>
//         * {
//             margin: 0;
//             padding: 0;
//             box-sizing: border-box;
//         }

//         body {
//             font-family: 'Times New Roman', serif;
//             background-color: white;
//             color: #000;
//             line-height: 1.2;
//             font-size: 12px;
//         }

//         .receipt-container {
//             width: 210mm;
//             height: 297mm;
//             margin: 0 auto;
//             background: white;
//             border: 2px solid #000;
//             padding: 15mm;
//             overflow: hidden;
//         }

//         .header {
//             text-align: center;
//             border-bottom: 2px solid #000;
//             padding-bottom: 8px;
//             margin-bottom: 12px;
//         }

//         .company-name {
//             font-size: 20px;
//             font-weight: bold;
//             margin-bottom: 3px;
//             text-transform: uppercase;
//         }

//         .company-details {
//             font-size: 10px;
//             margin-bottom: 8px;
//             line-height: 1.3;
//         }

//         .receipt-title {
//             font-size: 16px;
//             font-weight: bold;
//             text-transform: uppercase;
//             margin-top: 8px;
//         }

//         .receipt-info {
//             display: flex;
//             justify-content: space-between;
//             margin-bottom: 12px;
//             font-size: 9px;
//         }

//         .section {
//             margin-bottom: 10px;
//         }

//         .section-title {
//             font-size: 11px;
//             font-weight: bold;
//             text-transform: uppercase;
//             border-bottom: 1px solid #000;
//             padding-bottom: 2px;
//             margin-bottom: 5px;
//         }

//         .info-table {
//             width: 100%;
//             font-size: 9px;
//             margin-bottom: 5px;
//         }

//         .info-table td {
//             padding: 1px 0;
//             vertical-align: top;
//         }

//         .info-table td:first-child {
//             width: 25%;
//             font-weight: bold;
//         }

//         .order-table {
//             width: 100%;
//             border-collapse: collapse;
//             margin-bottom: 8px;
//             font-size: 8px;
//         }

//         .order-table th,
//         .order-table td {
//             border: 1px solid #000;
//             padding: 3px;
//             text-align: left;
//         }

//         .order-table th {
//             background-color: #f0f0f0;
//             font-weight: bold;
//             text-transform: uppercase;
//             font-size: 7px;
//         }

//         .order-table td:nth-child(2),
//         .order-table td:nth-child(3),
//         .order-table td:nth-child(4) {
//             text-align: right;
//         }

//         .subtotal-section {
//             border: 1px solid #000;
//             padding: 8px;
//             margin-top: 8px;
//         }

//         .subtotal-row {
//             display: flex;
//             justify-content: space-between;
//             margin-bottom: 2px;
//             font-size: 9px;
//         }

//         .subtotal-row.total {
//             border-top: 2px solid #000;
//             padding-top: 4px;
//             margin-top: 5px;
//             font-weight: bold;
//             font-size: 11px;
//         }

//         .footer {
//             border-top: 2px solid #000;
//             padding-top: 8px;
//             margin-top: 10px;
//             text-align: center;
//             font-size: 9px;
//         }

//         .terms {
//             font-size: 7px;
//             margin-top: 8px;
//             text-align: justify;
//             line-height: 1.2;
//         }

//         .signature-section {
//             margin-top: 15px;
//             display: flex;
//             justify-content: space-between;
//         }

//         .signature-box {
//             width: 150px;
//             text-align: center;
//             font-size: 8px;
//         }

//         .signature-line {
//             border-bottom: 1px solid #000;
//             margin-bottom: 3px;
//             height: 20px;
//         }

//         .two-column {
//             display: flex;
//             gap: 10px;
//         }

//         .column {
//             flex: 1;
//         }

//         @media print {
//             @page {
//                 size: A4;
//                 margin: 0;
//             }

//             body {
//                 padding: 0;
//                 margin: 0;
//             }

//             .receipt-container {
//                 border: none;
//                 padding: 15mm;
//                 margin: 0;
//                 width: 210mm;
//                 height: 297mm;
//                 max-width: none;
//                 max-height: none;
//             }
//         }

//         @media screen {
//             body {
//                 padding: 10px;
//                 background-color: #f0f0f0;
//             }
//         }
//         .cancel-icon {
//             position: absolute;
//             top: 15px;
//             right: 15px;
//             cursor: pointer;
//             font-size: 20px;
//             color: #ff0000;
//             z-index: 1000;
//         }

//         .next-button {
//             background-color: #28a745;
//             color: white;
//             border: none;
//             padding: 12px 24px;
//             font-size: 14px;
//             font-weight: bold;
//             border-radius: 4px;
//             cursor: pointer;
//             margin-top: 15px;
//             transition: background-color 0.3s ease;
//         }

//         .next-button:hover {
//             background-color: #218838;
//         }
//     </style>
// </head>
// <body>
//    <div class="cancel-icon" onclick="handleCancel()">✕</div>
//     <div class="receipt-container">
//         <div class="header">
//             <div class="company-name">Premium Event Catering Ltd.</div>
//             <div class="company-details">
//                 123 Wedding Lane, London, EC1A 1BB<br>
//                 Tel: +44-20-7123-4567 | Email: events@premiumcatering.co.uk | VAT: GB123456789
//             </div>
//             <div class="receipt-title">Booking Confirmation Receipt</div>
//         </div>

//         <div class="receipt-info">
//             <div>
//                 <strong>Receipt No:</strong> WED-${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}-001<br>
//                 <strong>Date:</strong> ${formatDate(DateTime.now())}<br>
//                 <strong>Payment Method:</strong> Bank Transfer
//             </div>
//             <div>
//                 <strong>Account Manager:</strong> Emma Wilson<br>
//                 <strong>Reference:</strong> WEDDING-${getCustomerInitials()}-001<br>
//                 <strong>Status:</strong> CONFIRMED
//             </div>
//         </div>

//         <div class="two-column">
//             <div class="column">
//                 <div class="section">
//                     <div class="section-title">Customer Information</div>
//                     <table class="info-table">
//                         <tr><td>Customer Name:</td><td>${nameController.text}</td></tr>
//                         <tr><td>Email:</td><td>${emailController.text}</td></tr>
//                         <tr><td>Contact:</td><td>${contactController.text}</td></tr>
//                         <tr><td>Event Address:</td><td>${selectedCity.value}</td></tr>
//                     </table>
//                 </div>
//             </div>
//             <div class="column">
//                 <div class="section">
//                     <div class="section-title">Event Details</div>
//                     <table class="info-table">
//                         <tr><td>Event Type:</td><td>${selectedEventType.value}</td></tr>
//                         <tr><td>Date:</td><td>${formatDate(selectedDate.value)}</td></tr>
//                         <tr><td>Time:</td><td>${formatTime(startTime.value)} - ${formatTime(endTime.value)}</td></tr>
//                         <tr><td>Guests:</td><td>${guests.value} persons</td></tr>
//                         <tr><td>Package:</td><td>${selectedPackage.value}</td></tr>
//                     </table>
//                 </div>
//             </div>
//         </div>

//         <div class="section">
//             <div class="section-title">Food Items</div>
//             <table class="order-table">
//                 <thead>
//                     <tr>
//                         <th style="width: 50%;">Description</th>
//                         <th style="width: 15%;">Qty</th>
//                         <th style="width: 17%;">Unit Price</th>
//                         <th style="width: 18%;">Amount</th>
//                     </tr>
//                 </thead>
//                 <tbody>
//                     $foodItemsHTML
//                 </tbody>
//             </table>
//         </div>

//         <div class="section">
//             <div class="section-title">Additional Services</div>
//             <table class="order-table">
//                 <thead>
//                     <tr>
//                         <th style="width: 50%;">Service Description</th>
//                         <th style="width: 15%;">Qty</th>
//                         <th style="width: 17%;">Rate</th>
//                         <th style="width: 18%;">Amount</th>
//                     </tr>
//                 </thead>
//                 <tbody>
//                     $servicesHTML
//                 </tbody>
//             </table>
//         </div>

//         <div class="subtotal-section">
//             <div class="subtotal-row"><span>Food Items Subtotal:</span><span>£${foodSubtotal.toStringAsFixed(2)}</span></div>
//             <div class="subtotal-row"><span>Services Subtotal:</span><span>£${servicesSubtotal.toStringAsFixed(2)}</span></div>
//             <div class="subtotal-row"><span>Net Amount:</span><span>£${netAmount.toStringAsFixed(2)}</span></div>
//             <div class="subtotal-row"><span>Service Charge (10%):</span><span>£${serviceCharge.toStringAsFixed(2)}</span></div>
//             <div class="subtotal-row"><span>Early Booking Discount (5%):</span><span>-£${discount.toStringAsFixed(2)}</span></div>
//             <div class="subtotal-row"><span>Subtotal after Discount:</span><span>£${subtotalAfterDiscount.toStringAsFixed(2)}</span></div>
//             <div class="subtotal-row"><span>VAT @ 20%:</span><span>£${vat.toStringAsFixed(2)}</span></div>
//             <div class="subtotal-row total"><span>TOTAL AMOUNT:</span><span>£${totalAmount.toStringAsFixed(2)}</span></div>
//         </div>

//         <div class="footer">
//             <p><strong>BOOKING CONFIRMED - PAYMENT DUE: 50% DEPOSIT BY ${formatDate(selectedDate.value?.subtract(const Duration(days: 14)))}</strong></p>
//             <p>Balance payment due 7 days prior to event date</p>

//             <div class="terms">
//                 <strong>Terms & Conditions:</strong> This booking is subject to our standard terms and conditions. Cancellation policy: 30 days notice required for full refund minus 10% administration fee. Final guest numbers must be confirmed 7 days prior to event. Additional charges may apply for changes made within 48 hours of event. All prices include VAT at current rate.
//             </div>

//             <div class="signature-section">
//                 <div class="signature-box">
//                     <div class="signature-line"></div>
//                     <div>Customer Signature</div>
//                 </div>
//                 <div class="signature-box">
//                     <div class="signature-line"></div>
//                     <div>Authorized Signature</div>
//                 </div>
//             </div>

//             <!-- Close button for the receipt -->
//             <div style="text-align: center; margin-top: 20px;">
//                 <button class="next-button" onclick="handleNext()">Close</button>
//             </div>
//         </div>
//     </div>
//        <script>
//         // Test function to check if channels are available when page loads
//         window.addEventListener('load', function() {
//             console.log('Page loaded - checking for available channels');
//             console.log('cancelBooking available:', typeof window.cancelBooking !== 'undefined');
//             console.log('navigateToNextScreen available:', typeof window.navigateToNextScreen !== 'undefined');
//             console.log('flutter_inappwebview available:', typeof window.flutter_inappwebview !== 'undefined');
//         });

//         function handleCancel() {
//             console.log('handleCancel() function called');

//             // Try different methods to call the Flutter channel
//             if (typeof window.cancelBooking !== 'undefined') {
//                 console.log('Using cancelBooking channel directly');
//                 window.cancelBooking.postMessage('');
//             } else if (typeof window.flutter_inappwebview !== 'undefined') {
//                 console.log('Using flutter_inappwebview API for cancel');
//                 window.flutter_inappwebview.callHandler('cancelBooking');
//             } else {
//                 console.log('Cancel button clicked - WebView handler not available');
//                 console.log('Available window objects:', Object.keys(window).filter(key => key.includes('flutter') || key.includes('navigate') || key.includes('cancel')));
//                 alert('Cancel button clicked - Navigation not available. Check console for details.');
//             }
//         }

//         function handleNext() {
//             console.log('Close button clicked - closing receipt');

//             // Try different methods to call the Flutter channel
//             if (typeof window.navigateToNextScreen !== 'undefined') {
//                 console.log('Using navigateToNextScreen channel directly');
//                 window.navigateToNextScreen.postMessage('');
//             } else if (typeof window.cancelBooking !== 'undefined') {
//                 console.log('Using cancelBooking channel to close');
//                 window.cancelBooking.postMessage('');
//             } else if (typeof window.flutter_inappwebview !== 'undefined') {
//                 console.log('Using flutter_inappwebview API to close');
//                 window.flutter_inappwebview.callHandler('navigateToNextScreen');
//             } else {
//                 console.log('Close button clicked - WebView handler not available');
//                 console.log('Available window objects:', Object.keys(window).filter(key => key.includes('flutter') || key.includes('navigate') || key.includes('cancel')));
//                 alert('Close button clicked - Closing not available. Check console for details.');
//             }
//         }
//     </script>
// </body>
// </html>
//     ''';
//   }

//   void _validateForm() {
//     isFormValid.value =
//         nameController.text.isNotEmpty &&
//         emailController.text.isNotEmpty &&
//         selectedCity.value.isNotEmpty &&
//         selectedDate.value != null &&
//         startTime.value != null &&
//         endTime.value != null &&
//         guests.value > 0 &&
//         selectedEventType.value.isNotEmpty;
//   }

//   // Form setters
//   void updateName(String value) => nameController.text = value;
//   void updateEmail(String value) => emailController.text = value;
//   void updateContact(String value) => contactController.text = value;
//   void updateMessage(String value) => messageController.text = value;
//   void updateSpecialRequirements(String value) =>
//       specialRequirementsController.text = value;

//   void setCity(String city) {
//     selectedCity.value = city;
//     // Find and set the city ID
//     final cityData = apiCities.firstWhere(
//       (c) => (c['name']?.toString() ?? c['title']?.toString()) == city,
//       orElse: () => {},
//     );
//     selectedCityId.value = cityData['id']?.toString() ?? '';
//   }

//   void setEventType(String eventType) {
//     selectedEventType.value = eventType;
//     // Find and set the event ID
//     final eventData = apiEvents.firstWhere(
//       (e) => (e['name']?.toString() ?? e['title']?.toString()) == eventType,
//       orElse: () => {},
//     );
//     selectedEventId.value = eventData['id']?.toString() ?? '';
//   }

//   void setPackage(String packageTitle) {
//     // Save current package state before switching
//     if (selectedPackage.value.isNotEmpty &&
//         selectedPackage.value != packageTitle &&
//         isPackageEditing.value) {
//       updateCustomPackageItems(selectedPackage.value, getCurrentMenu());
//     }

//     selectedPackage.value = packageTitle;

//     // Find and set the package ID
//     final packageData = packages.firstWhere(
//       (p) => p['title'] == packageTitle,
//       orElse: () => {},
//     );
//     selectedPackageId.value = packageData['id']?.toString() ?? '';

//     // Initialize edit state for this package if not exists
//     if (!packageEdited.containsKey(packageTitle)) {
//       packageEdited[packageTitle] = false;
//     }

//     // Load any previously saved selection for this package
//     _loadSelectionFromPrefs(packageTitle).then((saved) {
//       if (saved != null) {
//         _customSelections[packageTitle] = saved;
//         packageEdited[packageTitle] = true;
//         isPackageEditing.value = true;
//       } else {
//         // Reset to non-edited state if no saved selection
//         packageEdited[packageTitle] = false;
//         isPackageEditing.value = false;
//       }
//       update(); // Refresh UI
//     });
//   }

//   void setDate(DateTime date) => selectedDate.value = date;
//   void setStartTime(TimeOfDay time) => startTime.value = time;
//   void setEndTime(TimeOfDay time) => endTime.value = time;
//   void setGuests(int count) {
//     final oldCount = guests.value;
//     guests.value = count;

//     // Update food quantities in custom selections if package is edited
//     if (isPackageEditing.value && selectedPackage.value.isNotEmpty) {
//       final currentMenu = getCurrentMenu();
//       final updatedFoodItems = <Map<String, dynamic>>[];

//       // Update quantities for all food items
//       for (var foodItem in currentMenu['Food Items']!) {
//         final updatedItem = Map<String, dynamic>.from(foodItem);
//         updatedItem['qty'] = count; // Set to new guest count
//         updatedFoodItems.add(updatedItem);
//       }

//       // Update the custom selection
//       if (_customSelections.containsKey(selectedPackage.value)) {
//         _customSelections[selectedPackage.value]!['Food Items'] =
//             updatedFoodItems;
//         _saveSelectionToPrefs(
//           selectedPackage.value,
//           _customSelections[selectedPackage.value]!,
//         );
//       }
//     }
//   }

//   void incrementGuests() {
//     guests.value += 1;
//   }

//   void decrementGuests() => guests.value = (guests.value - 1).clamp(1, 10000);

//   // --- Pricing helpers ---
//   double _parsePriceString(String? priceStr) {
//     if (priceStr == null) return 0.0;
//     final cleaned = priceStr.replaceAll(RegExp(r'[^0-9.]'), '');
//     if (cleaned.isEmpty) return 0.0;
//     return double.tryParse(cleaned) ?? 0.0;
//   }

//   double calculateSubtotal() {
//     final pkg = _findPackage(selectedPackage.value);
//     if (pkg == null) return 0.0;

//     final isApiPackage = _isApiPackage(selectedPackage.value);
//     final isEdited = packageEdited[selectedPackage.value] == true;

//     if (!isEdited && isApiPackage) {
//       // Non-modified mode: Package price * guests
//       final packagePrice = _parsePriceString(pkg['price']?.toString());
//       return packagePrice * guests.value;
//     } else {
//       // Modified mode: Sum of all food items
//       return calculateSubtotalFromItems();
//     }
//   }
//   // double calculateSubtotal() {
//   //   final pkg = _findPackage(selectedPackage.value);
//   //   if (pkg == null) return 0.0;

//   //   final isApiPackage = _isApiPackage(selectedPackage.value);

//   //   if (!isPackageEditing.value && isApiPackage) {
//   //     // Non-edit mode for API package: package price + services
//   //     final packagePrice = _parsePriceString(pkg['price']?.toString());
//   //     final servicesCost = calculateServicesCost();
//   //     return packagePrice + servicesCost;
//   //   } else {
//   //     // Edit mode or custom package: sum of all items
//   //     return calculateSubtotalFromItems();
//   //   }
//   // }

//   double calculateServicesCost() {
//     final menu = menuForPackage(
//       selectedPackage.value,
//       guests.value > 0 ? guests.value : 1,
//     );

//     double servicesCost = 0.0;
//     for (var service in menu['Services']!) {
//       servicesCost +=
//           (service['price'] as num).toDouble() * (service['qty'] as int);
//     }
//     return servicesCost;
//   }

//   double calculateSubtotalFromItems() {
//     final menu = menuForPackage(
//       selectedPackage.value,
//       guests.value > 0 ? guests.value : 1,
//     );

//     double total = 0.0;
//     // Only calculate food items, not services
//     for (var item in menu['Food Items']!) {
//       total += (item['price'] as num).toDouble() * (item['qty'] as int);
//     }
//     return total;
//   }

//   bool _isApiPackage(String packageTitle) {
//     final pkg = packages.firstWhere(
//       (p) => p['title'] == packageTitle,
//       orElse: () => {},
//     );
//     return pkg['id']?.toString().isNotEmpty == true &&
//         pkg['id']?.toString() != 'custom';
//   }

//   double calculateTax() {
//     return calculateSubtotal() * 0.08;
//   }

//   double calculateTotal() => calculateSubtotal() + calculateTax();

//   String getTimeRange(BuildContext context) {
//     if (startTime.value != null && endTime.value != null) {
//       return '${startTime.value!.format(context)} - ${endTime.value!.format(context)}';
//     } else if (startTime.value != null) {
//       return '${startTime.value!.format(context)} - TBD';
//     } else if (endTime.value != null) {
//       return 'TBD - ${endTime.value!.format(context)}';
//     } else {
//       return 'TBD';
//     }
//   }

//   bool isCurrentPackageCustomized() {
//     return packageEdited[selectedPackage.value] == true;
//   }

//   String getPackageDisplay() {
//     final isEdited = packageEdited[selectedPackage.value] == true;
//     final subtotal = calculateSubtotal();
//     final perGuestCost = (subtotal / (guests.value > 0 ? guests.value : 1))
//         .toStringAsFixed(0);

//     if (isEdited) {
//       return '${selectedPackage.value} (Customized) - £$perGuestCost/Guest';
//     } else {
//       return '${selectedPackage.value} (£$perGuestCost/Guest)';
//     }
//   }

//   // Confirmation UI
//   void showBookingConfirmation() {
//     if (!isFormValid.value) {
//       Get.snackbar(
//         'Error',
//         'Please fill in all required fields',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return;
//     }

//     confirmPressCount.value++;

//     if (confirmPressCount.value == 1) {
//       Get.dialog(ReceiptPopup(controller: this), barrierDismissible: false);
//     } else if (confirmPressCount.value >= 2) {
//       Get.dialog(
//         PaymentPopup(
//           eventName: selectedEventType.value,
//           venue: selectedCity.value,
//           date: selectedDate.value!,
//           startTime: startTime.value!,
//           endTime: endTime.value!,
//           guests: guests.value,
//           package: selectedPackage.value,
//           totalAmount: calculateTotal(),
//           customerName: nameController.text,
//           customerEmail: emailController.text,
//           onConfirm: completeBooking,
//           onCancel: cancelBookingPopup,
//         ),
//       );
//     }
//   }

//   // In your BookingController, replace the completeBooking method with this enhanced version:
//   Future<void> completeBooking() async {
//     try {
//       if (!isFormValid.value) {
//         Get.snackbar(
//           'Error',
//           'Please fill in all required fields',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//         return;
//       }

//       // Get the current menu for the selected package
//       final menu = menuForPackage(selectedPackage.value, guests.value);
//       final bool isCustomFlag = packageEdited[selectedPackage.value] == true;

//       // Prepare order services from the services in the menu
//       List<Map<String, dynamic>> orderServices = [];
//       for (var service in menu['Services']!) {
//         final serviceItem = apiServiceItems
//             .expand(
//               (category) => (category['menu_items'] as List<dynamic>? ?? []),
//             )
//             .firstWhere(
//               (item) => item['title'] == service['name'],
//               orElse: () => null,
//             );

//         if (serviceItem != null) {
//           orderServices.add({
//             "menu_item_id": serviceItem['id'],
//             "price": service['price'].toString(),
//           });
//         }
//       }

//       // Prepare order packages with items
//       List<Map<String, dynamic>> orderPackages = [];

//       // Get package details
//       final packageData = apiPackages.firstWhere(
//         (pkg) => pkg['id'].toString() == selectedPackageId.value,
//         orElse: () => {},
//       );

//       if (packageData.isNotEmpty) {
//         List<Map<String, dynamic>> packageItems = [];

//         int? _resolveMenuItemId(Map<String, dynamic> entry) {
//           final dynamic direct = entry['menu_item_id'] ?? entry['id'];
//           if (direct != null) {
//             final parsed = int.tryParse(direct.toString());
//             if (parsed != null) return parsed;
//           }
//           final String name = entry['name']?.toString() ?? '';
//           // Search in foods
//           final foodFound = apiMenuItems
//               .expand((cat) => (cat['menu_items'] as List<dynamic>? ?? []))
//               .cast<Map>()
//               .firstWhere(
//                 (it) => (it['title']?.toString() ?? '') == name,
//                 orElse: () => {},
//               );
//           if (foodFound.isNotEmpty) {
//             return int.tryParse(foodFound['id']?.toString() ?? '');
//           }
//           // Search in services
//           final svcFound = apiServiceItems
//               .expand((cat) => (cat['menu_items'] as List<dynamic>? ?? []))
//               .cast<Map>()
//               .firstWhere(
//                 (it) => (it['title']?.toString() ?? '') == name,
//                 orElse: () => {},
//               );
//           if (svcFound.isNotEmpty) {
//             return int.tryParse(svcFound['id']?.toString() ?? '');
//           }
//           return null;
//         }

//         void _addEntryToPackageItems(
//           Map<String, dynamic> entry, {
//           required bool isFood,
//         }) {
//           final int? menuItemId = _resolveMenuItemId(entry);
//           if (menuItemId == null) return;
//           final num priceNum = (entry['price'] as num?) ?? 0;
//           final int qty = (entry['qty'] is int)
//               ? entry['qty'] as int
//               : int.tryParse(entry['qty']?.toString() ?? '') ??
//                     (isFood ? guests.value : 1);
//           packageItems.add({
//             "menu_item_id": menuItemId,
//             "price": priceNum.toString(),
//             "no_of_gust": qty.toString(),
//             "is_deleted": false,
//           });
//         }

//         // Add all food items
//         for (final food in menu['Food Items']!) {
//           _addEntryToPackageItems(food, isFood: true);
//         }
//         // Add all services as items as well
//         for (final svc in menu['Services']!) {
//           _addEntryToPackageItems(svc, isFood: false);
//         }

//         orderPackages.add({
//           "package_id": selectedPackageId
//               .value, //TODO: we need to pass geand total of the system
//           "amount": calculateTotal().toStringAsFixed(2),
//           "is_custom": isCustomFlag,
//           "order_package_items_attributes": packageItems,
//         });
//       }

//       // Format dates properly for API
//       String formatDateForApi(DateTime? date) {
//         if (date == null) return '';
//         return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
//       }

//       String formatTimeForApi(TimeOfDay? time) {
//         if (time == null) return '';
//         return "2000-01-01T${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00.000Z";
//       }

//       // Prepare the complete order data matching your API structure
//       Map<String, dynamic> orderData = {
//         "firstname": nameController.text.split(' ').first,
//         "lastname": nameController.text.split(' ').length > 1
//             ? nameController.text.split(' ').sublist(1).join(' ')
//             : nameController.text,
//         "email": emailController.text,
//         "phone": contactController.text,
//         "nin":
//             "123456789", // You can make this a field in your form or generate it
//         "city_id": selectedCityId.value,
//         "address": selectedCity
//             .value, // Using city as address, you might want an address field
//         "event_id": selectedEventId.value,
//         "no_of_gust": guests.value.toString(),
//         "event_date": formatDateForApi(selectedDate.value),
//         "event_time": formatTimeForApi(startTime.value),
//         "start_time": formatTimeForApi(startTime.value),
//         "end_time": formatTimeForApi(endTime.value),
//         "requirement": specialRequirementsController.text.isEmpty
//             ? "No special requirements"
//             : specialRequirementsController.text,
//         "payment_method_id": 1,
//         "is_inquiry": false,
//         // Hardcoded as CASH for now
//         // Include order services if any
//         if (orderServices.isNotEmpty)
//           "order_services_attributes": orderServices,

//         // Include order packages
//         "order_packages_attributes": orderPackages,
//       };

//       print('Sending order data: ${jsonEncode(orderData)}');

//       // Send order to API
//       final result = await ApiService.createOrder(
//         orderData: orderData,
//         token: ApiService.bearerToken,
//       );

//       if (result['success'] == true) {
//         confirmPressCount.value = 0;
//         Get.back(); // Close popup

//         Get.snackbar(
//           'Success',
//           'Booking confirmed successfully! Order ID: ${result['data']?['id'] ?? 'N/A'}',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//         );

//         // Clear form after successful booking
//         clearForm();
//         Get.to(SchedulePage());
//         // Navigate back
//       } else {
//         throw Exception(result['error'] ?? 'Failed to create order');
//       }
//     } catch (e) {
//       Get.back();
//       Get.snackbar(
//         'Error',
//         'Failed to save booking: $e',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }

//   Future<void> completeInquiryBooking() async {
//     try {
//       if (!isFormValid.value) {
//         Get.snackbar(
//           'Error',
//           'Please fill in all required fields',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//         return;
//       }

//       // Get the current menu for the selected package
//       final menu = menuForPackage(selectedPackage.value, guests.value);
//       final bool isCustomFlag = packageEdited[selectedPackage.value] == true;

//       // Prepare order services from the services in the menu
//       List<Map<String, dynamic>> orderServices = [];
//       for (var service in menu['Services']!) {
//         final serviceItem = apiServiceItems
//             .expand(
//               (category) => (category['menu_items'] as List<dynamic>? ?? []),
//             )
//             .firstWhere(
//               (item) => item['title'] == service['name'],
//               orElse: () => null,
//             );

//         if (serviceItem != null) {
//           orderServices.add({
//             "menu_item_id": serviceItem['id'],
//             "price": service['price'].toString(),
//           });
//         }
//       }

//       // Prepare order packages with items
//       List<Map<String, dynamic>> orderPackages = [];

//       // Get package details
//       final packageData = apiPackages.firstWhere(
//         (pkg) => pkg['id'].toString() == selectedPackageId.value,
//         orElse: () => {},
//       );

//       if (packageData.isNotEmpty) {
//         List<Map<String, dynamic>> packageItems = [];

//         int? _resolveMenuItemId(Map<String, dynamic> entry) {
//           final dynamic direct = entry['menu_item_id'] ?? entry['id'];
//           if (direct != null) {
//             final parsed = int.tryParse(direct.toString());
//             if (parsed != null) return parsed;
//           }
//           final String name = entry['name']?.toString() ?? '';
//           // Search in foods
//           final foodFound = apiMenuItems
//               .expand((cat) => (cat['menu_items'] as List<dynamic>? ?? []))
//               .cast<Map>()
//               .firstWhere(
//                 (it) => (it['title']?.toString() ?? '') == name,
//                 orElse: () => {},
//               );
//           if (foodFound.isNotEmpty) {
//             return int.tryParse(foodFound['id']?.toString() ?? '');
//           }
//           // Search in services
//           final svcFound = apiServiceItems
//               .expand((cat) => (cat['menu_items'] as List<dynamic>? ?? []))
//               .cast<Map>()
//               .firstWhere(
//                 (it) => (it['title']?.toString() ?? '') == name,
//                 orElse: () => {},
//               );
//           if (svcFound.isNotEmpty) {
//             return int.tryParse(svcFound['id']?.toString() ?? '');
//           }
//           return null;
//         }

//         void _addEntryToPackageItems(
//           Map<String, dynamic> entry, {
//           required bool isFood,
//         }) {
//           final int? menuItemId = _resolveMenuItemId(entry);
//           if (menuItemId == null) return;
//           final num priceNum = (entry['price'] as num?) ?? 0;
//           final int qty = (entry['qty'] is int)
//               ? entry['qty'] as int
//               : int.tryParse(entry['qty']?.toString() ?? '') ??
//                     (isFood ? guests.value : 1);
//           packageItems.add({
//             "menu_item_id": menuItemId,
//             "price": priceNum.toString(),
//             "no_of_gust": qty.toString(),
//             "is_deleted": false,
//           });
//         }

//         // Add all food items
//         for (final food in menu['Food Items']!) {
//           _addEntryToPackageItems(food, isFood: true);
//         }
//         // Add all services as items as well
//         for (final svc in menu['Services']!) {
//           _addEntryToPackageItems(svc, isFood: false);
//         }

//         orderPackages.add({
//           "package_id": selectedPackageId.value,
//           "amount": calculateSubtotal().toStringAsFixed(2),
//           "is_custom": isCustomFlag,
//           "order_package_items_attributes": packageItems,
//         });
//       }

//       // Format dates properly for API
//       String formatDateForApi(DateTime? date) {
//         if (date == null) return '';
//         return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
//       }

//       String formatTimeForApi(TimeOfDay? time) {
//         if (time == null) return '';
//         return "2000-01-01T${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00.000Z";
//       }

//       // Prepare the complete order data matching your API structure
//       Map<String, dynamic> orderData = {
//         "firstname": nameController.text.split(' ').first,
//         "lastname": nameController.text.split(' ').length > 1
//             ? nameController.text.split(' ').sublist(1).join(' ')
//             : nameController.text,
//         "email": emailController.text,
//         "phone": contactController.text,
//         "is_inquiry": true,

//         "nin":
//             "123456789", // You can make this a field in your form or generate it
//         "city_id": selectedCityId.value,
//         "address": selectedCity
//             .value, // Using city as address, you might want an address field
//         "event_id": selectedEventId.value,
//         "no_of_gust": guests.value.toString(),
//         "event_date": formatDateForApi(selectedDate.value),
//         "event_time": formatTimeForApi(startTime.value),
//         "start_time": formatTimeForApi(startTime.value),
//         "end_time": formatTimeForApi(endTime.value),
//         "requirement": specialRequirementsController.text.isEmpty
//             ? "No special requirements"
//             : specialRequirementsController.text,
//         "payment_method_id": 1, // Hardcoded as CASH for now
//         // Include order services if any
//         if (orderServices.isNotEmpty)
//           "order_services_attributes": orderServices,

//         // Include order packages
//         "order_packages_attributes": orderPackages,
//       };

//       print('Sending order data: ${jsonEncode(orderData)}');

//       // Send order to API
//       final result = await ApiService.createOrder(
//         orderData: orderData,
//         token: ApiService.bearerToken,
//       );

//       if (result['success'] == true) {
//         confirmPressCount.value = 0;
//         Get.back(); // Close popup

//         Get.snackbar(
//           'Success',
//           'Booking confirmed successfully! Order ID: ${result['data']?['id'] ?? 'N/A'}',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//         );

//         // Clear form after successful booking
//         clearForm();

//         Get.back(); // Navigate back
//       } else {
//         throw Exception(result['error'] ?? 'Failed to create order');
//       }
//     } catch (e) {
//       Get.back();
//       Get.snackbar(
//         'Error',
//         'Failed to save booking: $e',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }

//   // Add this method to clear the form after successful booking
//   void clearForm() {
//     nameController.clear();
//     emailController.clear();
//     contactController.clear();
//     messageController.clear();
//     specialRequirementsController.clear();
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
//     isPackageEditing.value = false;
//     confirmPressCount.value = 0;

//     // Reset package edited states but keep custom package
//     final keys = packageEdited.keys.toList();
//     for (var key in keys) {
//       if (key != 'Custom Package') {
//         packageEdited[key] = false;
//       }
//     }
//   }

//   void resetPackageToOriginal(String packageTitle) {
//     if (packageTitle.isEmpty) return;

//     // Clear any saved custom selections
//     clearSavedSelection(packageTitle);

//     // Reset the edited state
//     packageEdited[packageTitle] = false;
//     isPackageEditing.value = false;

//     // Force reload the original package menu
//     final currentGuests = guests.value > 0 ? guests.value : 1;
//     final originalMenu = _getOriginalPackageMenu(packageTitle, currentGuests);

//     _customSelections.remove(packageTitle);
//     _saveSelectionToPrefs(packageTitle, originalMenu);

//     // Refresh the UI
//     update();
//   }

//   Map<String, List<Map<String, dynamic>>> _getOriginalPackageMenu(
//     String packageTitle,
//     int guestCount,
//   ) {
//     final pkg = _findPackage(packageTitle);
//     if (pkg == null) {
//       return {'Food Items': [], 'Services': []};
//     }

//     final List<Map<String, dynamic>> rawItems = ((pkg['items'] ?? []) as List)
//         .map((i) => Map<String, dynamic>.from(i as Map))
//         .toList();

//     final food = <Map<String, dynamic>>[];
//     final services = <Map<String, dynamic>>[];

//     for (var item in rawItems) {
//       final name = item['name'] as String;
//       final price = (item['price'] as num).toDouble();
//       final qtyStored = (item['qty'] is int)
//           ? item['qty'] as int
//           : (item['qty'] is double ? (item['qty'] as double).toInt() : 1);

//       final isFood = masterAvailableFood.any((f) => f['name'] == name);
//       final finalQty = isFood ? guestCount : qtyStored;

//       final entry = {
//         'name': name,
//         'price': price,
//         'qty': finalQty,
//         'menu_item_id': item['menu_item_id'] ?? item['id'],
//         'id': item['id'],
//       };

//       if (isFood) {
//         food.add(Map<String, dynamic>.from(entry));
//       } else {
//         services.add(Map<String, dynamic>.from(entry));
//       }
//     }

//     return {'Food Items': food, 'Services': services};
//   }
//   // Future<void> completeBooking() async {
//   //   try {
//   //     // Prepare order data for API
//   //     final orderData = ApiService.formatOrderData(
//   //       firstname: nameController.text.split(' ').first,
//   //       lastname: nameController.text.split(' ').length > 1
//   //           ? nameController.text.split(' ').sublist(1).join(' ')
//   //           : nameController.text,
//   //       email: emailController.text,
//   //       phone: contactController.text,
//   //       nin: '12312321321321321', // You might want to make this dynamic
//   //       cityId: selectedCityId.value,
//   //       address: selectedCity.value,
//   //       eventId: selectedEventId.value,
//   //       noOfGest: guests.value.toString(),
//   //       eventDate: selectedDate.value!.toString().split(' ')[0],
//   //       eventTime: startTime.value!.format(Get.context!),
//   //       startTime: startTime.value!.format(Get.context!),
//   //       endTime: endTime.value!.format(Get.context!),
//   //       requirement: specialRequirementsController.text.isEmpty
//   //           ? 'No special requirements'
//   //           : specialRequirementsController.text,
//   //       orderPackages: [
//   //         {
//   //           "package_id": selectedPackageId.value,
//   //           "amount": calculateSubtotal().toStringAsFixed(2),
//   //           "order_package_items_attributes": _preparePackageItems(),
//   //         },
//   //       ],
//   //     );

//   //     // Send order to API
//   //     final result = await ApiService.createOrder(orderData: orderData);

//   //     if (result['success'] == true) {
//   //       confirmPressCount.value = 0;
//   //       Get.back(); // Close popup

//   //       Get.snackbar(
//   //         'Success',
//   //         'Booking confirmed successfully!',
//   //         snackPosition: SnackPosition.BOTTOM,
//   //         backgroundColor: Colors.green,
//   //         colorText: Colors.white,
//   //       );

//   //       Get.back(); // navigate back
//   //     } else {
//   //       throw Exception(result['error'] ?? 'Failed to create order');
//   //     }
//   //   } catch (e) {
//   //     Get.back();
//   //     Get.snackbar(
//   //       'Error',
//   //       'Failed to save booking: $e',
//   //       snackPosition: SnackPosition.BOTTOM,
//   //       backgroundColor: Colors.red,
//   //       colorText: Colors.white,
//   //     );
//   //   }
//   // }

//   List<Map<String, dynamic>> _preparePackageItems() {
//     final menu = menuForPackage(selectedPackage.value, guests.value);
//     final items = <Map<String, dynamic>>[];

//     for (var item in menu['Food Items']!) {
//       items.add({
//         "menu_item_id": _getMenuItemId(item['name']),
//         "price": item['price'].toString(),
//         "is_deleted": "0",
//       });
//     }

//     for (var item in menu['Services']!) {
//       items.add({
//         "menu_item_id": _getMenuItemId(item['name']),
//         "price": item['price'].toString(),
//         "is_deleted": "0",
//       });
//     }

//     return items;
//   }

//   String _getMenuItemId(String itemName) {
//     // This should map item names to their IDs from the API
//     // For now, using placeholder IDs - you might need to adjust this
//     final Map<String, String> itemIdMap = {
//       "Chicken Tikka": "5",
//       "Paneer Tikka": "8",
//       "Mutton Biryani": "11",
//       // Add more mappings as needed
//     };
//     return itemIdMap[itemName] ?? "1";
//   }

//   void cancelBookingPopup() {
//     confirmPressCount.value = 0;
//     Get.back();
//   }

//   void cancelBooking() {
//     confirmPressCount.value = 0;
//     Get.back();
//   }

//   // ---------------------------
//   // Package & menu related API
//   // ---------------------------

//   Map<String, dynamic>? _findPackage(String title) {
//     final idx = packages.indexWhere((p) => p['title'] == title);
//     if (idx == -1) return null;
//     return packages[idx];
//   }

//   Map<String, List<Map<String, dynamic>>> menuForPackage(
//     String packageTitle,
//     int guestCount,
//   ) {
//     // If user has a saved custom selection for this package, use it first
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

//   // Map<String, List<Map<String, dynamic>>> menuForPackage(
//   //   String packageTitle,
//   //   int guestCount,
//   // ) {
//   //   // If user has a saved custom selection for this package, use it first
//   //   final saved = _customSelections[packageTitle];
//   //   if (saved != null && (packageEdited[packageTitle] == true)) {
//   //     // Normalize quantities: ensure qty present; for food default to guestCount
//   //     final food = <Map<String, dynamic>>[];
//   //     final services = <Map<String, dynamic>>[];
//   //     for (final item in (saved['Food Items'] ?? [])) {
//   //       final int qty = (item['qty'] is int)
//   //           ? item['qty'] as int
//   //           : int.tryParse(item['qty']?.toString() ?? '') ?? guestCount;
//   //       final normalized = Map<String, dynamic>.from(item);
//   //       normalized['qty'] = qty;
//   //       food.add(normalized);
//   //     }
//   //     for (final item in (saved['Services'] ?? [])) {
//   //       final int qty = (item['qty'] is int)
//   //           ? item['qty'] as int
//   //           : int.tryParse(item['qty']?.toString() ?? '') ?? 1;
//   //       final normalized = Map<String, dynamic>.from(item);
//   //       normalized['qty'] = qty;
//   //       services.add(normalized);
//   //     }
//   //     return {'Food Items': food, 'Services': services};
//   //   }

//   //   final pkg = _findPackage(packageTitle);
//   //   if (pkg == null) {
//   //     return {'Food Items': [], 'Services': []};
//   //   }

//   //   final List<Map<String, dynamic>> rawItems = ((pkg['items'] ?? []) as List)
//   //       .map((i) => Map<String, dynamic>.from(i as Map))
//   //       .toList();

//   //   final food = <Map<String, dynamic>>[];
//   //   final services = <Map<String, dynamic>>[];

//   //   for (var item in rawItems) {
//   //     final name = item['name'] as String;
//   //     final price = (item['price'] as num).toDouble();
//   //     final qtyStored = (item['qty'] is int)
//   //         ? item['qty'] as int
//   //         : (item['qty'] is double ? (item['qty'] as double).toInt() : 1);

//   //     final isApiPackage = _isApiPackage(packageTitle);

//   //     // Quantity calculation: always use guest count for food, stored quantity for services
//   //     final isFood = masterAvailableFood.any((f) => f['name'] == name);
//   //     final finalQty = isFood ? guestCount : qtyStored;

//   //     final entry = {
//   //       'name': name,
//   //       'price': price,
//   //       'qty': finalQty,
//   //       'menu_item_id': item['menu_item_id'] ?? item['id'],
//   //       'id': item['id'],
//   //     };

//   //     if (isFood) {
//   //       food.add(Map<String, dynamic>.from(entry));
//   //     } else {
//   //       services.add(Map<String, dynamic>.from(entry));
//   //     }
//   //   }

//   //   return {'Food Items': food, 'Services': services};
//   // }

//   void toggleEditMode(bool editing) {
//     isPackageEditing.value = editing;
//   }

//   // Determine if menu has diverged from the predefined package items
//   bool hasMenuChangedFromPackage(
//     String packageTitle,
//     Map<String, List<Map<String, dynamic>>> currentMenu,
//     int guestCount,
//   ) {
//     final baseline = menuForPackage(packageTitle, guestCount);

//     bool listEqualsByIdQty(
//       List<Map<String, dynamic>> a,
//       List<Map<String, dynamic>> b,
//     ) {
//       if (a.length != b.length) return false;
//       // Compare by menu_item_id/id and qty
//       final normalize = (List<Map<String, dynamic>> list) =>
//           list
//               .map(
//                 (e) => {
//                   'id': (e['menu_item_id'] ?? e['id']).toString(),
//                   'qty': (e['qty'] as int),
//                 },
//               )
//               .toList()
//             ..sort((x, y) => (x['id'] as String).compareTo(y['id'] as String));
//       final na = normalize(a);
//       final nb = normalize(b);
//       for (var i = 0; i < na.length; i++) {
//         if (na[i]['id'] != nb[i]['id'] || na[i]['qty'] != nb[i]['qty']) {
//           return false;
//         }
//       }
//       return true;
//     }

//     final changedFood = !listEqualsByIdQty(
//       baseline['Food Items'] ?? [],
//       currentMenu['Food Items'] ?? [],
//     );
//     final changedServices = !listEqualsByIdQty(
//       baseline['Services'] ?? [],
//       currentMenu['Services'] ?? [],
//     );
//     return changedFood || changedServices;
//   }

//   List<Map<String, dynamic>> get masterAvailableFood {
//     if (apiMenuItems.isNotEmpty) {
//       final List<Map<String, dynamic>> allFoodItems = [];

//       for (var category in apiMenuItems) {
//         if (category['menu_items'] is List) {
//           for (var item in category['menu_items'] as List) {
//             allFoodItems.add({
//               "name": item['title']?.toString() ?? 'Unknown Item',
//               "price": _parsePriceString(item['price']?.toString()),
//               "id": item['id']?.toString(),
//               "category": category['title']?.toString() ?? 'Uncategorized',
//               // Preserve menu_item_id alias for consistent mapping
//               "menu_item_id": item['id']?.toString(),
//             });
//           }
//         }
//       }

//       return allFoodItems;
//     }

//     // Fallback to existing data
//     return [
//       // {"name": "Chicken Tikka", "price": 250.0},
//       // {"name": "Paneer Tikka", "price": 250.0},
//       // {"name": "Mutton Biryani", "price": 350.0},
//       // {"name": "Butter Chicken", "price": 300.0},
//     ];
//   }

//   List<Map<String, dynamic>> get masterAvailableServices {
//     if (apiServiceItems.isNotEmpty) {
//       final List<Map<String, dynamic>> allServiceItems = [];

//       for (var category in apiServiceItems) {
//         if (category['menu_items'] is List) {
//           for (var item in category['menu_items'] as List) {
//             allServiceItems.add({
//               "name": item['title']?.toString() ?? 'Unknown Service',
//               "price": _parsePriceString(item['price']?.toString()),
//               "id": item['id']?.toString(),
//               "category": category['title']?.toString() ?? 'Uncategorized',
//               // Preserve menu_item_id alias for consistent mapping
//               "menu_item_id": item['id']?.toString(),
//             });
//           }
//         }
//       }

//       return allServiceItems;
//     }

//     // Fallback to existing data
//     return [
//       // {"name": "Please Select a", "price": 1000.0},
//     ];
//   }

//   bool isPackageEditable(String packageTitle) {
//     return true;
//   }

//   bool isCustomPackage(String packageTitle) {
//     final pkg = _findPackage(packageTitle);
//     if (pkg == null) return false;
//     return (pkg['editable'] == true);
//   }

//   void createOrOpenCustomPackage() {
//     const customTitle = 'Custom Package';
//     final existing = packages.indexWhere((p) => p['title'] == customTitle);
//     if (existing == -1) {
//       final newPkg = {
//         'id': 'custom-${DateTime.now().millisecondsSinceEpoch}',
//         'title': customTitle,
//         'description': 'Custom editable package',
//         'price': '£0',
//         'items': <Map<String, dynamic>>[],
//         'editable': true,
//       };
//       // Add to local list (not to API)
//       packages.add(newPkg);
//       packageEdited[customTitle] = true;
//     }
//     selectedPackage.value = customTitle;
//   }

//   void updateCustomPackageItems(
//     String packageTitle,
//     Map<String, List<Map<String, dynamic>>> newMenu,
//   ) {
//     final idx = packages.indexWhere((p) => p['title'] == packageTitle);
//     if (idx == -1) return;

//     final newItems = <Map<String, dynamic>>[];

//     for (var f in newMenu['Food Items'] ?? []) {
//       newItems.add({
//         'name': f['name'],
//         'price': (f['price'] as num).toDouble(),
//         'qty': (f['qty'] as int),
//         'id': f['id'] ?? f['menu_item_id'],
//         'menu_item_id': f['menu_item_id'] ?? f['id'],
//       });
//     }
//     for (var s in newMenu['Services'] ?? []) {
//       newItems.add({
//         'name': s['name'],
//         'price': (s['price'] as num).toDouble(),
//         'qty': (s['qty'] as int),
//         'id': s['id'] ?? s['menu_item_id'],
//         'menu_item_id': s['menu_item_id'] ?? s['id'],
//       });
//     }

//     packages[idx]['items'] = newItems;
//     packageEdited[packageTitle] = true;
//     _customSelections[packageTitle] = {
//       'Food Items': (newMenu['Food Items'] ?? [])
//           .map((e) => Map<String, dynamic>.from(e))
//           .toList(),
//       'Services': (newMenu['Services'] ?? [])
//           .map((e) => Map<String, dynamic>.from(e))
//           .toList(),
//     };

//     // Persist selection
//     _saveSelectionToPrefs(packageTitle, _customSelections[packageTitle]!);
//     update(); // Refresh UI
//   }

//   void switchToCustomPackageAndUpdate(
//     Map<String, List<Map<String, dynamic>>> currentMenu,
//   ) {
//     // Switch to custom package
//     createOrOpenCustomPackage();

//     // Update custom package with current menu
//     updateCustomPackageItems('Custom Package', currentMenu);

//     // Mark as edited
//     markPackageAsEdited();

//     // Refresh UI
//     update();
//   }
//   // void updateCustomPackageItems(
//   //   String packageTitle,
//   //   Map<String, List<Map<String, dynamic>>> newMenu,
//   // ) {
//   //   final idx = packages.indexWhere((p) => p['title'] == packageTitle);
//   //   if (idx == -1) return;

//   //   final newItems = <Map<String, dynamic>>[];

//   //   for (var f in newMenu['Food Items'] ?? []) {
//   //     newItems.add({
//   //       'name': f['name'],
//   //       'price': (f['price'] as num).toDouble(),
//   //       'qty': (f['qty'] as int),
//   //       'id': f['id'] ?? f['menu_item_id'],
//   //       'menu_item_id': f['menu_item_id'] ?? f['id'],
//   //     });
//   //   }
//   //   for (var s in newMenu['Services'] ?? []) {
//   //     newItems.add({
//   //       'name': s['name'],
//   //       'price': (s['price'] as num).toDouble(),
//   //       'qty': (s['qty'] as int),
//   //       'id': s['id'] ?? s['menu_item_id'],
//   //       'menu_item_id': s['menu_item_id'] ?? s['id'],
//   //     });
//   //   }

//   //   packages[idx]['items'] = newItems;
//   //   packageEdited[packageTitle] = true;
//   //   _customSelections[packageTitle] = {
//   //     'Food Items': (newMenu['Food Items'] ?? [])
//   //         .map((e) => Map<String, dynamic>.from(e))
//   //         .toList(),
//   //     'Services': (newMenu['Services'] ?? [])
//   //         .map((e) => Map<String, dynamic>.from(e))
//   //         .toList(),
//   //   };
//   //   // Persist selection
//   //   _saveSelectionToPrefs(packageTitle, _customSelections[packageTitle]!);
//   // }

//   void clearSavedSelection(String packageTitle) {
//     _customSelections.remove(packageTitle);
//     packageEdited[packageTitle] = false;
//   }

//   // Inquiry flow
//   bool _validateInquiry() {
//     return selectedDate.value != null &&
//         startTime.value != null &&
//         endTime.value != null &&
//         guests.value > 0 &&
//         selectedEventType.value.isNotEmpty;
//   }

//   void showInquiry() {
//     if (!_validateInquiry()) {
//       Get.snackbar(
//         'Error',
//         'Please fill required fields for an inquiry (date, time, guests, event type).',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return;
//     }

//     Get.dialog(
//       AlertDialog(
//         title: const Text('Send Inquiry'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Event: ${selectedEventType.value}'),
//             const SizedBox(height: 6),
//             Text(
//               'Date: ${selectedDate.value!.day}/${selectedDate.value!.month}/${selectedDate.value!.year}',
//             ),
//             const SizedBox(height: 6),
//             Text(
//               'Time: ${startTime.value!.format(Get.context!)} - ${endTime.value!.format(Get.context!)}',
//             ),
//             const SizedBox(height: 6),
//             Text('Guests: ${guests.value}'),
//             const SizedBox(height: 6),
//             Text('Package: ${selectedPackage.value}'),
//             const SizedBox(height: 8),
//             const Text(
//               'Name, email and city are optional for inquiry. We will contact you for details.',
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
//           ElevatedButton(
//             onPressed: () {
//               Get.back();
//               _sendInquiry();
//             },
//             child: const Text('Send Inquiry'),
//           ),
//         ],
//       ),
//       barrierDismissible: false,
//     );
//   }

//   void _sendInquiry() {
//     // TODO: Implement inquiry API when available
//     Get.snackbar(
//       'Inquiry Sent',
//       'Your inquiry has been sent. We will contact you soon.',
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.green,
//       colorText: Colors.white,
//     );
//   }

//   // Helpers used by selection UI
//   List<Map<String, dynamic>> availableFoodForSelection() {
//     final menu = menuForPackage(
//       selectedPackage.value,
//       guests.value > 0 ? guests.value : 1,
//     );
//     final foodNames = menu['Food Items']!.map((d) => d['name']).toSet();
//     return masterAvailableFood
//         .where((f) => !foodNames.contains(f['name']))
//         .map((e) => Map<String, dynamic>.from(e))
//         .toList();
//   }

//   List<Map<String, dynamic>> availableServicesForSelection() {
//     final menu = menuForPackage(
//       selectedPackage.value,
//       guests.value > 0 ? guests.value : 1,
//     );
//     final serviceNames = menu['Services']!.map((d) => d['name']).toSet();
//     return masterAvailableServices
//         .where((s) => !serviceNames.contains(s['name']))
//         .map((e) => Map<String, dynamic>.from(e))
//         .toList();
//   }

//   // Add this method to your BookingController for testing the order data
//   Future<void> testOrderData() async {
//     try {
//       // Validate that all required fields are filled
//       if (!isFormValid.value) {
//         Get.snackbar(
//           'Error',
//           'Please fill in all required fields before testing',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//         return;
//       }

//       // Show a dialog with the data that will be sent
//       Get.dialog(
//         AlertDialog(
//           title: Text('Test Order Data'),
//           content: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   'This is the data that will be sent to the API:',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 10),
//                 Text('Name: ${nameController.text}'),
//                 Text('Email: ${emailController.text}'),
//                 Text('Phone: ${contactController.text}'),
//                 Text(
//                   'City: ${selectedCity.value} (ID: ${selectedCityId.value})',
//                 ),
//                 Text(
//                   'Event: ${selectedEventType.value} (ID: ${selectedEventId.value})',
//                 ),
//                 Text(
//                   'Package: ${selectedPackage.value} (ID: ${selectedPackageId.value})',
//                 ),
//                 Text('Guests: ${guests.value}'),
//                 Text('Date: ${selectedDate.value}'),
//                 Text(
//                   'Time: ${startTime.value?.format(Get.context!)} - ${endTime.value?.format(Get.context!)}',
//                 ),
//                 Text('Requirements: ${specialRequirementsController.text}'),
//                 SizedBox(height: 10),
//                 Text('Subtotal: £${calculateSubtotal().toStringAsFixed(2)}'),
//                 Text('Total: £${calculateTotal().toStringAsFixed(2)}'),
//                 SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: () async {
//                     // Get.back();
//                     await completeBooking();
//                     Get.to(() => SchedulePage());
//                   },
//                   child: Text('Send Actual Order'),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
//           ],
//         ),
//       );
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Error preparing test data: $e',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }

//   Future<void> testInquiryData() async {
//     try {
//       // Validate that all required fields are filled
//       if (!isFormValid.value) {
//         Get.snackbar(
//           'Error',
//           'Please fill in all required fields before testing',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//         return;
//       }

//       // Show a dialog with the data that will be sent
//       Get.dialog(
//         AlertDialog(
//           title: Text('Test Order Data'),
//           content: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   'This is the data that will be sent to the API:',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 10),
//                 Text('Name: ${nameController.text}'),
//                 Text('Email: ${emailController.text}'),
//                 Text('Phone: ${contactController.text}'),
//                 Text(
//                   'City: ${selectedCity.value} (ID: ${selectedCityId.value})',
//                 ),
//                 Text(
//                   'Event: ${selectedEventType.value} (ID: ${selectedEventId.value})',
//                 ),
//                 Text(
//                   'Package: ${selectedPackage.value} (ID: ${selectedPackageId.value})',
//                 ),
//                 Text('Guests: ${guests.value}'),
//                 Text('Date: ${selectedDate.value}'),
//                 Text(
//                   'Time: ${startTime.value?.format(Get.context!)} - ${endTime.value?.format(Get.context!)}',
//                 ),
//                 Text('Requirements: ${specialRequirementsController.text}'),
//                 SizedBox(height: 10),
//                 Text('Subtotal: £${calculateSubtotal().toStringAsFixed(2)}'),
//                 Text('Total: £${calculateTotal().toStringAsFixed(2)}'),
//                 SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: () async {
//                     // Get.back();
//                     await completeInquiryBooking();
//                   },
//                   child: Text('Send Actual Order'),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
//           ],
//         ),
//       );
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Error preparing test data: $e',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }
// }
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schedule_app/APIS/Api_Service.dart';
import 'package:schedule_app/pages/Recipt/bookingrecipt.dart';
import 'package:schedule_app/pages/schedule_page.dart';
import 'package:schedule_app/widgets/Payment_Popup.dart';

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

  // Form data
  final RxString selectedCity = ''.obs;
  final RxString selectedCityId = ''.obs;
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final Rx<TimeOfDay?> startTime = Rx<TimeOfDay?>(null);
  final Rx<TimeOfDay?> endTime = Rx<TimeOfDay?>(null);
  final RxInt guests = 1.obs;
  final RxString selectedEventType = ''.obs;
  final RxString selectedEventId = ''.obs;
  final RxBool isPackageEditing = false.obs;
  final RxString selectedPackage = ''.obs;
  final RxString selectedPackageId = ''.obs;

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

  @override
  void onInit() {
    super.onInit();
    loadApiData();

    // Listen to form changes for validation
    ever(selectedCity, (_) => _validateForm());
    ever(selectedDate, (_) => _validateForm());
    ever(startTime, (_) => _validateForm());
    ever(endTime, (_) => _validateForm());
    ever(guests, (_) => _validateForm());
    ever(selectedEventType, (_) => _validateForm());
    ever(selectedPackage, (_) => _validateForm());

    nameController.addListener(_validateForm);
    emailController.addListener(_validateForm);
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

  // Load data from APIs
  Future<void> loadApiData() async {
    isLoading.value = true;
    errorMessage.value = '';

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
          });
        }
      }

      return items;
    } catch (e) {
      return [];
    }
  }

  String generateReceiptHTML() {
    // Get the current menu for the selected package
    final menu = menuForPackage(
      selectedPackage.value,
      guests.value > 0 ? guests.value : 1,
    );

    // Calculate totals
    double foodSubtotal = 0;
    double servicesSubtotal = 0;

    for (var item in menu['Food Items']!) {
      foodSubtotal += (item['price'] as num).toDouble() * (item['qty'] as int);
    }

    for (var item in menu['Services']!) {
      servicesSubtotal +=
          (item['price'] as num).toDouble() * (item['qty'] as int);
    }

    double netAmount = foodSubtotal + servicesSubtotal;
    double serviceCharge = netAmount * 0.10;
    double discount = netAmount * 0.05;
    double subtotalAfterDiscount = netAmount + serviceCharge - discount;
    double vat = subtotalAfterDiscount * 0.20;
    double totalAmount = subtotalAfterDiscount + vat;

    // Format date and time
    String formatDate(DateTime? date) {
      if (date == null) return 'Not set';
      final day = date.day;
      final month = date.month;
      final year = date.year;
      final suffixes = [
        'th',
        'st',
        'nd',
        'rd',
        'th',
        'th',
        'th',
        'th',
        'th',
        'th',
      ];
      final suffix = day % 10 <= suffixes.length - 1
          ? suffixes[day % 10]
          : 'th';
      final months = [
        '',
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ];
      return '${day}$suffix ${months[month]} $year';
    }

    String formatTime(TimeOfDay? time) {
      if (time == null) return 'Not set';
      final hour = time.hourOfPeriod;
      final minute = time.minute.toString().padLeft(2, '0');
      final period = time.period == DayPeriod.am ? 'AM' : 'PM';
      return '$hour:$minute $period';
    }

    // Generate food items HTML
    String foodItemsHTML = '';
    for (var item in menu['Food Items']!) {
      foodItemsHTML +=
          '''
        <tr>
          <td>${item['name']}</td>
          <td>${item['qty']}</td>
          <td>£${(item['price'] as num).toStringAsFixed(2)}</td>
          <td>£${((item['price'] as num).toDouble() * (item['qty'] as int)).toStringAsFixed(2)}</td>
        </tr>
      ''';
    }

    // Generate services HTML
    String servicesHTML = '';
    for (var item in menu['Services']!) {
      servicesHTML +=
          '''
        <tr>
          <td>${item['name']}</td>
          <td>${item['qty']}</td>
          <td>£${(item['price'] as num).toStringAsFixed(2)}</td>
          <td>£${((item['price'] as num).toDouble() * (item['qty'] as int)).toStringAsFixed(2)}</td>
        </tr>
      ''';
    }

    // Generate customer initials for reference
    String getCustomerInitials() {
      if (nameController.text.isEmpty) return 'CUST';
      final names = nameController.text
          .trim()
          .split(' ')
          .where((name) => name.isNotEmpty)
          .toList();
      if (names.isEmpty) return 'CUST';
      if (names.length == 1) {
        return names[0].isNotEmpty ? names[0][0].toUpperCase() : 'CUST';
      }
      final firstInitial = names[0].isNotEmpty ? names[0][0].toUpperCase() : '';
      final lastInitial = names.last.isNotEmpty
          ? names.last[0].toUpperCase()
          : '';
      return firstInitial + lastInitial;
    }

    return '''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Confirmation Receipt - A4</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Times New Roman', serif; background-color: white; color: #000; line-height: 1.2; font-size: 12px; }
        .receipt-container { width: 210mm; height: 297mm; margin: 0 auto; background: white; border: 2px solid #000; padding: 15mm; overflow: hidden; }
        .header { text-align: center; border-bottom: 2px solid #000; padding-bottom: 8px; margin-bottom: 12px; }
        .company-name { font-size: 20px; font-weight: bold; margin-bottom: 3px; text-transform: uppercase; }
        .company-details { font-size: 10px; margin-bottom: 8px; line-height: 1.3; }
        .receipt-title { font-size: 16px; font-weight: bold; text-transform: uppercase; margin-top: 8px; }
        .receipt-info { display: flex; justify-content: space-between; margin-bottom: 12px; font-size: 9px; }
        .section { margin-bottom: 10px; }
        .section-title { font-size: 11px; font-weight: bold; text-transform: uppercase; border-bottom: 1px solid #000; padding-bottom: 2px; margin-bottom: 5px; }
        .info-table { width: 100%; font-size: 9px; margin-bottom: 5px; }
        .info-table td { padding: 1px 0; vertical-align: top; }
        .info-table td:first-child { width: 25%; font-weight: bold; }
        .order-table { width: 100%; border-collapse: collapse; margin-bottom: 8px; font-size: 8px; }
        .order-table th, .order-table td { border: 1px solid #000; padding: 3px; text-align: left; }
        .order-table th { background-color: #f0f0f0; font-weight: bold; text-transform: uppercase; font-size: 7px; }
        .order-table td:nth-child(2), .order-table td:nth-child(3), .order-table td:nth-child(4) { text-align: right; }
        .subtotal-section { border: 1px solid #000; padding: 8px; margin-top: 8px; }
        .subtotal-row { display: flex; justify-content: space-between; margin-bottom: 2px; font-size: 9px; }
        .subtotal-row.total { border-top: 2px solid #000; padding-top: 4px; margin-top: 5px; font-weight: bold; font-size: 11px; }
        .footer { border-top: 2px solid #000; padding-top: 8px; margin-top: 10px; text-align: center; font-size: 9px; }
        .terms { font-size: 7px; margin-top: 8px; text-align: justify; line-height: 1.2; }
        .signature-section { margin-top: 15px; display: flex; justify-content: space-between; }
        .signature-box { width: 150px; text-align: center; font-size: 8px; }
        .signature-line { border-bottom: 1px solid #000; margin-bottom: 3px; height: 20px; }
        .two-column { display: flex; gap: 10px; }
        .column { flex: 1; }
        @media print {
            @page { size: A4; margin: 0; }
            body { padding: 0; margin: 0; }
            .receipt-container { border: none; padding: 15mm; margin: 0; width: 210mm; height: 297mm; max-width: none; max-height: none; }
        }
        @media screen {
            body { padding: 10px; background-color: #f0f0f0; }
        }
        .cancel-icon { position: absolute; top: 15px; right: 15px; cursor: pointer; font-size: 20px; color: #ff0000; z-index: 1000; }
        .next-button { background-color: #28a745; color: white; border: none; padding: 12px 24px; font-size: 14px; font-weight: bold; border-radius: 4px; cursor: pointer; margin-top: 15px; transition: background-color 0.3s ease; }
        .next-button:hover { background-color: #218838; }
    </style>
</head>
<body>
   <div class="cancel-icon" onclick="handleCancel()">✕</div>
    <div class="receipt-container">
        <div class="header">
            <div class="company-name">Premium Event Catering Ltd.</div>
            <div class="company-details">
                123 Wedding Lane, London, EC1A 1BB<br>
                Tel: +44-20-7123-4567 | Email: events@premiumcatering.co.uk | VAT: GB123456789
            </div>
            <div class="receipt-title">Booking Confirmation Receipt</div>
        </div>
        
        <div class="receipt-info">
            <div>
                <strong>Receipt No:</strong> WED-${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}-001<br>
                <strong>Date:</strong> ${formatDate(DateTime.now())}<br>
                <strong>Payment Method:</strong> Bank Transfer
            </div>
            <div>
                <strong>Account Manager:</strong> Emma Wilson<br>
                <strong>Reference:</strong> WEDDING-${getCustomerInitials()}-001<br>
                <strong>Status:</strong> CONFIRMED
            </div>
        </div>
        
        <div class="two-column">
            <div class="column">
                <div class="section">
                    <div class="section-title">Customer Information</div>
                    <table class="info-table">
                        <tr><td>Customer Name:</td><td>${nameController.text}</td></tr>
                        <tr><td>Email:</td><td>${emailController.text}</td></tr>
                        <tr><td>Contact:</td><td>${contactController.text}</td></tr>
                        <tr><td>Event Address:</td><td>${selectedCity.value}</td></tr>
                    </table>
                </div>
            </div>
            <div class="column">
                <div class="section">
                    <div class="section-title">Event Details</div>
                    <table class="info-table">
                        <tr><td>Event Type:</td><td>${selectedEventType.value}</td></tr>
                        <tr><td>Date:</td><td>${formatDate(selectedDate.value)}</td></tr>
                        <tr><td>Time:</td><td>${formatTime(startTime.value)} - ${formatTime(endTime.value)}</td></tr>
                        <tr><td>Guests:</td><td>${guests.value} persons</td></tr>
                        <tr><td>Package:</td><td>${selectedPackage.value}</td></tr>
                    </table>
                </div>
            </div>
        </div>
        
        <div class="section">
            <div class="section-title">Food Items</div>
            <table class="order-table">
                <thead>
                    <tr>
                        <th style="width: 50%;">Description</th>
                        <th style="width: 15%;">Qty</th>
                        <th style="width: 17%;">Unit Price</th>
                        <th style="width: 18%;">Amount</th>
                    </tr>
                </thead>
                <tbody>
                    $foodItemsHTML
                </tbody>
            </table>
        </div>
        
        <div class="section">
            <div class="section-title">Additional Services</div>
            <table class="order-table">
                <thead>
                    <tr>
                        <th style="width: 50%;">Service Description</th>
                        <th style="width: 15%;">Qty</th>
                        <th style="width: 17%;">Rate</th>
                        <th style="width: 18%;">Amount</th>
                    </tr>
                </thead>
                <tbody>
                    $servicesHTML
                </tbody>
            </table>
        </div>
        
        <div class="subtotal-section">
            <div class="subtotal-row"><span>Food Items Subtotal:</span><span>£${foodSubtotal.toStringAsFixed(2)}</span></div>
            <div class="subtotal-row"><span>Services Subtotal:</span><span>£${servicesSubtotal.toStringAsFixed(2)}</span></div>
            <div class="subtotal-row"><span>Net Amount:</span><span>£${netAmount.toStringAsFixed(2)}</span></div>
            <div class="subtotal-row"><span>Service Charge (10%):</span><span>£${serviceCharge.toStringAsFixed(2)}</span></div>
            <div class="subtotal-row"><span>Early Booking Discount (5%):</span><span>-£${discount.toStringAsFixed(2)}</span></div>
            <div class="subtotal-row"><span>Subtotal after Discount:</span><span>£${subtotalAfterDiscount.toStringAsFixed(2)}</span></div>
            <div class="subtotal-row"><span>VAT @ 20%:</span><span>£${vat.toStringAsFixed(2)}</span></div>
            <div class="subtotal-row total"><span>TOTAL AMOUNT:</span><span>£${totalAmount.toStringAsFixed(2)}</span></div>
        </div>
        
        <div class="footer">
            <p><strong>BOOKING CONFIRMED - PAYMENT DUE: 50% DEPOSIT BY ${formatDate(selectedDate.value?.subtract(const Duration(days: 14)))}</strong></p>
            <p>Balance payment due 7 days prior to event date</p>
            
            <div class="terms">
                <strong>Terms & Conditions:</strong> This booking is subject to our standard terms and conditions. Cancellation policy: 30 days notice required for full refund minus 10% administration fee. Final guest numbers must be confirmed 7 days prior to event. Additional charges may apply for changes made within 48 hours of event. All prices include VAT at current rate.
            </div>
            
            <div class="signature-section">
                <div class="signature-box">
                    <div class="signature-line"></div>
                    <div>Customer Signature</div>
                </div>
                <div class="signature-box">
                    <div class="signature-line"></div>
                    <div>Authorized Signature</div>
                </div>
            </div>
            
            <!-- Close button for the receipt -->
            <div style="text-align: center; margin-top: 20px;">
                <button class="next-button" onclick="handleNext()">Close</button>
            </div>
        </div>
    </div>
       <script>
        window.addEventListener('load', function() {
            console.log('Page loaded - checking for available channels');
            console.log('cancelBooking available:', typeof window.cancelBooking !== 'undefined');
            console.log('navigateToNextScreen available:', typeof window.navigateToNextScreen !== 'undefined');
            console.log('flutter_inappwebview available:', typeof window.flutter_inappwebview !== 'undefined');
        });
        
        function handleCancel() {
            console.log('handleCancel() function called');
            
            if (typeof window.cancelBooking !== 'undefined') {
                console.log('Using cancelBooking channel directly');
                window.cancelBooking.postMessage('');
            } else if (typeof window.flutter_inappwebview !== 'undefined') {
                console.log('Using flutter_inappwebview API for cancel');
                window.flutter_inappwebview.callHandler('cancelBooking');
            } else {
                console.log('Cancel button clicked - WebView handler not available');
                console.log('Available window objects:', Object.keys(window).filter(key => key.includes('flutter') || key.includes('navigate') || key.includes('cancel')));
                alert('Cancel button clicked - Navigation not available. Check console for details.');
            }
        }
        
        function handleNext() {
            console.log('Close button clicked - closing receipt');
            
            if (typeof window.navigateToNextScreen !== 'undefined') {
                console.log('Using navigateToNextScreen channel directly');
                window.navigateToNextScreen.postMessage('');
            } else if (typeof window.cancelBooking !== 'undefined') {
                console.log('Using cancelBooking channel to close');
                window.cancelBooking.postMessage('');
            } else if (typeof window.flutter_inappwebview !== 'undefined') {
                console.log('Using flutter_inappwebview API to close');
                window.flutter_inappwebview.callHandler('navigateToNextScreen');
            } else {
                console.log('Close button clicked - WebView handler not available');
                console.log('Available window objects:', Object.keys(window).filter(key => key.includes('flutter') || key.includes('navigate') || key.includes('cancel')));
                alert('Close button clicked - Closing not available. Check console for details.');
            }
        }
    </script>
</body>
</html>
    ''';
  }

  void _validateForm() {
    isFormValid.value =
        nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        selectedCity.value.isNotEmpty &&
        selectedDate.value != null &&
        startTime.value != null &&
        endTime.value != null &&
        guests.value > 0 &&
        selectedEventType.value.isNotEmpty;
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
    final menu = menuForPackage(
      selectedPackage.value,
      guests.value > 0 ? guests.value : 1,
    );

    double total = 0.0;
    for (var item in menu['Food Items']!) {
      total += (item['price'] as num).toDouble() * (item['qty'] as int);
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
      return 'Custom Package - £$perGuestCost/Guest';
    } else {
      return '${selectedPackage.value} (£$perGuestCost/Guest)';
    }
  }

  // Confirmation UI
  void showBookingConfirmation() {
    if (!isFormValid.value) {
      Get.snackbar(
        'Error',
        'Please fill in all required fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    confirmPressCount.value++;

    if (confirmPressCount.value == 1) {
      Get.dialog(ReceiptPopup(controller: this), barrierDismissible: false);
    } else if (confirmPressCount.value >= 2) {
      Get.dialog(
        PaymentPopup(
          eventName: selectedEventType.value,
          venue: selectedCity.value,
          date: selectedDate.value!,
          startTime: startTime.value!,
          endTime: endTime.value!,
          guests: guests.value,
          package: selectedPackage.value,
          totalAmount: calculateTotal(),
          customerName: nameController.text,
          customerEmail: emailController.text,
          onConfirm: completeBooking,
          onCancel: cancelBookingPopup,
        ),
      );
    }
  }

  Future<void> completeBooking() async {
    try {
      if (!isFormValid.value) {
        Get.snackbar(
          'Error',
          'Please fill in all required fields',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Get the current menu for the selected package
      final menu = menuForPackage(selectedPackage.value, guests.value);
      final bool isCustomFlag =
          isPackageEditing.value && selectedPackage.value == 'Custom Package';

      // Prepare order services from the services in the menu
      List<Map<String, dynamic>> orderServices = [];
      for (var service in menu['Services']!) {
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
          });
        }

        // Add all food items
        for (final food in menu['Food Items']!) {
          _addEntryToPackageItems(food, isFood: true);
        }
        // Add all services as items as well
        for (final svc in menu['Services']!) {
          _addEntryToPackageItems(svc, isFood: false);
        }

        orderPackages.add({
          "package_id": selectedPackageId.value,
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

        Get.snackbar(
          'Success',
          'Booking confirmed successfully! Order ID: ${result['data']?['id'] ?? 'N/A'}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Clear form after successful booking
        clearForm();
        Get.to(SchedulePage());
      } else {
        throw Exception(result['error'] ?? 'Failed to create order');
      }
    } catch (e) {
      Get.back();
      Get.snackbar(
        'Error',
        'Failed to save booking: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> completeInquiryBooking() async {
    try {
      if (!isFormValid.value) {
        Get.snackbar(
          'Error',
          'Please fill in all required fields',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Get the current menu for the selected package
      final menu = menuForPackage(selectedPackage.value, guests.value);
      final bool isCustomFlag =
          isPackageEditing.value && selectedPackage.value == 'Custom Package';

      // Prepare order services from the services in the menu
      List<Map<String, dynamic>> orderServices = [];
      for (var service in menu['Services']!) {
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
          });
        }

        // Add all food items
        for (final food in menu['Food Items']!) {
          _addEntryToPackageItems(food, isFood: true);
        }
        // Add all services as items as well
        for (final svc in menu['Services']!) {
          _addEntryToPackageItems(svc, isFood: false);
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

        Get.snackbar(
          'Success',
          'Inquiry sent successfully! Order ID: ${result['data']?['id'] ?? 'N/A'}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Clear form after successful inquiry
        clearForm();
        Get.back();
      } else {
        throw Exception(result['error'] ?? 'Failed to create inquiry');
      }
    } catch (e) {
      Get.back();
      Get.snackbar(
        'Error',
        'Failed to send inquiry: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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

    // Switch to custom package
    selectedPackage.value = customTitle;
    selectedPackageId.value = 'custom';
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
      Get.snackbar(
        'Error',
        'Please fill required fields for an inquiry (date, time, guests, event type).',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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
    Get.snackbar(
      'Inquiry Sent',
      'Your inquiry has been sent. We will contact you soon.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  // Test methods
  Future<void> testOrderData() async {
    try {
      if (!isFormValid.value) {
        Get.snackbar(
          'Error',
          'Please fill in all required fields before testing',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
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
                Text('Subtotal: £${calculateSubtotal().toStringAsFixed(2)}'),
                Text('Total: £${calculateTotal().toStringAsFixed(2)}'),
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
      Get.snackbar(
        'Error',
        'Error preparing test data: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> testInquiryData() async {
    try {
      if (!isFormValid.value) {
        Get.snackbar(
          'Error',
          'Please fill in all required fields before testing',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
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
                Text('Subtotal: £${calculateSubtotal().toStringAsFixed(2)}'),
                Text('Total: £${calculateTotal().toStringAsFixed(2)}'),
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
      Get.snackbar(
        'Error',
        'Error preparing test data: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
