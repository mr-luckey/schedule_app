import 'package.dart';
import 'order_package_items.dart';

class OrderPackages {
  int? id;
  int? orderId;
  int? packageId;
  dynamic amount;
  bool? isCustom;
  String? createdAt;
  String? updatedAt;
  Package? package;
  List<OrderPackageItems>? orderPackageItems;

  OrderPackages({
    this.id,
    this.orderId,
    this.packageId,
    this.amount,
    this.isCustom,
    this.createdAt,
    this.updatedAt,
    this.package,
    this.orderPackageItems,
  });

  OrderPackages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    packageId = json['package_id'];
    amount = json['amount'];
    isCustom = json['is_custom'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    package = json['package'] != null
        ? new Package.fromJson(json['package'])
        : null;
    if (json['order_package_items'] != null) {
      orderPackageItems = <OrderPackageItems>[];
      json['order_package_items'].forEach((v) {
        orderPackageItems!.add(new OrderPackageItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['package_id'] = this.packageId;
    data['amount'] = this.amount;
    data['is_custom'] = this.isCustom;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.package != null) {
      data['package'] = this.package!.toJson();
    }
    if (this.orderPackageItems != null) {
      data['order_package_items'] = this.orderPackageItems!
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}
