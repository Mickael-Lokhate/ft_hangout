import 'package:flutter/material.dart';
import 'package:ft_hangout/screens/contact_details.dart';

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
      body: _buildList(),
    );
  }

  Widget _buildList() {
    if (dummyContactList.isNotEmpty) {
      return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: dummyContactList.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildRowContact(dummyContactList[index]);
        },
      );
    } else {
      return const Center(child: Text('Add your first contact with the + button'),);
    }
  }

  Widget _buildRowContact(Contact currentContact) {
      return GestureDetector(
          child: Card(
            child: ListTile(
              leading: Container(
                width: 64,
                height: 64,
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                alignment: Alignment.center,
                child: const Icon(Icons.person, size: 50,),
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