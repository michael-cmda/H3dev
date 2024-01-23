import 'package:flutter/material.dart';
import 'package:h3devs/search/recentSearchTile.dart';

class SearchDrawer extends StatefulWidget {
  const SearchDrawer({super.key});

  @override
  State<SearchDrawer> createState() => _SearchDrawerState();
}

class _SearchDrawerState extends State<SearchDrawer> {
  final List<String> recentSearches = ['H3 Devs', 'Yikes', 'John Doe'];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _buildSearchSection(),
          const Divider(
            height: 20,
            color: Colors.grey,
          ),
          const SizedBox(height: 10.0),
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
          const SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: const Padding(
                padding: EdgeInsets.only(
                  left: 15.0,
                  right: 5.0,
                ),
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSearches() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () => setState(() => recentSearches.clear()),
                child: const Text(
                  'Clear all',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Wrap(
            children: recentSearches
                .map((search) => RecentSearchTile(
                      search: search,
                      onDelete: () =>
                          setState(() => recentSearches.remove(search)),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
