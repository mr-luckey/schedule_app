// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

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

//   final List<Map<String, String>> packages = [
//     {
//       'title': 'Basic Packages',
//       'description': 'Hall + Basic Decoration + Security',
//       'price': '£25,000',
//     },
//     {
//       'title': 'Standard Packages',
//       'description': 'Hall + Standard Decoration + Security + Catering',
//       'price': '£35,000',
//     },
//     {
//       'title': 'Premium Packages',
//       'description':
//           'Hall + Premium Decoration + Security + Catering + Photography',
//       'price': '£45,000',
//     },
//     {
//       'title': 'Luxury Packages',
//       'description':
//           'Hall + Luxury Decoration + Security + Catering + Photography + Entertainment',
//       'price': '£55,000',
//     },
//   ];

//   @override
//   void onInit() {
//     super.onInit();
//     // Listen to form changes
//     ever(selectedCity, (_) => _validateForm());
//     ever(selectedDate, (_) => _validateForm());
//     ever(startTime, (_) => _validateForm());
//     ever(endTime, (_) => _validateForm());
//     ever(guests, (_) => _validateForm());
//     ever(selectedEventType, (_) => _validateForm());
//     ever(selectedPackage, (_) => _validateForm());
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

//   void updateName(String value) {
//     nameController.text = value;
//     _validateForm();
//   }

//   void updateEmail(String value) {
//     emailController.text = value;
//     _validateForm();
//   }

//   void updateContact(String value) {
//     contactController.text = value;
//   }

//   void updateMessage(String value) {
//     messageController.text = value;
//   }

//   void updateSpecialRequirements(String value) {
//     specialRequirementsController.text = value;
//   }

//   void setCity(String city) {
//     selectedCity.value = city;
//   }

//   void setDate(DateTime date) {
//     selectedDate.value = date;
//   }

//   void setStartTime(TimeOfDay time) {
//     startTime.value = time;
//   }

//   void setEndTime(TimeOfDay time) {
//     endTime.value = time;
//   }

//   void setGuests(int count) {
//     guests.value = count;
//   }

//   void setEventType(String type) {
//     selectedEventType.value = type;
//   }

//   void setPackage(String package) {
//     selectedPackage.value = package;
//   }

//   void incrementGuests() {
//     guests.value += 1;
//   }

//   void decrementGuests() {
//     guests.value = (guests.value - 1).clamp(0, 10000);
//   }

//   double calculateSubtotal() {
//     switch (selectedPackage.value) {
//       case 'Basic Packages':
//         return 25000.0;
//       case 'Standard Packages':
//         return 35000.0;
//       case 'Premium Packages':
//         return 45000.0;
//       case 'Luxury Packages':
//         return 55000.0;
//       default:
//         return 25000.0;
//     }
//   }

//   double calculateTax() {
//     return calculateSubtotal() * 0.08;
//   }

//   double calculateTotal() {
//     return calculateSubtotal() + calculateTax();
//   }

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

//   void confirmBooking() {
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

//     Get.snackbar(
//       'Success',
//       'Booking confirmed successfully!',
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.green,
//       colorText: Colors.white,
//     );

//     // Navigate back to schedule page
//     Get.back();
//   }

//   void cancelBooking() {
//     Get.back();
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schedule_app/controllers/hive_controller.dart';
import 'package:schedule_app/model/event_model.dart';
// import 'event_model.dart';
// import 'hive_service.dart';

class BookingController extends GetxController {
  // Form controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final contactController = TextEditingController();
  final messageController = TextEditingController();
  final specialRequirementsController = TextEditingController();

  // Form data
  final RxString selectedCity = ''.obs;
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final Rx<TimeOfDay?> startTime = Rx<TimeOfDay?>(null);
  final Rx<TimeOfDay?> endTime = Rx<TimeOfDay?>(null);
  final RxInt guests = 0.obs;
  final RxString selectedEventType = ''.obs;
  final RxString selectedPackage = 'Basic Packages'.obs;

  // Form validation
  final RxBool isFormValid = false.obs;

  // Available options
  final List<String> cities = [
    'New York',
    'Los Angeles',
    'Chicago',
    'Houston',
    'Phoenix',
    'Philadelphia',
    'San Antonio',
    'San Diego',
  ];

  final List<String> eventTypes = [
    'Wedding',
    'Corporate Event',
    'Birthday Party',
    'Conference',
    'Seminar',
    'Exhibition',
    'Other',
  ];

  final List<Map<String, String>> packages = [
    {
      'title': 'Basic Packages',
      'description': 'Hall + Basic Decoration + Security',
      'price': '£25,000',
    },
    {
      'title': 'Standard Packages',
      'description': 'Hall + Standard Decoration + Security + Catering',
      'price': '£35,000',
    },
    {
      'title': 'Premium Packages',
      'description':
          'Hall + Premium Decoration + Security + Catering + Photography',
      'price': '£45,000',
    },
    {
      'title': 'Luxury Packages',
      'description':
          'Hall + Luxury Decoration + Security + Catering + Photography + Entertainment',
      'price': '£55,000',
    },
  ];

  @override
  void onInit() {
    super.onInit();
    // Listen to form changes
    ever(selectedCity, (_) => _validateForm());
    ever(selectedDate, (_) => _validateForm());
    ever(startTime, (_) => _validateForm());
    ever(endTime, (_) => _validateForm());
    ever(guests, (_) => _validateForm());
    ever(selectedEventType, (_) => _validateForm());
    ever(selectedPackage, (_) => _validateForm());
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

  void updateName(String value) {
    nameController.text = value;
    _validateForm();
  }

  void updateEmail(String value) {
    emailController.text = value;
    _validateForm();
  }

  void updateContact(String value) {
    contactController.text = value;
  }

  void updateMessage(String value) {
    messageController.text = value;
  }

  void updateSpecialRequirements(String value) {
    specialRequirementsController.text = value;
  }

  void setCity(String city) {
    selectedCity.value = city;
  }

  void setDate(DateTime date) {
    selectedDate.value = date;
  }

  void setStartTime(TimeOfDay time) {
    startTime.value = time;
  }

  void setEndTime(TimeOfDay time) {
    endTime.value = time;
  }

  void setGuests(int count) {
    guests.value = count;
  }

  void setEventType(String type) {
    selectedEventType.value = type;
  }

  void setPackage(String package) {
    selectedPackage.value = package;
  }

  void incrementGuests() {
    guests.value += 1;
  }

  void decrementGuests() {
    guests.value = (guests.value - 1).clamp(0, 10000);
  }

  double calculateSubtotal() {
    switch (selectedPackage.value) {
      case 'Basic Packages':
        return 25000.0;
      case 'Standard Packages':
        return 35000.0;
      case 'Premium Packages':
        return 45000.0;
      case 'Luxury Packages':
        return 55000.0;
      default:
        return 25000.0;
    }
  }

  double calculateTax() {
    return calculateSubtotal() * 0.08;
  }

  double calculateTotal() {
    return calculateSubtotal() + calculateTax();
  }

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

  String getPackageDisplay() {
    final perGuestCost =
        (calculateSubtotal() / (guests.value > 0 ? guests.value : 1))
            .toStringAsFixed(0);
    return '${selectedPackage.value} (\$$perGuestCost/Guest)';
  }

  Future<void> confirmBooking() async {
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

    try {
      // Create event from form data
      final event = Event(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: selectedEventType.value,
        startTime: DateTime(
          selectedDate.value!.year,
          selectedDate.value!.month,
          selectedDate.value!.day,
          startTime.value!.hour,
          startTime.value!.minute,
        ),
        endTime: DateTime(
          selectedDate.value!.year,
          selectedDate.value!.month,
          selectedDate.value!.day,
          endTime.value!.hour,
          endTime.value!.minute,
        ),
        guests: guests.value,
        eventType: selectedEventType.value,
        package: selectedPackage.value,
        customerName: nameController.text,
        customerEmail: emailController.text,
        customerContact: contactController.text,
        hall: selectedCity.value,
        specialRequirements: specialRequirementsController.text,
      );

      // Save event to Hive
      // await HiveService.addEvent(event);

      Get.snackbar(
        'Success',
        'Booking confirmed successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Navigate back to schedule page
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save booking: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void cancelBooking() {
    Get.back();
  }
}
