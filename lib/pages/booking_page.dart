import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:schedule_app/pages/Recipt/bookingrecipt.dart';
// import 'package:schedule_app/pages/Recipt/bookingrecipt.dart';
import 'package:schedule_app/widgets/package_card.dart';
import '../theme/app_colors.dart';
import '../widgets/sidebar.dart';
import '../widgets/schedule_header.dart';
import '../widgets/booking_summary.dart';
import 'package:schedule_app/model/event_model.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BookingPage extends StatelessWidget {
  BookingPage({super.key});

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
                        if (!value.contains('@'))
                          return 'Please enter a valid email';
                        return null;
                      },
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
                          ? () => controller.showBookingConfirmation()
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

  // For editing we keep a stateful 'menu' that persists user edits.
  late Map<String, List<Map<String, dynamic>>> menu;
  late BookingController controller;

  // local available lists to pick from when editing
  late List<Map<String, dynamic>> availableFoodLocal;
  late List<Map<String, dynamic>> availableServicesLocal;

  // track previous selected package to auto-save edits on switch
  String previousPackage = '';

  @override
  void initState() {
    super.initState();
    controller = Get.find<BookingController>();

    previousPackage = controller.selectedPackage.value;

    // initialize menu (for both built-in and custom)
    menu = controller.menuForPackage(
      previousPackage,
      controller.guests.value > 0 ? controller.guests.value : 1,
    );

    availableFoodLocal = controller.masterAvailableFood
        .map((e) => Map.of(e))
        .toList();
    availableServicesLocal = controller.masterAvailableServices
        .map((e) => Map.of(e))
        .toList();

    _syncAvailableListsWithMenu();

    // Listen for package changes
    ever(controller.selectedPackage, (val) {
      final newPkg = val as String;
      // Persist changes of previously edited package (now allowed for all packages)
      if (isEditing) {
        controller.updateCustomPackageItems(previousPackage, menu);
      }
      setState(() {
        isEditing = false;
        menu = controller.menuForPackage(
          newPkg,
          controller.guests.value > 0 ? controller.guests.value : 1,
        );
        previousPackage = newPkg;
        _syncAvailableListsWithMenu();
      });
    });

    // Listen for guest count changes — update quantities for packages that weren't manually edited
    ever(controller.guests, (g) {
      final guestsCount = (g as int);
      final currentPkg = controller.selectedPackage.value;
      if (!isEditing) {
        setState(() {
          menu = controller.menuForPackage(
            currentPkg,
            guestsCount > 0 ? guestsCount : 1,
          );
          _syncAvailableListsWithMenu();
        });
      }
      // if currently editing we keep user's quantities unchanged
    });
  }

  void _syncAvailableListsWithMenu() {
    availableFoodLocal = controller.masterAvailableFood
        .map((e) => Map.of(e))
        .toList();
    availableServicesLocal = controller.masterAvailableServices
        .map((e) => Map.of(e))
        .toList();

    final foodNames = menu['Food Items']!.map((d) => d['name']).toSet();
    final serviceNames = menu['Services']!.map((d) => d['name']).toSet();

    availableFoodLocal.removeWhere((f) => foodNames.contains(f['name']));
    availableServicesLocal.removeWhere((s) => serviceNames.contains(s['name']));
  }

  double get foodAndBeverageCost {
    double total = 0;
    for (var section in menu.values) {
      for (var dish in section) {
        final int qty = (dish["qty"] as int);
        final double price = (dish["price"] as num).toDouble();
        total += qty * price;
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

      // Add back to available lists (so it can be re-added later)
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

    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text('Add $category'),
                    trailing: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ),
                  if (options.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: const Text('No more items available.'),
                    ),
                  ...options.map((item) {
                    return ListTile(
                      title: Text('${item["name"]} (£${item["price"]})'),
                      trailing: IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.green),
                        onPressed: () {
                          setState(() {
                            menu[category]!.add({
                              "name": item["name"],
                              "price": item["price"],
                              // default qty: guests for food, 1 for services
                              "qty": category == "Food Items"
                                  ? (controller.guests.value > 0
                                        ? controller.guests.value
                                        : 1)
                                  : 1,
                            });
                            options.remove(item);
                          });
                          _syncAvailableListsWithMenu();
                          Navigator.pop(ctx);
                        },
                      ),
                    );
                  }).toList(),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // New: dialog to edit dish qty manually
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

    return Padding(
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
                  "£${(dish["price"] as num).toStringAsFixed(0)} per unit",
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
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
    // Save current menu into packages (will overwrite items for selected package)
    controller.updateCustomPackageItems(controller.selectedPackage.value, menu);
    Get.snackbar('Saved', 'Package updated');
  }

  @override
  Widget build(BuildContext context) {
    if (isConfirmed) return const BookingSummary();

    final selectedPackageTitle = controller.selectedPackage.value;
    final isCustom = controller.isCustomPackage(selectedPackageTitle);

    return Container(
      width: 340,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
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
                    // always allow adding items now
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
                    // always allow adding services now
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
                    // toggle edit mode — no locking check anymore
                    setState(() => isEditing = !isEditing);
                    // if we switched from editing -> not editing, commit changes
                    if (!isEditing) {
                      commitEditsToController();
                    }
                  },
                  child: Text(isEditing ? "Done" : "Edit"),
                ),

                // Inquiry button (same auth as confirm but name/email/city optional)
                ElevatedButton(
                  onPressed: () {
                    // when sending inquiry also commit current edits
                    commitEditsToController();
                    controller.showInquiry();
                  },
                  child: const Text("Inquiry"),
                ),

                ElevatedButton(
                  onPressed: () {
                    // commit edits first
                    commitEditsToController();
                    setState(() {
                      isConfirmed = true;
                    });
                  },
                  child: const Text("Confirm Booking"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/* ---------------------------
   BookingController (merged)
   --------------------------- */

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
  final RxInt guests = 1.obs; // default changed to 1
  final RxString selectedEventType = ''.obs;

  // selectedPackage is the title string
  final RxString selectedPackage = 'Basic Packages'.obs;

  // Form validation
  final RxBool isFormValid = false.obs;
  // String generateReceiptHTML() {}
  // Track whether a package has been edited (committed) by the user.
  // If true => calculate subtotal from item list; otherwise use package price string for built-ins.
  final Map<String, bool> packageEdited = {};
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
    double discount = netAmount * 0.05; // 5% early booking discount
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
      final names = nameController.text.split(' ');
      if (names.length == 1) return names[0][0].toUpperCase();
      return '${names[0][0]}${names[names.length - 1][0]}'.toUpperCase();
    }

    return '''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Confirmation Receipt - A4</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Times New Roman', serif;
            background-color: white;
            color: #000;
            line-height: 1.2;
            font-size: 12px;
        }
        
        .receipt-container {
            width: 210mm;
            height: 297mm;
            margin: 0 auto;
            background: white;
            border: 2px solid #000;
            padding: 15mm;
            overflow: hidden;
        }
        
        .header {
            text-align: center;
            border-bottom: 2px solid #000;
            padding-bottom: 8px;
            margin-bottom: 12px;
        }
        
        .company-name {
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 3px;
            text-transform: uppercase;
        }
        
        .company-details {
            font-size: 10px;
            margin-bottom: 8px;
            line-height: 1.3;
        }
        
        .receipt-title {
            font-size: 16px;
            font-weight: bold;
            text-transform: uppercase;
            margin-top: 8px;
        }
        
        .receipt-info {
            display: flex;
            justify-content: space-between;
            margin-bottom: 12px;
            font-size: 9px;
        }
        
        .section {
            margin-bottom: 10px;
        }
        
        .section-title {
            font-size: 11px;
            font-weight: bold;
            text-transform: uppercase;
            border-bottom: 1px solid #000;
            padding-bottom: 2px;
            margin-bottom: 5px;
        }
        
        .info-table {
            width: 100%;
            font-size: 9px;
            margin-bottom: 5px;
        }
        
        .info-table td {
            padding: 1px 0;
            vertical-align: top;
        }
        
        .info-table td:first-child {
            width: 25%;
            font-weight: bold;
        }
        
        .order-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 8px;
            font-size: 8px;
        }
        
        .order-table th,
        .order-table td {
            border: 1px solid #000;
            padding: 3px;
            text-align: left;
        }
        
        .order-table th {
            background-color: #f0f0f0;
            font-weight: bold;
            text-transform: uppercase;
            font-size: 7px;
        }
        
        .order-table td:nth-child(2),
        .order-table td:nth-child(3),
        .order-table td:nth-child(4) {
            text-align: right;
        }
        
        .subtotal-section {
            border: 1px solid #000;
            padding: 8px;
            margin-top: 8px;
        }
        
        .subtotal-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 2px;
            font-size: 9px;
        }
        
        .subtotal-row.total {
            border-top: 2px solid #000;
            padding-top: 4px;
            margin-top: 5px;
            font-weight: bold;
            font-size: 11px;
        }
        
        .footer {
            border-top: 2px solid #000;
            padding-top: 8px;
            margin-top: 10px;
            text-align: center;
            font-size: 9px;
        }
        
        .terms {
            font-size: 7px;
            margin-top: 8px;
            text-align: justify;
            line-height: 1.2;
        }
        
        .signature-section {
            margin-top: 15px;
            display: flex;
            justify-content: space-between;
        }
        
        .signature-box {
            width: 150px;
            text-align: center;
            font-size: 8px;
        }
        
        .signature-line {
            border-bottom: 1px solid #000;
            margin-bottom: 3px;
            height: 20px;
        }
        
        .two-column {
            display: flex;
            gap: 10px;
        }
        
        .column {
            flex: 1;
        }
        
        @media print {
            @page {
                size: A4;
                margin: 0;
            }
            
            body {
                padding: 0;
                margin: 0;
            }
            
            .receipt-container {
                border: none;
                padding: 15mm;
                margin: 0;
                width: 210mm;
                height: 297mm;
                max-width: none;
                max-height: none;
            }
        }
        
        @media screen {
            body {
                padding: 10px;
                background-color: #f0f0f0;
            }
        }
        .cancel-icon {
            position: absolute;
            top: 15px;
            right: 15px;
            cursor: pointer;
            font-size: 20px;
            color: #ff0000;
            z-index: 1000;
        }
        
        .next-button {
            background-color: #28a745;
            color: white;
            border: none;
            padding: 12px 24px;
            font-size: 14px;
            font-weight: bold;
            border-radius: 4px;
            cursor: pointer;
            margin-top: 15px;
            transition: background-color 0.3s ease;
        }
        
        .next-button:hover {
            background-color: #218838;
        }
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
            
            <!-- Next button for navigation to another screen -->
            <div style="text-align: center; margin-top: 20px;">
                <button class="next-button" onclick="handleNext()">Next</button>
            </div>
        </div>
    </div>
       <script>
        function handleCancel() {
            // This will be handled by Flutter WebView
            window.flutter_inappwebview.callHandler('cancelBooking');
        }
    </script>
</body>
</html>
    ''';
  }

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

  // master available items (used for selection / creating custom packages)
  final List<Map<String, dynamic>> masterAvailableFood = [
    {"name": "Chicken Tikka", "price": 250.0},
    {"name": "Paneer Tikka", "price": 250.0},
    {"name": "Mutton Biryani", "price": 350.0},
    {"name": "Butter Chicken", "price": 300.0},
    {"name": "Gulab Jamun", "price": 150.0},
    {"name": "Ice Cream", "price": 200.0},
    {"name": "Soft Drinks", "price": 100.0},
    {"name": "Mocktails", "price": 180.0},
  ];

  final List<Map<String, dynamic>> masterAvailableServices = [
    {"name": "Waiter Service", "price": 1000.0},
    {"name": "Decoration", "price": 2000.0},
    {"name": "DJ", "price": 3000.0},
    {"name": "Lighting", "price": 1500.0},
  ];

  // packages: built-in packages only. Custom package will be added dynamically via FAB when user wants it.
  final RxList<Map<String, dynamic>> packages = <Map<String, dynamic>>[
    {
      'title': 'Basic Packages',
      'description': 'Hall + Basic Decoration + Security',
      'price': '£25,000',
      'items': [
        {'name': 'Soft Drinks', 'price': 100.0, 'qty': 100},
        {'name': 'Gulab Jamun', 'price': 150.0, 'qty': 100},
      ],
      'editable': false,
    },
    {
      'title': 'Standard Packages',
      'description': 'Hall + Standard Decoration + Security + Catering',
      'price': '£35,000',
      'items': [
        {'name': 'Chicken Tikka', 'price': 250.0, 'qty': 100},
        {'name': 'Mutton Biryani', 'price': 350.0, 'qty': 100},
      ],
      'editable': false,
    },
    {
      'title': 'Premium Packages',
      'description':
          'Hall + Premium Decoration + Security + Catering + Photography',
      'price': '£45,000',
      'items': [
        {'name': 'Butter Chicken', 'price': 300.0, 'qty': 100},
        {'name': 'Ice Cream', 'price': 200.0, 'qty': 100},
      ],
      'editable': false,
    },
    {
      'title': 'Luxury Packages',
      'description':
          'Hall + Luxury Decoration + Security + Catering + Photography + Entertainment',
      'price': '£55,000',
      'items': [
        {'name': 'Paneer Tikka', 'price': 250.0, 'qty': 100},
        {'name': 'Mocktails', 'price': 180.0, 'qty': 100},
      ],
      'editable': false,
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();

    // initialize packageEdited map for existing packages (false initially)
    for (var p in packages) {
      final title = p['title'] as String;
      packageEdited[title] = false;
    }

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
  void setCity(String city) => selectedCity.value = city;
  void setDate(DateTime date) => selectedDate.value = date;
  void setStartTime(TimeOfDay time) => startTime.value = time;
  void setEndTime(TimeOfDay time) => endTime.value = time;
  void setGuests(int count) => guests.value = count;
  void setEventType(String type) => selectedEventType.value = type;
  void setPackage(String packageTitle) => selectedPackage.value = packageTitle;
  void incrementGuests() => guests.value += 1;
  void decrementGuests() => guests.value = (guests.value - 1).clamp(1, 10000);

  // --- Pricing helpers ---

  // robust parsing of price strings like "£25,000" or "$12,345.67"
  double _parsePriceString(String? priceStr) {
    if (priceStr == null) return 0.0;
    // Remove currency symbols, commas and spaces — keep digits and dot
    final cleaned = priceStr.replaceAll(RegExp(r'[^0-9.]'), '');
    if (cleaned.isEmpty) return 0.0;
    return double.tryParse(cleaned) ?? 0.0;
  }

  // Computes subtotal either from package price (if not edited) or from package items sum (if edited/custom).
  double calculateSubtotal() {
    final pkg = _findPackage(selectedPackage.value);
    if (pkg == null) return 0.0;

    final title = pkg['title'] as String;
    final bool isEditablePackage = (pkg['editable'] == true);
    final bool edited = packageEdited[title] == true;

    // If it's a custom/editable package, we prefer to calculate from items.
    if (isEditablePackage) {
      return calculateSubtotalFromPackageItems(title);
    }

    // If package was edited (committed by user) — calculate from items.
    if (edited) {
      return calculateSubtotalFromPackageItems(title);
    }

    // otherwise fallback to the package's provided price string.
    final priceStr = (pkg['price'] ?? '').toString();
    final numeric = _parsePriceString(priceStr);
    return numeric;
  }

  // Sum of items for a package (price * qty)
  double calculateSubtotalFromPackageItems(String packageTitle) {
    final pkg = _findPackage(packageTitle);
    if (pkg == null) return 0.0;

    final items = ((pkg['items'] ?? []) as List)
        .map((i) => Map<String, dynamic>.from(i as Map))
        .toList();

    double sum = 0.0;
    for (var item in items) {
      final price = (item['price'] as num).toDouble();
      final qty = (item['qty'] is int)
          ? item['qty'] as int
          : (item['qty'] is double ? (item['qty'] as double).toInt() : 1);
      sum += price * qty;
    }
    return sum;
  }

  double calculateTax() {
    // keeping your earlier tax calc (you used 8% earlier). If you prefer 13% like the right pane,
    // change this to 0.13. I preserve 0.08 as in your original controller.
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

  String getPackageDisplay() {
    final subtotal = calculateSubtotal();
    final perGuestCost = (subtotal / (guests.value > 0 ? guests.value : 1))
        .toStringAsFixed(0);
    return '${selectedPackage.value} (£$perGuestCost/Guest)';
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

    Get.dialog(ReceiptPopup(controller: this), barrierDismissible: false);
  }

  Future<void> completeBooking() async {
    try {
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
        package: selectedPackage.value,
        customerName: nameController.text,
        customerEmail: emailController.text,
        customerContact: contactController.text,
        hall: selectedCity.value,
        specialRequirements: specialRequirementsController.text,
      );

      Get.back(); // Close popup
      Get.snackbar(
        'Success',
        'Booking confirmed successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.back(); // navigate back
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

  void cancelBookingPopup() => Get.back();
  void cancelBooking() => Get.back();

  // ---------------------------
  // Package & menu related API
  // ---------------------------

  // helper to find package by title; returns null if not found
  Map<String, dynamic>? _findPackage(String title) {
    final idx = packages.indexWhere((p) => p['title'] == title);
    if (idx == -1) return null;
    return packages[idx];
  }

  // Return deep-copy menu (Map with keys 'Food Items' and 'Services') for a package.
  // For food items we set qty = guestCount (so they scale with guests) — caller must pass the current guestCount.
  Map<String, List<Map<String, dynamic>>> menuForPackage(
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

      final entry = {
        'name': name,
        'price': price,
        // If it's a food item, its qty should scale with guestCount (for built-in packages).
        // For services, keep the stored qty.
        'qty': isFood ? (guestCount > 0 ? guestCount : qtyStored) : qtyStored,
      };

      if (isFood) {
        food.add(Map<String, dynamic>.from(entry));
      } else {
        services.add(Map<String, dynamic>.from(entry));
      }
    }

    return {'Food Items': food, 'Services': services};
  }

  // Now all packages are editable in UI — return true to allow editing controls
  bool isPackageEditable(String packageTitle) {
    // previously used 'editable' flag; now return true so built-in packages
    // also get full editing capabilities
    return true;
  }

  bool isCustomPackage(String packageTitle) {
    final pkg = _findPackage(packageTitle);
    if (pkg == null) return false;
    return (pkg['editable'] == true);
  }

  // Create custom package if not present and open it (used by FAB)
  void createOrOpenCustomPackage() {
    const customTitle = 'Custom Package';
    final existing = packages.indexWhere((p) => p['title'] == customTitle);
    if (existing == -1) {
      final newPkg = {
        'title': customTitle,
        'description': 'Custom editable package',
        'price': '£0',
        'items': <Map<String, dynamic>>[], // empty initially
        'editable': true,
      };
      packages.add(newPkg);
      packageEdited[customTitle] =
          true; // custom packages are considered item-based
    }
    // select it so right pane shows it and is editable
    selectedPackage.value = customTitle;
  }

  // Update stored package items when user edits in UI
  // NOTE: This now commits items for any package (custom or built-in)
  void updateCustomPackageItems(
    String packageTitle,
    Map<String, List<Map<String, dynamic>>> newMenu,
  ) {
    final idx = packages.indexWhere((p) => p['title'] == packageTitle);
    if (idx == -1) return;

    final newItems = <Map<String, dynamic>>[];

    for (var f in newMenu['Food Items'] ?? []) {
      newItems.add({
        'name': f['name'],
        'price': (f['price'] as num).toDouble(),
        'qty': (f['qty'] as int),
      });
    }
    for (var s in newMenu['Services'] ?? []) {
      newItems.add({
        'name': s['name'],
        'price': (s['price'] as num).toDouble(),
        'qty': (s['qty'] as int),
      });
    }

    packages[idx]['items'] = newItems;
    // mark package as edited so future calculations use items total
    packageEdited[packageTitle] = true;

    // Refresh the observable list so UI updates
    packages.refresh();
  }

  // Inquiry flow
  // Inquiry requires everything except name, email and city/address (you said name/email/address optional).
  // But to keep it useful, we still require: selectedDate, startTime, endTime, guests, selectedEventType
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

    // Show a confirmation dialog for the inquiry
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
    // TODO: wire this to your backend API. For now just show a snackbar.
    Get.snackbar(
      'Inquiry Sent',
      'Your inquiry has been sent. We will contact you soon.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  // Helpers used by selection UI and FoodBeverageSelection
  List<Map<String, dynamic>> availableFoodForSelection() {
    final menu = menuForPackage(
      selectedPackage.value,
      guests.value > 0 ? guests.value : 1,
    );
    final foodNames = menu['Food Items']!.map((d) => d['name']).toSet();
    return masterAvailableFood
        .where((f) => !foodNames.contains(f['name']))
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  List<Map<String, dynamic>> availableServicesForSelection() {
    final menu = menuForPackage(
      selectedPackage.value,
      guests.value > 0 ? guests.value : 1,
    );
    final serviceNames = menu['Services']!.map((d) => d['name']).toSet();
    return masterAvailableServices
        .where((s) => !serviceNames.contains(s['name']))
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }
}
