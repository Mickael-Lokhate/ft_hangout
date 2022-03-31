import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:ft_hangout/database.dart';

class Contact {
  int       id;
  String    name; 
  String    phonenumber;
  String?   lastname;
  String?   email;
  String?   imageUrl;
  String?   moreInfos;
  String?   entreprise;
  String?   address;

  Contact(this.id, this.name, this.phonenumber, [this.lastname, this.email, this.imageUrl, this.moreInfos, this.entreprise, this.address]);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phonenumber': phonenumber,
      'lastname': lastname,
      'email': email,
      'imageUrl': imageUrl,
      'moreInfos': moreInfos,
      'entreprise': entreprise,
      'address': address
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
    _contacts = await getContacts();
    notifyListeners();
  }

  void add(Contact contact) async {
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

  bool isPhoneExist(String phone, int currentId) {
    getContacts();
    Contact contact = _contacts.singleWhere((element) => element.phonenumber == phone, orElse: () => Contact(-1, '', ''));
    if (contact.id == -1 || contact.id == currentId) {
      return false;
    }
    return true;
  }
}

ContactListModel contactList = ContactListModel();