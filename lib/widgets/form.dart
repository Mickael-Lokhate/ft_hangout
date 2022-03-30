import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

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
  const ContactForm(this.contact, { Key? key }) : super(key: key);

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
      child: Consumer<ContactListModel>(
        builder: (context, list, _) => Column(
        children: <Widget>[
          _buildTextField(FieldType.name, AppLocalizations.of(context)!.nameFieldLabel,TextInputType.name, nameController, list),
          _buildTextField(FieldType.lastname,AppLocalizations.of(context)!.lastnameFieldLabel, TextInputType.text, lastnameController, list),
          _buildTextField(FieldType.phonenumber, AppLocalizations.of(context)!.phoneFieldLabel, TextInputType.phone, phoneNumberController, list),
          _buildTextField( FieldType.email,AppLocalizations.of(context)!.emailFieldLabel, TextInputType.emailAddress, emailController, list),
          _buildTextField(FieldType.moreInfos, AppLocalizations.of(context)!.moreFieldLabel, TextInputType.text, moreInfoController, list),
          _buildValidationButton(list)
        ],
      )
      ),
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

  Widget _buildTextField(FieldType type, String label, TextInputType keyboardType, TextEditingController controller, ContactListModel list) {
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
             return AppLocalizations.of(context)!.errorName;
            }
          break;
          case FieldType.lastname:
          break;
          case FieldType.email:
            if (value != null && value.isNotEmpty) {
              RegExp reg = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
              if (!reg.hasMatch(value)) {
                return AppLocalizations.of(context)!.errorEmail;
              }
            }
          break;
          case FieldType.phonenumber:
            int id = -2;
            if (widget.contact != null) {
              id = widget.contact!.id;
            }
            if (value == null || value.isEmpty) {
             return AppLocalizations.of(context)!.errorNoPhone;
            } else if (list.isPhoneExist(value, id)) {
              return AppLocalizations.of(context)!.errorPhoneExist;
            } 
            else {
              RegExp reg = RegExp(r"^(?:(?:\+|00)33[\s.-]{0,3}(?:\(0\)[\s.-]{0,3})?|0)[1-9](?:(?:[\s.-]?\d{2}){4}|\d{2}(?:[\s.-]?\d{3}){2})$");
              if (!reg.hasMatch(value)) {
                return AppLocalizations.of(context)!.errorPhone;
              }
            }
          break;
          case FieldType.imageUrl:
            if (value == null || value.isEmpty) {
             return AppLocalizations.of(context)!.errorImage;
            }
          break;
          case FieldType.moreInfos:
            
          break;
        }
        return null;
      },
    );
  }

  Widget _buildValidationButton(ContactListModel list) {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate() && widget.contact != null) {
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
          list.update(newContact);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.contactUpdateValid),
              backgroundColor: Colors.greenAccent,
              )
          );
          Navigator.of(context).pop();
        } else if (_formKey.currentState!.validate() && widget.contact == null) {
          Contact newContact = Contact(
            0,
            nameController.text,
            phoneNumberController.text,
            lastnameController.text,
            emailController.text,
            null,
            moreInfoController.text);
          
          list.add(newContact);
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.contactCreateValid),
              backgroundColor: Colors.greenAccent,
            )
          );
          Navigator.of(context).pop();
        }
      },
      child: widget.contact != null ? Text(AppLocalizations.of(context)!.saveButton) : Text(AppLocalizations.of(context)!.createButton)
    );
  }
}