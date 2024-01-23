import 'package:flutter/material.dart';

class RecentSearchTile extends StatelessWidget {
  final String search;
  final Function() onDelete;

  const RecentSearchTile({
    required this.search,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage('assets/images/profile.png'),
              ),
              const SizedBox(width: 8.0),
              Text(search),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.close),
            color: Colors.grey,
            iconSize: 16.0,
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
