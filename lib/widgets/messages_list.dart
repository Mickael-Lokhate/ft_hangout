import 'package:flutter/material.dart';
import 'package:ft_hangout/models/contact.dart';
import 'package:telephony/telephony.dart';
import 'message.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      return Center(
        child: Text(AppLocalizations.of(context)!.noMessages),
      );
    }
  }

   void _getAllmessage() async {
     List<SmsMessage> tmp;

     tmp = await telephony.getInboxSms(
        columns: [SmsColumn.TYPE, SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE, SmsColumn.SEEN, SmsColumn.READ, SmsColumn.THREAD_ID],
        filter: SmsFilter.where(SmsColumn.ADDRESS).equals(widget.currentContact.phonenumber),
        sortOrder: [OrderBy(SmsColumn.DATE_SENT)]
      );

      telephony.getSentSms(
        columns: [SmsColumn.TYPE, SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE, SmsColumn.SEEN, SmsColumn.READ, SmsColumn.THREAD_ID],
        filter: SmsFilter.where(SmsColumn.ADDRESS).equals(widget.currentContact.phonenumber),
        sortOrder: [OrderBy(SmsColumn.DATE)]
      ).then((valueSent) {
          tmp += valueSent;
          tmp.sort((m1, m2) {
            DateTime m1Date = DateTime.fromMicrosecondsSinceEpoch(m1.date! * 1000, isUtc: false).toLocal();
            DateTime m2Date = DateTime.fromMicrosecondsSinceEpoch(m2.date! * 1000, isUtc: false).toLocal();

            return m2Date.compareTo(m1Date);
          });
        setState(() {
            widget.messages = tmp;
        });
      });
  }
}