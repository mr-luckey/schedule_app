import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schedule_app/controllers/booking_controller.dart';
import 'package:schedule_app/pages/booking_page.dart';
import 'package:schedule_app/widgets/Payment_Popup.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ReceiptPopup extends StatefulWidget {
  final BookingController controller;
  const ReceiptPopup({super.key, required this.controller});

  @override
  State<ReceiptPopup> createState() => _ReceiptPopupState();
}

class _ReceiptPopupState extends State<ReceiptPopup> {
  late final WebViewController webViewController;
  late Timer _timer; // Declare a timer

  @override
  void initState() {
    super.initState();

    print('ReceiptPopup initState called');

    // Initialize WebView controller once
    webViewController = WebViewController()
      ..loadHtmlString(widget.controller.generateReceiptHTML());

    print('WebView controller initialized with HTML content');

    // Set up timer to close after 10 seconds
    _timer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        Get.back(); // Close the popup
      }
    });

    // Only set JavaScript mode and add channels on non-web platforms
    if (!kIsWeb) {
      print('Setting up JavaScript channels for non-web platform');
      webViewController
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..addJavaScriptChannel(
          'cancelBooking',
          onMessageReceived: (JavaScriptMessage message) {
            print("Working 1 Test");
            // Close the receipt popup
            Get.back();
          },
        )
        ..addJavaScriptChannel(
          'navigateToNextScreen',
          onMessageReceived: (JavaScriptMessage message) {
            print("Working 2 Test");
            // Close the receipt popup
            Get.back();
          },
        );
      print('JavaScript channels setup completed');
      print('Channels added: cancelBooking, navigateToNextScreen');
    } else {
      print('Running on web platform - JavaScript channels not available');
    }
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.9,
        child: WebViewWidget(controller: webViewController),
      ),
    );
  }
}
