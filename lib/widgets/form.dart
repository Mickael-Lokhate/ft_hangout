import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ft_hangout/database.dart';

import '../models/contact.dart';

enum FieldType {
  name,
  lastname,
  phonenumber,
  email,
  imageUrl,
  moreInfos
}

class ContactForm extends StatefulWidget {
  final Contact? contact;
  final ContactListModel list;
  const ContactForm(this.contact, this.list, { Key? key }) : super(key: key);

  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final lastnameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final moreInfoController = TextEditingController();
  final bloc = ContactsBloc();

  @override
  Widget build(BuildContext context) {
    if (widget.contact != null) {
      nameController.text = widget.contact!.name;
      lastnameController.text = widget.contact!.lastname ?? '';
      phoneNumberController.text = widget.contact!.phonenumber;
      emailController.text = widget.contact!.email ?? '';
      moreInfoController.text = widget.contact!.moreInfos ?? '';
    }
    
  
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _buildTextField(FieldType.name, "Enter a name (*)",TextInputType.name, nameController),
          _buildTextField(FieldType.lastname,"Enter a lastname", TextInputType.text, lastnameController),
          _buildTextField(FieldType.phonenumber,"Enter a phone number (*)", TextInputType.phone, phoneNumberController),
          _buildTextField( FieldType.email,"Enter an email", TextInputType.emailAddress, emailController),
          _buildTextField(FieldType.moreInfos,"Enter more details", TextInputType.text, moreInfoController),
          _buildValidationButton()
        ],
      )
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    lastnameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    moreInfoController.dispose();
    // bloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // bloc.getContacts();
  }

  Widget _buildTextField(FieldType type, String label, TextInputType keyboardType, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        labelText: label,
      ),
      validator: (value) {
        switch (type) {
          case FieldType.name:
            if (value == null || value.isEmpty) {
             return "Please enter a name";
            }
          break;
          case FieldType.lastname:
          break;
          case FieldType.email:
            if (value != null && value.isNotEmpty) {
              RegExp reg = RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
              if (!reg.hasMatch(value)) {
                return 'Please enter a valid email address';
              }
            }
          break;
          case FieldType.phonenumber:
            if (value == null || value.isEmpty) {
             return "Please enter a phone number";
            } else {
              RegExp reg = RegExp(r"^(?:(?:\+|00)33[\s.-]{0,3}(?:\(0\)[\s.-]{0,3})?|0)[1-9](?:(?:[\s.-]?\d{2}){4}|\d{2}(?:[\s.-]?\d{3}){2})$");
              if (!reg.hasMatch(value)) {
                return 'Please enter a valide french phone number';
              }
            }
          break;
          case FieldType.imageUrl:
            if (value == null || value.isEmpty) {
             return "Please enter a name";
            }
          break;
          case FieldType.moreInfos:
            
          break;
        }
        return null;
      },
    );
  }

  Widget _buildValidationButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate() && widget.contact != null) {
          // widget.list.update(
          //   widget.contact!.id,
          //   nameController.text,
          //   lastnameController.text,
          //   phoneNumberController.text,
          //   emailController.text,
          //   null,
          //   moreInfoController.text
          // );
          Contact newContact = widget.contact!;
          if (nameController.text.isNotEmpty) {
            newContact.name = nameController.text;
          }
          if (phoneNumberController.text.isNotEmpty) {
            newContact.phonenumber = phoneNumberController.text;
          }
          newContact.lastname = lastnameController.text;
          newContact.email = emailController.text;
          newContact.moreInfos = moreInfoController.text;

          // UPDATE IN DB
          // DBProvider.db.updateContact(newContact);
          // getContacts();
          bloc.update(newContact);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Contact has been updated'),
              backgroundColor: Colors.greenAccent,
              )
          );
          Navigator.of(context).pop();
        } else if (_formKey.currentState!.validate() && widget.contact == null) {
          Contact newContact = Contact(
            widget.list.contacts.length - 1,
            nameController.text,
            phoneNumberController.text,
            lastnameController.text,
            emailController.text,
            null,
            moreInfoController.text);
          // DBProvider.db.insertContact(newContact);
          bloc.add(newContact);
          // widget.list.add(newContact);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Contact succefully created'),
              backgroundColor: Colors.greenAccent,
            )
          );
          Navigator.of(context).pop();
        }
      },
      child: widget.contact != null ? const Text( 'Save') : const Text('Create')
    );
  }
}