import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OtherUserProfilePage extends StatefulWidget {
  final String otherUserId;

  const OtherUserProfilePage({required this.otherUserId});

  @override
  _OtherUserProfilePageState createState() => _OtherUserProfilePageState();
}

class _OtherUserProfilePageState extends State<OtherUserProfilePage> {
  String username = '';
  String bio = '';
  String profilePicUrl = '';
  List followers = [];
  List following = [];
  bool isFollowing = false;
  String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.otherUserId)
        .get();

    if (userDoc.exists) {
      setState(() {
        username = userDoc['username'] ?? '';
        bio = userDoc['bio'] ?? '';
        profilePicUrl = userDoc['profilePic'] ?? '';
        followers = userDoc['followers'] ?? [];
        following = userDoc['following'] ?? [];
        isFollowing = followers.contains(currentUserId);
      });
    }
  }

  Future<void> toggleFollow() async {
    final userRef = FirebaseFirestore.instance.collection('users');

    setState(() {
      isFollowing = !isFollowing;
      if (isFollowing) {
        followers.add(currentUserId);
      } else {
        followers.remove(currentUserId);
      }
    });

    final currentDoc = await userRef.doc(currentUserId).get();
    List myFollowing = currentDoc['following'] ?? [];

    if (isFollowing) {
      myFollowing.add(widget.otherUserId);
    } else {
      myFollowing.remove(widget.otherUserId);
    }

    await userRef.doc(currentUserId).update({
      'following': myFollowing,
    });

    await userRef.doc(widget.otherUserId).update({
      'followers': followers,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(username.isEmpty ? 'Loading...' : username),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage:
                  profilePicUrl.isNotEmpty ? NetworkImage(profilePicUrl) : null,
              radius: 40,
              child: profilePicUrl.isEmpty ? Icon(Icons.person, size: 40) : null,
            ),
            SizedBox(height: 12),
            Text(username, style: TextStyle(fontSize: 22)),
            SizedBox(height: 8),
            Text(bio),
            SizedBox(height: 12),
            Text("Followers: ${followers.length}"),
            Text("Following: ${following.length}"),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: toggleFollow,
              child: Text(isFollowing ? "Unfollow" : "Follow"),
            ),
            Divider(height: 32),
            Text("User Posts", style: TextStyle(fontSize: 18)),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .where('userId', isEqualTo: widget.otherUserId)
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  final posts = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index].data() as Map<String, dynamic>;
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(post['text'] ?? ''),
                          subtitle: Text(post['username'] ?? ''),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}