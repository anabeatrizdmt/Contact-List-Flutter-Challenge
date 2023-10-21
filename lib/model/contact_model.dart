class ContactModel {
  String objectId = '';
  String name = '';
  String phone = '';
  String? email;
  String profilePicturePath = '';
  String createdAt = '';
  String updatedAt = '';

  ContactModel(
      {required this.objectId,
      required this.name,
      required this.phone,
      this.email,
      required this.profilePicturePath,
      required this.createdAt,
      required this.updatedAt});

  ContactModel.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    profilePicturePath = json['profile_picture_path'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['objectId'] = objectId;
    data['name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    data['profile_picture_path'] = profilePicturePath;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }

  Map<String, dynamic> toCreateJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    data['profile_picture_path'] = profilePicturePath;
    return data;
  }
}
