import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ft_hangout/models/config.dart';
import 'package:ft_hangout/screens/edit_contact.dart';
import 'package:ft_hangout/screens/messages.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:telephony/telephony.dart';

import '../models/contact.dart';

class ContactDetails extends StatefulWidget {
  Contact contact;
  ContactDetails(this.contact, { Key? key }) : super(key: key);
  final Telephony telephony = Telephony.instance;

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
        builder: (context, list, _) { 
          if (list.contacts.isEmpty) {
            Navigator.of(context).pop();
          }
          Contact contact = list.contacts.firstWhere((element) => element.id == widget.contact.id, orElse: () => Contact(-1, '', ''));
          return Text(contact.name);
        },
      ),
        backgroundColor: headerColorGlobal.headerColor,
      ),
      body: Consumer<ContactListModel>(
        builder: (context, list, _) {
          if (list.contacts.isEmpty) {
            Navigator.of(context).pop();
          }
           return _buildContactDetails(context, list);
        },
      )
    );
  }

  Widget _buildContactDetails(context, ContactListModel list) {
    if (list.contacts.isEmpty) {
      Navigator.of(context).pop();
    }
    widget.contact = list.contacts.firstWhere((element) => element.id == widget.contact.id, orElse: () => Contact(-1, '', ''));

    return Container( 
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildHeader(),
            _buildActionButtons(context, list, widget.contact),
            const SizedBox(height: 10,),
            _buildCard(AppLocalizations.of(context)!.phoneLabel, widget.contact.phonenumber),
            _buildCard(AppLocalizations.of(context)!.entrepriseLabel, widget.contact.entreprise ?? ''),
            _buildCard(AppLocalizations.of(context)!.addressLabel, widget.contact.address ?? ''),
            _buildCard(AppLocalizations.of(context)!.moreLabel, widget.contact.moreInfos ?? ''),
          ],
        ),
      )
    );
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButton('Message', Icons.message, () {
           Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => MessagesInterface(currentContact))
            ); 
          }),
          const SizedBox(width: 5), 
          _buildButton(AppLocalizations.of(context)!.callLabel, Icons.call, () async {
            bool? permCall = await widget.telephony.requestPhonePermissions;
            if (permCall != null && permCall) {
              await widget.telephony.dialPhoneNumber(currentContact.phonenumber);
            }
          }),
          const SizedBox(width: 5), 
          _buildButton(AppLocalizations.of(context)!.editLabel, Icons.edit, () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => EditContact(currentContact))
            );
          }),
          const SizedBox(width: 5), 
          _buildButton(AppLocalizations.of(context)!.deleteLabel, Icons.delete, () {
            Navigator.of(context).pop();
            list.remove(currentContact.id);
          }),
        ],
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
        message: leading + ' ' + AppLocalizations.of(context)!.copyTooltip + ' !',
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