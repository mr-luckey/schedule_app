// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:schedule_app/model/event_model.dart';
// import 'package:schedule_app/widgets/Payment_Popup.dart';

// class BookingController extends GetxController {
//   // Form controllers
//   final nameController = TextEditingController();
//   final emailController = TextEditingController();
//   final contactController = TextEditingController();
//   final messageController = TextEditingController();
//   final specialRequirementsController = TextEditingController();

//   // Form data
//   final RxString selectedCity = ''.obs;
//   final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
//   final Rx<TimeOfDay?> startTime = Rx<TimeOfDay?>(null);
//   final Rx<TimeOfDay?> endTime = Rx<TimeOfDay?>(null);
//   final RxInt guests = 0.obs;
//   final RxString selectedEventType = ''.obs;

//   // selectedPackage is the title string
//   final RxString selectedPackage = 'Basic Packages'.obs;

//   // Form validation
//   final RxBool isFormValid = false.obs;

//   // Available options
//   final List<String> cities = [
//     'New York',
//     'Los Angeles',
//     'Chicago',
//     'Houston',
//     'Phoenix',
//     'Philadelphia',
//     'San Antonio',
//     'San Diego',
//   ];

//   final List<String> eventTypes = [
//     'Wedding',
//     'Corporate Event',
//     'Birthday Party',
//     'Conference',
//     'Seminar',
//     'Exhibition',
//     'Other',
//   ];

//   // master available items (used for selection / creating custom packages)
//   final List<Map<String, dynamic>> masterAvailableFood = [
//     {"name": "Chicken Tikka", "price": 250.0},
//     {"name": "Paneer Tikka", "price": 250.0},
//     {"name": "Mutton Biryani", "price": 350.0},
//     {"name": "Butter Chicken", "price": 300.0},
//     {"name": "Gulab Jamun", "price": 150.0},
//     {"name": "Ice Cream", "price": 200.0},
//     {"name": "Soft Drinks", "price": 100.0},
//     {"name": "Mocktails", "price": 180.0},
//   ];

//   final List<Map<String, dynamic>> masterAvailableServices = [
//     {"name": "Waiter Service", "price": 1000.0},
//     {"name": "Decoration", "price": 2000.0},
//     {"name": "DJ", "price": 3000.0},
//     {"name": "Lighting", "price": 1500.0},
//   ];

//   // packages: built-in packages only. Custom package will be added dynamically via FAB when user wants it.
//   final RxList<Map<String, dynamic>> packages = <Map<String, dynamic>>[
//     {
//       'title': 'Basic Packages',
//       'description': 'Hall + Basic Decoration + Security',
//       'price': '£25,000',
//       'items': [
//         {'name': 'Soft Drinks', 'price': 100.0, 'qty': 100},
//         {'name': 'Gulab Jamun', 'price': 150.0, 'qty': 100},
//       ],
//       'editable': false,
//     },
//     {
//       'title': 'Standard Packages',
//       'description': 'Hall + Standard Decoration + Security + Catering',
//       'price': '£35,000',
//       'items': [
//         {'name': 'Chicken Tikka', 'price': 250.0, 'qty': 100},
//         {'name': 'Mutton Biryani', 'price': 350.0, 'qty': 100},
//       ],
//       'editable': false,
//     },
//     {
//       'title': 'Premium Packages',
//       'description':
//           'Hall + Premium Decoration + Security + Catering + Photography',
//       'price': '£45,000',
//       'items': [
//         {'name': 'Butter Chicken', 'price': 300.0, 'qty': 100},
//         {'name': 'Ice Cream', 'price': 200.0, 'qty': 100},
//       ],
//       'editable': false,
//     },
//     {
//       'title': 'Luxury Packages',
//       'description':
//           'Hall + Luxury Decoration + Security + Catering + Photography + Entertainment',
//       'price': '£55,000',
//       'items': [
//         {'name': 'Paneer Tikka', 'price': 250.0, 'qty': 100},
//         {'name': 'Mocktails', 'price': 180.0, 'qty': 100},
//       ],
//       'editable': false,
//     },
//   ].obs;

//   @override
//   void onInit() {
//     super.onInit();

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
//   void setCity(String city) => selectedCity.value = city;
//   void setDate(DateTime date) => selectedDate.value = date;
//   void setStartTime(TimeOfDay time) => startTime.value = time;
//   void setEndTime(TimeOfDay time) => endTime.value = time;
//   void setGuests(int count) => guests.value = count;
//   void setEventType(String type) => selectedEventType.value = type;
//   void setPackage(String packageTitle) => selectedPackage.value = packageTitle;
//   void incrementGuests() => guests.value += 1;
//   void decrementGuests() => guests.value = (guests.value - 1).clamp(0, 10000);

//   // --- Pricing helpers ---
//   double calculateSubtotal() {
//     final pkg = _findPackage(selectedPackage.value);
//     if (pkg == null) return 0.0;
//     final priceStr = (pkg['price'] ?? '').toString();
//     final numeric = priceStr.replaceAll(RegExp(r'[^0-9]'), '');
//     if (numeric.isNotEmpty) {
//       return double.tryParse(numeric) ?? 0.0;
//     }
//     return 0.0;
//   }

//   double calculateTax() => calculateSubtotal() * 0.08;
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

//   String getPackageDisplay() {
//     final perGuestCost =
//         (calculateSubtotal() / (guests.value > 0 ? guests.value : 1))
//             .toStringAsFixed(0);
//     return '${selectedPackage.value} (\$$perGuestCost/Guest)';
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

//     Get.dialog(
//       PaymentPopup(
//         eventName: selectedEventType.value,
//         venue: selectedCity.value,
//         date: selectedDate.value!,
//         startTime: startTime.value!,
//         endTime: endTime.value!,
//         guests: guests.value,
//         package: selectedPackage.value,
//         totalAmount: calculateTotal(),
//         customerName: nameController.text,
//         customerEmail: emailController.text,
//         onConfirm: completeBooking,
//         onCancel: cancelBookingPopup,
//       ),
//       barrierDismissible: false,
//     );
//   }

//   Future<void> completeBooking() async {
//     try {
//       final event = Event(
//         id: DateTime.now().millisecondsSinceEpoch.toString(),
//         title: selectedEventType.value,
//         startTime: DateTime(
//           selectedDate.value!.year,
//           selectedDate.value!.month,
//           selectedDate.value!.day,
//           startTime.value!.hour,
//           startTime.value!.minute,
//         ),
//         endTime: DateTime(
//           selectedDate.value!.year,
//           selectedDate.value!.month,
//           selectedDate.value!.day,
//           endTime.value!.hour,
//           endTime.value!.minute,
//         ),
//         guests: guests.value,
//         eventType: selectedEventType.value,
//         package: selectedPackage.value,
//         customerName: nameController.text,
//         customerEmail: emailController.text,
//         customerContact: contactController.text,
//         hall: selectedCity.value,
//         specialRequirements: specialRequirementsController.text,
//       );

//       Get.back(); // Close popup
//       Get.snackbar(
//         'Success',
//         'Booking confirmed successfully!',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//       );

//       Get.back(); // navigate back
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

//   void cancelBookingPopup() => Get.back();
//   void cancelBooking() => Get.back();

//   // ---------------------------
//   // Package & menu related API
//   // ---------------------------

//   // helper to find package by title; returns null if not found
//   Map<String, dynamic>? _findPackage(String title) {
//     final idx = packages.indexWhere((p) => p['title'] == title);
//     if (idx == -1) return null;
//     return packages[idx];
//   }

//   // Return deep-copy menu (Map with keys 'Food Items' and 'Services') for a package.
//   // For food items we set qty = guestCount (so they scale with guests) — caller must pass the current guestCount.
//   Map<String, List<Map<String, dynamic>>> menuForPackage(
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

//       final entry = {
//         'name': name,
//         'price': price,
//         // If it's a food item, its qty should scale with guestCount (for built-in packages).
//         // For services, keep the stored qty.
//         'qty': isFood ? (guestCount > 0 ? guestCount : qtyStored) : qtyStored,
//       };

//       if (isFood) {
//         food.add(Map<String, dynamic>.from(entry));
//       } else {
//         services.add(Map<String, dynamic>.from(entry));
//       }
//     }

//     return {'Food Items': food, 'Services': services};
//   }

//   // Now all packages are editable in UI — return true to allow editing controls
//   bool isPackageEditable(String packageTitle) {
//     // previously used 'editable' flag; now return true so built-in packages
//     // also get full editing capabilities
//     return true;
//   }

//   bool isCustomPackage(String packageTitle) {
//     final pkg = _findPackage(packageTitle);
//     if (pkg == null) return false;
//     return (pkg['editable'] == true);
//   }

//   // Create custom package if not present and open it (used by FAB)
//   void createOrOpenCustomPackage() {
//     const customTitle = 'Custom Package';
//     final existing = packages.indexWhere((p) => p['title'] == customTitle);
//     if (existing == -1) {
//       final newPkg = {
//         'title': customTitle,
//         'description': 'Custom editable package',
//         'price': '£0',
//         'items': <Map<String, dynamic>>[], // empty initially
//         'editable': true,
//       };
//       packages.add(newPkg);
//     }
//     // select it so right pane shows it and is editable
//     selectedPackage.value = customTitle;
//   }

//   // Update stored package items when user edits in UI
//   // NOTE: This now commits items for any package (custom or built-in)
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
//       });
//     }
//     for (var s in newMenu['Services'] ?? []) {
//       newItems.add({
//         'name': s['name'],
//         'price': (s['price'] as num).toDouble(),
//         'qty': (s['qty'] as int),
//       });
//     }

//     packages[idx]['items'] = newItems;
//     packages.refresh();
//   }

//   // Inquiry flow
//   // Inquiry requires everything except name, email and city/address (you said name/email/address optional).
//   // But to keep it useful, we still require: selectedDate, startTime, endTime, guests, selectedEventType
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

//     // Show a confirmation dialog for the inquiry
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
//     // TODO: wire this to your backend API. For now just show a snackbar.
//     Get.snackbar(
//       'Inquiry Sent',
//       'Your inquiry has been sent. We will contact you soon.',
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.green,
//       colorText: Colors.white,
//     );
//   }

//   // Helpers used by selection UI and FoodBeverageSelection
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
// }
