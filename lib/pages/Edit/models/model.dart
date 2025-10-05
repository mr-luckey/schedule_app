class EditOrderModel {
  int? id;
  String? firstname;
  String? lastname;
  String? email;
  String? phone;
  String? nin;
  int? cityId;
  String? address;
  int? eventId;
  String? noOfGust;
  String? eventDate;
  String? eventTime;
  String? startTime;
  String? endTime;
  String? requirement;
  bool? isInquiry;
  int? paymentMethodId;
  City? city;
  Event? event;
  Event? paymentMethod;
  List<OrderServices>? orderServices;
  List<OrderPackages>? orderPackages;
  String? url;
  String? createdAt;
  String? updatedAt;

  EditOrderModel({
    this.id,
    this.firstname,
    this.lastname,
    this.email,
    this.phone,
    this.nin,
    this.cityId,
    this.address,
    this.eventId,
    this.noOfGust,
    this.eventDate,
    this.eventTime,
    this.startTime,
    this.endTime,
    this.requirement,
    this.isInquiry,
    this.paymentMethodId,
    this.city,
    this.event,
    this.paymentMethod,
    this.orderServices,
    this.orderPackages,
    this.url,
    this.createdAt,
    this.updatedAt,
  });

  EditOrderModel.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    phone = json['phone'];
    nin = json['nin'];
    cityId = json['city_id'];
    address = json['address'];
    eventId = json['event_id'];
    noOfGust = json['no_of_gust'];
    eventDate = json['event_date'];
    eventTime = json['event_time'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    requirement = json['requirement'];
    isInquiry = json['is_inquiry'];
    paymentMethodId = json['payment_method_id'];
    city = json['city'] != null ? new City.fromJson(json['city']) : null;
    event = json['event'] != null ? new Event.fromJson(json['event']) : null;
    paymentMethod = json['payment_method'] != null
        ? new Event.fromJson(json['payment_method'])
        : null;
    if (json['order_services'] != null) {
      orderServices = <OrderServices>[];
      json['order_services'].forEach((v) {
        orderServices!.add(new OrderServices.fromJson(v));
      });
    }
    if (json['order_packages'] != null) {
      orderPackages = <OrderPackages>[];
      json['order_packages'].forEach((v) {
        orderPackages!.add(new OrderPackages.fromJson(v));
      });
    }
    url = json['url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['nin'] = this.nin;
    data['city_id'] = this.cityId;
    data['address'] = this.address;
    data['event_id'] = this.eventId;
    data['no_of_gust'] = this.noOfGust;
    data['event_date'] = this.eventDate;
    data['event_time'] = this.eventTime;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['requirement'] = this.requirement;
    data['is_inquiry'] = this.isInquiry;
    data['payment_method_id'] = this.paymentMethodId;
    if (this.city != null) {
      data['city'] = this.city!.toJson();
    }
    if (this.event != null) {
      data['event'] = this.event!.toJson();
    }
    if (this.paymentMethod != null) {
      data['payment_method'] = this.paymentMethod!.toJson();
    }
    if (this.orderServices != null) {
      data['order_services'] = this.orderServices!
          .map((v) => v.toJson())
          .toList();
    }
    if (this.orderPackages != null) {
      data['order_packages'] = this.orderPackages!
          .map((v) => v.toJson())
          .toList();
    }
    data['url'] = this.url;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class City {
  int? id;
  String? name;
  String? description;
  bool? isActive;
  String? createdAt;
  String? updatedAt;

  City({
    this.id,
    this.name,
    this.description,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['is_active'] = this.isActive;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Event {
  int? id;
  String? title;
  String? description;
  bool? isActive;
  String? createdAt;
  String? updatedAt;

  Event({
    this.id,
    this.title,
    this.description,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  Event.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['is_active'] = this.isActive;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

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

class Service {
  final int id;
  final String title;
  final int? vatId;
  final int? discountId;
  final String? description;
  final int reorder;
  final List<MenuItem> menuItems;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String url;

  Service({
    required this.id,
    required this.title,
    this.vatId,
    this.discountId,
    this.description,
    required this.reorder,
    required this.menuItems,
    required this.createdAt,
    required this.updatedAt,
    required this.url,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] as int,
      title: json['title'] as String,
      vatId: json['vat_id'] as int?,
      discountId: json['discount_id'] as int?,
      description: json['description'] as String?,
      reorder: json['reorder'] as int,
      menuItems: (json['menu_items'] as List)
          .map((item) => MenuItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      url: json['url'] as String,
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
      'menu_items': menuItems.map((item) => item.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'url': url,
    };
  }
}

class MenuItem {
  final int id;
  final int menuId;
  final String title;
  final double price;
  final int? vatId;
  final int? discountId;
  final String? description;
  final int? reorder;
  final DateTime createdAt;
  final DateTime updatedAt;

  MenuItem({
    required this.id,
    required this.menuId,
    required this.title,
    required this.price,
    this.vatId,
    this.discountId,
    this.description,
    this.reorder,
    required this.createdAt,
    required this.updatedAt,
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
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
// class Service {
//   int? id;
//   String? title;
//   String? price;
//   var description;
//   String? createdAt;
//   String? updatedAt;

//   Service({
//     this.id,
//     this.title,
//     this.price,
//     this.description,
//     this.createdAt,
//     this.updatedAt,
//   });

//   Service.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     title = json['title'];
//     price = json['price'];
//     description = json['description'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['title'] = this.title;
//     data['price'] = this.price;
//     data['description'] = this.description;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     return data;
//   }
// }

class OrderPackages {
  int? id;
  int? orderId;
  int? packageId;
  String? amount;
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

class Package {
  int? id;
  String? title;
  String? price;
  Null? description;
  int? reorder;
  String? createdAt;
  String? updatedAt;
  String? url;

  Package({
    this.id,
    this.title,
    this.price,
    this.description,
    this.reorder,
    this.createdAt,
    this.updatedAt,
    this.url,
  });

  Package.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    price = json['price'];
    description = json['description'];
    reorder = json['reorder'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['price'] = this.price;
    data['description'] = this.description;
    data['reorder'] = this.reorder;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['url'] = this.url;
    return data;
  }
}

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
    price = json['price'];
    noOfGust = json['no_of_gust'];
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
