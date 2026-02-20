import 'service.dart';

class OrderServices {
  int? id;
  int? orderId;
  int? menuItemId;
  int? price;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  Service? service;

  OrderServices({
    this.id,
    this.orderId,
    this.menuItemId,
    this.price,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.service,
  });

  OrderServices.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    menuItemId = json['menu_item_id'];
    price = json['price'];
    isDeleted = json['is_deleted'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    service = json['service'] != null
        ? new Service.fromJson(json['service'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['menu_item_id'] = this.menuItemId;
    data['price'] = this.price;
    data['is_deleted'] = this.isDeleted;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.service != null) {
      data['service'] = this.service!.toJson();
    }
    return data;
  }
}
