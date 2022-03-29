import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:ft_hangout/database.dart';
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

  UnmodifiableListView<Contact> get contacts => UnmodifiableListView(_contacts);

  late List<Contact> allContacts;

  void getContacts() async {
      _contacts = await DBProvider.db.getContacts();
  }

  // void initContacts() async {
  //   print('CONTACT INIT');
  //   final db = await database;
  //   _contacts = await getContacts();
  //   print('INIT FINISH : $_contacts');
  //   notifyListeners();
  // }

  // void add(Contact contact) async {
  //   // _contacts.add(contact);
  //   insertContact(contact);
  //   _contacts = await getContacts();
  //   notifyListeners();
  // }

  // void update(int id, String? name, String? lastName, String? phoneNumber, String? email, String? imageUrl, String? moreInfos) async {
  //   // Contact findContact = _contacts.firstWhere((contact) => contact.id == id);
  //   Contact findContact = await getContact(id);
  //   if (name != null && name.isNotEmpty) {
  //     findContact.name = name;
  //   }
  //   if (phoneNumber != null && phoneNumber.isNotEmpty) {
  //     findContact.phonenumber = phoneNumber;
  //   }
  //   findContact.lastname = lastName;
  //   findContact.email = email;
  //   findContact.imageUrl = imageUrl;
  //   findContact.moreInfos = moreInfos;
  //   updateContact(findContact);
  //   _contacts = await getContacts();
  //   notifyListeners();
  // }

  // void remove(Contact contact) async {
  //   // _contacts.remove(contact);
  //   deleteContact(contact.id);
  //   _contacts = await getContacts();
  //   notifyListeners();
  // }

  // void removeAll() {
  //   _contacts.clear();
  //   notifyListeners();
  // }
}

// ContactListModel contactList = ContactListModel();

class ContactsBloc {
  ContactsBloc() {
    getContacts();
  }

  final _contactController = StreamController<List<Contact>>();

  Stream<List<Contact>> get contacts => _contactController.stream;

  getContacts() async {
    print('HEREEE');
    if (!_contactController.isClosed) {
      _contactController.sink.add(await DBProvider.db.getContacts());
    }
  }

  Future<void> add(Contact contact) async {
    print('ADDING CONTACT');
    await DBProvider.db.insertContact(contact);
    await getContacts();
    print('CONTACT ADDED');
  }

  Future<void> update(Contact contact) async {
    await DBProvider.db.updateContact(contact);
    await getContacts();
  }

  Future<void> remove(int id) async {
    await DBProvider.db.deleteContact(id);
    await getContacts();
  }

  Future<void> removeAll() async {
    await DBProvider.db.deleteAllContact();
    await getContacts();
  }

  dispose() {
    // _contactController.close();
  }
}