import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  File? _selectedImage;
  File? _selectedVideo;
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickVideo() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.video);

    if (result != null) {
      setState(() {
        _selectedVideo = File(result.files.single.path!);
        _videoPlayerController = VideoPlayerController.file(_selectedVideo!);
        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          autoPlay: true,
          looping: false,
        );
      });
    }
  }

  void _saveToFirebase() async {
    if (_formKey.currentState!.validate()) {
      // Upload image to Firebase Storage
      String imageUrl = "";
      if (_selectedImage != null) {
        Reference storageReference =
            FirebaseStorage.instance.ref('images/${DateTime.now()}');
        UploadTask uploadTask = storageReference.putFile(_selectedImage!);
        await uploadTask.whenComplete(() async {
          imageUrl = await storageReference.getDownloadURL();
        });
      }

      // Upload video to Firebase Storage
      String videoUrl = "";
      if (_selectedVideo != null) {
        Reference storageReference =
            FirebaseStorage.instance.ref('videos/${DateTime.now()}');
        UploadTask uploadTask = storageReference.putFile(_selectedVideo!);
        await uploadTask.whenComplete(() async {
          videoUrl = await storageReference.getDownloadURL();
        });
      }

      // Save data to Firestore
      FirebaseFirestore.instance.collection('create_post').add({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'size': _sizeController.text,
        'price': _priceController.text,
        'location': _locationController.text,
        'imageUrl': imageUrl,
        'videoUrl': videoUrl,
      }).then((value) {
        print("Post added with ID: ${value.id}");
        // You can add further actions or navigate to another screen on successful save
      }).catchError((error) {
        print("Error adding post: $error");
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(
      'https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
    );
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      looping: false,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.0),
            _selectedImage != null
                ? Image.file(_selectedImage!, height: 80, width: 80)
                : GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Center(
                        child: Icon(Icons.camera_alt, color: Colors.grey),
                      ),
                    ),
                  ),
            SizedBox(height: 8.0),
            _selectedVideo != null
                ? Chewie(controller: _chewieController)
                : GestureDetector(
                    onTap: _pickVideo,
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Center(
                        child: Icon(Icons.video_library, color: Colors.grey),
                      ),
                    ),
                  ),
            SizedBox(height: 8.0),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      suffix: _buildRoundedContainer(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      suffix: _buildRoundedContainer(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _sizeController,
                    decoration: InputDecoration(
                      labelText: 'Size (SQT)',
                      suffix: _buildRoundedContainer(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the size';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(
                      labelText: 'Price',
                      suffix: _buildRoundedContainer(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the price';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      labelText: 'Location',
                      suffix: _buildRoundedContainer(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the location';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _saveToFirebase,
                    child: Text('Save'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundedContainer() {
    return Container(
      width: 30.0,
      height: 30.0,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Center(
        child: Icon(Icons.arrow_forward, color: Colors.grey),
      ),
    );
  }
}
