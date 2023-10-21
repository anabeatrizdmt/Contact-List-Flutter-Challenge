import 'package:flutter/material.dart';
import 'package:contact_list_app/my_app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}