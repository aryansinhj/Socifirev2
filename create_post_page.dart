import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController captionController = TextEditingController();
  File? selectedImage;

  Future<void> pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        selectedImage = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Post')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            selectedImage != null
                ? Image.file(selectedImage!, height: 200)
                : Text('No image selected.'),
            ElevatedButton(
              onPressed: pickImage,
              child: Text('Pick Image'),
            ),
            TextField(
              controller: captionController,
              decoration: InputDecoration(hintText: 'Enter a caption...'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Firebase upload logic will come here in next step
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Post created! (Firebase coming next...)')),
                );
              },
              child: Text('Upload Post'),
            ),
          ],
        ),
      ),
    );
  }
}