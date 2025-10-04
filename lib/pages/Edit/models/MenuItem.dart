// Add these models to your model.dart file or create a new menu_model.dart file

class MenuCategory {
  final int? id;
  final String? title;
  final List<MenuItem>? menuItems;
  final String? createdAt;
  final String? updatedAt;
  final String? url;

  MenuCategory({
    this.id,
    this.title,
    this.menuItems,
    this.createdAt,
    this.updatedAt,
    this.url,
  });

  factory MenuCategory.fromJson(Map<String, dynamic> json) {
    return MenuCategory(
      id: json['id'],
      title: json['title'],
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
  final String? description;
  final String? createdAt;
  final String? updatedAt;

  MenuItem({
    this.id,
    this.menuId,
    this.title,
    this.price,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      menuId: json['menu_id'],
      title: json['title'],
      price: json['price'],
      description: json['description'],
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
      'description': description,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
