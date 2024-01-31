import 'package:flutter/material.dart';
import 'package:h3devs/messages/providers/sendMessageProvider.dart';
import 'package:h3devs/messages/sendMessage.dart';
import 'package:provider/provider.dart';
import 'package:h3devs/messages/providers/askUserProvider.dart';

class AskUserScreen extends StatefulWidget {
  const AskUserScreen({Key? key}) : super(key: key);

  @override
  State<AskUserScreen> createState() => _AskUserScreenState();
}

class _AskUserScreenState extends State<AskUserScreen> {
  final TextEditingController _usernameController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  _navigateToMessages() {
    final provider = Provider.of<AskUserProvider>(context, listen: false);
    if (_usernameController.text.trim().isNotEmpty) {
      provider.setErrorMessage('');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (context) => SendMessageProvider(),
            child: SendMessageScreen(
              username: _usernameController.text.trim(),
            ),
          ),
        ),
      );
    } else {
      provider.setErrorMessage('Username is required!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Selector<AskUserProvider, String>(
                selector: (_, provider) => provider.errorMessage,
                builder: (_, errorMessage, __) => errorMessage != ''
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 30.0),
                        child: Card(
                          color: Colors.red,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              errorMessage,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ),
              const SizedBox(height: 5),
              Text(
                'City Loads Chat',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline5,
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Who are you?',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _navigateToMessages,
                child: const Text('Start Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
