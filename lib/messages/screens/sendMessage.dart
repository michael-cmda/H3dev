import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:h3devs/messages/screens/convo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class SendMessage extends StatefulWidget {
  const SendMessage({Key? key}) : super(key: key);

  @override
  _SendMessageState createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  final TextEditingController _receiverIdController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  _getCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _currentUser = user;
      });
    }
  }

  _sendMessage() async {
    final receiverId = _receiverIdController.text.trim();
    final message = _messageController.text.trim();

    if (receiverId.isNotEmpty && message.isNotEmpty) {
      try {
        final conversationId = const Uuid().v1();

        await FirebaseFirestore.instance
            .collection('conversations')
            .doc(conversationId)
            .set({
          'participants': [_currentUser!.uid, receiverId],
        });

        await FirebaseFirestore.instance
            .collection('conversations')
            .doc(conversationId)
            .collection('messages')
            .add({
          'sender': _currentUser!.uid,
          'receiverID': receiverId,
          'message': message,
          'timestamp': FieldValue.serverTimestamp(),
          'type': 'sent',
        });

        _messageController.clear();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ConversationScreen(
              conversationId: conversationId,
            ),
          ),
        );
      } catch (error) {
        print(error);
        // wala pa error handling
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Message'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _receiverIdController,
            decoration: InputDecoration(
              hintText: 'Enter recipient ID',
            ),
          ),
          TextField(
            controller: _messageController,
            decoration: InputDecoration(
              hintText: 'Type your message',
            ),
          ),
          ElevatedButton(
            onPressed: _sendMessage,
            child: Text('Send'),
          ),
        ],
      ),
    );
  }
}
