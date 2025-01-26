import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notirak/api/api.dart';
import 'package:notirak/community_login_screen.dart';
import 'barangay_register_screen.dart';
import 'dart:io';

class RegisterBarangayAdd extends StatelessWidget {
  final String userType;
  final String captainName;
  final String email;
  final String phone;
  final String password;
  final String barangayName;
  final String confirmPassword;

  RegisterBarangayAdd({
    required this.userType,
    required this.captainName,
    required this.email,
    required this.barangayName,
    required this.phone,
    required this.password,
    required this.confirmPassword,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RegisterBarangayAddForm(
        userType: userType,
        captainName: captainName,
        password: password,
        confirmPassword: confirmPassword,
        phone: phone,
        email: email,
        barangayName: barangayName,
      ),
    );
  }
}

class RegisterBarangayAddForm extends StatefulWidget {
  final String userType;
  final String captainName;
  final String email;
  final String phone;
  final String password;
  final String confirmPassword;
  final String barangayName;

  RegisterBarangayAddForm({
    required this.userType,
    required this.captainName,
    required this.email,
    required this.phone,
    required this.barangayName,
    required this.password,
    required this.confirmPassword,
  });

  @override
  _RegisterBarangayAddFormState createState() => _RegisterBarangayAddFormState();
}

class _RegisterBarangayAddFormState extends State<RegisterBarangayAddForm> {
  final _formKey = GlobalKey<FormState>();
  XFile? _image;
  XFile? _validId;
  XFile? _barangayPermit; // New field for storing barangay permit image
  String? _address;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BarangayRegisterScreen(userType: widget.userType),
              ),
            );
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 50.0, 30.0, 30.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                "Additional Information",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
              SizedBox(height: 30),
              _buildLabelWithAsterisk('Address'),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    _address = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Enter your address',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              _buildLabelWithAsterisk('Provide a photo of your barangay hall'),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _image == null
                      ? Center(
                          child: Text(
                            'Upload a photo',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        )
                      : Image.file(File(_image!.path)),
                ),
              ),
              SizedBox(height: 20),
              _buildLabelWithAsterisk('Upload valid ID'),
              GestureDetector(
                onTap: _pickValidIdImage,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _validId == null
                      ? Center(
                          child: Text(
                            'Upload valid ID',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        )
                      : Image.file(File(_validId!.path)),
                ),
              ),
              SizedBox(height: 20),
              _buildLabelWithAsterisk('Upload Barangay Permit'), // New label for barangay permit
              GestureDetector(
                onTap: _pickBarangayPermitImage,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _barangayPermit == null
                      ? Center(
                          child: Text(
                            'Upload Barangay Permit',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        )
                      : Image.file(File(_barangayPermit!.path)),
                ),
              ),
              SizedBox(height: 50),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (_image == null || _validId == null || _barangayPermit == null || _address == null || _address!.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Please fill in all required fields and upload all photos.',
                              style: TextStyle(fontFamily: 'Roboto'),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else {
                        _showRegistrationDialog(context);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF40A858),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 100),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: TextButton(
                  onPressed: () async {
                    // Navigate to the login screen if the user is already a member
                  },
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Already a member? ',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Roboto',
                          ),
                        ),
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(
                            color: Colors.blue,
                            fontFamily: 'Roboto',
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabelWithAsterisk(String label) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Roboto',
          ),
        ),
        Text(
          '*',
          style: TextStyle(
            fontSize: 18,
            color: Colors.red,
            fontFamily: 'Roboto',
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Future<void> _pickValidIdImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _validId = image;
    });
  }

  Future<void> _pickBarangayPermitImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _barangayPermit = image;
    });
  }

  void _showRegistrationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Registering...',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              CircularProgressIndicator(), // Showing a loader while the registration is being processed
            ],
          ),
        );
      },
    );

    _registerBarangay(context);
  }

 Future<void> _registerBarangay(BuildContext context) async {
  try {
    var data = {
      'userType': widget.userType,
      'password': widget.password,
      'email': widget.email,
      "confirmPassword": widget.confirmPassword,
      "phone": widget.phone,
      'barangayName': widget.barangayName,
      'capName': widget.captainName,
      'address': _address,
    };

    File? imageFile;
    File? validIdFile;
    File? barangayPermitFile;
    String? validIdBase64;
    String? barangayPermitBase64;
    String? barangayHallBase64;

    // Handle image files and check sizes
    if (_image != null) {
      imageFile = File(_image!.path);
      if (await imageFile.length() > 3 * 1024 * 1024) { // Check if greater than 3MB
        Navigator.of(context).pop(); // Close loading dialog
        _showImageSizeError(context, 'Barangay Hall Photo');
        return;
      }
      barangayHallBase64 = base64Encode(imageFile.readAsBytesSync());
      data['barangayHall'] = barangayHallBase64;
    }
    if (_validId != null) {
      validIdFile = File(_validId!.path);
      if (await validIdFile.length() > 3 * 1024 * 1024) { // Check if greater than 3MB
        Navigator.of(context).pop(); // Close loading dialog
        _showImageSizeError(context, 'Valid ID');
        return;
      }
      validIdBase64 = base64Encode(validIdFile.readAsBytesSync());
      data['validIdImage'] = validIdBase64;
    }
    if (_barangayPermit != null) {
      barangayPermitFile = File(_barangayPermit!.path);
      if (await barangayPermitFile.length() > 3 * 1024 * 1024) { // Check if greater than 3MB
        Navigator.of(context).pop(); // Close loading dialog
        _showImageSizeError(context, 'Barangay Permit');
        return;
      }
      barangayPermitBase64 = base64Encode(barangayPermitFile.readAsBytesSync());
      data['barangayPermit'] = barangayPermitBase64;
    }

    // Call the API function
    await Api.registrationBarangay(context, data, imageFile!);

    // Show success prompt after registration
    _showSuccessPrompt(context, 'You are now registered. Please login to your account.');
  } catch (e) {
    Navigator.of(context).pop();
    _showErrorPrompt(context, 'An error occurred while registering. Please try again.');
  }
}

  void _showSuccessPrompt(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Registration Successful'),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorPrompt(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Registration Failed'),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showImageSizeError(BuildContext context, String imageType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Image Size Error'),
          content: Text('$imageType must not exceed 3MB.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
