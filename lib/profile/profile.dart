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

class _ProfilePageState extends State<ProfilePage> {
  late User? _currentUser;
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
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
          ? Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.35,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.10,
                    child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20.0),
                          height: MediaQuery.of(context).size.height * 0.25,
                          width: MediaQuery.of(context).size.width * 0.50,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
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
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(left: 20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                        Icons.favorite),
                                                  ),
                                                ),
                                                const SizedBox(height: 14.0),
                                                const Text(
                                                  '10',
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                                const SizedBox(height: 6.0),
                                                const Text(
                                                  'Favorites',
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                        Icons.article),
                                                  ),
                                                ),
                                                const SizedBox(height: 14.0),
                                                const Text(
                                                  '6',
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                                const SizedBox(height: 6.0),
                                                const Text(
                                                  'Articles',
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                    icon:
                                                        const Icon(Icons.image),
                                                  ),
                                                ),
                                                const SizedBox(height: 14.0),
                                                const Text(
                                                  '23',
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                                const SizedBox(height: 6.0),
                                                const Text(
                                                  'Posts',
                                                  style:
                                                      TextStyle(fontSize: 18),
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
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
