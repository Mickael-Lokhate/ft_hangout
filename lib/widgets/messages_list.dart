import 'dart:math';

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

   void _getAllmessage() async {
     List<SmsMessage> tmp;

     tmp = await telephony.getInboxSms(
        columns: [SmsColumn.TYPE, SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE, SmsColumn.DATE_SENT, SmsColumn.SEEN, SmsColumn.READ, SmsColumn.THREAD_ID],
        filter: SmsFilter.where(SmsColumn.ADDRESS).equals(widget.currentContact.phonenumber),
        sortOrder: [OrderBy(SmsColumn.DATE_SENT)]
      );

      telephony.getSentSms(
        columns: [SmsColumn.TYPE, SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE_SENT, SmsColumn.DATE,SmsColumn.SEEN, SmsColumn.READ, SmsColumn.THREAD_ID],
        filter: SmsFilter.where(SmsColumn.THREAD_ID).equals(tmp[0].threadId.toString()),
        sortOrder: [OrderBy(SmsColumn.DATE)]
      ).then((valueSent) {
          tmp += valueSent;
          tmp.sort((m1, m2) {
            DateTime m1Date = DateTime.fromMicrosecondsSinceEpoch(m1.dateSent! * 1000);
            DateTime m2Date = DateTime.fromMicrosecondsSinceEpoch(m2.dateSent! * 1000);

            if (m1.type == SmsType.MESSAGE_TYPE_SENT) {
              m1Date = DateTime.fromMicrosecondsSinceEpoch(m1.date! * 1000); 
            }
            if (m2.type == SmsType.MESSAGE_TYPE_SENT) {
              m2Date = DateTime.fromMicrosecondsSinceEpoch(m2.date! * 1000); 
            }
            return m2Date.compareTo(m1Date);
          });
        setState(() {
            widget.messages = tmp;
        });
      });
  }
}