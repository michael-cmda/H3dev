import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/logo.jpg', height: 30.0, width: 30.0),
            SizedBox(width: 8.0),
            Text('CITY LOADS'),
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: CircleAvatar(
                backgroundImage: AssetImage('assets/images/ChaHae.jpg'),
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          bottomLeft: Radius.circular(20.0),
        ),
        child: Row(
          children: [
            Container(
              width: 200.0,
              color: Colors.white,
              padding: EdgeInsets.only(left: 16.0, bottom: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => HomeRoute(),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text('Home'),
                      leading: Icon(Icons.home),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: ListTile(
                      title: Text('Search'),
                      leading: Icon(Icons.search),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: ListTile(
                      title: Text('Discover'),
                      leading: Icon(Icons.explore),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: ListTile(
                      title: Text('Latest News'),
                      leading: Icon(Icons.new_releases),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: ListTile(
                      title: Text('Create a Post'),
                      leading: Icon(Icons.edit),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: ListTile(
                      title: Text('Notification'),
                      leading: Icon(Icons.notifications),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: ListTile(
                      title: Text('Messages'),
                      leading: Icon(Icons.message),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: ListTile(
                      title: Text('Profile'),
                      leading: Icon(Icons.person),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: ListTile(
                      title: Text('Settings'),
                      leading: Icon(Icons.settings),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.grey[200],
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text('THIS IS HOME PAGE'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Text('This is the Home route.'),
      ),
    );
  }
}
