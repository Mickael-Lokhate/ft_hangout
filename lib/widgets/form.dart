import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/contact.dart';

enum FieldType {
  name,
  lastname,
  phonenumber,
  email,
  imageUrl,
  moreInfos
}

class EditContactForm extends StatefulWidget {
  final Contact contact;
  final ContactListModel list;
  const EditContactForm(this.contact, this.list, { Key? key }) : super(key: key);

  @override
  _EditContactFormState createState() => _EditContactFormState();
}

class _EditContactFormState extends State<EditContactForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final lastnameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final moreInfoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    nameController.text = widget.contact.name;
    lastnameController.text = widget.contact.lastname ?? '';
    phoneNumberController.text = widget.contact.phonenumber;
    emailController.text = widget.contact.email ?? '';
    moreInfoController.text = widget.contact.moreInfos ?? '';
  
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
    super.dispose();
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
        if (_formKey.currentState!.validate()) {
          widget.list.updateContact(
            widget.contact.id,
            nameController.text,
            lastnameController.text,
            phoneNumberController.text,
            emailController.text,
            null,
            moreInfoController.text
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Contact has been updated'))
          );
          Navigator.of(context).pop();
        }
      },
      child: const Text('Submit')
    );
  }
}