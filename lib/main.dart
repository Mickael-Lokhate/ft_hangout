import 'package:ft_hangout/database.dart';
import 'package:sqflite/sqflite.dart';

import 'models/config.dart';
import 'models/contact.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/home.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    contactList.initContacts();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ContactListModel())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ContactList(),
      )
    );
  }
}