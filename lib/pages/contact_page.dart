import 'dart:io';

import 'package:contact_list_app/model/contact_model.dart';
import 'package:contact_list_app/repository/contact_back4app_repository.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart';

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

  XFile? photo;
  String photoPath = '';

  @override
  void initState() {
    super.initState();
    nameController.text = widget.contact.name;
    phoneController.text = widget.contact.phone;
    emailController.text = widget.contact.email ?? '';
    photoPath = widget.contact.profilePicturePath;
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }


  _cropImage(XFile imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      await GallerySaver.saveImage(croppedFile.path);
      photo = XFile(croppedFile.path);
      setState(() {});
      photoPath = croppedFile.path;
    }
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
            SizedBox(
              width: 160,
              height: 160,
              child: CircleAvatar(
                radius: 80,
                child: ClipOval(
                  child: SizedBox(
                    width: 160,
                    height: 160,
                    child: photoPath.length > 10
                        ? Image.file(
                            File(photoPath),
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
            ),
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
                    photoPath = photo!.path;
                    _cropImage(photo!);
                  }
                },
                child: const Text('Take a photo')),
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

                if (name.isNotEmpty && phone.isNotEmpty) {
                  ContactModel updatedContact = ContactModel(
                    objectId: widget.contact.objectId,
                    name: name,
                    phone: phone,
                    email: email,
                    profilePicturePath: photoPath,
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
                      content: const Text(
                          'Are you sure you want to delete this contact?'),
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
