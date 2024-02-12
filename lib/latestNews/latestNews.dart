import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class LatestNews extends StatefulWidget {
  @override
  _LatestNewsState createState() => _LatestNewsState();
}

class _LatestNewsState extends State<LatestNews> {
  final String apiKey = '1c864ea3432d4523aca77b44cb905591';
  final String apiUrl =
      'https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=';

  List<dynamic> newsArticles = [];

  Set<int> favorites = Set<int>();

  Future<void> fetchNews() async {
    var response = await http.get(Uri.parse(apiUrl + apiKey));
    if (response.statusCode == 200) {
      setState(() {
        newsArticles = json.decode(response.body)['articles'];
      });
    } else {
      throw Exception('Failed to load news');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  void toggleFavorite(int index) {
    setState(() {
      if (favorites.contains(index)) {
        favorites.remove(index);
      } else {
        favorites.add(index);
      }
    });
    updateFavoritesInFirestore();
  }

  void updateFavoritesInFirestore() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await FirebaseFirestore.instance.collection('favorites').doc(userId).set({
        'articles': favorites.toList(),
      }, SetOptions(merge: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Latest News'),
      ),
      body: ListView.builder(
        itemCount: newsArticles.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              title: Row(
                children: [
                  Expanded(
                    child: Text(newsArticles[index]['title']),
                  ),
                  IconButton(
                    icon: Icon(
                      favorites.contains(index)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color:
                          favorites.contains(index) ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      toggleFavorite(index);
                    },
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(newsArticles[index]['description'] ?? ''),
                  SizedBox(height: 8),
                  if (newsArticles[index]['urlToImage'] != null)
                    Container(
                      height: 100,
                      child: Image.network(
                        newsArticles[index]['urlToImage'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  if (newsArticles[index]['url'] != null)
                    TextButton(
                      onPressed: () {},
                      child: Text('Read more'),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LatestNews(),
  ));
}
