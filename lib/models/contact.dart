import 'dart:collection';

import 'package:flutter/material.dart';

class Contact {
  int       id;
  String    name; 
  String    phonenumber;
  String?   lastname;
  String?   email;
  String?   imageUrl;
  String?   moreInfos;

  Contact(this.id, this.name, this.phonenumber, [this.lastname, this.email, this.imageUrl, this.moreInfos]);
}

class ContactListModel with ChangeNotifier {
  final List<Contact> _contacts = [
    Contact(
        0,
        'Micka',
        '0781635945',
        'Lokhate',
        'lokhatemickael@gmail.com'
      ),
      Contact(
        1,
        'John',
        '0111111111',
        'Doe',
        'johndoe@gmail.com'
      ),
      Contact(
        2,
        'Test',
        '022222222',
      ),
      Contact(
        3,
        'Hello',
        '0333333333',
      ),
      Contact(
        4,
        'World',
        '0444444444',
      ),
      Contact(
        5,
        'Here',
        '0555555555',
      ),
  ];

  UnmodifiableListView<Contact> get contacts => UnmodifiableListView(_contacts);

  void add(Contact contact) {
    _contacts.add(contact);
    notifyListeners();
  }

  void updateContact(int id, String? name, String? lastName, String? phoneNumber, String? email, String? imageUrl, String? moreInfos) {
    Contact findContact = _contacts.firstWhere((contact) => contact.id == id);
    if (name != null && name.isNotEmpty) {
      findContact.name = name;
    }
    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      findContact.phonenumber = phoneNumber;
    }
    findContact.lastname = lastName;
    findContact.email = email;
    findContact.imageUrl = imageUrl;
    findContact.moreInfos = moreInfos;
    notifyListeners();
  }

  void remove(Contact contact) {
    _contacts.remove(contact);
    notifyListeners();
  }

  void removeAll() {
    _contacts.clear();
    notifyListeners();
  }
}

ContactListModel contactList = ContactListModel();