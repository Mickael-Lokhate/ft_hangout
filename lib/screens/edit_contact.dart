import 'package:flutter/material.dart';
import 'package:ft_hangout/models/contact.dart';
import 'package:ft_hangout/widgets/form.dart';
import 'package:provider/provider.dart';

import '../models/config.dart';

class EditContact extends StatefulWidget {
  final Contact     contact;
  const EditContact(this.contact, { Key? key }) : super(key: key);

  @override
  _EditContactState createState() => _EditContactState();
}

class _EditContactState extends State<EditContact> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ' + widget.contact.name),
        backgroundColor: headerColorGlobal.headerColor,
      ),
      body: Consumer<ContactListModel>(
        builder: (context, list, child) {
          return _buildForm(list);
        },
      )
       
    );
  }

  Widget _buildForm(ContactListModel list) {
    return ContactForm(widget.contact, list);
  }
}