import 'package_title.dart';

class Package {
  int? id;
  String? title;
  String? price;
  dynamic description;
  int? reorder;
  bool? isCustom;
  String? createdAt;
  String? updatedAt;
  String? url;
  List<PackageTitle>? packageTitles;

  Package({
    this.id,
    this.title,
    this.price,
    this.description,
    this.reorder,
    this.isCustom,
    this.createdAt,
    this.updatedAt,
    this.url,
    this.packageTitles,
  });

  Package.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    price = json['price']?.toString();
    description = json['description'];
    reorder = json['reorder'];
    isCustom = json['is_custom'] == true || json['is_custom'] == 'true';
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    url = json['url'];
    if (json['package_titles'] != null) {
      packageTitles = <PackageTitle>[];
      json['package_titles'].forEach((v) {
        packageTitles!.add(new PackageTitle.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['price'] = this.price;
    data['description'] = this.description;
    data['reorder'] = this.reorder;
    data['is_custom'] = this.isCustom;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['url'] = this.url;
    if (this.packageTitles != null) {
      data['package_titles'] = this.packageTitles!
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}
