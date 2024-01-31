import 'dart:io';

import 'package:flutter/material.dart';
import 'package:h3devs/messages/providers/sendMessageProvider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:h3devs/messages/model/message.dart';

class SendMessageScreen extends StatefulWidget {
  final String username;
  const SendMessageScreen({Key? key, required this.username}) : super(key: key);

  @override
  State<SendMessageScreen> createState() => _SendMessageScreenState();
}

class _SendMessageScreenState extends State<SendMessageScreen> {
  // final IO.Socket _socket = IO.io('http://localhost:54462');
  late IO.Socket _socket;
  final TextEditingController _messageInputController = TextEditingController();

  _sendMessage() {
    _socket.emit('message', {
      'message': _messageInputController.text.trim(),
      'sender': widget.username
    });
    _messageInputController.clear();
  }

  _connectSocket() {
    _socket.onConnect((data) => print('Connection established'));
    _socket.onConnectError((data) => print('Connect Error: $data'));
    _socket.onDisconnect((data) => print('Socket.IO server disconnected'));
    _socket.on(
      'message',
      (data) => Provider.of<SendMessageProvider>(context, listen: false)
          .addNewMessage(
        Message.fromJson(data),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _socket = IO.io(
      'http://localhost:61276',
      IO.OptionBuilder().setTransports(['websocket']).setQuery(
          {'username': widget.username}).build(),
    );
    _connectSocket();
  }

  @override
  void dispose() {
    _messageInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('City Loads Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<SendMessageProvider>(
              builder: (_, provider, __) => Scrollbar(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final message = provider.messages[index];
                    return Row(
                      mainAxisAlignment:
                          message.senderUsername == widget.username
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            color: message.senderUsername == widget.username
                                ? Theme.of(context).primaryColorLight
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment:
                                message.senderUsername == widget.username
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                            children: [
                              Text(message.message),
                              Text(
                                DateFormat('hh:mm a').format(message.sentAt),
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (_, index) => const SizedBox(height: 5),
                  itemCount: provider.messages.length,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              border: const Border(top: BorderSide(color: Colors.grey)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageInputController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message here...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (_messageInputController.text.trim().isNotEmpty) {
                      _sendMessage();
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
