import 'service.dart';

class PackageItem {
  int? id;
  int? packageTitleId;
  int? menuItemId;
  dynamic description;
  int? reorder;
  String? createdAt;
  String? updatedAt;
  Service? menuItem;

  PackageItem({
    this.id,
    this.packageTitleId,
    this.menuItemId,
    this.description,
    this.reorder,
    this.createdAt,
    this.updatedAt,
    this.menuItem,
  });

  PackageItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    packageTitleId = json['package_title_id'];
    menuItemId = json['menu_item_id'];
    description = json['description'];
    reorder = json['reorder'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    menuItem = json['menu_item'] != null
        ? new Service.fromJson(json['menu_item'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['package_title_id'] = this.packageTitleId;
    data['menu_item_id'] = this.menuItemId;
    data['description'] = this.description;
    data['reorder'] = this.reorder;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.menuItem != null) {
      data['menu_item'] = this.menuItem!.toJson();
    }
    return data;
  }
}
