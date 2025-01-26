import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert'; // Import for Base64 decoding
import 'barangay_edit_detail.dart';

class EditProfilePage extends StatefulWidget {
  final Map data;

  const EditProfilePage({Key? key, required this.data}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? _image;

  late TextEditingController _barangayCaptainController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();

    // Initialize the text controllers with the current values from widget.data
    _barangayCaptainController = TextEditingController(text: widget.data['barangay']['capName']);
    _emailController = TextEditingController(text: widget.data['barangay']['email']);
    _phoneController = TextEditingController(text: widget.data['barangay']['phone']);
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    // Dispose the controllers when the widget is removed from the widget tree
    _barangayCaptainController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  bool _isValidPhoneNumber(String phone) {
    // Regular expression to validate Philippine phone numbers
    final RegExp regex = RegExp(r'^(0|\+63)[1-9]\d{9}$');
    return regex.hasMatch(phone);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Box with Border containing Circle Profile Picture and Text
            Container(
              width: double.infinity, // Make the container full width
              padding: EdgeInsets.all(5.0), // Padding around the content
              decoration: BoxDecoration(
                color: Colors.green,
                border: Border.all(color: Colors.grey, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // Circle Profile Picture
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _image != null
                        ? FileImage(_image!)
                        : (widget.data['barangay']['bImg'] != null
                            ? MemoryImage(base64Decode(widget.data['barangay']['bImg']))
                            : AssetImage('assets/barangay_icon.png') as ImageProvider), // Default image if bImg is null
                  ),
                  SizedBox(height: 10.0), // Space between the CircleAvatar and the button

                  // Edit Profile Picture Text Button
                  TextButton(
                    onPressed: _pickImage,
                    child: Text('Edit Profile Picture'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),

            // Barangay Captain Name
            TextField(
              controller: _barangayCaptainController,
              decoration: InputDecoration(
                labelText: 'Barangay Captain Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),

            // Email
            TextField(
              controller: _emailController,
              readOnly: true, // Make the email field non-editable
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),

            // Phone Number
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),

            // Next Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Get the input values from the text fields
                  String barangayCaptainName = _barangayCaptainController.text;
                  String email = _emailController.text; // The email will be read-only
                  String phone = _phoneController.text;

                  // Validate the phone number
                  if (!_isValidPhoneNumber(phone)) {
                    // Show an error message if the phone number is invalid
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter a valid Philippine phone number.')),
                    );
                    return; // Prevent navigation if the phone number is invalid
                  }

                  // Navigate to the next page, passing both widget.data and the input data
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditBarangayDetailsPage(
                        data: widget.data,  // Passing the original widget data
                        capName: barangayCaptainName,  // Passing individual input data
                        email: email,
                        phone: phone,
                      ),
                    ),
                  );
                },
                child: Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
