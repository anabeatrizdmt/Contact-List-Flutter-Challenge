import 'package:contact_list_app/pages/contact_list_page.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: const ContactListPage(),
        theme: ThemeData(
          primarySwatch: Colors.cyan,
        ));
  }
}
