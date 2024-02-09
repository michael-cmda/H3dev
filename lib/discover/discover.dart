import 'package:flutter/material.dart';

class Discover extends StatelessWidget {
  const Discover({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Discover',
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Discover',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        body: CountryGrid(),
      ),
    );
  }
}

class CountryGrid extends StatelessWidget {
  // Define a list of countries with their flags and names
  final List<Map<String, dynamic>> countries = [
    {"name": "USA", "image": "assets/images/US-Flag.webp", "cityCount": 4},
    {"name": "UK", "image": "assets/images/UK_Flag.jpg", "cityCount": 14},
    {
      "name": "France",
      "image": "assets/images/France-Flag.webp",
      "cityCount": 9
    },
    {
      "name": "Germany",
      "image": "assets/images/Germany-flag.webp",
      "cityCount": 6
    },
    // Add more countries as needed
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: countries.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _getCrossAxisCount(context),
        childAspectRatio: 3 / 2, // You can adjust the aspect ratio as needed
      ),
      itemBuilder: (BuildContext context, int index) {
        return CountryItem(
          name: countries[index]["name"],
          image: countries[index]["image"],
          cityCount: countries[index]["cityCount"],
        );
      },
    );
  }

  // Function to determine the cross axis count based on screen size
  int _getCrossAxisCount(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 600) {
      return 1; // For small screens, show one box per row
    } else if (screenWidth < 1200) {
      return 2; // For medium screens, show two boxes per row
    } else {
      return 4; // For large screens, show three boxes per row
    }
  }
}

class CountryItem extends StatelessWidget {
  final String name;
  final String image;
  final int cityCount;

  const CountryItem({
    Key? key,
    required this.name,
    required this.image,
    required this.cityCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.20,
        height: 50,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            // Display the flag image with gradient opacity
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black],
                ).createShader(bounds);
              },
              blendMode: BlendMode.darken,
              child: Image.asset(
                image,
                fit: BoxFit.cover,
              ),
            ),
            // Overlay texts at the bottom
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    //mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$cityCount Cities',
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          letterSpacing: 0.10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
