import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConversationScreen extends StatefulWidget {
  final String conversationId;

  const ConversationScreen({Key? key, required this.conversationId})
      : super(key: key);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversation'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('conversations')
                  .doc(widget.conversationId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error loading messages'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final messageData =
                        messages[index].data() as Map<String, dynamic>;
                    final messageType = messageData['type'];

                    return MessageBubble(
                      sender: messageData['sender'],
                      text: messageData['message'],
                      isReply: messageType == 'reply',
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final message = _messageController.text.trim();
                    if (message.isNotEmpty) {
                      final currentUser = FirebaseAuth.instance.currentUser;
                      final senderId = currentUser?.uid; 

                      final conversationSnapshot = await FirebaseFirestore
                          .instance
                          .collection('conversations')
                          .doc(widget.conversationId)
                          .get();
                      final receiverId =
                          conversationSnapshot.get('participants')[1];

                      if (senderId != null && receiverId != null) {
                        await FirebaseFirestore.instance
                            .collection('conversations')
                            .doc(widget.conversationId)
                            .collection('messages')
                            .add({
                          'sender': senderId,
                          'receiverID': receiverId,
                          'type': 'sent',
                          'message': message,
                          'timestamp': FieldValue.serverTimestamp(),
                        });
                        _messageController.clear();
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;
  final bool isReply;

  const MessageBubble({
    Key? key,
    required this.sender,
    required this.text,
    required this.isReply,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 2),
            child: Text(
              sender,
              style: TextStyle(
                fontSize: 10.0,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: isReply ? Colors.grey : Colors.blue,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
