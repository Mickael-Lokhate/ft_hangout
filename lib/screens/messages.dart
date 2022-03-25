import 'package:flutter/material.dart';
import 'package:ft_hangout/widgets/messages_list.dart';
import 'package:telephony/telephony.dart';
import '../models/contact.dart';

class MessagesInterface extends StatefulWidget {
  MessagesInterface(this.currentContact, { Key? key }) : super(key: key);
  final Contact currentContact;
  final Telephony telephony = Telephony.instance;

  @override
  _MessagesInterfaceState createState() => _MessagesInterfaceState();
}

class _MessagesInterfaceState extends State<MessagesInterface> {
 final messageController = TextEditingController();
 final _formKey = GlobalKey<FormState>();
 late List<SmsMessage> messages;

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
      body: Column(
        children: [
          MessagesListWidget(widget.currentContact),
          _buildForm(),
        ],
      )
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
        bool? permSms = await widget.telephony.requestSmsPermissions;
        if (_formKey.currentState!.validate() && permSms != null && permSms) {
            print('NEED SEND MESSAGE');
            
            await widget.telephony.sendSms(
              to: widget.currentContact.phonenumber,
              message: messageController.text,
              statusListener: _sendMessageListener
            );
            messageController.text = '';
        }
      },
      child: const Text('Send'),
    );
  }

  void  _sendMessageListener(SendStatus status) {
    print("STATUS OF MESSAGE : $status");
  }
}