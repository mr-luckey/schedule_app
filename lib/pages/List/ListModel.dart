// get_orders_model.dart
class GetOrdersModel {
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
  dynamic foodBeverageAmount;
  dynamic serviceAmount;
  dynamic discountAmount;
  dynamic discountId;
  dynamic totalAmount;
  dynamic discount;
  List<OrderServices>? orderServices;
  List<OrderPackages>? orderPackages;
  String? url;
  String? createdAt;
  String? updatedAt;

  GetOrdersModel({
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
    this.foodBeverageAmount,
    this.serviceAmount,
    this.discountAmount,
    this.discountId,
    this.totalAmount,
    this.discount,
    this.orderServices,
    this.orderPackages,
    this.url,
    this.createdAt,
    this.updatedAt,
  });

  factory GetOrdersModel.fromJson(Map<String, dynamic> json) {
    return GetOrdersModel(
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
      event: json['event'] != null ? Event.fromJson(json['event']) : null,
      paymentMethod: json['payment_method'] != null
          ? Event.fromJson(json['payment_method'])
          : null,
      foodBeverageAmount: json['food_beverage_amount'],
      serviceAmount: json['service_amount'],
      discountAmount: json['discount_amount'],
      discountId: json['discount_id'],
      totalAmount: json['total_amount'],
      discount: json['discount'],
      orderServices: json['order_services'] != null
          ? (json['order_services'] as List)
                .map((v) => OrderServices.fromJson(v))
                .toList()
          : null,
      orderPackages: json['order_packages'] != null
          ? (json['order_packages'] as List)
                .map((v) => OrderPackages.fromJson(v))
                .toList()
          : null,
      url: json['url'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['email'] = email;
    data['phone'] = phone;
    data['nin'] = nin;
    data['city_id'] = cityId;
    data['address'] = address;
    data['event_id'] = eventId;
    data['no_of_gust'] = noOfGust;
    data['event_date'] = eventDate;
    data['event_time'] = eventTime;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['requirement'] = requirement;
    data['is_inquiry'] = isInquiry;
    data['payment_method_id'] = paymentMethodId;
    if (city != null) {
      data['city'] = city!.toJson();
    }
    if (event != null) {
      data['event'] = event!.toJson();
    }
    if (paymentMethod != null) {
      data['payment_method'] = paymentMethod!.toJson();
    }
    data['food_beverage_amount'] = foodBeverageAmount;
    data['service_amount'] = serviceAmount;
    data['discount_amount'] = discountAmount;
    data['discount_id'] = discountId;
    data['total_amount'] = totalAmount;
    data['discount'] = discount;
    if (orderServices != null) {
      data['order_services'] = orderServices!.map((v) => v.toJson()).toList();
    }
    if (orderPackages != null) {
      data['order_packages'] = orderPackages!.map((v) => v.toJson()).toList();
    }
    data['url'] = url;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
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
        ? Service.fromJson(json['service'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['menu_item_id'] = menuItemId;
    data['price'] = price;
    data['is_deleted'] = isDeleted;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (service != null) {
      data['service'] = service!.toJson();
    }
    return data;
  }
}

class Service {
  int? id;
  String? title;
  String? price;
  dynamic description;
  String? createdAt;
  String? updatedAt;

  Service({
    this.id,
    this.title,
    this.price,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  Service.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    price = json['price'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['price'] = price;
    data['description'] = description;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

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
        ? Package.fromJson(json['package'])
        : null;
    if (json['order_package_items'] != null) {
      orderPackageItems = <OrderPackageItems>[];
      json['order_package_items'].forEach((v) {
        orderPackageItems!.add(OrderPackageItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['package_id'] = packageId;
    data['amount'] = amount;
    data['is_custom'] = isCustom;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (package != null) {
      data['package'] = package!.toJson();
    }
    if (orderPackageItems != null) {
      data['order_package_items'] = orderPackageItems!
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
  dynamic description;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['price'] = price;
    data['description'] = description;
    data['reorder'] = reorder;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['url'] = url;
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
        ? Service.fromJson(json['menu_item'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_package_id'] = orderPackageId;
    data['menu_item_id'] = menuItemId;
    data['price'] = price;
    data['no_of_gust'] = noOfGust;
    data['is_deleted'] = isDeleted;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (menuItem != null) {
      data['menu_item'] = menuItem!.toJson();
    }
    return data;
  }
}
