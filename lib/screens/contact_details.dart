import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ft_hangout/database.dart';
import 'package:ft_hangout/models/config.dart';
import 'package:ft_hangout/screens/edit_contact.dart';
import 'package:ft_hangout/screens/messages.dart';
import 'package:provider/provider.dart';

import '../models/contact.dart';

class ContactDetails extends StatefulWidget {
  Contact contact;
  ContactDetails(this.contact, { Key? key }) : super(key: key);

  @override
  State<ContactDetails> createState() => _ContactDetailsState();
}

class _ContactDetailsState extends State<ContactDetails> {
  // final bloc = ContactsBloc();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact.name),
        backgroundColor: headerColorGlobal.headerColor,
      ),
      body: FutureBuilder<List<Contact>>(
        future: DBProvider.db.getContacts(),//bloc.contacts,
        builder: (BuildContext context, AsyncSnapshot<List<Contact>> snapshot) {
          if (snapshot.hasData) {
            return _buildContactDetails(context, snapshot.data!);
          } else {
            return const Center(child: CircularProgressIndicator(),);
          }
        },
      )
      // Consumer<ContactListModel>(
      //   builder: (context, list, child) {
      //     return _buildContactDetails(context, list);
      //   },
      // )
    );
  }

  Widget _buildContactDetails(context, List<Contact> list) {
    widget.contact = list.firstWhere((element) => element.id == widget.contact.id);

    return Container( 
      padding: const EdgeInsets.all(10),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildHeader(),
        _buildActionButtons(context, list, widget.contact),
        const SizedBox(height: 10,),
        _buildCard('Phone', widget.contact.phonenumber)
      ],
    ));
  }

  Widget _buildHeader() {
    String completeName = widget.contact.name;
    if (widget.contact.lastname != null) {
      completeName += ' ' + widget.contact.lastname!;
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
          if (widget.contact.email != null) Text(
            widget.contact.email!,
            style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic, fontSize: 14),
          )
        ],
      )
    );
  }

  Widget _buildActionButtons(context, List<Contact> list, Contact currentContact) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildButton('Message', Icons.message, () {
           Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => MessagesInterface(currentContact))
            ); 
          }),
          const SizedBox(width: 8), 
          _buildButton('Call', Icons.call, () {}),
          const SizedBox(width: 8), 
          _buildButton('Edit', Icons.edit, () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => EditContact(currentContact))
            );
          }),
          const SizedBox(width: 8), 
          _buildButton('Delete', Icons.delete, () {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text('Delete ${currentContact.name}'),
                content: Text('Do you really want to delete ${currentContact.name} ?'),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.redAccent,
                      textStyle: const TextStyle(
                          fontSize: 16.0,
                      )
                    ),
                    onPressed: () {
                      // list.remove(currentContact);
                      DBProvider.db.deleteContact(currentContact.id);
                      // bloc.remove(currentContact.id);
                      Navigator.of(context).pop('Remove');
                      Navigator.of(context).pop();
                    }, 
                    child: Text("Good bye ${currentContact.name}")
                  ),
                   TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      )
                    ),
                    onPressed: () {
                      Navigator.of(context).pop('Cancel');
                    }, 
                    child: const Text("Cancel")
                  )
                ],
              )
            );
            
          }),
        ],
      )
    );
  }

  Widget _buildButton(String name, IconData icon, void Function() action) {
    return ElevatedButton(
      onPressed: action,
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

  Widget _buildCard(String leading, String title) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: title));
      },
      child: Tooltip(
        triggerMode: TooltipTriggerMode.tap,
        showDuration: const Duration(milliseconds: 1500),
        message: leading + ' copied !',
        child:Card(
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(leading)
            ),
            title:  Text(
                title,
                style: const TextStyle(color: Colors.blueAccent),
              )
            ),
          ),
        ),
    );
  }
}