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

class MenuItem {
  final int? id;
  final int? menuId;
  final String? title;
  final double? price;
  final int? vatId;
  final int? discountId;
  final String? description;
  final int? reorder;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MenuItem({
    this.id,
    this.menuId,
    this.title,
    this.price,
    this.vatId,
    this.discountId,
    this.description,
    this.reorder,
    this.createdAt,
    this.updatedAt,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] as int?,
      menuId: json['menu_id'] as int?,
      title: json['title'] as String?,
      price: json['price'] != null
          ? double.tryParse(json['price'].toString())
          : null,
      vatId: json['vat_id'] as int?,
      discountId: json['discount_id'] as int?,
      description: json['description'] as String?,
      reorder: json['reorder'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'menu_id': menuId,
      'title': title,
      'price': price?.toString(),
      'vat_id': vatId,
      'discount_id': discountId,
      'description': description,
      'reorder': reorder,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
