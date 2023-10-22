import 'package:contact_list_app/model/contact_list_model.dart';
import 'package:contact_list_app/pages/contact_page.dart';
import 'package:contact_list_app/pages/create_contact_page.dart';
import 'package:contact_list_app/repository/contact_back4app_repository.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
        title: const Text('My Contacts'),
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
        child: const FaIcon(
          FontAwesomeIcons.userPlus,
          size: 20,
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Scrollbar(
                radius: const Radius.circular(10),
                trackVisibility: true,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ListView.builder(
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            isThreeLine: contactEmail == '' ? false : true,
                            onTap: () async {
                              await openContactPage(context, index);
                            },
                            leading: CircleAvatar(
                              child: Text(contactName[0]),
                            ),
                            title: Text(contactName),
                            subtitle: contactEmail == ''
                                ? Text(contactPhoneNumber)
                                : Text('$contactPhoneNumber\n$contactEmail'),
                            trailing: IconButton(
                                onPressed: () async {
                                  await openContactPage(context, index);
                                },
                                icon: const FaIcon(
                                  FontAwesomeIcons.userPen,
                                  size: 18,
                                  color: Colors.grey,
                                )),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
      ),
    );
  }

  Future<void> openContactPage(BuildContext context, int index) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ContactPage(
                  contact: _contactList.contacts[index],
                )));
    setState(() {});
    _getContactList();
  }
}
