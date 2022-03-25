import 'package:flutter/material.dart';
import 'package:ft_hangout/models/contact.dart';
import 'package:telephony/telephony.dart';
import 'message.dart';

class MessagesListWidget extends StatefulWidget {
  MessagesListWidget(this.currentContact, { Key? key }) : super(key: key);
  final Contact currentContact;
  List<SmsMessage> messages = []; 

  @override
  State<MessagesListWidget> createState() => _MessagesListWidgetState();
}

class _MessagesListWidgetState extends State<MessagesListWidget> {
  final Telephony telephony = Telephony.instance;

  @override
  Widget build(BuildContext context) {
    _getAllmessage();
    if (widget.messages.isNotEmpty){
      return Flexible(
        child: ListView.builder(
          itemCount: widget.messages.length,
          reverse: true,
          itemBuilder: (context, index) => MessageWidget(widget.messages[index], widget.currentContact)
        )
      );
    } else {
      return const Center(
        child: Text('No messages yet.'),
      );
    }
  }

   void _getAllmessage() {
     telephony.getInboxSms(
        columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE_SENT, SmsColumn.SEEN, SmsColumn.READ],
        filter: SmsFilter.where(SmsColumn.ADDRESS).equals(widget.currentContact.phonenumber),
        sortOrder: [OrderBy(SmsColumn.DATE_SENT)]
      ).then((value) {
        setState(() {
          widget.messages = value;
        });
      });
  }
}