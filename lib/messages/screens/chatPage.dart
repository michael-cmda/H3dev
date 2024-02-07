import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class UserSelectionPage extends StatefulWidget {
  @override
  _UserSelectionPageState createState() => _UserSelectionPageState();
}

class _UserSelectionPageState extends State<UserSelectionPage> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        toolbarHeight: 70,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: const InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(8.0),
              child: UserSelectionList(searchQuery: _searchController.text),
            ),
          ),
        ],
      ),
    );
  }
}

class UserSelectionList extends StatelessWidget {
  final String? searchQuery;

  UserSelectionList({this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .where('name', isGreaterThanOrEqualTo: searchQuery)
          .where('name', isLessThan: searchQuery! + 'z')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        var users = snapshot.data!.docs;
        List<Widget> userWidgets = [];

        for (var userDoc in users) {
          var userData = userDoc.data() as Map<String, dynamic>;
          var userName = userData['name'];
          var userEmail = userData['email'];
          var unreadNotifications = userData['unreadNotifications'] ?? 0;
          var profilePictureUrl = userData['profilePictureUrl'];
          var unreadMessages = userData['unreadMessages'] ?? 0;

          var userWidget = ListTile(
            leading: CircleAvatar(
              backgroundImage: profilePictureUrl != null
                  ? NetworkImage(profilePictureUrl)
                  : Image.asset('assets/images/Default.jpg').image,
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(userName),
                if (unreadNotifications > 0)
                  Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      unreadNotifications.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                if (unreadMessages > 0)
                  Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      unreadMessages.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userEmail),
              ],
            ),
            onTap: () {
              _updateUnreadNotifications(userDoc.id);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    userName: userName,
                    userEmail: userEmail,
                    profilePictureUrl: profilePictureUrl,
                  ),
                ),
              );
            },
          );
          userWidgets.add(userWidget);
        }

        return ListView(
          children: userWidgets,
        );
      },
    );
  }

  Future<void> _updateUnreadNotifications(String userId) async {
    await FirebaseFirestore.instance.collection('Users').doc(userId).update({
      'unreadNotifications': 0,
    });
  }
}

class ChatPage extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String? profilePictureUrl;

  const ChatPage({
    required this.userName,
    required this.userEmail,
    this.profilePictureUrl,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();
  late User _currentUser;
  late String _chatRoomId;
  late Stream<QuerySnapshot> _messagesStream;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _getChatRoomId();
    _messagesStream = _firestore
        .collection('messages')
        .doc(_chatRoomId)
        .collection('chats')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> _getChatRoomId() async {
    List<String> emails = [_currentUser.email!, widget.userEmail];
    emails.sort();
    _chatRoomId = emails.join('_');

    await _createOrJoinChatRoom();
  }

  Future<void> _getCurrentUser() async {
    _currentUser = _auth.currentUser!;
  }

  Future<void> _createOrJoinChatRoom() async {
    final chatRoomDocRef = _firestore.collection('messages').doc(_chatRoomId);
    final chatCollectionRef = chatRoomDocRef.collection('chats');

    var chatRoomSnapshot = await chatRoomDocRef.get();

    if (!chatRoomSnapshot.exists) {
      await chatRoomDocRef.set({
        'users': [_currentUser.email, widget.userEmail],
      });
    }
  }

  Future<void> _sendMessage() async {
    String messageText = _messageController.text.trim();
    if (messageText.isNotEmpty) {
      final chatCollectionRef = _firestore
          .collection('messages')
          .doc(_chatRoomId)
          .collection('chats');
      await chatCollectionRef.add({
        'text': messageText,
        'sender': _currentUser.email,
        'recipient': widget.userEmail,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _messageController.clear();

      await _deleteOldMessages(chatCollectionRef);
    }
  }

  Future<void> _deleteOldMessages(CollectionReference chatCollectionRef) async {
    DateTime oneWeekAgo = DateTime.now().subtract(Duration(days: 7));
    QuerySnapshot oldMessages = await chatCollectionRef
        .where('timestamp', isLessThan: oneWeekAgo)
        .get();

    for (QueryDocumentSnapshot message in oldMessages.docs) {
      await message.reference.delete();
    }
  }

  Future<void> _incrementUnreadMessages() async {
    final recipientUserDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.userEmail)
        .get();

    if (recipientUserDoc != null && recipientUserDoc.exists) {
      int unreadMessages =
          (recipientUserDoc.data()?['unreadMessages'] ?? 0) + 1;

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userEmail)
          .update({
        'unreadMessages': unreadMessages,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.userName}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _messagesStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                var messages = snapshot.data!.docs;
                List<Widget> messageWidgets = [];

                for (var message in messages) {
                  var messageText = message['text'];
                  var messageSender = message['sender'];
                  var messageTimestamp = message['timestamp'];

                  DateTime messageDateTime = DateTime.now();
                  if (messageTimestamp != null) {
                    messageDateTime = (messageTimestamp as Timestamp).toDate();
                  }

                  var messageWidget = MessageWidget(
                    sender: messageSender,
                    text: messageText,
                    isMe: messageSender == _currentUser.email,
                    timestamp: messageDateTime,
                  );
                  messageWidgets.add(messageWidget);
                }

                return ListView(
                  children: messageWidgets.reversed.toList(),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _sendMessage,
                  icon: Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  final String sender;
  final String text;
  final bool isMe;
  final DateTime timestamp;

  MessageWidget({
    required this.sender,
    required this.text,
    required this.isMe,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            '$sender ${isMe ? '(You)' : ''}',
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 5.0),
          Material(
            color: isMe
                ? Color.fromARGB(255, 124, 188, 253)
                : Color.fromARGB(255, 229, 229, 229),
            borderRadius: BorderRadius.circular(12.0),
            elevation: 6.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                text,
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            DateFormat('MMM d, HH:mm').format(timestamp),
            style: TextStyle(fontSize: 12.0, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: UserSelectionPage(),
  ));
}
