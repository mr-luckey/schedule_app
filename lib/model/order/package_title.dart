import 'package_item.dart';

class PackageTitle {
  int? id;
  int? packageId;
  String? name;
  String? maxItem;
  String? createdAt;
  String? updatedAt;
  List<PackageItem>? packageItems;

  PackageTitle({
    this.id,
    this.packageId,
    this.name,
    this.maxItem,
    this.createdAt,
    this.updatedAt,
    this.packageItems,
  });

  PackageTitle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    packageId = json['package_id'];
    name = json['name'];
    maxItem = json['max_item']?.toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['package_items'] != null) {
      packageItems = <PackageItem>[];
      json['package_items'].forEach((v) {
        packageItems!.add(new PackageItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['package_id'] = this.packageId;
    data['name'] = this.name;
    data['max_item'] = this.maxItem;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.packageItems != null) {
      data['package_items'] = this.packageItems!
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}
