import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0), // Adjust radius as needed
          border: Border.all(
            color: Colors.grey, // Grey border color
            width: 2.0, // Border width
          ),
        ),
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
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
                                _buildLabeledTextField(
                                    'Title', _titleController),
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
                                _buildLabeledTextField(
                                    'Price', _priceController),
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
                                _buildNumberInputWithLabel(
                                    'Baths',
                                    _bathCount,
                                    _incrementBath,
                                    _decrementBath,
                                    Icons.bathtub),
                                _buildNumberInputWithLabel(
                                    'Floor',
                                    _floorCount,
                                    _incrementFloor,
                                    _decrementFloor,
                                    Icons.layers),
                                _buildLabeledCheckbox(
                                    'Car Parking', _isCarParkingChecked,
                                    (newValue) {
                                  setState(() {
                                    _isCarParkingChecked = newValue ?? false;
                                  });
                                }),
                                _buildAvailableForCheckbox(),
                                _buildLabeledCheckbox(
                                    'Maid Room', _isMaidRoomChecked,
                                    (newValue) {
                                  setState(() {
                                    _isMaidRoomChecked = newValue ?? false;
                                  });
                                }),
                                _buildInteriorCheckbox(),
                                _isSubmitting
                                    ? CircularProgressIndicator()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                            onPressed: _isSubmitting
                                                ? null
                                                : () {
                                                    if (_selectedImages
                                                        .isNotEmpty) {
                                                      // Check if images are selected
                                                      _postListing(); // Call _postListing if images are selected
                                                    } else {
                                                      // Show a message to the user indicating that images are required
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                              'Please select at least one image.'),
                                                        ),
                                                      );
                                                    }
                                                  },
                                            style: ElevatedButton.styleFrom(
                                              primary: Color(
                                                  0xFF2D365C), // Background color
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    10), // Adjust border radius as needed
                                              ),
                                            ),
                                            child: Text('Post'),
                                          ),
                                          SizedBox(width: 16.0),
                                          ElevatedButton(
                                            onPressed: _isSubmitting
                                                ? null
                                                : () => _discardPost(),
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors
                                                  .white, // Background color
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    20), // Adjust border radius as needed
                                                side: BorderSide(
                                                    color: Colors
                                                        .grey), // Set border color
                                              ),
                                            ),
                                            child: Text(
                                              'Discard Post',
                                              style: TextStyle(
                                                  color: Colors
                                                      .grey), // Text color
                                            ),
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
      margin: EdgeInsets.only(bottom: 16.0),
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
                  primary: Color(0xFF2D365C), // Background color #FF2D365C
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        30.0), // Adjust the radius as needed
                  ),
                  minimumSize:
                      Size(38, 46), // Adjust the width and height as needed
                ),
                child: Text('Add New Type +',
                    style:
                        TextStyle(fontSize: 16)), // Adjust font size if needed
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTypeChip(String type) {
    return Chip(
      labelPadding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
      label: Text(type),
      deleteIconColor: Colors.black,
      onDeleted: () => _removeType(type),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
            28.0), // Adjust border radius for a rounder circular border
        side: BorderSide(color: Colors.grey), // Set the border color
      ),
      visualDensity: VisualDensity.compact,
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
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _selectedImages.map<Widget>((imagePath) {
              if (imagePath is String) {
                return Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Stack(
                    children: [
                      Image.network(
                        imagePath,
                        width: 150,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: Icon(Icons.remove_circle),
                          onPressed: () => _removeSelectedImage(imagePath),
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return SizedBox.shrink(); // Handle null or unexpected type
              }
            }).toList(),
          ),
        ),
        SizedBox(height: 10),
        GestureDetector(
          onTap: () => _selectImages(),
          child: Container(
            width: 150.0, // Adjust width as needed
            height: 80.0, // Adjust height as needed
            decoration: BoxDecoration(
              color: Colors.grey,
            ),
            child: Center(
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _removeSelectedImage(String imagePath) {
    setState(() {
      _selectedImages.remove(imagePath);
    });
  }

  Future<void> _selectImages() async {
    List<String>? result;

    try {
      if (kIsWeb) {
        final filePickerResult = await FilePicker.platform.pickFiles(
          type: FileType.image,
          allowMultiple: true,
        );
        if (filePickerResult != null) {
          result = [];
          for (var file in filePickerResult.files) {
            if (file.bytes != null) {
              result.add('data:image/jpeg;base64,${base64Encode(file.bytes!)}');
            }
          }
        }
      } else {
        final picker = ImagePicker();
        final pickedFiles = await picker.pickMultiImage();
        if (pickedFiles != null) {
          result = pickedFiles.map((file) => file.path).toList();
        }
      }
    } catch (e) {
      print('Error selecting images: $e');
    }

    if (result != null && result.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(result!);
      });
    }
  }

  Future<void> _postListing() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      final List<String> uploadedImageUrls =
          await _uploadImages(_selectedImages);

      final Map<String, dynamic> data = {
        'title': _titleController.text.trim(),
        'yearBuilt': _yearBuiltController.text.trim(),
        'description': _descriptionController.text.trim(),
        'size': _sizeController.text.trim(),
        'price': _priceController.text.trim(),
        'location': _locationController.text.trim(),
        'type': _selectedTypes,
        'bedrooms': _bedroomCount,
        'baths': _bathCount,
        'floor': _floorCount,
        'carParking': _isCarParkingChecked,
        'rent': _isRentChecked,
        'sale': _isSaleChecked,
        'maidRoom': _isMaidRoomChecked,
        'furnished': _isFurnishedChecked,
        'notFurnished': _isNotFurnishedChecked,
        'images': uploadedImageUrls,
      };

      await _firestore.collection('listings').add(data);

      setState(() {
        _isSubmitting = false;
        _selectedImages.clear();
        _titleController.clear();
        _yearBuiltController.clear();
        _descriptionController.clear();
        _sizeController.clear();
        _priceController.clear();
        _locationController.clear();
        _selectedTypes.clear();
        _bedroomCount = 0;
        _bathCount = 0;
        _floorCount = 0;
        _isCarParkingChecked = false;
        _isRentChecked = false;
        _isSaleChecked = false;
        _isFurnishedChecked = false;
        _isNotFurnishedChecked = false;
        _isMaidRoomChecked = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Listing posted successfully'),
        ),
      );
    } catch (e) {
      print('Error posting listing: $e');
      setState(() {
        _isSubmitting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to post listing. Please try again later.'),
        ),
      );
    }
  }

  Future<List<String>> _uploadImages(List<String> paths) async {
    List<String> uploadedImageUrls = [];

    for (String imagePath in paths) {
      try {
        if (!kIsWeb) {
          // Handling local file paths
          final uuid = Uuid();
          final String imageId = uuid.v4();
          final Reference firebaseStorageRef = FirebaseStorage.instance
              .ref()
              .child('post') // Change folder name to 'post'
              .child('$imageId.jpg');
          final UploadTask uploadTask =
              firebaseStorageRef.putFile(File(imagePath));
          await uploadTask; // Wait for the upload to complete
          final String downloadUrl = await firebaseStorageRef.getDownloadURL();
          uploadedImageUrls.add(downloadUrl);
        } else {
          // Handling base64 encoded strings for web
          final bytes = Base64Decoder()
              .convert(imagePath.replaceFirst('data:image/jpeg;base64,', ''));
          final uuid = Uuid();
          final String imageId = uuid.v4();
          final Reference firebaseStorageRef = FirebaseStorage.instance
              .ref()
              .child('post') // Change folder name to 'post'
              .child('$imageId.jpg');
          final UploadTask uploadTask = firebaseStorageRef.putData(bytes);
          await uploadTask; // Wait for the upload to complete
          final String downloadUrl = await firebaseStorageRef.getDownloadURL();
          uploadedImageUrls.add(downloadUrl);
        }
      } catch (e) {
        print('Error uploading image: $e');
      }
    }

    return uploadedImageUrls;
  }

  void _discardPost() {
    setState(() {
      _titleController.clear();
      _yearBuiltController.clear();
      _descriptionController.clear();
      _sizeController.clear();
      _priceController.clear();
      _locationController.clear();
      _selectedImages.clear();
      _selectedTypes.clear();
      _bedroomCount = 0;
      _bathCount = 0;
      _floorCount = 0;
      _isCarParkingChecked = false;
      _isRentChecked = false;
      _isSaleChecked = false;
      _isFurnishedChecked = false;
      _isNotFurnishedChecked = false;
      _isMaidRoomChecked = false;
    });
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
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(RealEstateForm());
}
