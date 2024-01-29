import 'package:flutter/material.dart';
<<<<<<< Updated upstream
import 'package:h3devs/messages/messages.dart';
import 'package:h3devs/search/searchDrawer.dart';
=======
import 'package:h3devs/createPost/createPost.dart';
>>>>>>> Stashed changes

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
            child: Row(
              children: [
                Container(
                  width: 200.0,
                  color: Colors.white,
                  padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const HomeRoute(),
                            ),
                          );
                        },
                        child: const ListTile(
                          title: Text('Home'),
                          leading: Icon(Icons.home),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          openSearchDrawer(context);
                        },
                        child: const ListTile(
                          title: Text('Search'),
                          leading: Icon(Icons.search),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const ListTile(
                          title: Text('Discover'),
                          leading: Icon(Icons.explore),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const ListTile(
                          title: Text('Latest News'),
                          leading: Icon(Icons.new_releases),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const ListTile(
                          title: Text('Create a Post'),
                          leading: Icon(Icons.edit),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const ListTile(
                          title: Text('Notification'),
                          leading: Icon(Icons.notifications),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Messages()),
                          );
                        },
                        child: const ListTile(
                          title: Text('Messages'),
                          leading: Icon(Icons.message),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const ListTile(
                          title: Text('Profile'),
                          leading: Icon(Icons.person),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const ListTile(
                          title: Text('Settings'),
                          leading: Icon(Icons.settings),
                        ),
                      ),
                    ],
                  ),
<<<<<<< Updated upstream
=======
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreatePostScreen()),
                      );
                    },
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
>>>>>>> Stashed changes
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
