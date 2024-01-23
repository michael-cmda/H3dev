import 'package:flutter/material.dart';

class SearchDrawer extends StatefulWidget {
  const SearchDrawer({super.key});

  @override
  State<SearchDrawer> createState() => _SearchDrawerState();
}

class _SearchDrawerState extends State<SearchDrawer> {
  final List<String> recentSearches = ['H3 Devs', 'Funny Videos', 'John Doe'];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _buildSearchSection(),
          _buildRecentSearches(),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Search',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: const Padding(
                padding: EdgeInsets.only(
                  left: 15.0,
                  right: 5.0,
                ),
                // adjust padding value as needed
                child: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(28.0),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 10.0,
              ),
            ),
          ),
          const Divider(
            height: 20,
            color: Color.fromARGB(255, 49, 52, 76),
          ),
          Text(
            'Recent',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => setState(() => recentSearches.clear()),
                child: Text(
                  'Clear all',
                  style: TextStyle(color: Color.fromARGB(255, 49, 52, 76)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSearches() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Wrap(
        children: recentSearches
            .map((search) => Chip(
                  label: Text(search),
                  onDeleted: () =>
                      setState(() => recentSearches.remove(search)),
                ))
            .toList(),
      ),
    );
  }
}
