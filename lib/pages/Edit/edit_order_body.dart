class EditOrderBody {
  Order? order;

  EditOrderBody({this.order});

  EditOrderBody.fromJson(Map<String, dynamic> json) {
    order = json['order'] != null ? Order.fromJson(json['order']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (order != null) {
      data['order'] = order!.toJson();
    }
    return data;
  }
}

class Order {
  String? id;
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
  List<OrderServices>? orderServices;
  List<OrderPackages>? orderPackages;

  Order({
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
    this.orderServices,
    this.orderPackages,
  });

  Order.fromJson(Map<String, dynamic> json) {
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
    if (json['order_services'] != null) {
      orderServices = <OrderServices>[];
      json['order_services'].forEach((v) {
        orderServices!.add(OrderServices.fromJson(v));
      });
    }
    if (json['order_packages'] != null) {
      orderPackages = <OrderPackages>[];
      json['order_packages'].forEach((v) {
        orderPackages!.add(OrderPackages.fromJson(v));
      });
    }
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
    // Use *_attributes so backend updates nested records
    if (orderServices != null) {
      data['order_services_attributes'] = orderServices!
          .map((v) => v.toJson())
          .toList();
    }
    if (orderPackages != null) {
      data['order_packages_attributes'] = orderPackages!
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}

class OrderServices {
  String? id;
  String? orderId;
  String? menuItemId;
  int? price;
  bool? isDeleted;

  OrderServices({
    this.id,
    this.orderId,
    this.menuItemId,
    this.price,
    this.isDeleted,
  });

  OrderServices.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    orderId = json['order_id'].toString();
    menuItemId = json['menu_item_id'].toString();
    price = json['price'];
    isDeleted = json['is_deleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id.toString();
    data['order_id'] = orderId.toString();
    data['menu_item_id'] = menuItemId.toString();
    data['price'] = price;
    data['is_deleted'] = isDeleted;
    return data;
  }
}

class OrderPackages {
  String? id;
  String? orderId;
  String? packageId;
  String? amount;
  bool? isCustom;
  List<OrderPackageItems>? orderPackageItems;

  OrderPackages({
    this.id,
    this.orderId,
    this.packageId,
    this.amount,
    this.isCustom,
    this.orderPackageItems,
  });

  OrderPackages.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    orderId = json['order_id'].toString();
    packageId = json['package_id'].toString();
    amount = json['amount'];
    isCustom = json['is_custom'];
    if (json['order_package_items'] != null) {
      orderPackageItems = <OrderPackageItems>[];
      json['order_package_items'].forEach((v) {
        orderPackageItems!.add(OrderPackageItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id.toString();
    data['order_id'] = orderId.toString();
    data['package_id'] = packageId.toString();
    data['amount'] = amount;
    data['is_custom'] = isCustom;
    if (orderPackageItems != null) {
      // Use *_attributes so backend updates nested records
      data['order_package_items_attributes'] = orderPackageItems!
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}

class OrderPackageItems {
  String? id;
  String? orderPackageId;
  String? menuItemId;
  String? price;
  String? noOfGust;
  bool? isDeleted;

  OrderPackageItems({
    this.id,
    this.orderPackageId,
    this.menuItemId,
    this.price,
    this.noOfGust,
    this.isDeleted,
  });

  OrderPackageItems.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    orderPackageId = json['order_package_id'].toString();
    menuItemId = json['menu_item_id'].toString();
    price = json['price'];
    noOfGust = json['no_of_gust'];
    isDeleted = json['is_deleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id.toString();
    data['order_package_id'] = orderPackageId.toString();
    data['menu_item_id'] = menuItemId.toString();
    data['price'] = price;
    data['no_of_gust'] = noOfGust;
    data['is_deleted'] = isDeleted;
    return data;
  }
}
