import 'package:contact_list_app/model/contact_model.dart';
import 'package:contact_list_app/repository/contact_back4app_repository.dart';
import 'package:flutter/material.dart';

class CreateContactPage extends StatefulWidget {
  const CreateContactPage({Key? key}) : super(key: key);

  @override
  State<CreateContactPage> createState() => _CreateContactPageState();
}

class _CreateContactPageState extends State<CreateContactPage> {
  ContactBack4AppRepository contactBack4AppRepository =
      ContactBack4AppRepository();

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

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
        title: const Text('New contact'),
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
                  ContactModel contactToSave = ContactModel(
                      objectId: '0',
                      name: name,
                      phone: phone,
                      email: email,
                      profilePicturePath: '/todo',
                      createdAt: DateTime.now().toString(),
                      updatedAt: DateTime.now().toString());

                  await contactBack4AppRepository.addContact(contactToSave);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Contact created successfully')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Name and phone are required fields')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
