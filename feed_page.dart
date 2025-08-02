import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'comment_page.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  Future<void> toggleLike(String postId, bool liked) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final likesRef = FirebaseFirestore.instance.collection('posts').doc(postId).collection('likes');

    if (liked) {
      await likesRef.doc(userId).delete();
    } else {
      await likesRef.doc(userId).set({'likedAt': Timestamp.now()});
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: Text('Feed')),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          final posts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final data = posts[index];
              final postId = data.id;

              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  title: Text(data['username']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data['text']),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('posts')
                            .doc(postId)
                            .collection('likes')
                            .snapshots(),
                        builder: (context, snapshotLikes) {
                          if (!snapshotLikes.hasData) return SizedBox.shrink();
                          final likes = snapshotLikes.data!.docs;
                          final isLiked = likes.any((doc) => doc.id == userId);

                          return Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  isLiked ? Icons.favorite : Icons.favorite_border,
                                  color: isLiked ? Colors.red : null,
                                ),
                                onPressed: () => toggleLike(postId, isLiked),
                              ),
                              Text('${likes.length}'),
                              IconButton(
                                icon: Icon(Icons.comment),
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CommentPage(postId: postId),
                                  ),
                                ),
                              ),
                            ],
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
    );
  }
}