import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:h3devs/messages/screens/chatPage.dart';

class Messages extends StatefulWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String currentUserEmail;
  List<Contact> recentContacts = [];
  Contact? selectedContact;

  @override
  void initState() {
    super.initState();
   
    currentUserEmail = "shanti@test.com"; 
   
    fetchRecentChats();
  }

  Future<void> fetchRecentChats() async {
    try {
      QuerySnapshot chatSnapshot = await _firestore
          .collection('messages')
          .where('users', arrayContains: currentUserEmail)
          .get();
      List<Contact> contacts = [];
      chatSnapshot.docs.forEach((chatDoc) {
     
        List<dynamic> users = chatDoc['users'];
        String otherUserEmail =
            users.firstWhere((user) => user != currentUserEmail);
     
        Contact contact = Contact(
            name: otherUserEmail.split('@')[0],
            email: otherUserEmail,
            imageUrl: ''); 
        if (!contacts.contains(contact)) {
          contacts.add(contact);
        }
      });

      setState(() {
        recentContacts = contacts;
      });
    } catch (e) {
      print("Error fetching recent chats: $e");
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
          const VerticalDivider(
            width: 2.5,
            thickness: 2.5,
            color: Color.fromARGB(255, 228, 228, 228),
          ),
          Expanded(
            flex: 5,
            child: _buildMessagesSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildContactsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(20.0),
          child: const Text(
            'Messages',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount:
                recentContacts.length, 
            itemBuilder: (context, index) {
              final contact = recentContacts[index];
              return ContactTile(
                contact: contact,
                isSelected: contact == selectedContact,
                onTap: () {
                  setState(() {
                    selectedContact =
                        contact; 
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMessagesSection() {
    return selectedContact == null
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/speech_bubble.png',
                  height: 80,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Your messages',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Tap here to start a new message',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 14.0,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserSelectionPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 49, 52, 76),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    minimumSize: const Size(250, 50),
                  ),
                  child: const Text('Send Message'),
                ),
              ],
            ),
          )
        : Container(); 
  }
}

class Contact {
  final String name;
  final String imageUrl;
  final String email;

  const Contact(
      {required this.name, required this.imageUrl, required this.email});

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
      trailing: isSelected ? const Icon(Icons.check) : null,
      onTap: onTap,
    );
  }
}
