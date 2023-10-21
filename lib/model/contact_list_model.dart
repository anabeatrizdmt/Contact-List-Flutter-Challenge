import 'package:contact_list_app/model/contact_model.dart';

class ContactListModel {
  List<ContactModel> contacts = [];

  ContactListModel(this.contacts);

  ContactListModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      contacts = [];
      json['results'].forEach((v) {
        contacts.add(ContactModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['results'] = contacts.map((v) => v.toJson()).toList();
    return data;
  }
}
