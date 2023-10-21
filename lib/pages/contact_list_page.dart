import 'package:contact_list_app/model/contact_list_model.dart';
import 'package:contact_list_app/pages/contact_page.dart';
import 'package:contact_list_app/pages/create_contact_page.dart';
import 'package:contact_list_app/repository/contact_back4app_repository.dart';
import 'package:flutter/material.dart';

class ContactListPage extends StatefulWidget {
  const ContactListPage({Key? key}) : super(key: key);

  @override
  State<ContactListPage> createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  ContactBack4AppRepository contactBack4AppRepository =
      ContactBack4AppRepository();
  ContactListModel _contactList = ContactListModel([]);
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _getContactList();
  }

  void _getContactList() async {
    setState(() {
      isLoading = true;
    });
    ContactListModel contactList =
        await contactBack4AppRepository.getContactsFromBack4App();
    setState(() {
      _contactList = contactList;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact list'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CreateContactPage()));
          setState(() {});
          _getContactList();
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: _contactList.contacts.length,
                itemBuilder: (context, index) {
                  _contactList.contacts
                      .sort((a, b) => a.name.compareTo(b.name));
                  String contactName = _contactList.contacts[index].name;
                  String contactPhoneNumber =
                      _contactList.contacts[index].phone ?? '';
                  String contactEmail =
                      _contactList.contacts[index].email ?? '';
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(contactName[0]),
                      ),
                      title: Text(contactName),
                      subtitle: Text('$contactPhoneNumber\n$contactEmail'),
                      trailing: IconButton(
                        onPressed: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ContactPage(
                                        contact: _contactList.contacts[index],
                                      )));
                          setState(() {});
                          _getContactList();
                        },
                        icon: const Icon(Icons.edit),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
