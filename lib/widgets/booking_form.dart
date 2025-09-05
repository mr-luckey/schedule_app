import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';
import '../controllers/booking_controller.dart';
import 'package_card.dart';

class BookingForm extends StatelessWidget {
  const BookingForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookingController>();
    final formKey = GlobalKey<FormState>();

    return Container(
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
            Text(
              'Personal Information',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            // Name and Email Row
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
                    onChanged: controller.updateName,
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
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    onChanged: controller.updateEmail,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Contact and City Row
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    context: context,
                    controller: controller.contactController,
                    label: 'Contact#',
                    hint: '+44-XXX-XXX-XXX',
                    onChanged: controller.updateContact,
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

            // Message Field
            _buildTextField(
              context: context,
              controller: controller.messageController,
              label: 'Message (If Any)',
              hint: 'If you have any question?',
              maxLines: 3,
              onChanged: controller.updateMessage,
            ),

            const SizedBox(height: 32),

            // Event Details Section
            Text(
              'Event Details',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            // Date and Time Row
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
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        controller.setDate(date);
                      }
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
                      if (time != null) {
                        controller.setStartTime(time);
                      }
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
                      if (time != null) {
                        controller.setEndTime(time);
                      }
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Guests and Event Type Row
            Row(
              children: [
                Expanded(child: _buildGuestsField(context, controller)),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDropdown(
                    context: context,
                    label: 'Event Type',
                    value: controller.selectedEventType.value,
                    items: controller.eventTypes,
                    onChanged: controller.setEventType,
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
              onChanged: controller.updateSpecialRequirements,
            ),

            const SizedBox(height: 32),

            // Packages Section
            Text(
              'Packages',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            // Package Grid
            // Obx(
            //   () =>
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
                final isSelected =
                    controller.selectedPackage.value == package['title'];
                return
                // Obx(
                //   () =>
                PackageCard(
                  title: package['title']!,
                  description: package['description']!,
                  price: package['price']!,
                  isSelected: isSelected,
                  onTap: () => controller.setPackage(package['title']!),
                  // ),
                );
              },
            ),
            // ),
          ],
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
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary),
            ),
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
          items: items.map((item) {
            return DropdownMenuItem(value: item, child: Text(item));
          }).toList(),
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

  Widget _buildGuestsField(BuildContext context, BookingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Number of Guests',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Obx(
            () => Row(
              children: [
                IconButton(
                  onPressed: controller.decrementGuests,
                  icon: const Icon(Icons.remove),
                ),
                Expanded(
                  child: Text(
                    controller.guests.value.toString(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                IconButton(
                  onPressed: controller.incrementGuests,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
