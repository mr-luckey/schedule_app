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
