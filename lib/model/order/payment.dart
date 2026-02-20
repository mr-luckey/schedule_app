class Payment {
  int? orderId;
  double? amount;
  String? paymentType;
  String? paymentDate;

  Payment({this.orderId, this.amount, this.paymentType, this.paymentDate});

  Payment.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    amount = json['amount'] != null
        ? double.tryParse(json['amount'].toString())
        : null;
    paymentType = json['payment_type'];
    paymentDate = json['payment_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['amount'] = this.amount;
    data['payment_type'] = this.paymentType;
    data['payment_date'] = this.paymentDate;
    return data;
  }
}
