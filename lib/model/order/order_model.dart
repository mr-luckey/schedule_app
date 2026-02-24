import '../discount_model.dart';
import 'city.dart';
import 'event.dart';
import 'payment_method.dart';
import 'order_services.dart';
import 'order_packages.dart';

class OrderModel {
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
  PaymentMethod? paymentMethod;
  dynamic foodBeverageAmount;
  dynamic serviceAmount;
  dynamic discountAmount;
  int? discountId;
  dynamic totalAmount;
  Discount? discount;
  List<OrderServices>? orderServices;
  List<OrderPackages>? orderPackages;
  String? url;
  String? createdAt;
  String? updatedAt;

  OrderModel({
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

  OrderModel.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    phone = json['phone'];
    nin = json['nin'];
    cityId = json['city_id'];
    address = json['address'];
    eventId = json['event_id'];
    noOfGust = json['no_of_gust']?.toString() ?? json['no_of_gust'];
    eventDate = json['event_date'];
    eventTime = json['event_time'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    requirement = json['requirement'];
    isInquiry = json['is_inquiry'];
    paymentMethodId = json['payment_method_id'];
    city = json['city'] != null ? new City.fromJson(json['city']) : null;
    event = json['event'] != null ? new Event.fromJson(json['event']) : null;

    // Handle both old dynamic map or new map format if paymentMethod differs
    if (json['payment_method'] != null) {
      try {
        paymentMethod = PaymentMethod.fromJson(json['payment_method']);
      } catch (e) {
        // Optional fallback for backward compatibility
      }
    }

    foodBeverageAmount = json['food_beverage_amount'];
    serviceAmount = json['service_amount'];
    discountAmount = json['discount_amount'];
    discountId = json['discount_id'];
    totalAmount = json['total_amount'];

    discount = json['discount'] != null
        ? new Discount.fromJson(json['discount'])
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
    data['food_beverage_amount'] = this.foodBeverageAmount;
    data['service_amount'] = this.serviceAmount;
    data['discount_amount'] = this.discountAmount;
    data['discount_id'] = this.discountId;
    data['total_amount'] = this.totalAmount;
    if (this.discount != null) {
      data['discount'] = this.discount!.toJson();
    } else {
      data['discount'] = null;
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
