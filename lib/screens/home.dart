import 'package:flutter/material.dart';
import 'package:ft_hangout/models/config.dart';
import 'package:ft_hangout/screens/contact_details.dart';
import 'package:ft_hangout/screens/create_contact.dart';
import 'package:provider/provider.dart';

import '../models/contact.dart';

class ContactList extends StatefulWidget {
  ContactList({ Key? key }) : super(key: key);
  MaterialAccentColor headerColor = headerColorGlobal.headerColor;
  DateTime? dateInactive;

  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> with WidgetsBindingObserver {

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      setState(() {
        widget.dateInactive = DateTime.now();
      });
    } else if (state == AppLifecycleState.resumed && widget.dateInactive != null) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('App set in background at : ${widget.dateInactive!.hour}:${widget.dateInactive!.minute}:${widget.dateInactive!.second}'),
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
                switch (value) {
                  case 1:
                    widget.headerColor = Colors.redAccent;
                    headerColorGlobal.updateColor(value);
                  break;
                  case 2:
                    widget.headerColor = Colors.blueAccent;
                    headerColorGlobal.updateColor(value);
                    break;
                  case 3:
                    widget.headerColor = Colors.yellowAccent;
                    headerColorGlobal.updateColor(value);
                    break;
                  case 4:
                    widget.headerColor = Colors.greenAccent;
                    headerColorGlobal.updateColor(value);
                    break;
                }
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(child: Text('Red'), value: 1),
              const PopupMenuItem(child: Text('Blue'), value: 2,),
              const PopupMenuItem(child: Text('Yellow'), value: 3,),
              const PopupMenuItem(child: Text('Green'), value: 4,)
            ]
            )
        ],
      ),
      body: Consumer<ContactListModel>(
        builder: (context, list, child) {
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
          return _buildRowContact(list, list.contacts[index]);
        },
      );
    } else {
      return const Center(child: Text('Add your first contact with the + button'),);
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
                child: const CircleAvatar(
                  radius: 24,
                  child: Icon(Icons.person, size: 48,),
                ),
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