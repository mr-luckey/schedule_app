import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:schedule_app/pages/Edit/EditController.dart';
import 'package:schedule_app/pages/Edit/models/EditModel.dart' as EditModels;
import 'package:schedule_app/pages/Edit/models/MenuItem.dart' as MenuItemModel;
import 'package:schedule_app/theme/app_colors.dart';
import 'package:schedule_app/widgets/package_card.dart';
import 'package:flutter/services.dart';
import 'package:schedule_app/widgets/schedule_header.dart';
import 'package:schedule_app/pages/schedule_page.dart' hide Sidebar;

import 'models/model.dart';

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
    // Load API data first, then order data when the page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await editController.loadApiData(); // Load packages, cities, events, etc.
      editController.loadOrderById(widget.selectedId);
    });
    editController.loadServiceItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
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
        // SizedBox(width: 240, child: Sidebar()),
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

    /// Helper to open a dialog to edit guests manually
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
              // Personal Information Section
              _buildSectionTitle('Personal Information'),
              const SizedBox(height: 16),

              // Name and Email
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
                        if (value.trim().length < 2) {
                          return 'Name must be at least 2 characters';
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
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Contact and City
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      context: context,
                      controller: controller.contactController,
                      label: 'Contact#',
                      hint: '+44-XXX-XXX-XXX',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your contact number';
                        }
                        // Remove all non-digit characters for validation
                        final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
                        if (digitsOnly.length < 10) {
                          return 'Contact number must be at least 10 digits';
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a city';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Message
              _buildTextField(
                context: context,
                controller: controller.messageController,
                label: 'Message (If Any)',
                hint: 'If you have any question?',
                maxLines: 3,
              ),

              const SizedBox(height: 32),

              // Event Details Section
              _buildSectionTitle('Event Details'),
              const SizedBox(height: 16),

              // Event Type Field
              _buildDropdown(
                context: context,
                label: 'Event Type',
                value: controller.selectedEventType.value,
                items: controller.eventTypes,
                onChanged: controller.setEventType,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select an event type';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Date and Time
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
                              Obx(() => Text(
                                controller.guests.value.toString(),
                                style: Theme.of(context).textTheme.bodyLarge,
                              )),
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

              // Special Requirements
              _buildTextField(
                context: context,
                controller: controller.specialRequirementsController,
                label: 'Special Requirements',
                hint:
                    'Stage Decoration, Seating Arrangement, Dietary Restrictions, etc.',
                maxLines: 3,
              ),

              const SizedBox(height: 32),

              // Packages Section
              _buildSectionTitle('Packages'),
              const SizedBox(height: 16),

              // Grid of packages
              Obx(() {
                print('🔄 Building packages grid with ${controller.packages.length} packages');
                if (controller.packages.isEmpty) {
                  return Container(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'No packages available. Loading...',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }
                
                return GridView.builder(
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
                    print('📦 Building package card: ${package.title}');
                    return Obx(() {
                      final isSelected =
                          controller.selectedPackage.value == package.title;
                      return PackageCard(
                        title: package.title ?? 'Unknown Package',
                        description: package.description ?? '',
                        price: package.price ?? '0',
                        isSelected: isSelected,
                        onTap: () {
                          print('📦 Package tapped: ${package.title}');
                          controller.setPackage(package.title ?? '');
                        },
                      );
                    });
                  },
                );
              }),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // FORM BUILDING METHODS
  // ===========================================================================

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
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
    String? Function(String?)? validator,
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
          validator: validator,
          decoration: InputDecoration(
            hintText: 'Select $label',
            border: const OutlineInputBorder(),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary),
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
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
  bool isEditing = false;
  bool isEdited = false;

  // ===========================================================================
  // LIFECYCLE METHODS
  // ===========================================================================

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // ===========================================================================
  // DATA GETTERS
  // ===========================================================================

  /// Get available menu items grouped by category (excluding already selected ones)
  List<MenuItemModel.MenuCategory> get availableMenuCategories {
    final selectedIds = editController.selectedMenuItems
        .map((item) => item.menuItemId.toString())
        .toSet();

    return editController.menuCategories
        .map((category) {
          final availableItems = category.menuItems?.where((item) {
            return !selectedIds.contains(item.id.toString());
          }).toList();

          return MenuItemModel.MenuCategory(
            id: category.id,
            title: category.title,
            menuItems: availableItems,
            createdAt: category.createdAt,
            updatedAt: category.updatedAt,
            url: category.url,
          );
        })
        .where((category) => category.menuItems?.isNotEmpty == true)
        .toList();
  }

  /// Get available service MENU ITEMS (not already selected as a menu item)
  List<MenuItemModel.MenuItem> get availableServiceMenuItems {
    final selectedIds = editController.selectedMenuItems
        .map((item) => item.menuItemId.toString())
        .toSet();

    final allMenuItems = <MenuItemModel.MenuItem>[];

    for (final service in editController.apiServiceItems) {
      final items = service.menuItems ?? <EditModels.MenuItem>[];
      for (final mi in items) {
        if (!selectedIds.contains(mi.id.toString())) {
          allMenuItems.add(
            MenuItemModel.MenuItem(
              id: mi.id,
              menuId: mi.menuId,
              title: mi.title,
              price: mi.price.toString(),
              description: mi.description,
              createdAt: mi.createdAt?.toIso8601String(),
              updatedAt: mi.updatedAt?.toIso8601String(),
            ),
          );
        }
      }
    }

    return allMenuItems;
  }
  // List<ServiceMode> get availableServiceItems {
  //   final selectedIds = editController.selectedServiceItems
  //       .map((item) => item.serviceId.toString())
  //       .toSet();

  //   return editController.apiServiceItems
  //       .where((service) => !selectedIds.contains(service.id.toString()))
  //       .toList();
  // }
  // List<ServiceMode> get availableServiceItems {
  //   final selectedIds = editController.selectedServiceItems
  //       .map((item) => item.serviceId.toString())
  //       .toSet();

  //   return editController.apiServiceItems
  //       .where((item) => !selectedIds.contains(item.id.toString()))
  //       .toList();
  // }

  // ===========================================================================
  // COST CALCULATION METHODS
  // ===========================================================================
  double _calculateTotalFromItems() {
    double total = 0.0;
    for (var item in editController.selectedMenuItems) {
      final price = double.tryParse(item.price) ?? 0.0;
      total += price * item.qty;
    }
    return total;
  }

  /// Calculate total food and beverage cost (excluding services)
  double get foodAndBeverageCost {
    // Apply the same simple logic as booking screen
    if (editController.isCustomEditing.value && 
        editController.selectedPackage.value == 'Custom Package') {
      return _calculateTotalFromItems();
    } else {
      final pkg = editController.apiPackages.firstWhere(
        (p) => p.title == editController.selectedPackage.value,
        orElse: () => Package(),
      );
      final packagePrice = _parsePriceString(pkg.price);
      final guestCount = editController.guests.value;
      return packagePrice * guestCount;
    }
  }

  double _parsePriceString(String? priceStr) {
    if (priceStr == null) return 0.0;
    final cleaned = priceStr.replaceAll(RegExp(r'[^0-9.]'), '');
    if (cleaned.isEmpty) return 0.0;
    return double.tryParse(cleaned) ?? 0.0;
  }


  /// Get service cost (sum of selected services)
  double get serviceCost {
    double total = 0.0;
    for (var service in editController.selectedServiceItems) {
      final price = double.tryParse(service.price) ?? 0.0;
      total += price * service.qty;
    }
    return total;
  }

  /// Get VAT (20% of food and beverage cost)
  double get vat => 0.20 * foodAndBeverageCost;

  /// Get total amount
  double get totalAmount => foodAndBeverageCost + serviceCost + vat;

  // ===========================================================================
  // CUSTOM PACKAGE SWITCHING (matching booking screen)
  // ===========================================================================

  /// Auto switch to custom package when editing (like booking screen)
  void _autoSwitchToCustomPackage() {
    // Get current menu state from selected items
    final currentMenu = {
      'Food Items': editController.selectedMenuItems
          .map((item) => {
                'name': item.name,
                'price': item.price,
                'qty': item.qty,
                'menu_item_id': item.menuItemId,
                'id': item.id,
              })
          .toList(),
      'Services': editController.selectedServiceItems
          .map((item) => {
                'name': item.title,
                'price': item.price,
                'qty': item.qty,
                'menu_item_id': item.serviceId,
                'id': item.id,
              })
          .toList(),
    };

    // Switch to custom package and update with current menu
    editController.switchToCustomPackageAndUpdate(currentMenu);
  }

  // ===========================================================================
  // ITEM MANAGEMENT METHODS
  // ===========================================================================

  /// Increment quantity for a food item
  /// Increment quantity for a food item
  void incrementQuantity(SelectedMenuItem item) {
    final index = editController.selectedMenuItems.indexWhere(
      (i) => i.menuItemId == item.menuItemId,
    );

    if (index != -1) {
      final currentQty = editController.selectedMenuItems[index].qty;
      editController.selectedMenuItems[index] = SelectedMenuItem(
        menuItemId: item.menuItemId,
        name: item.name,
        price: item.price,
        qty: currentQty + 1,
        id: item.id,
        isDeleted: item.isDeleted,
      );
      editController.selectedMenuItems.refresh();
      editController.markPackageAsEdited(); // Mark as edited
      
      // Auto switch to custom package when modifying items (like booking screen)
      _autoSwitchToCustomPackage();
    }
  }

  /// Decrement quantity for a food item
  void decrementQuantity(SelectedMenuItem item) {
    final index = editController.selectedMenuItems.indexWhere(
      (i) => i.menuItemId == item.menuItemId,
    );

    if (index != -1) {
      final currentQty = editController.selectedMenuItems[index].qty;
      if (currentQty > 1) {
        editController.selectedMenuItems[index] = SelectedMenuItem(
          menuItemId: item.menuItemId,
          name: item.name,
          price: item.price,
          qty: currentQty - 1,
          id: item.id,
          isDeleted: item.isDeleted,
        );
        editController.selectedMenuItems.refresh();
        editController.markPackageAsEdited(); // Mark as edited
        
        // Auto switch to custom package when modifying items (like booking screen)
        _autoSwitchToCustomPackage();
      }
    }
  }

  /// Remove item from selection
  void removeItem(dynamic item, bool isFoodItem) {
    if (isFoodItem) {
      editController.removeSelectedMenuItemByMenuItemId(
        (item as SelectedMenuItem).menuItemId,
      );
      // Auto switch to custom package only for food items (like booking screen)
      _autoSwitchToCustomPackage();
    } else {
      editController.removeSelectedServiceItemById(
        (item as SelectedServiceItem).serviceId,
      );
      // Services are excluded from auto-switching functionality
    }
    editController.markPackageAsEdited(); // Mark as edited
  }

  /// Add menu item to selection
  /// Add menu item to selection
  void addMenuItem(MenuItemModel.MenuItem menuItem) {
    editController.addSelectedMenuItem(
      menuItemId: menuItem.id ?? 0,
      name: menuItem.title ?? 'Unknown Item',
      price: menuItem.price?.toString() ?? '0',
      qty: editController.guests.value, // Use guest count for food
    );
    editController.markPackageAsEdited(); // Mark as edited
    
    // Auto switch to custom package when modifying items (like booking screen)
    _autoSwitchToCustomPackage();
  }

  /// Add service item to selection
  void addServiceItem(EditModels.ServiceMode service) {
    editController.addSelectedServiceItem(
      serviceId: service.id ?? 0,
      title: service.title ?? 'Unknown Service',
      price:
          service.price?.toString() ?? '0', // Use service.price, not menuItems
      qty: 1,
    );
    editController.markPackageAsEdited(); // Mark as edited
  }

  /// Add a service MENU ITEM directly into Services section
  void addServiceMenuItem(MenuItemModel.MenuItem menuItem) {
    editController.addSelectedServiceItem(
      serviceId: menuItem.id ?? 0,
      title: menuItem.title ?? 'Unknown Service',
      price: (menuItem.price ?? '0').toString(),
      qty: 1,
    );
    editController.markPackageAsEdited(); // Mark as edited
  }


  // ===========================================================================
  // DIALOG METHODS
  // ===========================================================================

  /// Show dialog to edit quantity
  void _showEditQuantityDialog(SelectedMenuItem item) {
    final txtController = TextEditingController(text: item.qty.toString());

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Set quantity for ${item.name}'),
          content: TextField(
            controller: txtController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(hintText: 'Enter quantity'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final val = int.tryParse(txtController.text);
                if (val != null && val > 0) {
                  final index = editController.selectedMenuItems.indexWhere(
                    (i) => i.menuItemId == item.menuItemId,
                  );

                  if (index != -1) {
                    editController.selectedMenuItems[index] = SelectedMenuItem(
                      menuItemId: item.menuItemId,
                      name: item.name,
                      price: item.price,
                      qty: val,
                      id: item.id,
                      isDeleted: item.isDeleted,
                    );
                    editController.selectedMenuItems.refresh();
                    editController.markPackageAsEdited(); // Mark as edited
                  }
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

  /// Show dialog to add menu items (with categories)
  void _showAddMenuItemsDialog() {
    final availableCategories = availableMenuCategories;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return SafeArea(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text(
                    'Add Food Items',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ),
                if (availableCategories.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'No more food items available to add.',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  )
                else
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        for (var category in availableCategories)
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
                                  category.title ?? 'Uncategorized',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.blue[700],
                                  ),
                                ),
                              ),
                              ...(category.menuItems ?? []).map((item) {
                                return ListTile(
                                  title: Text(item.title ?? 'Unknown Item'),
                                  subtitle: Text(
                                    '£${(double.tryParse(item.price ?? '0') ?? 0.0).toStringAsFixed(2)}',
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.add_circle,
                                      color: Colors.green,
                                    ),
                                    onPressed: () {
                                      addMenuItem(item);
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
  }

  /// Get available menu items from all services (excluding already selected ones)
  // List<MenuItem> get availableServiceMenuItems {
  //   final selectedIds = editController.selectedMenuItems
  //       .map((item) => item.menuItemId.toString())
  //       .toSet();

  //   final allMenuItems = <MenuItem>[];

  //   for (var service in editController.apiServiceItems) {
  //     if (service.menuItems != null && service.menuItems!.isNotEmpty) {
  //       for (var menuItem in service.menuItems!) {
  //         if (!selectedIds.contains(menuItem.id.toString())) {
  //           allMenuItems.add(menuItem);
  //         }
  //       }
  //     }
  //   }

  //   return allMenuItems;
  // }

  /// Show dialog to add service items
  /// Show dialog to add service items
  /// Show dialog to add service items
  /// Show dialog to add service items
  void _showAddServiceItemsDialog() {
    final availableMenuItems = availableServiceMenuItems;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return SafeArea(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text(
                    'Add Services Menu Items',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ),
                if (availableMenuItems.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'No more service menu items available to add.',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  )
                else
                  Expanded(
                    child: Obx(() {
                      if (editController.isLoadingServices.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return ListView(
                        shrinkWrap: true,
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: Text(
                              'Available Service Menu Items',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          ...availableMenuItems.map((menuItem) {
                            return ListTile(
                              title: Text(menuItem.title ?? 'Unknown Item'),
                              subtitle: Text('£${(menuItem.price ?? '0')}'),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.add_circle,
                                  color: Colors.green,
                                ),
                                onPressed: () {
                                  addServiceMenuItem(menuItem);
                                  Navigator.pop(ctx);
                                },
                              ),
                            );
                          }).toList(),
                        ],
                      );
                    }),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  ///   // void _showAddServiceItemsDialog() {
  //   final availableServices = availableServiceItems;

  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (ctx) {
  //       return SafeArea(
  //         child: Container(
  //           constraints: BoxConstraints(
  //             maxHeight: MediaQuery.of(context).size.height * 0.8,
  //           ),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               ListTile(
  //                 title: const Text(
  //                   'Add Services',
  //                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
  //                 ),
  //                 trailing: IconButton(
  //                   icon: const Icon(Icons.close),
  //                   onPressed: () => Navigator.pop(ctx),
  //                 ),
  //               ),
  //               if (availableServices.isEmpty)
  //                 Padding(
  //                   padding: const EdgeInsets.all(16),
  //                   child: Text(
  //                     'No more services available to add.',
  //                     style: TextStyle(color: Colors.grey[600]),
  //                   ),
  //                 )
  //               else
  //                 Expanded(
  //                   child: ListView(
  //                     shrinkWrap: true,
  //                     children: [
  //                       const Padding(
  //                         padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
  //                         child: Text(
  //                           'Available Services',
  //                           style: TextStyle(
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 16,
  //                             color: Colors.blue,
  //                           ),
  //                         ),
  //                       ),
  //                       ...availableServices.map((menuItems) {
  //                         return ListTile(
  //                           title: Text(MenuItem.title ?? 'Unknown Service'),
  //                           subtitle: Text(
  //                             '£${(double.tryParse(MenuItem.menuItems) ?? 0.0).toStringAsFixed(2)}',
  //                           ),
  //                           trailing: IconButton(
  //                             icon: const Icon(
  //                               Icons.add_circle,
  //                               color: Colors.green,
  //                             ),
  //                             onPressed: () {
  //                               addServiceItem(service as Service);
  //                               Navigator.pop(ctx);
  //                             },
  //                           ),
  //                         );
  //                       }).toList(),
  //                     ],
  //                   ),
  //                 ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // ===========================================================================
  // UI BUILDING METHODS
  // ===========================================================================

  /// Build item row for display
  Widget buildItemRow(dynamic item, bool isFoodItem) {
    final name = isFoodItem
        ? (item as SelectedMenuItem).name
        : (item as SelectedServiceItem).title;
    final price = isFoodItem
        ? (item as SelectedMenuItem).price
        : (item as SelectedServiceItem).price;
    final qty = isFoodItem
        ? (item as SelectedMenuItem).qty
        : (item as SelectedServiceItem).qty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Item name + price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 15)),
                Text(
                  "£${(double.tryParse(price) ?? 0.0).toStringAsFixed(2)} ${isFoodItem ? 'per unit' : 'service'}",
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ],
            ),
          ),

          // Quantity controls (visible when editing for food, always for services)
          if (isEditing || !isFoodItem)
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
                    onPressed: isFoodItem
                        ? () => decrementQuantity(item as SelectedMenuItem)
                        : null,
                  ),
                  Text(qty.toString(), style: const TextStyle(fontSize: 16)),
                  IconButton(
                    icon: const Icon(Icons.add, size: 20),
                    onPressed: isFoodItem
                        ? () => incrementQuantity(item as SelectedMenuItem)
                        : null,
                  ),
                  // Edit button to input number manually (only for food)
                  if (isFoodItem)
                    IconButton(
                      icon: const Icon(Icons.edit, size: 18),
                      onPressed: () =>
                          _showEditQuantityDialog(item as SelectedMenuItem),
                    ),
                ],
              ),
            )
          else if (isFoodItem)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text("Qty: $qty"),
            ),

          // Remove button (only visible when editing)
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red, size: 20),
              onPressed: () => removeItem(item, isFoodItem),
            ),
        ],
      ),
    );
  }

  /// Build cost summary section
  Widget _buildSummary() {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _summaryRow(
              "Food & Beverage",
              foodAndBeverageCost.toStringAsFixed(2),
            ),
            _summaryRow("Service Cost", serviceCost.toStringAsFixed(2)),
            _summaryRow("VAT (20%)", vat.toStringAsFixed(2)),
            const Divider(),
            _summaryRow(
              "Total Amount",
              totalAmount.toStringAsFixed(2),
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
    String value, {
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
            "£$value",
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  // Widget _summaryRow(
  //   String label,
  //   dynamic value, {
  //   bool isBold = false,
  //   double fontSize = 16,
  // }) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 4),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text(
  //           label,
  //           style: TextStyle(
  //             fontSize: fontSize,
  //             fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
  //           ),
  //         ),
  //         Text(
  //           "£${value}",
  //           style: TextStyle(
  //             fontSize: fontSize,
  //             fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // ===========================================================================
  // VALIDATION METHODS
  // ===========================================================================

  /// Check if form is valid for submission
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

  // ===========================================================================
  // MAIN BUILD METHOD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
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
              // Package header
              Obx(() {
                final packageTitle = editController.selectedPackage.value;

                return Column(
                  children: [
                    Text(
                      "Selected Package",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      packageTitle.isEmpty
                          ? "No Package Selected"
                          : packageTitle,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                  ],
                );
              }),

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
                          icon: const Icon(
                            Icons.add_circle,
                            color: Colors.green,
                          ),
                          onPressed: _showAddMenuItemsDialog,
                        ),
                      ],
                    ),
                ],
              ),
              const Divider(),
              if (editController.selectedMenuItems.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "No food items added",
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              else
                ...editController.selectedMenuItems.map(
                  (item) => buildItemRow(item, true),
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
                        onPressed: _showAddServiceItemsDialog,
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(),
              if (editController.selectedServiceItems.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "No services added",
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              else
                ...editController.selectedServiceItems.map(
                  (item) => buildItemRow(item, false),
                ),

              // Cost Summary
              _buildSummary(),
              const SizedBox(height: 10),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isEditing = !isEditing;
                        isEdited = !isEdited;
                        editController.isEditingItems.value = isEditing;

                        if (isEditing) {
                          editController.isCustomEditing.value = true;
                          // Always sync selected package to current order package when entering edit mode
                          final pkgs = editController.currentOrderPackages;
                          if (pkgs.isNotEmpty && pkgs.first.packageId != null) {
                            editController.selectedPackageId.value = pkgs
                                .first
                                .packageId!
                                .toString();
                            final pkgTitle = pkgs.first.package?.title ?? '';
                            if (pkgTitle.isNotEmpty) {
                              editController.selectedPackage.value = pkgTitle;
                            }
                          }
                        } else {
                          isEdited = true;
                          // Leaving edit mode retains items
                          editController.isCustomEditing.value = true;
                        }
                      });
                    },
                    child: Text(isEditing ? "Done Editing" : "Edit Items"),
                  ),

                  ElevatedButton(
                    onPressed: _isFormValid
                        ? () async {
                            // Show loading
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );

                            try {
                              final success = await editController
                                  .completeEdit();
                              Get.offAll(() => SchedulePage());

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
      ),
    );
  }
}
