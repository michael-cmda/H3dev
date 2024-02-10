import 'package:flutter/material.dart';
import 'package:h3devs/search/recentSearchTile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchDrawer extends StatefulWidget {
  const SearchDrawer({Key? key}) : super(key: key);

  @override
  State<SearchDrawer> createState() => _SearchDrawerState();
}

class _SearchDrawerState extends State<SearchDrawer> {
  final TextEditingController _searchController = TextEditingController();
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
            controller: _searchController,
            onChanged: (value) {
              setState(() {});
            },
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
          SizedBox(height: 20),
          _buildUserList(),
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

  Widget _buildUserList() {
    return _searchController.text.isEmpty
        ? SizedBox()
        : StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where('name', isGreaterThanOrEqualTo: _searchController.text)
                .where('name', isLessThan: _searchController.text + '\uf8ff')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              var users = snapshot.data!.docs;
              List<Widget> userWidgets = [];

              if (users.isEmpty) {
                return const Center(
                  child: Text(
                    'No search results found.',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                );
              }

              for (var userDoc in users) {
                var userData = userDoc.data() as Map<String, dynamic>;
                var userName = userData['name'];
                var userEmail = userData['email'];
                var profilePictureUrl = userData['profilePictureUrl'];

                var userWidget = ListTile(
                  leading: CircleAvatar(
                    backgroundImage: profilePictureUrl != null
                        ? NetworkImage(profilePictureUrl)
                        : Image.asset('assets/images/Default.jpg').image,
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(userName),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(userEmail),
                    ],
                  ),
                  onTap: () {},
                );
                userWidgets.add(userWidget);
              }

              return ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: userWidgets,
              );
            },
          );
  }
}
