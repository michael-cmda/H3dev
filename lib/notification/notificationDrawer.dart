// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

void main() => runApp(const NotificationDrawer());

class NotificationDrawer extends StatelessWidget {
  const NotificationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _notificationHeader(),
          const Divider(
            height: 20,
            color: Colors.grey,
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}

Widget _notificationHeader() {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 5.0))),
    child: const Text(
      "Notificaiton",
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
  );
}
