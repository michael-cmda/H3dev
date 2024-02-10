import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:h3devs/messages/screens/chatPage.dart';
import 'package:intl/intl.dart';

class RecentMessages extends StatefulWidget {
  const RecentMessages({Key? key}) : super(key: key);

  @override
  _RecentMessagesState createState() => _RecentMessagesState();
}

class _RecentMessagesState extends State<RecentMessages> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String currentUserEmail;
  List<Contact> recentContacts = [];
  Contact? selectedContact;

  @override
  void initState() {
    super.initState();
    fetchCurrentUserEmail();
    fetchRecentChats();
  }

  Future<void> fetchCurrentUserEmail() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        setState(() {
          currentUserEmail = user.email!;
        });
      }
    } catch (e) {
      print("Error fetching current user's email: $e");
    }
  }

  Future<void> fetchRecentChats() async {
    try {
      QuerySnapshot chatSnapshot = await _firestore
          .collection('messages')
          .where('users', arrayContains: currentUserEmail)
          .get();
      print("Number of chat documents: ${chatSnapshot.docs.length}");
      List<Contact> contacts = [];

      List<Future<void>> tasks = [];

      chatSnapshot.docs.forEach((chatDoc) {
        tasks.add(Future<void>(() async {
          List<dynamic> users = chatDoc['users'];
          String otherUserEmail;
          try {
            otherUserEmail =
                users.firstWhere((user) => user != currentUserEmail);
          } catch (e) {
            print("Error finding other user email: $e");
            return;
          }

          QuerySnapshot messagesSnapshot = await _firestore
              .collection('messages')
              .doc(chatDoc.id)
              .collection('chats')
              .orderBy('timestamp', descending: true)
              .limit(1)
              .get();

          if (messagesSnapshot.docs.isNotEmpty) {
            Timestamp timestamp = messagesSnapshot.docs.first['timestamp'];
            String timeAgo = getTimeAgo(timestamp.toDate());

            Contact contact = Contact(
                name: otherUserEmail.split('@')[0],
                email: otherUserEmail,
                imageUrl: '',
                timeAgo: timeAgo);
            if (!contacts.contains(contact)) {
              contacts.add(contact);
            }
          }
        }));
      });

      await Future.wait(tasks);

      setState(() {
        recentContacts = contacts;
      });
    } catch (e) {
      print("Error fetching recent chats: $e");
    }
  }

  String getTimeAgo(DateTime dateTime) {
    Duration difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: _buildContactsSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildContactsSection() {
    return Material(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(20.0),
                child: const Text(
                  'Messages',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_horiz),
                  iconSize: 30,
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: recentContacts.length,
              itemBuilder: (context, index) {
                final contact = recentContacts[index];
                return ContactTile(
                  contact: contact,
                  isSelected: contact == selectedContact,
                  onTap: () {
                    setState(() {
                      selectedContact = contact;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          userName: contact.name,
                          userEmail: contact.email,
                          // profilePictureUrl: profilePictureUrl,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Contact {
  final String name;
  final String imageUrl;
  final String email;
  final String timeAgo;

  const Contact({
    required this.name,
    required this.imageUrl,
    required this.email,
    required this.timeAgo,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Contact && this.email == other.email;
  }

  @override
  int get hashCode => email.hashCode;
}

class ContactTile extends StatelessWidget {
  final Contact contact;
  final bool isSelected;
  final Function() onTap;

  const ContactTile({
    required this.contact,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(contact.imageUrl),
      ),
      title: Text(contact.name),
      subtitle: Row(
        children: [
          Expanded(
            child: Text(
              contact.timeAgo,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
