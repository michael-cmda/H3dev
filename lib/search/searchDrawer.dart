import 'package:flutter/material.dart';

class SearchDrawer extends StatelessWidget {
  // Make it stateless since it doesn't need internal state
  const SearchDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Text('Search'),
          ),
          _buildSearchBar(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Search',
          prefixIcon: Icon(Icons.search),
        ),
        onChanged: (searchQuery) {
          // Implement search query handling here
        },
      ),
    );
  }
}
