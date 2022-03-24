import 'package:flutter/material.dart';
import 'package:ft_hangout/screens/contact_details.dart';
import 'package:provider/provider.dart';

import '../models/contact.dart';

class ContactList extends StatefulWidget {
  const ContactList({ Key? key }) : super(key: key);

  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ft_hangout'),
      ),
      body: Consumer<ContactListModel>(
        builder: (context, list, child) {
          return _buildList(list);
        },
      )
    );
  }

  Widget _buildList(ContactListModel list) {
    if (list.contacts.isNotEmpty) {
      return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: list.contacts.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildRowContact(list, list.contacts[index]);
        },
      );
    } else {
      return const Center(child: Text('Add your first contact with the + button'),);
    }
  }

  Widget _buildRowContact(ContactListModel list, Contact currentContact) {
      return GestureDetector(
          child: Card(
            child: ListTile(
              leading: Container(
                width: 64,
                height: 64,
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                alignment: Alignment.center,
                child: const CircleAvatar(
                  radius: 24,
                  child: Icon(Icons.person, size: 48,),
                ),
              ),
              title: Text(
                currentContact.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(currentContact.phonenumber),
            )
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ContactDetails(currentContact)
            ));
          }, 
      );
  }
}