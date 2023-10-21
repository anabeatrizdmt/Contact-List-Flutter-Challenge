import 'package:contact_list_app/back4app/back4app_custom_dio.dart';
import 'package:contact_list_app/model/contact_list_model.dart';
import 'package:contact_list_app/model/contact_model.dart';

class ContactBack4AppRepository {
  final _customDio = Back4AppCustomDio();

  ContactBack4AppRepository();

  Future<ContactListModel> getContactsFromBack4App() async {
    var response = await _customDio.dio.get('/Contact');
    return ContactListModel.fromJson(response.data);
  }


  Future<void> addContact(ContactModel contact) async {
    await _customDio.dio.post('/Contact', data: contact.toCreateJson());
  }

  Future<void> deleteContact(String objectId) async {
    await _customDio.dio.delete('/Contact/$objectId');
  }

  Future<void> updateContact(ContactModel contact) async {
    await _customDio.dio
        .put('/Contact/${contact.objectId}', data: contact.toCreateJson());
  }
}
