import 'service.dart';

class OrderPackageItems {
  int? id;
  int? orderPackageId;
  int? menuItemId;
  String? price;
  String? noOfGust;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  Service? menuItem;

  OrderPackageItems({
    this.id,
    this.orderPackageId,
    this.menuItemId,
    this.price,
    this.noOfGust,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.menuItem,
  });

  OrderPackageItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderPackageId = json['order_package_id'];
    menuItemId = json['menu_item_id'];
    price = json['price']?.toString();
    noOfGust = json['no_of_gust']?.toString();
    isDeleted = json['is_deleted'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    menuItem = json['menu_item'] != null
        ? new Service.fromJson(json['menu_item'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_package_id'] = this.orderPackageId;
    data['menu_item_id'] = this.menuItemId;
    data['price'] = this.price;
    data['no_of_gust'] = this.noOfGust;
    data['is_deleted'] = this.isDeleted;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.menuItem != null) {
      data['menu_item'] = this.menuItem!.toJson();
    }
    return data;
  }
}
