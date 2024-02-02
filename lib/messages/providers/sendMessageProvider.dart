import 'package:flutter/material.dart';
import 'package:h3devs/messages/model/message.dart';
import 'package:flutter/foundation.dart';

class SendMessageProvider extends ChangeNotifier {
  List<Message> _messages = [];

  List<Message> get messages => _messages;

  void addNewMessage(Message message) {
    _messages.add(message);
    notifyListeners(); 
  }
}
