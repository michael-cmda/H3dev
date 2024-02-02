import 'package:flutter/material.dart';
import 'package:h3devs/createPost/createPost.dart';
import 'package:h3devs/messages/messages.dart';
import 'package:h3devs/notification/notificationDrawer.dart';
import 'package:h3devs/search/searchDrawer.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  void openSearchDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SearchDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 30.0, width: 30.0),
            const SizedBox(width: 8.0),
            const Text('CITY LOADS'),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const CircleAvatar(
                backgroundImage: AssetImage('assets/images/user.jpg'),
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          return ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              bottomLeft: Radius.circular(20.0),
            ),
            child: Container(
              color: Colors.grey[200],
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.18,
                    padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
                    margin: const EdgeInsets.only(
                        left: 22.0, top: 16.0, bottom: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26.0),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const HomeRoute(),
                              ),
                            );
                          },
                          child: const ListTile(
                            minLeadingWidth: 30,
                            title: Text('Home'),
                            leading: Icon(Icons.home),
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        GestureDetector(
                          onTap: () {
                            openSearchDrawer(context);
                          },
                          child: const ListTile(
                            minLeadingWidth: 30,
                            title: Text('Search'),
                            leading: Icon(Icons.search),
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        GestureDetector(
                          onTap: () {},
                          child: const ListTile(
                            minLeadingWidth: 30,
                            title: Text('Discover'),
                            leading: Icon(Icons.explore),
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        GestureDetector(
                          onTap: () {},
                          child: const ListTile(
                            minLeadingWidth: 30,
                            title: Text('Latest News'),
                            leading: Icon(Icons.new_releases),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RealEstateForm()),
                            );
                          },
                          child: const ListTile(
                            minLeadingWidth: 30,
                            title: Text('Create a Post'),
                            leading: Icon(Icons.edit),
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        GestureDetector(
                          onTap: () {
                            const NotificationDrawer();
                          },
                          child: const ListTile(
                            minLeadingWidth: 30,
                            title: Text('Notification'),
                            leading: Icon(Icons.notifications),
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Messages()),
                            );
                          },
                          child: const ListTile(
                            minLeadingWidth: 30,
                            title: Text('Messages'),
                            leading: Icon(Icons.message),
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        GestureDetector(
                          onTap: () {},
                          child: const ListTile(
                            minLeadingWidth: 30,
                            title: Text('Profile'),
                            leading: Icon(Icons.person),
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        GestureDetector(
                          onTap: () {},
                          child: const ListTile(
                            minLeadingWidth: 30,
                            title: Text('Settings'),
                            leading: Icon(Icons.settings),
                          ),
                        ),
                        const SizedBox(height: 6.0),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.grey[200],
                      padding: const EdgeInsets.all(16.0),
                      child: const Center(
                        child: Text('THIS IS HOME PAGE'),
                      ),
                    ),
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

class HomeRoute extends StatelessWidget {
  const HomeRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: const Center(
        child: Text('This is the Home route.'),
      ),
    );
  }
}
