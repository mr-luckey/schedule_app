import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../theme/app_colors.dart';
import '../controllers/booking_controller.dart';
import '../widgets/sidebar.dart';
import '../widgets/schedule_header.dart';
import '../widgets/booking_form.dart';
import '../widgets/booking_summary.dart';

class BookingPage extends StatelessWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    Get.put(BookingController());

    return Scaffold(
      backgroundColor: AppColors.background,
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

    if (isMobile) {
      return _buildMobileLayout();
    } else if (isTablet) {
      return _buildTabletLayout();
    } else {
      return _buildDesktopLayout();
    }
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        // Header for mobile
        const ScheduleHeader(),

        // Content for mobile
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Booking form
                const BookingForm(),

                const SizedBox(height: 24),

                // Booking summary
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
        // Sidebar for tablet (narrower)
        SizedBox(width: 240, child: const Sidebar()),

        // Main content
        Expanded(
          child: Column(
            children: [
              // const ScheduleHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Booking form
                      Expanded(flex: 2, child: const BookingForm()),

                      const SizedBox(width: 24),

                      // Booking summary
                      Expanded(flex: 1, child: const BookingSummary()),
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
        // Sidebar for desktop
        // const Sidebar(),

        // Main content
        Expanded(
          child: Column(
            children: [
              // const ScheduleHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Booking form
                      Expanded(flex: 2, child: const BookingForm()),

                      const SizedBox(width: 24),

                      // Booking summary
                      Expanded(flex: 1, child: const BookingSummary()),
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
