import 'dart:io';

import 'package:contact_list_app/model/contact_model.dart';
import 'package:contact_list_app/repository/contact_back4app_repository.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path/path.dart';

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

  XFile? photo;
  String photoPath = '';

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
            TextButton(
                onPressed: () async {
                  final ImagePicker picker = ImagePicker();
                  photo = await picker.pickImage(source: ImageSource.camera);
                  if (photo != null) {
                    String path =
                        (await path_provider.getApplicationDocumentsDirectory())
                            .path;
                    String name = basename(photo!.path);
                    await photo!.saveTo("$path/$name");
                    print(photo!.path);
                    photoPath = photo!.path;

                    await GallerySaver.saveImage(photo!.path);
                    setState(() {});
                  }
                },
                child: const Text('Take a photo')),

            photo != null
                ? SizedBox(height: 100, child: Image.file(File(photo!.path)))
                : const SizedBox.shrink(),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name*'),
              keyboardType: TextInputType.name,
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone*'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
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
                if (name.isNotEmpty && phone.isNotEmpty && photoPath.isNotEmpty) {
                  ContactModel contactToSave = ContactModel(
                      objectId: '0',
                      name: name,
                      phone: phone,
                      email: email,
                      profilePicturePath: photoPath,
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
                        content: Text('Name, phone and photo are required')),
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
