import 'package:contact_list_app/model/contact_model.dart';
import 'package:contact_list_app/repository/contact_back4app_repository.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  final ContactModel contact;

  const ContactPage({Key? key, required this.contact}) : super(key: key);

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  ContactBack4AppRepository contactBack4AppRepository =
      ContactBack4AppRepository();

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.contact.name;
    phoneController.text = widget.contact.phone;
    emailController.text = widget.contact.email ?? '';
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name*'),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone*'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen[300],
                fixedSize: const Size(200, 40),
              ),
              onPressed: () async {
                final name = nameController.text;
                final phone = phoneController.text;
                final email = emailController.text;

                if (name.isNotEmpty && phone.isNotEmpty) {
                  ContactModel updatedContact = ContactModel(
                    objectId: widget.contact.objectId,
                    name: name,
                    phone: phone,
                    email: email,
                    profilePicturePath: widget.contact.profilePicturePath,
                    createdAt: widget.contact.createdAt,
                    updatedAt: DateTime.now().toString(),
                  );
                  await contactBack4AppRepository.updateContact(updatedContact);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Name and phone are required fields'),
                    ),
                  );
                }
              },
              child: const Text('Save'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[300],
                fixedSize: const Size(200, 40),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Delete Contact'),
                      content:
                          const Text('Are you sure you want to delete this contact?'),
                      actions: [
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('Delete'),
                          onPressed: () async {
                            await contactBack4AppRepository
                                .deleteContact(widget.contact.objectId);

                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Delete user'),
            )
          ],
        ),
      ),
    );
  }
}
