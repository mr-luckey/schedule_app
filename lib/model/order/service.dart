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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['price'] = this.price;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
