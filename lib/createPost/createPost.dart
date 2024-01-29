import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class RealEstateForm extends StatefulWidget {
  @override
  _RealEstateFormState createState() => _RealEstateFormState();
}

class _RealEstateFormState extends State<RealEstateForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _yearBuiltController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<String> _selectedImages = [];

  int _bedroomCount = 0;
  int _bathCount = 0;
  int _floorCount = 0;
  bool _isCarParkingChecked = false;
  bool _isRentChecked = false;
  bool _isSaleChecked = false;
  bool _isFurnishedChecked = false;
  bool _isNotFurnishedChecked = false;
  bool _isMaidRoomChecked = false;

  List<String> _selectedTypes = [];

  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Card(
            elevation: 4.0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(color: Colors.grey, width: 1.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildTitle('Create Post'),
                  SizedBox(height: 16.0),
                  Divider(
                    color: Colors.grey,
                    thickness: 2.0,
                    height: 16.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabeledTextField('Title', _titleController),
                            SizedBox(height: 12.0),
                            _buildLabeledTextField(
                                'Built', _yearBuiltController),
                            SizedBox(height: 12.0),
                            _buildLabeledTextField(
                                'Description', _descriptionController),
                            SizedBox(height: 12.0),
                            _buildLabeledTextField(
                                'Size in SQFT', _sizeController),
                            SizedBox(height: 12.0),
                            _buildLabeledTextField('Price', _priceController),
                            SizedBox(height: 12.0),
                            _buildLabeledTextField(
                                'Location', _locationController),
                            _buildImageSelector()
                          ],
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTypeSelector(),
                            _buildNumberInputWithLabel(
                                'Bedroom',
                                _bedroomCount,
                                _incrementBedroom,
                                _decrementBedroom,
                                Icons.king_bed),
                            _buildNumberInputWithLabel('Baths', _bathCount,
                                _incrementBath, _decrementBath, Icons.bathtub),
                            _buildNumberInputWithLabel('Floor', _floorCount,
                                _incrementFloor, _decrementFloor, Icons.layers),
                            _buildLabeledCheckbox(
                                'Car Parking', _isCarParkingChecked,
                                (newValue) {
                              setState(() {
                                _isCarParkingChecked = newValue ?? false;
                              });
                            }),
                            _buildAvailableForCheckbox(),
                            _buildLabeledCheckbox(
                                'Maid Room', _isMaidRoomChecked, (newValue) {
                              setState(() {
                                _isMaidRoomChecked = newValue ?? false;
                              });
                            }),
                            _buildInteriorCheckbox(),
                            _isSubmitting
                                ? CircularProgressIndicator()
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: _isSubmitting
                                            ? null
                                            : () => _postListing(),
                                        child: Text('Post'),
                                      ),
                                      SizedBox(width: 16.0),
                                      ElevatedButton(
                                        onPressed: _isSubmitting
                                            ? null
                                            : () => _discardPost(),
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.red,
                                        ),
                                        child: Text('Discard Post'),
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledTextField(
      String label, TextEditingController controller) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Text(
              label,
              style: TextStyle(fontSize: 12.0),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberInputWithLabel(String label, int count, Function increment,
      Function decrement, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(
              icon,
              size: 20.0,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 12.0),
          ),
          SizedBox(width: 8.0),
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: () => decrement(),
          ),
          Text('$count'),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => increment(),
          ),
        ],
      ),
    );
  }

  Widget _buildLabeledCheckbox(String label, bool value, Function onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12.0),
        ),
        Expanded(
          child: Checkbox(
            value: value,
            onChanged: (newValue) {
              onChanged(newValue);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTypeSelector() {
    return Container(
      margin: EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Text(
            'Type',
            style: TextStyle(fontSize: 12.0),
          ),
          SizedBox(width: 8.0),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: [
              ..._selectedTypes.map((type) => _buildTypeChip(type)),
              ElevatedButton(
                onPressed: () => _showTypeDialog(),
                style: ElevatedButton.styleFrom(
                  primary: Colors.lightBlue,
                ),
                child: Text('Add New Type +'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTypeChip(String type) {
    return Chip(
      label: Text(type),
      onDeleted: () => _removeType(type),
    );
  }

  Future<void> _showTypeDialog() async {
    String? newType = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Type'),
          content: TextField(
            controller: _typeController,
            decoration: InputDecoration(labelText: 'Type'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, null);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String enteredType = _typeController.text.trim();
                if (enteredType.isNotEmpty) {
                  Navigator.pop(context, enteredType);
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );

    if (newType != null) {
      setState(() {
        _selectedTypes.add(newType);
        _typeController.clear();
      });
    }
  }

  void _removeType(String type) {
    setState(() {
      _selectedTypes.remove(type);
    });
  }

  Widget _buildTitle(String title) {
    return Center(
      child: Text(
        title,
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildAvailableForCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available For',
          style: TextStyle(fontSize: 14.0),
        ),
        SizedBox(
          width: 10,
        ),
        Row(
          children: [
            Row(
              children: [
                Checkbox(
                  value: _isRentChecked,
                  onChanged: (newValue) {
                    setState(() {
                      _isRentChecked = newValue ?? false;
                      _isSaleChecked = !newValue!;
                    });
                  },
                ),
                SizedBox(width: 8.0),
                Text(
                  'Rent',
                  style: TextStyle(fontSize: 12.0),
                ),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: _isSaleChecked,
                  onChanged: (newValue) {
                    setState(() {
                      _isSaleChecked = newValue ?? false;
                      _isRentChecked = !newValue!;
                    });
                  },
                ),
                SizedBox(width: 8.0),
                Text(
                  'Sale',
                  style: TextStyle(fontSize: 12.0),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInteriorCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Interior',
          style: TextStyle(fontSize: 14.0),
        ),
        SizedBox(
          width: 10,
        ),
        Row(
          children: [
            Checkbox(
              value: _isFurnishedChecked,
              onChanged: (newValue) {
                setState(() {
                  _isFurnishedChecked = newValue ?? false;
                  _isNotFurnishedChecked = !newValue!;
                });
              },
            ),
            SizedBox(width: 8.0),
            Text(
              'Furnished',
              style: TextStyle(fontSize: 12.0),
            ),
            Checkbox(
              value: _isNotFurnishedChecked,
              onChanged: (newValue) {
                setState(() {
                  _isNotFurnishedChecked = newValue ?? false;
                  _isFurnishedChecked = !newValue!;
                });
              },
            ),
            SizedBox(width: 8.0),
            Text(
              'Not Furnished',
              style: TextStyle(fontSize: 12.0),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImageSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Images',
          style: TextStyle(fontSize: 14.0),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            ElevatedButton(
              onPressed: () => _selectImages(),
              style: ElevatedButton.styleFrom(
                primary: Colors.lightBlue,
              ),
              child: Text('Select Images'),
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ..._selectedImages
                        .map((imageUrl) => _buildSelectedImage(imageUrl)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSelectedImage(String imageUrl) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Stack(
        children: [
          kIsWeb
              ? Image.network(
                  imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                )
              : Image.file(
                  File(imageUrl),
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: Icon(Icons.remove_circle),
              onPressed: () => _removeSelectedImage(imageUrl),
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  void _removeSelectedImage(String imageUrl) {
    setState(() {
      _selectedImages.removeWhere((element) => element == imageUrl);
    });
  }

  Future<void> _selectImages() async {
    List<XFile>? result;

    try {
      result = await ImagePicker().pickMultiImage(
        imageQuality: 80,
      );
    } catch (e) {
      // Handle exception if any
      print('Error selecting images: $e');
    }

    if (result != null && result.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(result!.map((image) => image.path).toList());
      });
    }
  }

  Future<void> _postListing() async {
    // Show circular indicator while submitting
    setState(() {
      _isSubmitting = true;
    });

    try {
      // Upload images to Firebase Storage
      List<String> imagePaths = await _uploadImages();

      // Create a listing document in Firestore
      await _firestore.collection('listings').add({
        'title': _titleController.text,
        'yearBuilt': _yearBuiltController.text,
        'description': _descriptionController.text,
        'size': _sizeController.text,
        'price': _priceController.text,
        'location': _locationController.text,
        'bedroomCount': _bedroomCount,
        'bathCount': _bathCount,
        'floorCount': _floorCount,
        'carParking': _isCarParkingChecked,
        'rentChecked': _isRentChecked,
        'saleChecked': _isSaleChecked,
        'furnishedChecked': _isFurnishedChecked,
        'notFurnishedChecked': _isNotFurnishedChecked,
        'maidRoomChecked': _isMaidRoomChecked,
        'types': _selectedTypes,
        'images': await _getDownloadUrls(imagePaths),
      });

      // Reset form
      _resetForm();

      // Show success message
      _showSuccessMessage();
    } catch (e) {
      print('Error posting listing: $e');
      // Handle error (e.g., show an error message)
    } finally {
      // Hide circular indicator after submission
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  Future<List<String>> _uploadImages() async {
    List<String> imagePaths = [];

    for (var imagePath in _selectedImages) {
      try {
        String imageName = _generateRandomString();
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('post') // Use 'post' as part of the path
            .child('$imageName.jpg');

        File imageFile = File(imagePath);
        if (!imageFile.existsSync()) {
          print('Error: Image file does not exist at path: $imagePath');
          continue;
        }

        await ref.putFile(imageFile);

        // Check if the image was successfully uploaded
        if (await ref.getDownloadURL() != null) {
          imagePaths.add(ref.fullPath);
          print('Image uploaded successfully: ${ref.fullPath}');
        } else {
          print('Error: Image upload failed');
        }
      } catch (e) {
        print('Error uploading image: $e');
      }
    }

    return imagePaths;
  }

  // Modify this method to generate a random string of 20 characters
  String _generateRandomString() {
    return Uuid().v4().substring(0, 20);
  }

  Future<List<String>> _getDownloadUrls(List<String> imagePaths) async {
    List<String> downloadUrls = [];

    for (var path in imagePaths) {
      try {
        Reference ref = FirebaseStorage.instance.ref().child(path);
        String downloadUrl = await ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
        print('Download URL fetched successfully: $downloadUrl');
      } catch (e) {
        print('Error fetching download URL: $e');
      }
    }

    return downloadUrls;
  }

  void _showValidationError() {
    // Implement your validation error handling (e.g., show a dialog)
    print('Validation error: Some fields are empty');
  }

  void _resetForm() {
    setState(() {
      _titleController.clear();
      _yearBuiltController.clear();
      _descriptionController.clear();
      _sizeController.clear();
      _priceController.clear();
      _locationController.clear();
      _bedroomCount = 0;
      _bathCount = 0;
      _floorCount = 0;
      _isCarParkingChecked = false;
      _isRentChecked = false;
      _isSaleChecked = false;
      _isFurnishedChecked = false;
      _isNotFurnishedChecked = false;
      _isMaidRoomChecked = false;
      _selectedTypes.clear();
      _selectedImages.clear();
    });
  }

  void _showSuccessMessage() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Listing posted successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _discardPost() {
    // Implement your logic for discarding the post (e.g., show a confirmation dialog)
    print('Post discarded');
    _resetForm();
  }

  void _incrementBedroom() {
    setState(() {
      _bedroomCount++;
    });
  }

  void _decrementBedroom() {
    if (_bedroomCount > 0) {
      setState(() {
        _bedroomCount--;
      });
    }
  }

  void _incrementBath() {
    setState(() {
      _bathCount++;
    });
  }

  void _decrementBath() {
    if (_bathCount > 0) {
      setState(() {
        _bathCount--;
      });
    }
  }

  void _incrementFloor() {
    setState(() {
      _floorCount++;
    });
  }

  void _decrementFloor() {
    if (_floorCount > 0) {
      setState(() {
        _floorCount--;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _yearBuiltController.dispose();
    _descriptionController.dispose();
    _sizeController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    _typeController.dispose();
    super.dispose();
  }
}
