import 'package:flutter/material.dart';
import 'package:ft_hangout/widgets/messages_list.dart';
import 'package:telephony/telephony.dart';
import '../models/config.dart';
import '../models/contact.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  @override
  Widget build(BuildContext context) {
    String completeName = widget.currentContact.name;

    if (widget.currentContact.lastname != null) {
      completeName += ' ' + widget.currentContact.lastname!;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(completeName),
        backgroundColor: headerColorGlobal.headerColor,
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
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(child: _buildMessageInput()),
            _buildSendButton()
          ],
        )
      )
    );
  }

  Widget _buildMessageInput() {
    return TextFormField(
      controller: messageController,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: AppLocalizations.of(context)!.messageFieldHint
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context)!.errorMessage;
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
            await widget.telephony.sendSms(
              to: widget.currentContact.phonenumber,
              message: messageController.text,
              statusListener: _sendMessageListener
            );
            messageController.text = '';
        }
      },
      child: const Icon(Icons.send),
    );
  }

  void  _sendMessageListener(SendStatus status) {
    print("STATUS OF MESSAGE : $status");
  }
}