import 'package:ft_hangout/models/contact.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:ft_hangout/screens/home.dart';

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
        title: 'ft_hangout',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ContactList(),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('fr', ''),
        ],
      )
    );
  }
}