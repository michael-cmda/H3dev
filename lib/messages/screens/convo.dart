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
                  .collection('sent_messages')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, sentMessagesSnapshot) {
                if (sentMessagesSnapshot.hasError) {
                  return Center(child: Text('Error loading messages'));
                }

                if (sentMessagesSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final sentMessages = sentMessagesSnapshot.data!.docs;

                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('conversations')
                      .doc(widget.conversationId)
                      .collection(
                          'replies') 
                      .orderBy('timestamp', descending: false)
                      .snapshots(),
                  builder: (context, repliesSnapshot) {
                    if (repliesSnapshot.hasError) {
                      return Center(child: Text('Error loading replies'));
                    }

                    if (repliesSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final replies = repliesSnapshot.data!.docs;

                    final allMessages = [...sentMessages, ...replies];
                    allMessages.sort((a, b) => (a['timestamp'] as Timestamp)
                        .compareTo(b['timestamp'] as Timestamp));

                    return ListView.builder(
                      reverse: true,
                      controller: _scrollController,
                      itemCount: allMessages.length,
                      itemBuilder: (context, index) {
                        final messageData =
                            allMessages[index].data() as Map<String, dynamic>;
                        final isReply = replies.contains(allMessages[index]);

                        return MessageBubble(
                          sender: messageData['sender'],
                          text: messageData['message'],
                          isReply: isReply,
                        );
                      },
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
                      await FirebaseFirestore.instance
                          .collection('conversations')
                          .doc(widget.conversationId)
                          .collection('sent_messages')
                          .add({
                        'sender': 'John Doe',
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
                    color: isReply
                        ? Colors.grey
                        : Colors.blue, 
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
