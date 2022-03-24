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
    return Column(
      children: [
        _buildHeader()
      ],
    );
  }

  Widget _buildHeader() {
    String completeName = contact.name;
    if (contact.lastname != null) {
      completeName += ' ' + contact.lastname!;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.person),
        Text(completeName),
        if (contact.email != null) Text(contact.email!)
      ],
    );
  }
}