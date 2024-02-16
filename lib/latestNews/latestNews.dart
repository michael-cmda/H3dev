import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

class LatestNews extends StatefulWidget {
  @override
  _LatestNewsState createState() => _LatestNewsState();
}

class _LatestNewsState extends State<LatestNews> {
  final String apiUrl = 'https://api.simplyrets.com/properties';

  List<dynamic> properties = [];

  Set<int> favorites = Set<int>();

  Map<int, bool> clickedFavorites = {};

  Future<User?> getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user;
  }

  Future<void> fetchProperties() async {
    var response = await http.get(Uri.parse(apiUrl), headers: {
      "Authorization":
          "Basic " + base64Encode(utf8.encode("simplyrets:simplyrets"))
    });
    if (response.statusCode == 200) {
      setState(() {
        properties = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load properties');
    }
  }

  Future<void> fetchFavorites() async {
    User? user = await getCurrentUser();
    if (user != null) {
      String userId = user.uid;
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('favorites')
          .doc(userId)
          .get();
      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        if (data != null) {
          setState(() {
            favorites.clear();
            clickedFavorites.clear();
            List<dynamic> favoritesData = data['favorites'] ?? [];
            for (var favoriteData in favoritesData) {
              var index = favoriteData['index'];
              var clicked = favoriteData['clicked'] ?? false;
              if (clicked) {
                favorites.add(index);
              }
              clickedFavorites[index] = clicked;
            }
          });
        }
      }
    }
  }

  void toggleFavorite(int index) async {
    print('Toggle favorite called for index: $index');
    User? user = await getCurrentUser();
    if (user != null) {
      String userId = user.uid;
      Map<String, dynamic> propertyData = properties[index];
      bool isFavorite = favorites.contains(index);
      setState(() {
        if (isFavorite) {
          favorites.remove(index);
          clickedFavorites[index] = false;
          FirebaseFirestore.instance
              .collection('favorites')
              .doc(userId)
              .update({
            'favorites': FieldValue.arrayRemove([
              {
                'index': index,
                'data': propertyData,
                'clicked': true,
              }
            ]),
          });
        } else {
          favorites.add(index);
          clickedFavorites[index] = true;
          FirebaseFirestore.instance.collection('favorites').doc(userId).set(
            {
              'favorites': FieldValue.arrayUnion([
                {
                  'index': index,
                  'data': propertyData,
                  'clicked': true,
                }
              ]),
            },
            SetOptions(merge: true),
          );
        }
      });
    } else {
      print('No user logged in.');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProperties();
    fetchFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Latest Properties'),
      ),
      body: ListView.builder(
        itemCount: properties.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              title: Text(properties[index]['address']['full']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Price: \$${properties[index]['listPrice']}'),
                  Text('Area: ${properties[index]['property']['area']} sqft'),
                  Text(
                      'Bedrooms: ${properties[index]['property']['bedrooms']}'),
                  Text(
                      'Bathrooms: ${properties[index]['property']['bathsFull']}'),
                  if (properties[index]['photos'] != null &&
                      properties[index]['photos'].isNotEmpty)
                    Image.network(
                      properties[index]['photos'][0],
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                ],
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: clickedFavorites.containsKey(index) &&
                          clickedFavorites[index] == true
                      ? Colors.red
                      : Colors.grey,
                ),
                onPressed: () {
                  toggleFavorite(index);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: LatestNews(),
  ));
}
