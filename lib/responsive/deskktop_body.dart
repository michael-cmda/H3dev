import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:h3devs/createPost/createPost.dart';
import 'package:h3devs/discover/discover.dart';
import 'package:h3devs/homePage/homePage.dart';
import 'package:h3devs/latestNews/latestNews.dart';
import 'package:h3devs/messages/screens/messages.dart';
import 'package:h3devs/notification/notificationDrawer.dart';
import 'package:h3devs/search/searchDrawer.dart';

class MyDesktopBody extends StatelessWidget {
  const MyDesktopBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 243, 243, 243),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Second column (assuming YourWidget2 is a widget you want to position)
            Stack(
              children: [
                Positioned(
                  child: Sidebar(),
                  // Adjust the position as needed
                ),
              ],
            ),

            // First column
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // youtube video
                    Positioned(
                      child: HighlightCategory(),
                    ),

                    // comment section & recommended videos
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: Column(
                          children: [
                            // youtube video
                            Positioned(
                              child: HomeBody(),
                            ),

                            // comment section & recommended videos
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Third column
            Stack(
              children: [
                // Positioned widget for YourWidget4
                Column(
                  children: [
                    Positioned(child: HomeProfileWidget()
                        // Adjust the position as needed for YourWidget4
                        ),
                    Positioned(child: HomeMessagesWidget()),
                  ],
                ),

                // Another Positioned widget for YourWidget5 under YourWidget4
              ],
            ),
          ],
        ),
      ),
      drawer: SearchDrawer(),
    );
  }
}

BoxDecoration buildBoxDecoration() {
  return BoxDecoration(
    color: const Color.fromARGB(255, 255, 255, 255),
    borderRadius: BorderRadius.circular(16.0),
  );
}

class HighlightCategory extends StatelessWidget {
  const HighlightCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('listings').snapshots(),
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData ||
            snapshot.data == null ||
            snapshot.data!.docs.isEmpty) {
          return SizedBox.shrink(); // No data found
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0), // Rounded border
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 3,
                offset: Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Highlight',
                style: TextStyle(
                  color: Color.fromARGB(255, 5, 5, 5),
                  fontWeight: FontWeight.bold,
                  fontSize: 25, // Adjust font size as needed
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height:
                    MediaQuery.of(context).size.height * 0.15, // Reduced height
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final document = snapshot.data!.docs[index];
                    final data = document.data();
                    final List<dynamic>? images = data!['images'];

                    if (images == null || images.isEmpty) {
                      return SizedBox.shrink(); // Skip if no images
                    }

                    int maxImagesToShow = 5;
                    double itemWidth =
                        MediaQuery.of(context).size.width / maxImagesToShow;

                    return Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: SizedBox(
                        width: itemWidth < 100
                            ? itemWidth
                            : 100, // Set a minimum width of 100
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(10.0), // Rounded border
                          child: Image.network(
                            images[0], // Fetching only the first image
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class HomeBody extends StatelessWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('listings').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data found'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final document = snapshot.data!.docs[index];
              final data = document.data();
              final List<dynamic>? images = data!['images'];
              final description = data['description'];

              if (images == null || images.isEmpty) {
                return SizedBox(); // Skip if no images
              }

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.all(20.0),
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      description ?? '',
                      style: TextStyle(
                        color: Color.fromARGB(255, 5, 5, 5),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.25,
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.network(
                                    images[0],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              if (images.length >= 2)
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width * 0.2,
                                  width: double.infinity,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.network(
                                      images[1],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (images.length > 2)
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width * 0.2,
                                  width: double.infinity,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.network(
                                      images[2],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              if (images.length > 3)
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width * 0.2,
                                  width: double.infinity,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.network(
                                      images[3],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class HomeProfileWidget extends StatelessWidget {
  const HomeProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    if (screenWidth >= 1000 && screenHeight >= 580) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.22,
        height: MediaQuery.of(context).size.height * 0.55,
        padding: const EdgeInsets.only(bottom: 16.0, right: 16.0),
        margin: const EdgeInsets.only(top: 16, bottom: 16, right: 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26.0),
          color: Colors.white,
        ),

        // Add your child widget(s) here
      );
    } else {
      // Provide a default return statement
      return const SizedBox
          .shrink(); // You can use SizedBox.shrink() or any other widget here.
    }
  }
}

class HomeMessagesWidget extends StatelessWidget {
  const HomeMessagesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    if (screenWidth >= 1000 && screenHeight >= 580) {
      return Flexible(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.22,
          height: MediaQuery.of(context).size.height * 0.335,
          padding: const EdgeInsets.only(bottom: 16.0, right: 16.0),
          margin: const EdgeInsets.only(top: 0, bottom: 16, right: 16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26.0),
            color: Colors.white,
          ),

          // Add your child widget(s) here
        ),
      );
    } else {
      // Provide a default return statement
      return const SizedBox
          .shrink(); // You can use SizedBox.shrink() or any other widget here.
    }
  }
}

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  void openSearchDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    if (screenWidth >= 1000 && screenHeight >= 660) {
      return Flexible(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.18,
          padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
          margin: const EdgeInsets.only(left: 22.0, top: 16.0, bottom: 16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26.0),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
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
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Discover()));
                },
                child: const ListTile(
                  minLeadingWidth: 30,
                  title: Text('Discover'),
                  leading: Icon(Icons.explore),
                ),
              ),
              const SizedBox(height: 6.0),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => MyHomePage(),
                    ),
                  );
                },
                child: const ListTile(
                  minLeadingWidth: 30,
                  title: Text('Latest News'),
                  leading: Icon(Icons.new_releases),
                ),
              ),
              const SizedBox(height: 10.0),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            20.0, // Adjust radius as needed
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              20.0, // Same as dialog border radius
                            ),
                            border: Border.all(
                              color: Colors.grey, // Grey border color
                              width: 2.0, // Border width
                            ),
                          ),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width *
                                0.6, // Decreased width to 70% of screen width
                            height: MediaQuery.of(context).size.height *
                                0.7, // Increased height to 80% of screen height
                            child: RealEstateForm(),
                          ),
                        ),
                      );
                    },
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Messages()),
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
      );
    } else {
      // Provide a default return statement
      return const SizedBox
          .shrink(); // You can use SizedBox.shrink() or any other widget here.
    }
  }
}
