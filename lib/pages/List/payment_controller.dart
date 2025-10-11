import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schedule_app/pages/List/order_model%20(1).dart';

class PaymentController extends GetxController {
  // Text editing controllers
  final TextEditingController amountController = TextEditingController();

  // Observable payment type
  final RxString paymentType = ''.obs;

  // Observable list of payments (if you want to track multiple payments)
  final RxList<Payment> payments = <Payment>[].obs;

  @override
  void onClose() {
    amountController.dispose();
    super.onClose();
  }

  void addPayment(int orderId) {
    // Validate input
    if (amountController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter payment amount',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (paymentType.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select payment type',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    double? amount = double.tryParse(amountController.text);
    if (amount == null || amount <= 0) {
      Get.snackbar(
        'Error',
        'Please enter a valid amount',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Create payment object
    // Payment payment=Payment(amount:amount);
    Payment payment = Payment(
      orderId: orderId,
      amount: amount,
      paymentType: paymentType.value,
      paymentDate: DateTime.now().toIso8601String(),
    );

    // Add to list
    payments.add(payment);

    // Here you would typically make an API call to save the payment
    // Example: await ApiService.savePayment(payment);

    // Clear form
    amountController.clear();
    paymentType.value = '';

    // Show success message
    Get.snackbar(
      'Success',
      'Payment recorded successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF10B981),
      colorText: Colors.white,
    );
  }

  double getTotalPaidForOrder(int orderId) {
    return payments
        .where((payment) => payment.orderId == orderId)
        .fold(0.0, (sum, payment) => sum + (payment.amount ?? 0));
  }

  List<Payment> getPaymentsForOrder(int orderId) {
    return payments.where((payment) => payment.orderId == orderId).toList();
  }

  void clearForm() {
    amountController.clear();
    paymentType.value = '';
  }
}