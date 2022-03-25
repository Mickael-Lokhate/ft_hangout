import 'package:flutter/material.dart';
import 'package:ft_hangout/models/config.dart';
import 'package:ft_hangout/models/contact.dart';
import 'package:ft_hangout/widgets/form.dart';
import 'package:provider/provider.dart';

class CreateContact extends StatefulWidget {
  const CreateContact({ Key? key }) : super(key: key);

  @override
  _CreateContactState createState() => _CreateContactState();
}

class _CreateContactState extends State<CreateContact> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a new contact'),
        backgroundColor: headerColorGlobal.headerColor,
      ),
      body: Consumer<ContactListModel>(
        builder: (context, list, child) {
          return _buildForm(list);
        }
      ),
    );
  }

  Widget _buildForm(ContactListModel list) {
    return ContactForm(null, list);
  }
}