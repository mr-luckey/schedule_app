class ServiceMode {
  int? id;
  String? title;
  String? description;
  double? price;
  List<MenuItem>? menuItems;

  ServiceMode({
    this.id,
    this.title,
    this.description,
    this.price,
    this.menuItems,
  });

  factory ServiceMode.fromJson(Map<String, dynamic> json) {
    return ServiceMode(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'] != null
          ? double.tryParse(json['price'].toString())
          : null,
      menuItems: json['menu_items'] != null
          ? (json['menu_items'] as List)
                .map((i) => MenuItem.fromJson(i))
                .toList()
          : null,
    );
  }
}
// class ServiceMode {
//   final int? id;
//   final String? title;
//   final int? vatId;
//   final int? discountId;
//   final String? description;
//   final int? reorder;
//   final List<MenuItem>? menuItems;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//   final String? url;

//   ServiceMode({
//     this.id,
//     this.title,
//     this.vatId,
//     this.discountId,
//     this.description,
//     this.reorder,
//     this.menuItems,
//     this.createdAt,
//     this.updatedAt,
//     this.url,
//   });

//   factory ServiceMode.fromJson(Map<String, dynamic> json) {
//     return ServiceMode(
//       id: json['id'] as int,
//       title: json['title'] as String,
//       vatId: json['vat_id'] as int?,
//       discountId: json['discount_id'] as int?,
//       description: json['description'] as String?,
//       reorder: json['reorder'] as int,
//       menuItems: (json['menu_items'] as List)
//           .map((item) => MenuItem.fromJson(item as Map<String, dynamic>))
//           .toList(),
//       createdAt: DateTime.parse(json['created_at'] as String),
//       updatedAt: DateTime.parse(json['updated_at'] as String),
//       url: json['url'] as String,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'title': title,
//       'vat_id': vatId,
//       'discount_id': discountId,
//       'description': description,
//       'reorder': reorder,
//       'menu_items': menuItems!.map((item) => item.toJson()).toList(),
//       'created_at': createdAt,
//       'updated_at': updatedAt,
//       'url': url,
//     };
//   }
// }

class MenuItem {
  final int id;
  final int menuId;
  final String title;
  final double price;
  final int? vatId;
  final int? discountId;
  final String? description;
  final int? reorder;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MenuItem({
    required this.id,
    required this.menuId,
    required this.title,
    required this.price,
    this.vatId,
    this.discountId,
    this.description,
    this.reorder,
    this.createdAt,
    this.updatedAt,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] as int,
      menuId: json['menu_id'] as int,
      title: json['title'] as String,
      price: double.parse(json['price'] as String),
      vatId: json['vat_id'] as int?,
      discountId: json['discount_id'] as int?,
      description: json['description'] as String?,
      reorder: json['reorder'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'menu_id': menuId,
      'title': title,
      'price': price.toString(),
      'vat_id': vatId,
      'discount_id': discountId,
      'description': description,
      'reorder': reorder,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
