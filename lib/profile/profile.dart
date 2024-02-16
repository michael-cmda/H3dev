import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late User? _currentUser;
  Uint8List? _imageBytes;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload(); // Reload the user to fetch updated data
      setState(() {
        _currentUser = FirebaseAuth.instance.currentUser;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: _currentUser != null
          ? LayoutBuilder(
              builder: (context, constraints) {
                return Center(
                  child: SizedBox(
                    width: constraints.maxWidth * 0.8,
                    height: constraints.maxHeight * 0.8,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _currentUser!.photoURL != null
                              ? CircleAvatar(
                                  radius: 80,
                                  backgroundImage:
                                      NetworkImage(_currentUser!.photoURL!),
                                )
                              : Container(
                                  height: 160,
                                  width: 160,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey[200],
                                  ),
                                  child: const Icon(Icons.person,
                                      size: 100, color: Colors.grey),
                                ),
                          const SizedBox(height: 16.0),
                          Container(
                            margin: const EdgeInsets.only(left: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _currentUser!.displayName ?? 'N/A',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(width: 10.0),
                                    IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.settings))
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.black54,
                                                width: 1.0,
                                              ),
                                            ),
                                            child: IconButton(
                                              onPressed: () {},
                                              icon: const Icon(Icons.favorite),
                                            ),
                                          ),
                                          const SizedBox(height: 14.0),
                                          const Text(
                                            '10',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          const SizedBox(height: 6.0),
                                          const Text(
                                            'Favorites',
                                            style: TextStyle(fontSize: 18),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.black54,
                                                width: 1.0,
                                              ),
                                            ),
                                            child: IconButton(
                                              onPressed: () {},
                                              icon: const Icon(
                                                  Icons.article_rounded),
                                            ),
                                          ),
                                          const SizedBox(height: 14.0),
                                          const Text(
                                            '6',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          const SizedBox(height: 6.0),
                                          const Text(
                                            'Articles',
                                            style: TextStyle(fontSize: 18),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.black54,
                                                width: 1.0,
                                              ),
                                            ),
                                            child: IconButton(
                                              onPressed: () {},
                                              icon: const Icon(Icons.image),
                                            ),
                                          ),
                                          const SizedBox(height: 14.0),
                                          const Text(
                                            '23',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          const SizedBox(height: 6.0),
                                          const Text(
                                            'Posts',
                                            style: TextStyle(fontSize: 18),
                                          )
                                        ],
                                      ),
                                    ),
                                    /*Text(
                                    'Email: ${_currentUser!.email}',
                                    style: const TextStyle(fontSize: 18),
                                  ),*/
                                  ],
                                ),
                                const SizedBox(height: 12),
                              ],
                            ),
                          ),
                          TabBar(
                            controller: _tabController,
                            tabs: const [
                              Tab(icon: Icon(Icons.image), text: 'Posts'),
                              Tab(
                                  icon: Icon(Icons.article_rounded),
                                  text: 'Articles'),
                              Tab(
                                  icon: Icon(Icons.favorite),
                                  text: 'Favorites'),
                            ],
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.black87,
                          ),
                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: const [
                                PostsScreen(),
                                ArticlesScreen(),
                                FavoritesScreen(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class PostsScreen extends StatelessWidget {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('This is the Posts tab'),
    );
  }
}

class ArticlesScreen extends StatelessWidget {
  const ArticlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('This is the Articles tab'),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('favorites')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (!snapshot.hasData || snapshot.data!.data() == null) {
          return Center(
            child: Text('No favorites yet.'),
          );
        } else {
          Map<String, dynamic> favoritesData =
              snapshot.data!.data()! as Map<String, dynamic>;
          List<dynamic> favoritesList = favoritesData['favorites'] ?? [];

          if (favoritesList.isEmpty) {
            return Center(
              child: Text('You have no favorites selected.'),
            );
          }

          return ListView.builder(
            itemCount: favoritesList.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> favoriteItem = favoritesList[index];
              return ListTile(
                title: Text(favoriteItem['data']['address']['full']),
                subtitle: Text('Price: \$${favoriteItem['data']['listPrice']}'),
                trailing: IconButton(
                  icon: Icon(Icons.favorite, color: Colors.red),
                  onPressed: () {},
                ),
              );
            },
          );
        }
      },
    );
  }
}
