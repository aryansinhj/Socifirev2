import 'package:flutter/material.dart';
import 'login_page.dart';
import 'signup_page.dart';
import 'home_page.dart';
import 'feed_page.dart';
import 'post_page.dart';
import 'comment_page.dart';
import 'profile_page.dart';
import 'edit_profile_page.dart';
import 'chat_page.dart';
import 'other_user_profile_page.dart';

class SocifireApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Socifire',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/home': (context) => HomePage(),
        '/feed': (context) => FeedPage(),
        '/post': (context) => PostPage(),
        '/comment': (context) => CommentPage(),
        '/profile': (context) => ProfilePage(),
        '/edit_profile': (context) => EditProfilePage(),
        '/chat': (context) => ChatPage(),
        '/other_profile': (context) => OtherUserProfilePage(),
      },
    );
  }
}