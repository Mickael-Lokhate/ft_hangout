import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ft_hangout/models/config.dart';
import 'package:ft_hangout/screens/edit_contact.dart';
import 'package:ft_hangout/screens/messages.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        title: Consumer<ContactListModel>(
        builder: (context, list, _) => Text(list.contacts.firstWhere((element) => element.id == widget.contact.id).name),
      ),
        backgroundColor: headerColorGlobal.headerColor,
      ),
      body: Consumer<ContactListModel>(
        builder: (context, list, _) => _buildContactDetails(context, list),
      )
    );
  }

  Widget _buildContactDetails(context, ContactListModel list) {
    widget.contact = list.contacts.firstWhere((element) => element.id == widget.contact.id);

    return Container( 
      padding: const EdgeInsets.all(10),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildHeader(),
        _buildActionButtons(context, list, widget.contact),
        const SizedBox(height: 10,),
        _buildCard(AppLocalizations.of(context)!.phoneLabel, widget.contact.phonenumber)
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

  Widget _buildActionButtons(context, ContactListModel list, Contact currentContact) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Flexible(
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButton('Message', Icons.message, () {
           Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => MessagesInterface(currentContact))
            ); 
          }),
          const SizedBox(width: 5), 
          _buildButton(AppLocalizations.of(context)!.callLabel, Icons.call, () {}),
          const SizedBox(width: 5), 
          _buildButton(AppLocalizations.of(context)!.editLabel, Icons.edit, () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => EditContact(currentContact))
            );
          }),
          const SizedBox(width: 5), 
          _buildButton(AppLocalizations.of(context)!.deleteLabel, Icons.delete, () {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text('${AppLocalizations.of(context)!.deleteLabel} ${currentContact.name}'),
                content: Text('${AppLocalizations.of(context)!.deleteConfirmText} ${currentContact.name} ?'),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.redAccent,
                      textStyle: const TextStyle(
                          fontSize: 16.0,
                      )
                    ),
                    onPressed: () {
                      list.remove(currentContact.id);
                      Navigator.of(context).pop('Remove');
                      Navigator.of(context).pop();
                    }, 
                    child: Text("${AppLocalizations.of(context)!.deleteConfirmText} ${currentContact.name}")
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
                    child: Text(AppLocalizations.of(context)!.deleteCancelButton)
                  )
                ],
              )
            );
            
          }),
        ],
      )
      )
    );
  }

  Widget _buildButton(String name, IconData icon, void Function() action) {
    return Flexible(
      child: ElevatedButton(
      onPressed: action,
      child: Container(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Column(
        children: [
          Icon(icon),
          Text(name, style: const TextStyle(fontSize: 12),)
        ],
      ),
      )
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