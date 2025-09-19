import 'package:flutter/material.dart';
import 'package:schedule_app/pages/booking_page.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ReceiptPopup extends StatefulWidget {
  final BookingController controller;

  const ReceiptPopup({super.key, required this.controller});

  @override
  State<ReceiptPopup> createState() => _ReceiptPopupState();
}

class _ReceiptPopupState extends State<ReceiptPopup> {
  late final WebViewController webViewController;

  @override
  void initState() {
    super.initState();
    webViewController = WebViewController()
      ..loadHtmlString(widget.controller.generateReceiptHTML());
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
