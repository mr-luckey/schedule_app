class Discount {
  int? id;
  String? title;
  String? val;
  bool? isPercent;
  String? createdAt;
  String? updatedAt;
  String? url;

  Discount({
    this.id,
    this.title,
    this.val,
    this.isPercent,
    this.createdAt,
    this.updatedAt,
    this.url,
  });

  Discount.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    val = json['val'];
    isPercent = json['is_percent'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['val'] = val;
    data['is_percent'] = isPercent;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['url'] = url;
    return data;
  }
}