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
  EventType? event;
  PaymentMethod? paymentMethod;
  List<OrderService>? orderServices; // Change from List<dynamic>
  List<OrderPackage>? orderPackages;

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
    // this.orderServices,
    this.orderPackages,

    this.requirement,
    this.isInquiry,
    this.paymentMethodId,
    this.city,
    this.event,
    this.paymentMethod,
    this.orderServices,
    // this.orderPackages,
    this.url,
    this.createdAt,
    this.updatedAt,
  });

  factory EditOrderModel.fromJson(Map<dynamic, dynamic> json) {
    return EditOrderModel(
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      email: json['email'],
      phone: json['phone'],
      nin: json['nin'],
      cityId: json['city_id'],
      address: json['address'],
      eventId: json['event_id'],
      noOfGust: json['no_of_gust'],
      eventDate: json['event_date'],
      eventTime: json['event_time'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      requirement: json['requirement'],
      isInquiry: json['is_inquiry'],
      paymentMethodId: json['payment_method_id'],
      city: json['city'] != null ? City.fromJson(json['city']) : null,
      event: json['event'] != null ? EventType.fromJson(json['event']) : null,
      paymentMethod: json['payment_method'] != null
          ? PaymentMethod.fromJson(json['payment_method'])
          : null,
      orderServices: json['order_services'] != null
          ? List<OrderService>.from(
              json['order_services'].map((x) => OrderService.fromJson(x)),
            )
          : null,
      orderPackages: json['order_packages'] != null
          ? List<OrderPackage>.from(
              json['order_packages'].map((x) => OrderPackage.fromJson(x)),
            )
          : null,
      url: json['url'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'phone': phone,
      'nin': nin,
      'city_id': cityId,
      'address': address,
      'event_id': eventId,
      'no_of_gust': noOfGust,
      'event_date': eventDate,
      'event_time': eventTime,
      'start_time': startTime,
      'end_time': endTime,
      'requirement': requirement,
      'is_inquiry': isInquiry,
      'payment_method_id': paymentMethodId,
      'city': city?.toJson(),
      'event': event?.toJson(),
      'payment_method': paymentMethod?.toJson(),
      'order_services': orderServices?.map((x) => x.toJson()).toList(),
      'order_packages': orderPackages?.map((x) => x.toJson()).toList(),
      'url': url,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
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

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      isActive: json['is_active'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class EventType {
  int? id;
  String? title;
  String? description;
  bool? isActive;
  String? createdAt;
  String? updatedAt;

  EventType({
    this.id,
    this.title,
    this.description,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory EventType.fromJson(Map<String, dynamic> json) {
    return EventType(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isActive: json['is_active'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class PaymentMethod {
  int? id;
  String? title;
  String? description;
  bool? isActive;
  String? createdAt;
  String? updatedAt;

  PaymentMethod({
    this.id,
    this.title,
    this.description,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isActive: json['is_active'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class OrderPackage {
  int? id;
  int? orderId;
  int? packageId;
  String? amount;
  bool? isCustom;
  String? createdAt;
  String? updatedAt;
  Package? package;
  List<OrderPackageItem>? orderPackageItems;

  OrderPackage({
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

  factory OrderPackage.fromJson(Map<String, dynamic> json) {
    return OrderPackage(
      id: json['id'],
      orderId: json['order_id'],
      packageId: json['package_id'],
      amount: json['amount'],
      isCustom: json['is_custom'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      package: json['package'] != null
          ? Package.fromJson(json['package'])
          : null,
      orderPackageItems: json['order_package_items'] != null
          ? List<OrderPackageItem>.from(
              json['order_package_items'].map(
                (x) => OrderPackageItem.fromJson(x),
              ),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'package_id': packageId,
      'amount': amount,
      'is_custom': isCustom,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'package': package?.toJson(),
      'order_package_items': orderPackageItems?.map((x) => x.toJson()).toList(),
    };
  }
}

class Package {
  int? id;
  String? title;
  String? price;
  String? description;
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

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      id: json['id'],
      title: json['title'],
      price: json['price'],
      description: json['description'],
      reorder: json['reorder'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'reorder': reorder,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'url': url,
    };
  }
}

class OrderPackageItem {
  int? id;
  int? orderPackageId;
  int? menuItemId;
  String? price;
  String? noOfGust;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  MenuItem? menuItem;

  OrderPackageItem({
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

  factory OrderPackageItem.fromJson(Map<String, dynamic> json) {
    return OrderPackageItem(
      id: json['id'],
      orderPackageId: json['order_package_id'],
      menuItemId: json['menu_item_id'],
      price: json['price'],
      noOfGust: json['no_of_gust'],
      isDeleted: json['is_deleted'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      menuItem: json['menu_item'] != null
          ? MenuItem.fromJson(json['menu_item'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'order_package_id': orderPackageId,
      'menu_item_id': menuItemId,
      'price': price,
      'no_of_gust': noOfGust,
      'is_deleted': isDeleted,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'menu_item': menuItem?.toJson(),
    };
  }
}

class MenuItem {
  int? id;
  String? title;
  String? price;
  String? description;
  String? createdAt;
  String? updatedAt;

  MenuItem({
    this.id,
    this.title,
    this.price,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      title: json['title'],
      price: json['price'],
      description: json['description'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'title': title,
      'price': price,
      'description': description,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class OrderService {
  String? id;
  int? orderId;
  int? menuItemId;
  String? price;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  MenuItem? menuItem;

  OrderService({
    this.id,
    this.orderId,
    this.menuItemId,
    this.price,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.menuItem,
  });

  factory OrderService.fromJson(Map<String, dynamic> json) {
    return OrderService(
      id: json['id'],
      orderId: json['order_id'],
      menuItemId: json['menu_item_id'],
      price: json['price'],
      isDeleted: json['is_deleted'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      menuItem: json['menu_item'] != null
          ? MenuItem.fromJson(json['menu_item'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId.toString(),
      'menu_item_id': menuItemId,
      'price': price,
      'is_deleted': isDeleted,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'menu_item': menuItem?.toJson(),
    };
  }
}
