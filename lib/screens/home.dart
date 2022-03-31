import 'package:flutter/material.dart';
import 'package:ft_hangout/models/config.dart';
import 'package:ft_hangout/screens/contact_details.dart';
import 'package:ft_hangout/screens/create_contact.dart';
import 'package:ft_hangout/utility.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:telephony/telephony.dart';

import '../models/contact.dart';

class ContactList extends StatefulWidget {
  ContactList({ Key? key }) : super(key: key);
  MaterialAccentColor headerColor = headerColorGlobal.headerColor;
  DateTime? dateInactive;

  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> with WidgetsBindingObserver {
  final Telephony telephony = Telephony.instance;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      setState(() {
        widget.dateInactive = DateTime.now();
      });
    } else if (state == AppLifecycleState.resumed && widget.dateInactive != null) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppLocalizations.of(context)!.backgroundMessage} : ${widget.dateInactive!.hour}:${widget.dateInactive!.minute}:${widget.dateInactive!.second}'),
        )
      );
      setState(() {
        widget.dateInactive = null;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
   super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ft_hangout'),
        backgroundColor: widget.headerColor,
        actions: [
          PopupMenuButton(
            onSelected: (int value) {
              setState(() {
                widget.headerColor = headerColorGlobal.updateColor(value);
              }
              );
            },
            itemBuilder: (context) => [
              PopupMenuItem(child: Text(AppLocalizations.of(context)!.redLabel), value: 1),
              PopupMenuItem(child: Text(AppLocalizations.of(context)!.blueLabel), value: 2,),
              PopupMenuItem(child: Text(AppLocalizations.of(context)!.yellowLabel), value: 3,),
              PopupMenuItem(child: Text(AppLocalizations.of(context)!.greenLabel), value: 4,),
              PopupMenuItem(child: Text(AppLocalizations.of(context)!.orangeLabel), value: 5,),
              PopupMenuItem(child: Text(AppLocalizations.of(context)!.purpleLabel), value: 6,),
              PopupMenuItem(child: Text(AppLocalizations.of(context)!.pinkLabel), value: 7,)
            ]
           )
        ],
      ),
      body: Consumer<ContactListModel>(
        builder: (context, list, _) { 
          telephony.listenIncomingSms(
          onNewMessage: (SmsMessage message) {
            if (!list.isPhoneExist(message.address!, -2)) {
              Contact newContact = Contact(
                0,
                message.address!,
                message.address!,
              );
              list.add(newContact);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${AppLocalizations.of(context)!.newMessage} ${message.address}'),
                )
              );
            }
          },
          listenInBackground: false
        );
          return _buildList(list);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const CreateContact())
          );
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.person_add),
      ),
    );
  }

  Widget _buildList(ContactListModel list) {
    if (list.contacts.isNotEmpty) {
      return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: list.contacts.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: ValueKey<int>(index),
            dismissThresholds: const {DismissDirection.endToStart: 0.6},
            background: Card(
              color: Colors.red,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Icon(Icons.delete, color: Colors.white, size: 30,),
                  SizedBox(width: 10,)
                ]
              )
            ),
            onDismissed: (DismissDirection dir) {
                list.remove(list.contacts[index].id);
            },
            direction: DismissDirection.endToStart,
            child: _buildRowContact(list, list.contacts[index])
          );
        },
      );
    } else {
      return Center(child: Text(AppLocalizations.of(context)!.noContactLabel),);
    }
  }

  Widget _buildAvatar(Contact currentContact) {
    if (currentContact.imageUrl != null && currentContact.imageUrl!.isNotEmpty) {
      return CircleAvatar(
            radius: 24,
            child: const Icon(Icons.person, size: 48,),
            foregroundImage: Utility.imageFromBase64String(currentContact.imageUrl!).image,
      );
    } else {
      return const CircleAvatar(
            radius: 24,
            child: Icon(Icons.person, size: 48,),
      );
    }
  }

  Widget _buildRowContact(ContactListModel list, Contact currentContact) {
      return GestureDetector(
          child: Card(
            child: ListTile(
              leading: Container(
                width: 64,
                height: 64,
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                alignment: Alignment.center,
                child: _buildAvatar(currentContact),
              ),
              title: Text(
                currentContact.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(currentContact.phonenumber),
            )
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ContactDetails(currentContact)
            ));
          }, 
      );
  }
}