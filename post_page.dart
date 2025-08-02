import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'comment_page.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final TextEditingController postController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;

  void uploadPost() async {
    if (postController.text.trim().isEmpty) return;

    await FirebaseFirestore.instance.collection('posts').add({
      'text': postController.text.trim(),
      'likes': [],
      'timestamp': Timestamp.now(),
      'userId': currentUser!.uid,
    });

    postController.clear();
  }

  void toggleLike(String postId, List likes) async {
    final userId = currentUser!.uid;
    final isLiked = likes.contains(userId);

    final doc = FirebaseFirestore.instance.collection('posts').doc(postId);
    if (isLiked) {
      await doc.update({
        'likes': FieldValue.arrayRemove([userId]),
      });
    } else {
      await doc.update({
        'likes': FieldValue.arrayUnion([userId]),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Post Something")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: postController,
              decoration: InputDecoration(
                hintText: "What's on your mind?",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: uploadPost,
            child: Text("Post"),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();

                final posts = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    final postId = post.id;
                    final data = post.data();
                    final text = data['text'];
                    final likes = List<String>.from(data['likes'] ?? []);
                    final isLiked = likes.contains(currentUser!.uid);

                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: ListTile(
                        title: Text(text),
                        subtitle: Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.thumb_up,
                                color: isLiked ? Colors.blue : Colors.grey,
                              ),
                              onPressed: () =>
                                  toggleLike(postId, likes),
                            ),
                            Text("${likes.length}"),
                            IconButton(
                              icon: Icon(Icons.comment),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CommentPage(postId: postId),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}