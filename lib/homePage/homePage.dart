import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:h3devs/createPost/createPost.dart';
import 'package:h3devs/login.dart';
import 'package:h3devs/messages/screens/messages.dart';
import 'package:h3devs/notification/notificationDrawer.dart';
import 'package:h3devs/responsive/deskktop_body.dart';
import 'package:h3devs/responsive/mobile_body.dart';
import 'package:h3devs/responsive/reponsive_layout.dart';
import 'package:h3devs/search/searchDrawer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

void openSearchDrawer(BuildContext context) {
  Scaffold.of(context).openDrawer();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _currentUserUid;
  String? _currentUserName;

  @override
  void initState() {
    super.initState();
    _fetchUid();
  }

  void _fetchUid() async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      _currentUserUid = user?.uid;
    });

    if (_currentUserUid != null) {
      _fetchDocumentId();
    }
  }

  void _fetchDocumentId() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: _currentUserUid)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final docId = querySnapshot.docs.first.id;
      _fetchName(docId); // Pass the retrieved document ID
    } else {
      // Handle the case where no user document matches the UID
      debugPrint('User document not found in Firestore.');
    }
  }

  void _fetchName(String docId) async {
    final docSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(docId).get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      setState(() {
        _currentUserName = data?['name'];
      });
    } else {
      // Handle the case where the user document doesn't exist
      debugPrint('User document does not exist in Firestore.');
    }
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
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: PopupMenuButton<dynamic>(
              icon: const CircleAvatar(
                backgroundImage: AssetImage('assets/images/user.jpg'),
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child:
                      Text(_currentUserName ?? _currentUserUid ?? 'Loading...'),
                ),
                PopupMenuItem(
                  child: const Text('Logout'),
                  onTap: () async {
                    // Perform the logout logic
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pop(); // Close the dialog
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          return Scaffold(
            body: ResponsiveLayout(
              mobileBody: MyMobileBody(),
              desktopBody: MyDesktopBody(),
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

BoxDecoration buildBoxDecoration() {
  return BoxDecoration(
    color: Color.fromARGB(255, 255, 255, 255),
    borderRadius: BorderRadius.circular(16.0),
  );
}

class HighlightsCategory extends StatelessWidget {
  const HighlightsCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      width: 850,
      decoration: buildBoxDecoration(),
      padding: EdgeInsets.all(18.0),
      child: const Text(
        'This is for highlights category.',
        style: TextStyle(
            color: Color.fromARGB(255, 5, 5, 5), fontWeight: FontWeight.bold),
      ),
    );
  }
}

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: 850,
      decoration: buildBoxDecoration(),
      padding: EdgeInsets.all(18.0),
      child: const Text(
        'This is for body.',
        style: TextStyle(
            color: Color.fromARGB(255, 5, 5, 5), fontWeight: FontWeight.bold),
      ),
    );
  }
}

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  void openSearchDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                MaterialPageRoute(builder: (context) => RealEstateForm()),
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
    );
  }
}
