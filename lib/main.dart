import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'theme/app_theme.dart';
import 'pages/schedule_page.dart';

void main() {
  runApp(const BookingScheduleApp());
}

class BookingScheduleApp extends StatelessWidget {
  const BookingScheduleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Booking Schedule',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const SchedulePage(),
      builder: (context, child) {
        return ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: const [
            Breakpoint(start: 0, end: 599, name: MOBILE),
            Breakpoint(start: 600, end: 1023, name: TABLET),
            Breakpoint(start: 1024, end: 1439, name: DESKTOP),
            Breakpoint(start: 1440, end: double.infinity, name: '4K'),
          ],
        );
      },
    );
  }
}
