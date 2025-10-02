import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:responsive_framework/responsive_framework.dart';
import 'package:schedule_app/APIS/Api_Service.dart';

import 'package:schedule_app/pages/Auth/Login_Signup.dart';
import 'package:schedule_app/pages/Edit/editApi.dart';
import 'package:schedule_app/pages/schedule_page.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_web/webview_flutter_web.dart';
import 'theme/app_theme.dart';

void main() async {
  await ApiService.init();
  // await EditApiService.init();
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    WebViewPlatform.instance = WebWebViewPlatform();
  }

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
      home: _getInitialScreen(),
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

  Widget _getInitialScreen() {
    // If user is already logged in, go directly to SchedulePage
    if (ApiService.isLoggedIn) {
      return SchedulePage();
    } else {
      return AuthScreen();
    }
  }
}
