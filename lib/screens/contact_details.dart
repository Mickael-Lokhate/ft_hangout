import 'package:flutter/material.dart';

import '../models/contact.dart';

class ContactDetails extends StatelessWidget {
  final Contact contact;
  const ContactDetails(this.contact, { Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(contact.name),
      ),
      body: _buildContactDetails(),
    );
  }

  Widget _buildContactDetails() {
    return Container( 
      padding: const EdgeInsets.all(10),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildHeader(),
        _buildActionButtons(contact)
      ],
    ));
  }

  Widget _buildHeader() {
    String completeName = contact.name;
    if (contact.lastname != null) {
      completeName += ' ' + contact.lastname!;
    }
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 64,
            child: Icon(Icons.person, size: 128,)
            ,),
          const SizedBox(height: 8), 
          Text(
            completeName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          const SizedBox(height: 8), 
          if (contact.email != null) Text(
            contact.email!,
            style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic, fontSize: 14),
          )
        ],
      )
    );
  }

  Widget _buildActionButtons(Contact currentContact) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildButton('Message', Icons.message),
          const SizedBox(width: 8), 
          _buildButton('Call', Icons.call),
          const SizedBox(width: 8), 
          _buildButton('Edit', Icons.edit),
          const SizedBox(width: 8), 
          _buildButton('Delete', Icons.delete),
        ],
      )
    );
  }

  Widget _buildButton(String name, IconData icon) {
    return ElevatedButton(
      onPressed: () {},
      child: Container(
      padding: const EdgeInsets.fromLTRB(5, 8, 5, 8),
      child: Column(
        children: [
          Icon(icon),
          Text(name)
        ],
      ),
      )
    );
  }
}