import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Socifire 🔥"),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.chat),
              label: Text("Chat"),
              onPressed: () {
                Navigator.pushNamed(context, '/chat');
              },
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.add),
              label: Text("Create Post"),
              onPressed: () {
                Navigator.pushNamed(context, '/post');
              },
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.feed),
              label: Text("Feed"),
              onPressed: () {
                Navigator.pushNamed(context, '/feed');
              },
            ),
          ],
        ),
      ),
    );
  }
}