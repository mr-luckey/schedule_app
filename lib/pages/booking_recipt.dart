// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// // ---------------- Popup Widget ----------------
// class BookingReceiptPopup extends StatelessWidget {
//   final String htmlContent;

//   const BookingReceiptPopup({super.key, required this.htmlContent});

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       insetPadding: const EdgeInsets.all(16),
//       child: SizedBox(
//         width: double.maxFinite,
//         height: MediaQuery.of(context).size.height * 0.9,
//         child: WebViewWidget(
//           controller: WebViewController()
//             ..setJavaScriptMode(JavaScriptMode.unrestricted)
//             ..loadHtmlString(htmlContent),
//         ),
//       ),
//     );
//   }
// }

// // ---------------- Booking Controller Stub ----------------
// // Replace with your existing BookingController
// class BookingController extends GetxController {
//   final nameController = TextEditingController(text: "Sarah & Michael Johnson");
//   final emailController = TextEditingController(
//     text: "sarah.johnson@email.com",
//   );
//   final contactController = TextEditingController(text: "+44-789-123-4567");
//   final selectedCity = "Royal Gardens Hotel, London".obs;
//   final selectedEventType = "Wedding Reception".obs;
//   final selectedDate = DateTime(2025, 10, 12).obs;
//   final startTime = const TimeOfDay(hour: 18, minute: 0).obs;
//   final endTime = const TimeOfDay(hour: 23, minute: 30).obs;
//   final guests = 120.obs;
//   final selectedPackage = "Premium Wedding Package".obs;

//   double calculateTotal() => 7963.20;

//   String getTimeRange(BuildContext context) {
//     return "${startTime.value.format(context)} - ${endTime.value.format(context)}";
//   }
// }

// // ---------------- Show Booking Confirmation ----------------
// void showBookingConfirmation(BookingController controller) {
//   // Exact HTML template you provided (trimmed for brevity here)
//   String htmlTemplate = """
// <!DOCTYPE html>
// <html lang="en">
// <head>
// <meta charset="UTF-8">
// <meta name="viewport" content="width=device-width, initial-scale=1.0">
// <title>Booking Confirmation Receipt - A4</title>
// <style>
// * { margin: 0; padding: 0; box-sizing: border-box; }
// body { font-family: 'Times New Roman', serif; background-color: white; color: #000; line-height: 1.2; font-size: 12px; }
// .receipt-container { width: 210mm; height: 297mm; margin: 0 auto; background: white; border: 2px solid #000; padding: 15mm; overflow: hidden; }
// .header { text-align: center; border-bottom: 2px solid #000; padding-bottom: 8px; margin-bottom: 12px; }
// .company-name { font-size: 20px; font-weight: bold; margin-bottom: 3px; text-transform: uppercase; }
// .company-details { font-size: 10px; margin-bottom: 8px; line-height: 1.3; }
// .receipt-title { font-size: 16px; font-weight: bold; text-transform: uppercase; margin-top: 8px; }
// </style>
// </head>
// <body>
// <div class="receipt-container">
//   <div class="header">
//     <div class="company-name">Premium Event Catering Ltd.</div>
//     <div class="company-details">
//       123 Wedding Lane, London, EC1A 1BB<br>
//       Tel: +44-20-7123-4567 | Email: events@premiumcatering.co.uk | VAT: GB123456789
//     </div>
//     <div class="receipt-title">Booking Confirmation Receipt</div>
//   </div>

//   <div>
//     <strong>Customer:</strong> {{customerName}}<br>
//     <strong>Email:</strong> {{customerEmail}}<br>
//     <strong>Contact:</strong> {{customerContact}}<br>
//     <strong>Event:</strong> {{eventType}}<br>
//     <strong>Date:</strong> {{eventDate}}<br>
//     <strong>Time:</strong> {{eventTime}}<br>
//     <strong>Guests:</strong> {{guests}} persons<br>
//     <strong>Package:</strong> {{package}}<br>
//     <strong>Total:</strong> £{{total}}
//   </div>
// </div>
// </body>
// </html>
// """;

//   // Replace placeholders with controller values
//   String filledHtml = htmlTemplate
//       .replaceAll("{{customerName}}", controller.nameController.text)
//       .replaceAll("{{customerEmail}}", controller.emailController.text)
//       .replaceAll("{{customerContact}}", controller.contactController.text)
//       .replaceAll("{{eventType}}", controller.selectedEventType.value)
//       .replaceAll(
//         "{{eventDate}}",
//         "${controller.selectedDate.value.day}/${controller.selectedDate.value.month}/${controller.selectedDate.value.year}",
//       )
//       .replaceAll(
//         "{{eventTime}}",
//         controller.getTimeRange(Get.context ?? Get.overlayContext!),
//       )
//       .replaceAll("{{guests}}", controller.guests.value.toString())
//       .replaceAll("{{package}}", controller.selectedPackage.value)
//       .replaceAll("{{total}}", controller.calculateTotal().toStringAsFixed(2));

//   Get.dialog(
//     BookingReceiptPopup(htmlContent: filledHtml),
//     barrierDismissible: false,
//   );
// }
