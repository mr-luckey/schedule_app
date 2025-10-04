import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:schedule_app/controllers/booking_controller.dart';
import 'package:schedule_app/pages/Edit/EditController.dart';

import 'package:schedule_app/pages/Edit/models/model.dart';
import 'package:schedule_app/theme/app_colors.dart';
import 'package:schedule_app/widgets/package_card.dart';
import 'package:flutter/services.dart';
import 'package:schedule_app/widgets/schedule_header.dart';
import 'package:schedule_app/widgets/sidebar.dart';
import 'package:schedule_app/pages/schedule_page.dart';

// ignore: must_be_immutable
class EditPage extends StatefulWidget {
  final String selectedId;
  EditPage({super.key, required this.selectedId});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final EditController editController = Get.put(EditController());

  @override
  void initState() {
    super.initState();
    // Load order data when the page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      editController.loadOrderById(widget.selectedId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // You'll need to implement custom package creation in EditController
          // For now, we'll just show a snackbar
          Get.snackbar('Info', 'Custom package feature to be implemented');
        },
        label: const Text('Custom Package'),
        icon: const Icon(Icons.edit),
      ),
      body: Obx(() {
        if (editController.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading order data...'),
              ],
            ),
          );
        }

        if (editController.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, size: 64, color: Colors.red),
                SizedBox(height: 16),
                Text(
                  'Error loading order',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(editController.errorMessage.value),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    editController.loadOrderById(widget.selectedId);
                  },
                  child: Text('Retry'),
                ),
              ],
            ),
          );
        }

        return ResponsiveBreakpoints.builder(
          child: _buildLayout(context),
          breakpoints: const [
            Breakpoint(start: 0, end: 599, name: MOBILE),
            Breakpoint(start: 600, end: 1023, name: TABLET),
            Breakpoint(start: 1024, end: 1439, name: DESKTOP),
            Breakpoint(start: 1440, end: double.infinity, name: '4K'),
          ],
        );
      }),
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
        ScheduleHeader(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                BookingForm(),
                const SizedBox(height: 24),
                FoodBeverageSelection(),
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
        SizedBox(width: 240, child: Sidebar()),
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: BookingForm()),
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
                      Expanded(flex: 2, child: BookingForm()),
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
    final controller = Get.find<EditController>();
    final formKey = GlobalKey<FormState>();

    // helper to open a dialog to edit guests manually
    void _showEditGuestsDialog() {
      final txtCtrl = TextEditingController(
        text: controller.guests.value.toString(),
      );
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

              // Guests control
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

              // Grid of packages
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
  final EditController editController = Get.find<EditController>();
  bool isConfirmed = false;
  bool isEditing = false;

  late Map<String, List<Map<String, dynamic>>> menu;

  late List<Map<String, dynamic>> availableFoodLocal;
  late List<Map<String, dynamic>> availableServicesLocal;

  String previousPackage = '';
  final List<Worker> _workers = [];

  @override
  void initState() {
    super.initState();

    // Initialize with current package
    previousPackage = editController.selectedPackage.value;

    // Initialize menu from current order data
    _initializeMenuFromOrder();

    availableFoodLocal = [];
    availableServicesLocal = [];

    _syncAvailableListsWithMenu();

    _workers.add(
      ever(editController.selectedPackage, (val) {
        final newPkg = val as String;
        if (isEditing) {
          _updateCustomPackageItems(previousPackage, menu);
        }
        if (!mounted) return;
        setState(() {
          isEditing = false;
          menu = _getMenuForPackage(
            newPkg,
            editController.guests.value > 0 ? editController.guests.value : 1,
          );
          previousPackage = newPkg;
          _syncAvailableListsWithMenu();
        });
      }),
    );

    _workers.add(
      ever(editController.guests, (g) {
        final guestsCount = (g);
        if (!mounted) return;
        setState(() {
          menu = _getMenuForPackage(
            editController.selectedPackage.value,
            guestsCount > 0 ? guestsCount : 1,
          );
          _syncAvailableListsWithMenu();
        });
      }),
    );

    // Listen for edit order changes to update menu
    ever(editController.currentEditOrder, (order) {
      if (order != null && mounted) {
        _initializeMenuFromOrder();
      }
    });
  }

  void _initializeMenuFromOrder() {
    final order = editController.currentEditOrder.value;
    if (order != null) {
      print('🔄 Initializing menu from edit order data');

      // Create menu structure from API data
      Map<String, List<Map<String, dynamic>>> apiMenu = {
        "Food Items": [],
        "Services": [],
      };

      // Load food items from order packages
      if (order.orderPackages != null && order.orderPackages!.isNotEmpty) {
        for (var orderPackage in order.orderPackages!) {
          if (orderPackage.orderPackageItems != null) {
            for (var packageItem in orderPackage.orderPackageItems!) {
              if (packageItem.menuItem != null) {
                apiMenu["Food Items"]!.add({
                  "name": packageItem.menuItem!.title ?? "Unknown Item",
                  "price":
                      double.tryParse(packageItem.menuItem!.price ?? "0") ??
                      0.0,
                  "qty": int.tryParse(packageItem.noOfGust ?? "1") ?? 1,
                  "id": packageItem.menuItem!.id,
                });
              }
            }
          }
        }
      }

      // Load services
      if (order.orderServices != null) {
        for (var orderService in order.orderServices!) {
          if (orderService.service != null &&
              !(orderService.isDeleted ?? false)) {
            apiMenu["Services"]!.add({
              "name": orderService.service!.title ?? "Unknown Service",
              "price":
                  double.tryParse(orderService.service!.price ?? "0") ?? 0.0,
              "qty": 1,
              "id": orderService.service!.id,
            });
          }
        }
      }

      if (mounted) {
        setState(() {
          menu = apiMenu;
          _syncAvailableListsWithMenu();
        });
      }
    } else {
      // Fallback to empty menu if no edit data
      if (mounted) {
        setState(() {
          menu = {"Food Items": [], "Services": []};
          _syncAvailableListsWithMenu();
        });
      }
    }
  }

  Map<String, List<Map<String, dynamic>>> _getMenuForPackage(
    String packageTitle,
    int guests,
  ) {
    // For edit page, we use the current menu state
    return menu;
  }

  void _updateCustomPackageItems(
    String packageTitle,
    Map<String, List<Map<String, dynamic>>> updatedMenu,
  ) {
    // Update the local menu state
    setState(() {
      menu = updatedMenu;
    });
  }

  @override
  void dispose() {
    for (final worker in _workers) {
      worker.dispose();
    }
    super.dispose();
  }

  bool _isApiPackage(String packageTitle) {
    final pkg = editController.packages.firstWhere(
      (p) => p['title'] == packageTitle,
      orElse: () => {},
    );
    return pkg['id']?.toString().isNotEmpty == true &&
        pkg['id']?.toString() != 'custom';
  }

  void _syncAvailableListsWithMenu() {
    // Initialize available lists from API data
    availableFoodLocal = List.from(
      editController.apiMenuItems.map((item) {
        return {
          'id': item['id'],
          'name': item['title'] ?? item['name'] ?? 'Unknown',
          'price': double.tryParse(item['price']?.toString() ?? '0') ?? 0.0,
          'category': item['category'] ?? 'Other',
        };
      }).toList(),
    );

    availableServicesLocal = List.from(
      editController.apiServiceItems.map((item) {
        return {
          'id': item['id'],
          'name': item['title'] ?? item['name'] ?? 'Unknown',
          'price': double.tryParse(item['price']?.toString() ?? '0') ?? 0.0,
          'category': item['category'] ?? 'Other',
        };
      }).toList(),
    );

    // Remove items that are already in the menu
    final foodNames = menu['Food Items']!.map((d) => d['name']).toSet();
    final serviceNames = menu['Services']!.map((d) => d['name']).toSet();

    availableFoodLocal.removeWhere((f) => foodNames.contains(f['name']));
    availableServicesLocal.removeWhere((s) => serviceNames.contains(s['name']));
  }

  double get foodAndBeverageCost {
    return _calculateTotalFromItems();
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
    if (!mounted) return;
    setState(() => dish["qty"] = (dish["qty"] ?? 0) + 1);
  }

  void decrement(Map<String, dynamic> dish) {
    if (!mounted) return;
    setState(() {
      if ((dish["qty"] ?? 0) > 0) {
        dish["qty"] = (dish["qty"] ?? 0) - 1;
      }
    });
  }

  void removeDish(String category, Map<String, dynamic> dish) {
    if (!mounted) return;
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
                                          if (!mounted) {
                                            Navigator.pop(ctx);
                                            return;
                                          }
                                          setState(() {
                                            final baseQty =
                                                category == "Food Items"
                                                ? 1
                                                : 1;

                                            final exists = menu[category]!.any(
                                              (m) =>
                                                  m['id']?.toString() ==
                                                  item['id']?.toString(),
                                            );
                                            if (!exists) {
                                              menu[category]!.add({
                                                "name": item["name"],
                                                "price": item["price"],
                                                "qty": baseQty,
                                                "id": item["id"],
                                              });
                                            }

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
                if (val != null && val >= 0 && mounted) {
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
                  "£${(dish["price"] as num).toStringAsFixed(2)} ${isFoodItem ? 'per unit' : 'service'}",
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ],
            ),
          ),

          // Quantity controls (visible when editing for food, not for services)
          if (isEditing && isFoodItem)
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
          else if (isFoodItem)
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
            _summaryRow("Food & Beverage", foodAndBeverageCost),
            _summaryRow("Service Charges (10%)", serviceCharges),
            _summaryRow("Tax (13%)", tax),
            const Divider(),
            _summaryRow(
              "Total Amount",
              totalAmount,
              isBold: true,
              fontSize: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(
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

  void _commitEditsToController() {
    // Convert current menu to EditController format
    final List<OrderServices> updatedServices = [];
    final List<OrderPackages> updatedPackages = [];

    // Process services
    for (var service in menu["Services"]!) {
      final dynamic rawId = service['id'];
      final int? menuItemId = int.tryParse(rawId?.toString() ?? '');
      updatedServices.add(
        OrderServices(
          menuItemId: menuItemId,
          price: (service['price'] as num).toInt(),
          isDeleted: false,
          service: Service(
            id: menuItemId,
            title: service['name'] ?? 'Service',
            price: (service['price'] as num).toString(),
            description: null,
          ),
        ),
      );
    }

    // Process food items (packages)
    if (menu["Food Items"]!.isNotEmpty) {
      final List<OrderPackageItems> packageItems = [];

      for (var foodItem in menu["Food Items"]!) {
        final dynamic rawId = foodItem['id'];
        final int? menuItemId = int.tryParse(rawId?.toString() ?? '');
        packageItems.add(
          OrderPackageItems(
            menuItemId: menuItemId,
            price: (foodItem['price'] as num).toString(),
            noOfGust: (foodItem['qty'] as int).toString(),
            isDeleted: false,
            menuItem: Service(
              id: menuItemId,
              title: foodItem['name'] ?? 'Food Item',
              price: (foodItem['price'] as num).toString(),
              description: null,
            ),
          ),
        );
      }

      // Get current package info
      final currentPackage = editController.packages.firstWhere(
        (p) => p['title'] == editController.selectedPackage.value,
        orElse: () => {},
      );
      final int? packageId = int.tryParse(
        currentPackage['id']?.toString() ?? '',
      );

      updatedPackages.add(
        OrderPackages(
          packageId: packageId ?? 1,
          amount: foodAndBeverageCost.toString(),
          isCustom: editController.selectedPackage.value == 'Custom Package',
          package: Package(
            id: packageId ?? 1,
            title: currentPackage['title'] ?? 'Package',
            price: currentPackage['price']?.toString() ?? '0.0',
            description: currentPackage['description'] ?? '',
          ),
          orderPackageItems: packageItems,
        ),
      );
    }

    // Update edit controller
    editController.currentOrderServices.value = updatedPackages
        .cast<OrderServices>();
    editController.currentOrderPackages.value = updatedPackages
        .cast<OrderPackages>();

    Get.snackbar('Saved', 'Package updated');
  }

  bool get _isFormValid {
    return editController.nameController.text.isNotEmpty &&
        editController.emailController.text.isNotEmpty &&
        editController.contactController.text.isNotEmpty &&
        editController.selectedCity.value.isNotEmpty &&
        editController.selectedEventType.value.isNotEmpty &&
        editController.selectedDate.value != null &&
        editController.startTime.value != null &&
        editController.endTime.value != null;
  }

  @override
  Widget build(BuildContext context) {
    if (isConfirmed)
      return Container(); // You can replace with your booking summary

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
                if (isEditing)
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
            if (menu["Food Items"]!.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "No food items added",
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
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
                if (isEditing)
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
            if (menu["Services"]!.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "No services added",
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
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
                    if (!mounted) return;
                    setState(() {
                      isEditing = !isEditing;
                    });
                    if (!isEditing) {
                      _commitEditsToController();
                    }
                  },
                  child: Text(isEditing ? "Done" : "Edit"),
                ),

                ElevatedButton(
                  onPressed: _isFormValid
                      ? () async {
                          // Commit current edits first
                          if (isEditing) {
                            _commitEditsToController();
                          }

                          // Show loading
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );

                          try {
                            final success = await editController.completeEdit();

                            // Hide loading
                            if (mounted) {
                              Navigator.of(context).pop();
                            }

                            if (success) {
                              // Show success dialog then navigate to main screen
                              if (mounted) {
                                await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Success'),
                                    content: const Text(
                                      'Event updated successfully!',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                                if (!mounted) return;
                                Get.offAll(() => SchedulePage());
                              }
                            } else {
                              // Show error
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Failed to update event: ${editController.errorMessage.value}',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          } catch (e) {
                            // Hide loading
                            if (mounted) {
                              Navigator.of(context).pop();
                            }

                            // Show error
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error updating event: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Update Event'),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
