import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ft_hangout/utility.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/contact.dart';

enum FieldType {
  name,
  lastname,
  phonenumber,
  email,
  imageUrl,
  moreInfos,
  entreprise,
  address
}

class ContactForm extends StatefulWidget {
  final Contact? contact;
  String photoString = '';
  ContactForm(this.contact, { Key? key }) : super(key: key);

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
  final entrepriseController = TextEditingController();
  final addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.contact != null) {
      nameController.text = widget.contact!.name;
      lastnameController.text = widget.contact!.lastname ?? '';
      phoneNumberController.text = widget.contact!.phonenumber;
      emailController.text = widget.contact!.email ?? '';
      moreInfoController.text = widget.contact!.moreInfos ?? '';
      entrepriseController.text = widget.contact!.entreprise ?? '';
      addressController.text = widget.contact!.address ?? '';
      if (widget.photoString.isEmpty) {
        widget.photoString = widget.contact!.imageUrl ?? '';
      }
    }
    
  
    return Form(
      key: _formKey,
      child: Consumer<ContactListModel>(
        builder: (context, list, _) => Column(
        children: <Widget>[
          const SizedBox(height: 10,),
          _buildImage(),
          const SizedBox(height: 5),
          const Center(child: Text('Click on the avatar to choose from gallery', style: TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),),),
          _buildCameraButton(),
          _buildTextField(FieldType.name, AppLocalizations.of(context)!.nameFieldLabel,TextInputType.name, nameController, list),
          _buildTextField(FieldType.lastname,AppLocalizations.of(context)!.lastnameFieldLabel, TextInputType.text, lastnameController, list),
          _buildTextField(FieldType.phonenumber, AppLocalizations.of(context)!.phoneFieldLabel, TextInputType.phone, phoneNumberController, list),
          _buildTextField(FieldType.email,AppLocalizations.of(context)!.emailFieldLabel, TextInputType.emailAddress, emailController, list),
          _buildTextField(FieldType.entreprise, AppLocalizations.of(context)!.entrepriseFieldLabel, TextInputType.text, entrepriseController, list),
          _buildTextField(FieldType.address, AppLocalizations.of(context)!.addressFieldLabel, TextInputType.streetAddress, addressController, list),
          _buildTextField(FieldType.moreInfos, AppLocalizations.of(context)!.moreFieldLabel, TextInputType.text, moreInfoController, list),
          _buildValidationButton(list)
        ],
      )
      ),
    );
  }

  Widget _buildCameraButton() {
    return ElevatedButton(
      onPressed: () {
        ImagePicker().pickImage(source: ImageSource.camera).then((imgFile) async {
          if (imgFile != null) {
            String imgString = Utility.base64String(await imgFile.readAsBytes());
            setState(() {
              widget.photoString = imgString;
            });
          }
        });
      },
      child: Text(AppLocalizations.of(context)!.photoButton)
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

  Widget _buildAvatar() {
    if (widget.photoString.isNotEmpty) {
      return CircleAvatar(
            radius: 64,
            child: const Icon(Icons.person, size: 128,),
            foregroundImage: Utility.imageFromBase64String(widget.photoString).image,
      );
    } else {
      return const CircleAvatar(
            radius: 64,
            child: Icon(Icons.person, size: 128,),
      );
    }
  }

  Widget _buildImage() {
    return GestureDetector(
      onTap: () {
        ImagePicker().pickImage(source: ImageSource.gallery).then((imgFile) async {
          if (imgFile != null) {
            String imgString = Utility.base64String(await imgFile.readAsBytes());
            setState(() {
              widget.photoString = imgString;
            });
          }
        });
      },
      child: _buildAvatar(),
    );
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
          default:
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
          newContact.entreprise = entrepriseController.text;
          newContact.address = addressController.text;
          if (widget.photoString.isNotEmpty){
            newContact.imageUrl = widget.photoString;
          }

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
          String? image;
          if (widget.photoString.isNotEmpty) {
            image = widget.photoString;
          }
          Contact newContact = Contact(
            0,
            nameController.text,
            phoneNumberController.text,
            lastnameController.text,
            emailController.text,
            image,
            moreInfoController.text,
            entrepriseController.text,
            addressController.text);
          
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