import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyMobileBody extends StatelessWidget {
  const MyMobileBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 242, 238, 232),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            // comment section & recommended videos
            Expanded(
              child: HomeBody(),
            )
          ],
        ),
      ),
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
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No data found'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final document = snapshot.data!.docs[index];
              final data = document.data();
              final List<dynamic>? images = data!['images'];
              final description = data['description'];
              final documentId = document.id; // Get the document ID

              if (images == null || images.isEmpty) {
                return const SizedBox(); // Skip if no images
              }

              // Function to add a comment to Firestore
              void addComment(String comment) {
                FirebaseFirestore.instance
                    .collection('comments')
                    .doc(documentId)
                    .collection('comments')
                    .add({
                  'comment': comment,
                  'timestamp': Timestamp.now(),
                });
              }

              // Function to delete a comment from Firestore
              void deleteComment(String commentId) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Delete Comment"),
                      content: const Text(
                          "Are you sure you want to delete this comment?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('comments')
                                .doc(documentId)
                                .collection('comments')
                                .doc(commentId)
                                .delete();
                            Navigator.pop(context);
                          },
                          child: const Text("Delete"),
                        ),
                      ],
                    );
                  },
                );
              }

              return Container(
                // ... (same as provided code)
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.all(10.0),
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 200, // Fixed height for the image containers
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.grey[200],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  images.length > 0 ? images[0] : '',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            flex: 3,
                            child: images.length > 1
                                ? Container(
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.grey[200],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Image.network(
                                        images[1],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ),
                        ],
                      ),
                    ),
                    if (images.length > 2) const SizedBox(height: 5),
                    if (images.length > 2)
                      SizedBox(
                        height: 200,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.grey[200],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.network(
                                    images[2],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: images.length > 3
                                  ? Container(
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: Colors.grey[200],
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: Image.network(
                                          images[3],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('comments')
                              .doc(documentId)
                              .collection('comments')
                              .orderBy('timestamp', descending: true)
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                  commentSnapshot) {
                            if (commentSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (commentSnapshot.hasError) {
                              return Center(
                                  child:
                                      Text('Error: ${commentSnapshot.error}'));
                            }
                            if (!commentSnapshot.hasData ||
                                commentSnapshot.data == null ||
                                commentSnapshot.data!.docs.isEmpty) {
                              return const SizedBox();
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:
                                  commentSnapshot.data!.docs.map((commentDoc) {
                                final commentData = commentDoc.data();
                                final commentText = commentData['comment'];
                                final commentId = commentDoc.id;
                                return Container(
                                  padding: const EdgeInsets.all(10.0),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          commentText,
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          // Handle three-dot icon tap, e.g., delete comment
                                          deleteComment(commentId);
                                        },
                                        child: const Icon(Icons.more_vert),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                              ),
                              child: TextField(
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Write a comment...',
                                ),
                                onSubmitted: (comment) {
                                  // Call the function to add comment to Firestore
                                  addComment(comment);
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Favorites(),
                        const SizedBox(width: 10),
                        const Icon(Icons.comment),
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

class Favorites extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Favorites> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite
            ? Colors.red
            : null, // Set color to red when it's a favorite
      ),
      onPressed: () {
        setState(() {
          isFavorite = !isFavorite; // Toggle the favorite status
        });
      },
    );
  }
}
