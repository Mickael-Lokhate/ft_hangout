import 'package:ft_hangout/database.dart';
import 'package:sqflite/sqflite.dart';

import 'models/config.dart';
import 'models/contact.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/home.dart';

void main() async {
  // _initDB();
  runApp(const MyApp());
}

void _initDB() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // final db = await openDatabase(
  //   path.join(await getDatabasesPath(), 'contacts.db'),
  //   onCreate: (db, version) {
  //     return db.execute(
  //       'CREATE TABLE contacts(id INTEGER PRIMARY KEY, name TEXT, phonenumber TEXT, lastname TEXT, email TEXT, imageUrl TEXT, moreInfos TEXT)'
  //     );
  //   },
  //   version: 1
  //   );
  // database = db;
  // contactList.initContacts();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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