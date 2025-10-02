import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:schedule_app/APIS/Api_Service.dart';
import 'package:schedule_app/controllers/booking_controller.dart';
import 'package:schedule_app/pages/Recipt/bookingrecipt.dart';
import 'package:schedule_app/pages/schedule_page.dart';
import 'package:schedule_app/widgets/Payment_Popup.dart';
// import 'package:schedule_app/pages/Recipt/bookingrecipt.dart';
import 'package:schedule_app/widgets/package_card.dart';
import '../theme/app_colors.dart';
import '../widgets/sidebar.dart';
import '../widgets/schedule_header.dart';
import '../widgets/booking_summary.dart';
import 'package:schedule_app/model/event_model.dart';
import 'package:flutter/services.dart';

class BookingPage extends StatelessWidget {
  final selectedId;
  BookingPage({super.key, this.selectedId});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final controller = Get.put(BookingController());

    return Scaffold(
      backgroundColor: AppColors.background,
      // Floating button for creating/opening the Custom Package
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          controller.createOrOpenCustomPackage();
        },
        label: const Text('Custom Package'),
        icon: const Icon(Icons.edit),
      ),
      body: ResponsiveBreakpoints.builder(
        child: _buildLayout(context),
        breakpoints: const [
          Breakpoint(start: 0, end: 599, name: MOBILE),
          Breakpoint(start: 600, end: 1023, name: TABLET),
          Breakpoint(start: 1024, end: 1439, name: DESKTOP),
          Breakpoint(start: 1440, end: double.infinity, name: '4K'),
        ],
      ),
    );
  }

  Widget _buildLayout(BuildContext context) {
    final bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    final bool isTablet = ResponsiveBreakpoints.of(
      context,
    ).between(TABLET, DESKTOP);

    if (isMobile) return _buildMobileLayout();
    if (isTablet) return _buildTabletLayout();
    return _buildDesktopLayout();
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        const ScheduleHeader(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const BookingForm(),
                const SizedBox(height: 24),
                const BookingSummary(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      children: [
        SizedBox(width: 240, child: const Sidebar()),
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: const BookingForm()),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 1,
                        child:
                            FoodBeverageSelection(), // now reads guests from controller
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: const BookingForm()),
                      const SizedBox(width: 24),
                      Expanded(flex: 1, child: FoodBeverageSelection()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BookingForm extends StatelessWidget {
  const BookingForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookingController>();
    final formKey = GlobalKey<FormState>();

    // helper to open a dialog to edit guests manually
    void _showEditGuestsDialog() {
      final txtCtrl = TextEditingController(
        text: controller.guests.value.toString(),
      ); // initial value
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Enter number of guests'),
            content: TextField(
              controller: txtCtrl,
              autofocus: true,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(hintText: 'e.g. 50'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final val = int.tryParse(txtCtrl.text);
                  if (val != null && val > 0) {
                    controller.setGuests(val);
                    Navigator.pop(ctx);
                  } else {
                    // show error
                    ScaffoldMessenger.of(ctx).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a valid number (>0)'),
                      ),
                    );
                  }
                },
                child: const Text('Set'),
              ),
            ],
          );
        },
      );
    }

    return Obx(
      () => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Personal Information',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      context: context,
                      controller: controller.nameController,
                      label: 'Name',
                      hint: 'Full Name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      context: context,
                      controller: controller.emailController,
                      label: 'Email Address',
                      hint: 'Email Address',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        // Improved email validation with regex
                        final emailRegex = RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                        );
                        if (!emailRegex.hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },

                      // Add input formatters for email
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      context: context,
                      controller: controller.contactController,
                      label: 'Contact#',
                      hint: '+44-XXX-XXX-XXX',
                      // Add input formatters for phone number
                      // inputFormatters: [
                      //   FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-()\s]')), // Only allow digits, +, -, (, ), and spaces
                      // ],
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          // Basic phone number validation - at least 6 digits
                          final digitCount = value
                              .replaceAll(RegExp(r'[^0-9]'), '')
                              .length;
                          if (digitCount < 15) {
                            return 'Please enter a valid contact number';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDropdown(
                      context: context,
                      label: 'City',
                      value: controller.selectedCity.value,
                      items: controller.cities,
                      onChanged: controller.setCity,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              _buildTextField(
                context: context,
                controller: controller.messageController,
                label: 'Message (If Any)',
                hint: 'If you have any question?',
                maxLines: 3,
                onChanged: controller.updateMessage,
              ),

              const SizedBox(height: 32),

              Text(
                'Event Details',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              // Event Type Field
              _buildDropdown(
                context: context,
                label: 'Event Type',
                value: controller.selectedEventType.value,
                items: controller.eventTypes,
                onChanged: controller.setEventType,
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildDateField(
                      context: context,
                      label: 'Event Date',
                      value: controller.selectedDate.value,
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );
                        if (date != null) controller.setDate(date);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTimeField(
                      context: context,
                      label: 'Start Time',
                      value: controller.startTime.value,
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (time != null) controller.setStartTime(time);
                        print("TESTING START TIME FIELD");
                        print(time);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTimeField(
                      context: context,
                      label: 'End Time',
                      value: controller.endTime.value,
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (time != null) controller.setEndTime(time);
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // --- Guests control (added per request) ---
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Guests',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(minWidth: 28),
                                icon: const Icon(Icons.remove),
                                onPressed: controller.guests.value > 1
                                    ? controller.decrementGuests
                                    : null,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                controller.guests.value.toString(),
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(minWidth: 28),
                                icon: const Icon(Icons.add),
                                onPressed: controller.incrementGuests,
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(minWidth: 28),
                                icon: const Icon(Icons.edit, size: 20),
                                onPressed: _showEditGuestsDialog,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              _buildTextField(
                context: context,
                controller: controller.specialRequirementsController,
                label: 'Special Requirements',
                hint:
                    'Stage Decoration, Seating Arrangement, Dietary Restrictions, etc.',
                maxLines: 3,
                onChanged: controller.updateSpecialRequirements,
              ),

              const SizedBox(height: 32),

              Text(
                'Packages',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              // Grid of packages (built-ins). Custom package is opened via FAB.
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemCount: controller.packages.length,
                itemBuilder: (context, index) {
                  final package = controller.packages[index];
                  final title = package['title'] as String;
                  final description = package['description'] as String;
                  final price = package['price'] as String;
                  return Obx(() {
                    final isSelected =
                        controller.selectedPackage.value == title;
                    return PackageCard(
                      title: title,
                      description: description,
                      price: price,
                      isSelected: isSelected,
                      onTap: () {
                        controller.setPackage(title);
                      },
                    );
                  });
                },
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.isFormValid.value
                          ? () => controller
                                .showBookingConfirmation() //TODO: Change made herer
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Confirm Booking'),
                    ),
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // inquiry has slightly different validation (name/email optional)
                        controller.showInquiry();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Inquiry'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    String? Function(String?)? validator,
    Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary),
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ),
            errorMaxLines: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required BuildContext context,
    required String label,
    required String value,
    required List<String> items,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value.isEmpty ? null : value,
          decoration: InputDecoration(
            hintText: 'Select $label',
            border: const OutlineInputBorder(),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: (value) => onChanged(value ?? ''),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required BuildContext context,
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  value != null
                      ? '${value.day}/${value.month}/${value.year}'
                      : 'Pick a Date',
                  style: TextStyle(
                    color: value != null
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeField({
    required BuildContext context,
    required String label,
    required TimeOfDay? value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  value != null
                      ? value.format(context)
                      : 'Select ${label.split(' ').last} Time',
                  style: TextStyle(
                    color: value != null
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class FoodBeverageSelection extends StatefulWidget {
  const FoodBeverageSelection({super.key});

  @override
  _FoodBeverageSelectionState createState() => _FoodBeverageSelectionState();
}

class _FoodBeverageSelectionState extends State<FoodBeverageSelection> {
  bool isConfirmed = false;
  bool isEditing = false;

  late Map<String, List<Map<String, dynamic>>> menu;
  late BookingController controller;

  late List<Map<String, dynamic>> availableFoodLocal;
  late List<Map<String, dynamic>> availableServicesLocal;

  String previousPackage = '';
  final List<Worker> _workers = [];

  @override
  void initState() {
    super.initState();
    controller = Get.find<BookingController>();

    previousPackage = controller.selectedPackage.value;

    menu = controller.menuForPackage(
      previousPackage,
      controller.guests.value > 0 ? controller.guests.value : 1,
    );

    availableFoodLocal = List.from(controller.masterAvailableFood);
    availableServicesLocal = List.from(controller.masterAvailableServices);

    _syncAvailableListsWithMenu();

    _workers.add(
      ever(controller.selectedPackage, (val) {
        final newPkg = val as String;
        if (isEditing) {
          controller.updateCustomPackageItems(previousPackage, menu);
        }
        if (!mounted) return;
        setState(() {
          isEditing = false;
          controller.toggleEditMode(false);
          menu = controller.menuForPackage(
            newPkg,
            controller.guests.value > 0 ? controller.guests.value : 1,
          );
          previousPackage = newPkg;
          _syncAvailableListsWithMenu();
        });
      }),
    );

    _workers.add(
      ever(controller.guests, (g) {
        final guestsCount = (g);
        if (!mounted) return;
        setState(() {
          menu = controller.menuForPackage(
            controller.selectedPackage.value,
            guestsCount > 0 ? guestsCount : 1,
          );
          _syncAvailableListsWithMenu();
        });
      }),
    );
  }

  @override
  void dispose() {
    for (final worker in _workers) {
      worker.dispose();
    }
    super.dispose();
  }

  bool _isApiPackage(String packageTitle) {
    final pkg = controller.packages.firstWhere(
      (p) => p['title'] == packageTitle,
      orElse: () => {},
    );
    return pkg['id']?.toString().isNotEmpty == true &&
        pkg['id']?.toString() != 'custom';
  }

  void _syncAvailableListsWithMenu() {
    availableFoodLocal = List.from(controller.masterAvailableFood);
    availableServicesLocal = List.from(controller.masterAvailableServices);

    final foodNames = menu['Food Items']!.map((d) => d['name']).toSet();
    final serviceNames = menu['Services']!.map((d) => d['name']).toSet();

    availableFoodLocal.removeWhere((f) => foodNames.contains(f['name']));
    availableServicesLocal.removeWhere((s) => serviceNames.contains(s['name']));
  }

  // Group available items by category for the add dialogs
  Map<String, List<Map<String, dynamic>>> _groupItemsByCategory(
    List<Map<String, dynamic>> items,
  ) {
    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (var item in items) {
      final category = item['category']?.toString() ?? 'Other';
      if (!grouped.containsKey(category)) {
        grouped[category] = [];
      }
      grouped[category]!.add(item);
    }

    return grouped;
  }

  double get foodAndBeverageCost {
    final isApiPackage = _isApiPackage(controller.selectedPackage.value);

    if (!isEditing && isApiPackage) {
      // Non-edit mode: Package price from API + services
      final pkg = controller.packages.firstWhere(
        (p) => p['title'] == controller.selectedPackage.value,
        orElse: () => {},
      );
      final packagePrice = _parsePriceString(pkg['price']?.toString());
      final servicesCost = _calculateServicesCost();
      return packagePrice + servicesCost;
    } else {
      // Edit mode: Sum of all items
      return _calculateTotalFromItems();
    }
  }

  double _parsePriceString(String? priceStr) {
    if (priceStr == null) return 0.0;
    final cleaned = priceStr.replaceAll(RegExp(r'[^0-9.]'), '');
    if (cleaned.isEmpty) return 0.0;
    return double.tryParse(cleaned) ?? 0.0;
  }

  double _calculateServicesCost() {
    double servicesCost = 0.0;
    for (var service in menu['Services']!) {
      servicesCost += (service['price'] as num).toDouble();
    }
    return servicesCost;
  }

  double _calculateTotalFromItems() {
    double total = 0.0;
    for (var section in menu.values) {
      for (var dish in section) {
        total += (dish['price'] as num).toDouble() * (dish['qty'] as int);
      }
    }
    return total;
  }

  double get serviceCharges => 0.10 * (foodAndBeverageCost);
  double get tax => 0.13 * (foodAndBeverageCost + serviceCharges);
  double get totalAmount => foodAndBeverageCost + serviceCharges + tax;

  void increment(Map<String, dynamic> dish) {
    setState(() => dish["qty"] = (dish["qty"] ?? 0) + 1);
  }

  void decrement(Map<String, dynamic> dish) {
    setState(() {
      if ((dish["qty"] ?? 0) > 0) {
        dish["qty"] = (dish["qty"] ?? 0) - 1;
      }
    });
  }

  void removeDish(String category, Map<String, dynamic> dish) {
    setState(() {
      menu[category]?.remove(dish);

      if (category == "Food Items") {
        availableFoodLocal.add({"name": dish["name"], "price": dish["price"]});
      } else if (category == "Services") {
        availableServicesLocal.add({
          "name": dish["name"],
          "price": dish["price"],
        });
      }
    });
  }

  void addDish(String category) {
    final options = category == "Food Items"
        ? availableFoodLocal
        : availableServicesLocal;
    final groupedOptions = _groupItemsByCategory(options);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return SafeArea(
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text(
                        'Add $category',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ),
                    if (options.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'No more ${category.toLowerCase()} available.',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      )
                    else
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            for (var categoryName in groupedOptions.keys)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      16,
                                      16,
                                      16,
                                      8,
                                    ),
                                    child: Text(
                                      categoryName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.blue[700],
                                      ),
                                    ),
                                  ),
                                  ...groupedOptions[categoryName]!.map((item) {
                                    return ListTile(
                                      title: Text(item["name"]),
                                      subtitle: Text(
                                        '£${(item["price"] as num).toStringAsFixed(2)}',
                                      ),
                                      trailing: IconButton(
                                        icon: const Icon(
                                          Icons.add_circle,
                                          color: Colors.green,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            final isApiPackage = _isApiPackage(
                                              controller.selectedPackage.value,
                                            );
                                            final baseQty =
                                                category == "Food Items" &&
                                                    !isApiPackage
                                                ? (controller.guests.value > 0
                                                      ? controller.guests.value
                                                      : 1)
                                                : 1;

                                            menu[category]!.add({
                                              "name": item["name"],
                                              "price": item["price"],
                                              "qty": controller.guests.value,
                                              "id": item["id"],
                                            });

                                            // Remove from available list
                                            if (category == "Food Items") {
                                              availableFoodLocal.removeWhere(
                                                (f) =>
                                                    f['name'] == item['name'],
                                              );
                                            } else {
                                              availableServicesLocal
                                                  .removeWhere(
                                                    (s) =>
                                                        s['name'] ==
                                                        item['name'],
                                                  );
                                            }
                                          });
                                          _syncAvailableListsWithMenu();
                                          Navigator.pop(ctx);
                                        },
                                      ),
                                    );
                                  }).toList(),
                                  const Divider(),
                                ],
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showEditDishQuantityDialog(Map<String, dynamic> dish) {
    final txt = TextEditingController(text: dish['qty'].toString());
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Set quantity for ${dish['name']}'),
          content: TextField(
            controller: txt,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              hintText: 'Enter quantity (numeric)',
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final val = int.tryParse(txt.text);
                if (val != null && val >= 0) {
                  setState(() {
                    dish['qty'] = val;
                  });
                  Navigator.pop(ctx);
                } else {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid number'),
                    ),
                  );
                }
              },
              child: const Text('Set'),
            ),
          ],
        );
      },
    );
  }

  Widget buildItemRow(String category, Map<String, dynamic> dish) {
    final isFoodItem = category == "Food Items";

    return isFoodItem
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Dish name + price
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(dish["name"], style: const TextStyle(fontSize: 15)),
                      Text(
                        "£${(dish["price"] as num).toStringAsFixed(2)} per unit",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),

                // Quantity controls (visible when editing for both food & services)
                if (isEditing)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_outlined, size: 20),
                          onPressed: () => decrement(dish),
                        ),
                        Text(
                          dish["qty"].toString(),
                          style: const TextStyle(fontSize: 16),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add, size: 20),
                          onPressed: () => increment(dish),
                        ),
                        // Edit button to input number manually
                        IconButton(
                          icon: const Icon(Icons.edit, size: 18),
                          onPressed: () => _showEditDishQuantityDialog(dish),
                        ),
                      ],
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text("Qty: ${dish["qty"]}"),
                  ),

                // Remove button (only visible when editing)
                if (isEditing)
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red, size: 20),
                    onPressed: () => removeDish(category, dish),
                  ),
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Dish name + price
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(dish["name"], style: const TextStyle(fontSize: 15)),
                      Text(
                        "£${(dish["price"] as num).toStringAsFixed(2)} per unit",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),

                // Quantity controls (visible when editing for both food & services)
                // if (isEditing)
                //   Container(
                //     padding: const EdgeInsets.symmetric(horizontal: 4),
                //     decoration: BoxDecoration(
                //       border: Border.all(color: Colors.black),
                //       borderRadius: BorderRadius.circular(10),
                //     ),
                //     // child: Row(
                //     //   children: [
                //     //     IconButton(
                //     //       icon: const Icon(Icons.remove_outlined, size: 20),
                //     //       onPressed: () => decrement(dish),
                //     //     ),
                //     //     Text(
                //     //       dish["qty"].toString(),
                //     //       style: const TextStyle(fontSize: 16),
                //     //     ),
                //     //     IconButton(
                //     //       icon: const Icon(Icons.add, size: 20),
                //     //       onPressed: () => increment(dish),
                //     //     ),
                //     //     // Edit button to input number manually
                //     //     IconButton(
                //     //       icon: const Icon(Icons.edit, size: 18),
                //     //       onPressed: () => _showEditDishQuantityDialog(dish),
                //     //     ),
                //     //   ],
                //     // ),
                //   )
                // else
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 8),
                //   child: Text("Qty: ${dish["qty"]}"),
                // ),

                // Remove button (only visible when editing)
                if (isEditing)
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red, size: 20),
                    onPressed: () => removeDish(category, dish),
                  ),
              ],
            ),
          );
  }

  Widget buildSummary() {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            summaryRow("Food & Beverage", foodAndBeverageCost),
            summaryRow("Service Charges (10%)", serviceCharges),
            summaryRow("Tax (13%)", tax),
            const Divider(),
            summaryRow("Total Amount", totalAmount, isBold: true, fontSize: 18),
          ],
        ),
      ),
    );
  }

  Widget summaryRow(
    String label,
    double value, {
    bool isBold = false,
    double fontSize = 16,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            "£${value.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void commitEditsToController() {
    controller.updateCustomPackageItems(controller.selectedPackage.value, menu);
    Get.snackbar('Saved', 'Package updated');
  }

  @override
  Widget build(BuildContext context) {
    if (isConfirmed) return const BookingSummary();

    return Container(
      width: 340,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Food Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Food Items",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: Colors.green),
                      onPressed: () => addDish("Food Items"),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(),
            ...menu["Food Items"]!.map(
              (dish) => buildItemRow("Food Items", dish),
            ),

            const SizedBox(height: 20),

            // Services Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Services",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: Colors.green),
                      onPressed: () => addDish("Services"),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(),
            ...menu["Services"]!.map(
              (service) => buildItemRow("Services", service),
            ),

            buildSummary(),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isEditing = !isEditing;
                      controller.toggleEditMode(isEditing);
                    });
                    if (!isEditing) {
                      commitEditsToController();
                    }
                  },
                  child: Text(isEditing ? "Done" : "Edit"),
                ),

                ElevatedButton(
                  onPressed: () {
                    Get.find<BookingController>().testInquiryData();
                    setState(() {});
                  },
                  child: Text("Inquiry"),
                ),
                //TODO:change test here
                // ElevatedButton(
                //   onPressed: () {
                //     commitEditsToController();
                //     controller.showInquiry();
                //   },
                //   child: const Text("test"),
                // ),
                ElevatedButton(
                  onPressed: () {
                    commitEditsToController();

                    setState(() {
                      isConfirmed = true;
                    });
                  },
                  child: const Text("Confirm Booking"),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Get.find<BookingController>().testOrderData();
                // setState(() {});
              },
              child: Text("testOrder"),
            ),
          ],
        ),
      ),
    );
  }
}
