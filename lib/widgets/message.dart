import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';

import '../models/contact.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget(this.message, this.contact, { Key? key }) : super(key: key);
  final SmsMessage message;
  final Contact contact;

  @override
  Widget build(BuildContext context) {
    return _buildMessage();
  }

  Widget _buildMessage() {
    MaterialAccentColor bgColor = Colors.blueAccent;
    CrossAxisAlignment align = CrossAxisAlignment.end;
    MainAxisAlignment alignMain = MainAxisAlignment.end;
    TextAlign textAlign = TextAlign.right;
    if (message.type != SmsType.MESSAGE_TYPE_SENT) {
      bgColor = Colors.greenAccent;
      align = CrossAxisAlignment.start;
      alignMain = MainAxisAlignment.start;
      textAlign = TextAlign.left;
    }

    DateTime dateSent = DateTime.fromMicrosecondsSinceEpoch(message.date! * 1000, isUtc: false).toLocal(); 

    String stringDate = "${dateSent.day} ${_convertMonth(dateSent.month)} ${dateSent.hour.toString().padLeft(2, '0')}:${dateSent.minute.toString().padLeft(2, '0')}";   
    Icon icon = const Icon(Icons.check_circle_outline, size: 16,);
    if (message.read != null && message.read!) {
      icon = const Icon(Icons.check_circle, color: Colors.blueAccent, size: 16,);
    }
    else if (message.seen != null && message.seen!) {
      icon = const Icon(Icons.check_circle, size: 16,);
    }
    
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Column(
        crossAxisAlignment: align,
        children: [
          Card(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Text(message.body!,)
            ),
            color: bgColor,
          ),
          Row(
            mainAxisAlignment: alignMain,
            children: [
              Text(stringDate, textAlign: textAlign),
              icon
            ],
          )
          
        ],
      )
    );
  }

  String _convertMonth(int m) {
    switch (m) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }
}