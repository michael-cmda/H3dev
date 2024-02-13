import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LatestNews extends StatefulWidget {
  @override
  _LatestNewsState createState() => _LatestNewsState();
}

class _LatestNewsState extends State<LatestNews> {
  final String apiUrl = 'https://api.simplyrets.com/properties';

  List<dynamic> properties = [];

  Set<int> favorites = Set<int>();

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

  void toggleFavorite(int index) {
    setState(() {
      if (favorites.contains(index)) {
        favorites.remove(index);
      } else {
        favorites.add(index);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchProperties();
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
                  favorites.contains(index)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: favorites.contains(index) ? Colors.red : Colors.grey,
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

void main() {
  runApp(MaterialApp(
    home: LatestNews(),
  ));
}
