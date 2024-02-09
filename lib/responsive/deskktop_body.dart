import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:h3devs/createPost/createPost.dart';
import 'package:h3devs/discover/discover.dart';
import 'package:h3devs/homePage/homePage.dart';
import 'package:h3devs/messages/screens/messages.dart';
import 'package:h3devs/notification/notificationDrawer.dart';

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
          )),
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
  const HighlightCategory({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    if (screenHeight >= 580) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.25,
        decoration: buildBoxDecoration(),
        padding: const EdgeInsets.all(20.0),
        child: const AspectRatio(
          aspectRatio: 16 / 2,
          child: Text(
            'Highlight',
            style: TextStyle(
              color: Color.fromARGB(255, 5, 5, 5),
              fontWeight: FontWeight.bold,
              fontSize: 25, // Adjust font size as needed
            ),
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
                height: MediaQuery.of(context).size.height * 0.635,
                decoration: buildBoxDecoration(),
                padding: const EdgeInsets.all(20.0),
                child: AspectRatio(
                  aspectRatio: 16 / 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: images.length,
                          itemBuilder: (context, index) {
                            final imageUrl = images[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  imageUrl,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        description ?? '',
                        style: TextStyle(
                          color: Color.fromARGB(255, 5, 5, 5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
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
