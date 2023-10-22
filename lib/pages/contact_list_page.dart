import 'dart:io';

import 'package:contact_list_app/model/contact_list_model.dart';
import 'package:contact_list_app/model/contact_model.dart';
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
  String searchQuery = '';

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

  List<ContactModel> _filteredContacts() {
    return _contactList.contacts
        .where((contact) =>
            contact.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
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
            : Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Search by Name',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    child: Scrollbar(
                      radius: const Radius.circular(10),
                      trackVisibility: true,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: ListView.builder(
                          itemCount: _filteredContacts().length,
                          itemBuilder: (context, index) {
                            _filteredContacts()
                                .sort((a, b) => a.name.compareTo(b.name));
                            String contactName =
                                _filteredContacts()[index].name;
                            String contactPhoneNumber =
                                _filteredContacts()[index].phone;
                            String contactEmail =
                                _filteredContacts()[index].email ?? '';
                            String contactProfilePicturePath =
                                _filteredContacts()[index].profilePicturePath ??
                                    '';
                            return Card(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  isThreeLine:
                                      contactEmail == '' ? false : true,
                                  onTap: () async {
                                    await openContactPage(
                                        context, _filteredContacts()[index]);
                                    searchQuery = '';
                                  },
                                  leading: CircleAvatar(
                                    child: ClipOval(
                                      child: SizedBox(
                                        width: 60,
                                        height: 60,
                                        child: contactProfilePicturePath
                                                    .length >
                                                10
                                            ? Image.file(
                                                File(contactProfilePicturePath),
                                                fit: BoxFit.cover,
                                              )
                                            : const Center(
                                                child: FaIcon(
                                                  FontAwesomeIcons.user,
                                                  size: 20,
                                                  color: Colors.white,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                  title: Text(contactName),
                                  subtitle: contactEmail == ''
                                      ? Text(contactPhoneNumber)
                                      : Text(
                                          '$contactPhoneNumber\n$contactEmail'),
                                  trailing: IconButton(
                                      onPressed: () async {
                                        await openContactPage(context,
                                            _filteredContacts()[index]);
                                        searchQuery = '';
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
                ],
              ),
      ),
    );
  }

  Future<void> openContactPage(
      BuildContext context, ContactModel contact) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ContactPage(
                  contact: contact,
                )));
    setState(() {});
    _getContactList();
  }
}
