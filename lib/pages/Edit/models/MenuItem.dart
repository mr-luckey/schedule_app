// Add these models to your model.dart file or create a new menu_model.dart file

class MenuCategory {
  final int? id;
  final String? title;
  final int? vatId;
  final int? discountId;
  final String? description;
  final int? reorder;
  final bool? isPremium;
  final List<MenuItem>? menuItems;
  final String? createdAt;
  final String? updatedAt;
  final String? url;

  MenuCategory({
    this.id,
    this.title,
    this.vatId,
    this.discountId,
    this.description,
    this.reorder,
    this.isPremium,
    this.menuItems,
    this.createdAt,
    this.updatedAt,
    this.url,
  });

  factory MenuCategory.fromJson(Map<String, dynamic> json) {
    return MenuCategory(
      id: json['id'],
      title: json['title'],
      vatId: json['vat_id'],
      discountId: json['discount_id'],
      description: json['description'],
      reorder: json['reorder'],
      isPremium: json['is_premium'],
      menuItems: json['menu_items'] != null
          ? (json['menu_items'] as List)
                .map((item) => MenuItem.fromJson(item))
                .toList()
          : null,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'vat_id': vatId,
      'discount_id': discountId,
      'description': description,
      'reorder': reorder,
      'is_premium': isPremium,
      'menu_items': menuItems?.map((item) => item.toJson()).toList(),
      'created_at': createdAt,
      'updated_at': updatedAt,
      'url': url,
    };
  }
}

class MenuItem {
  final int? id;
  final int? menuId;
  final String? title;
  final String? price;
  final int? vatId;
  final int? discountId;
  final String? description;
  final int? reorder;
  final String? createdAt;
  final String? updatedAt;

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
      id: json['id'],
      menuId: json['menu_id'],
      title: json['title'],
      price: json['price'],
      vatId: json['vat_id'],
      discountId: json['discount_id'],
      description: json['description'],
      reorder: json['reorder'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'menu_id': menuId,
      'title': title,
      'price': price,
      'vat_id': vatId,
      'discount_id': discountId,
      'description': description,
      'reorder': reorder,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
