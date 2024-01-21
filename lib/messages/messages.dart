import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final List<Contact> contacts = [
    const Contact(name: 'Noice', imageUrl: 'assets/images/profile1.png'),
    const Contact(name: 'H3 Devs', imageUrl: 'assets/images/profile2.png'),
    const Contact(name: 'Not Funny', imageUrl: 'assets/images/profile3.png'),
  ];

  List<Message> messages = [
    const Message(sender: 'Sender ', text: 'Hey there!'),
  ];

  Contact? selectedContact;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
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
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Color.fromARGB(255, 228, 228, 228),
                          width: 2.5,
                        ),
                      ),
                    ),
                    child: ListView.builder(
                      itemCount: contacts.length,
                      itemBuilder: (context, index) {
                        final contact = contacts[index];
                        return ContactTile(
                          contact: contact,
                          isSelected: contact == selectedContact,
                          onTap: () =>
                              setState(() => selectedContact = contact),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: selectedContact == null
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
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:
                                const Color.fromARGB(255, 49, 52, 76),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            minimumSize: const Size(250, 50),
                          ),
                          child: const Text('Send Message'),
                        )
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return MessageBubble(message: message);
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

  const Contact({required this.name, required this.imageUrl});
}

class Message {
  final String sender;
  final String text;

  const Message({required this.sender, required this.text});
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

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          if (message.sender == 'You') const Spacer(),
          const CircleAvatar(
            backgroundImage: AssetImage('assets/images/profile1.png'),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(message.text),
          ),
          if (message.sender != 'You') const Spacer(),
        ],
      ),
    );
  }
}
