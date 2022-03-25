import 'package:flutter/material.dart';
import '../models/contact.dart';

class MessagesInterface extends StatefulWidget {
  const MessagesInterface(this.currentContact, { Key? key }) : super(key: key);
  final Contact currentContact;

  @override
  _MessagesInterfaceState createState() => _MessagesInterfaceState();
}

class _MessagesInterfaceState extends State<MessagesInterface> {
 final messageController = TextEditingController();
 final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String completeName = widget.currentContact.name;
    if (widget.currentContact.lastname != null) {
      completeName += ' ' + widget.currentContact.lastname!;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(completeName),
      ),
      body: _buildForm(),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Row(
        children: <Widget>[
          Expanded(child: _buildMessageInput()),
          _buildSendButton()
        ],
      )
    );
  }

  Widget _buildMessageInput() {
    return TextFormField(
      controller: messageController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Message'
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Enter a message first";
        }
        return null;
      },
    );
  }

  Widget _buildSendButton() {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
            print('NEED SEND MESSAGE');
        }
      },
      child: const Text('Send'),
    );
  }
}