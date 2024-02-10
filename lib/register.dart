import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
        title: const Text(
          'Registration',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                height: double.infinity,
                child: Image.asset('assets/images/phone.png'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 120,
                ),
                child: FractionallySizedBox(
                  widthFactor: 0.6, // Adjust this value as needed
                  child: Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Center(
                              child: Text(
                                'Create your account',
                                style: TextStyle(
                                  fontSize:
                                      20, // Change the font size as needed
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            InkWell(
                              onTap: pickImage,
                              customBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Container(
                                height: 150,
                                width: 150,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[200],
                                ),
                                child: Center(
                                  child: imageBytes != null
                                      ? ClipOval(
                                          child: SizedBox(
                                            height: 140,
                                            width: 140,
                                            child: Image.memory(
                                              imageBytes!,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                      : const Icon(
                                          Icons.image,
                                          size: 70,
                                          color: Colors.grey,
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // ElevatedButton(
                            //   onPressed: pickImage,
                            //   child: const Text('Select Image'),
                            // ),
                            TextField(
                              controller: nameController,
                              decoration:
                                  const InputDecoration(labelText: 'Name'),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: emailController,
                              decoration:
                                  const InputDecoration(labelText: 'Email'),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: passwordController,
                              decoration:
                                  const InputDecoration(labelText: 'Password'),
                              obscureText: true,
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: confirmPasswordController,
                              decoration: const InputDecoration(
                                  labelText: 'Confirm Password'),
                              obscureText: true,
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: ageController,
                              decoration:
                                  const InputDecoration(labelText: 'Age'),
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: addressController,
                              decoration:
                                  const InputDecoration(labelText: 'Address'),
                              maxLines: null,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () async {
                                await _registerUser();
                              },
                              child: const Text('Register'),
                              style: ButtonStyle(
                                fixedSize: MaterialStateProperty.all<Size>(
                                  const Size(200,
                                      55), // Adjust width and height as needed
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pickImage() async {
    try {
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedImage != null) {
        final imageBytes = await pickedImage.readAsBytes();
        setState(() {
          this.imageBytes = Uint8List.fromList(imageBytes);
        });
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
            const SnackBar(
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

        await FirebaseFirestore.instance.collection('users').add({
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
          const SnackBar(
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
        const SnackBar(
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
