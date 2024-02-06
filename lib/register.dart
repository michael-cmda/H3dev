import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  late TextEditingController ageController;
  late TextEditingController addressController;
  Uint8List? imageBytes;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    ageController = TextEditingController();
    addressController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    ageController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: pickImage,
                child: Text('Select Image'),
              ),
              SizedBox(height: 12),
              imageBytes != null
                  ? GestureDetector(
                      onTap: pickImage,
                      child: Image.memory(
                        imageBytes!,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      height: 100,
                      width: 100,
                      color: Colors.grey[200],
                    ),
              SizedBox(height: 12),
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              SizedBox(height: 12),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 12),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 12),
              TextField(
                controller: confirmPasswordController,
                decoration: InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
              ),
              SizedBox(height: 12),
              TextField(
                controller: ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 12),
              TextField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Address'),
                maxLines: null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await _registerUser();
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> pickImage() async {
    try {
      if (!kIsWeb) {
        final pickedImage = await ImagePicker().pickImage(
          source: ImageSource.gallery,
        );
        if (pickedImage != null) {
          final imageBytes = await pickedImage.readAsBytes();
          setState(() {
            this.imageBytes = Uint8List.fromList(imageBytes);
          });
        }
      } else {
        final FilePickerResult? pickedImage =
            await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['jpg', 'jpeg', 'png'],
          allowMultiple: false,
        );

        if (pickedImage != null && pickedImage.files.isNotEmpty) {
          setState(() {
            imageBytes = pickedImage.files.single.bytes;
          });
        }
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _registerUser() async {
    try {
      if (_validateInputs()) {
        if (passwordController.text != confirmPasswordController.text) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Passwords do not match.'),
            ),
          );
          return;
        }

        String imageUrl = await _uploadImageToStorage();

        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        String uid = userCredential.user!.uid;

        await FirebaseFirestore.instance.collection('users').add({
          'uid': uid,
          'name': nameController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'age': int.parse(ageController.text),
          'address': addressController.text,
          'profile_image': imageUrl,
        });

        nameController.clear();
        emailController.clear();
        passwordController.clear();
        confirmPasswordController.clear();
        ageController.clear();
        addressController.clear();
        setState(() {
          imageBytes = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration Successful!'),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration failed: $error'),
        ),
      );
    }
  }

  bool _validateInputs() {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty ||
        ageController.text.isEmpty ||
        addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all fields.'),
        ),
      );
      return false;
    }
    return true;
  }

  Future<String> _uploadImageToStorage() async {
    if (imageBytes == null) return '';

    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('profile_images/${DateTime.now().millisecondsSinceEpoch}');

    UploadTask uploadTask = storageReference.putData(imageBytes!);
    TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
