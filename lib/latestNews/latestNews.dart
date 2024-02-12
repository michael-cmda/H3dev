import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LatestNews extends StatefulWidget {
  @override
  _LatestNewsState createState() => _LatestNewsState();
}

class _LatestNewsState extends State<LatestNews> {
  final String apiKey = '1c864ea3432d4523aca77b44cb905591';
  final String apiUrl =
      'https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=';

  List<dynamic> newsArticles = [];

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
              title: Text(newsArticles[index]['title']),
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
                  if (newsArticles[index]['url'] !=
                      null) // Check if URL is available
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
