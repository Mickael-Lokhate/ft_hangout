import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:ft_hangout/database.dart';
import 'package:ft_hangout/screens/home.dart';
import 'package:path/path.dart';
import 'package:sqflite/sql.dart';

import 'config.dart';

class Contact {
  int       id;
  String    name; 
  String    phonenumber;
  String?   lastname;
  String?   email;
  String?   imageUrl;
  String?   moreInfos;

  Contact(this.id, this.name, this.phonenumber, [this.lastname, this.email, this.imageUrl, this.moreInfos]);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phonenumber': phonenumber,
      'lastname': lastname,
      'email': email,
      'imageUrl': imageUrl,
      'moreInfos': moreInfos
    };
  }
}

class ContactListModel with ChangeNotifier {
  List<Contact> _contacts = [];

  ContactListModel() {
    initContacts();
  }

  UnmodifiableListView<Contact> get contacts => UnmodifiableListView(_contacts);

  Future<List<Contact>> getContacts() async {
      _contacts = await DBProvider.db.getContacts();
      return _contacts;
  }

  void initContacts() async {
    print('CONTACT INIT');
    var contact = await getContacts();
    print('INIT FINISH : $contact');
    notifyListeners();
  }

  void add(Contact contact) async {
    // _contacts.add(contact);
    // insertContact(contact);
    await DBProvider.db.insertContact(contact);
    await getContacts();
    notifyListeners();
  }

  Future<void> update(Contact contact) async {
    await DBProvider.db.updateContact(contact);
    await getContacts();
    notifyListeners();
  }

   Future<void> remove(int id) async {
    await DBProvider.db.deleteContact(id);
    await getContacts();
    notifyListeners();
  }

  Future<void> removeAll() async {
    await DBProvider.db.deleteAllContact();
    await getContacts();
    notifyListeners();
  }
}

ContactListModel contactList = ContactListModel();