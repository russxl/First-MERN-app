import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notirak/api/api.dart';
import 'package:notirak/community_login_screen.dart'; // Assuming this is correct
import 'package:notirak/junkshop_register_screen.dart'; // Assuming this is correct
import 'dart:io';

class RegisterJunkshopAdd extends StatelessWidget {
  final String userType; 
  final String captainName;
  final String email;
  final String phone;
  final String password;
  final String confirmPassword;
  final String junkshopName;

  RegisterJunkshopAdd({
    required this.userType,
    required this.captainName,
    required this.email,
    required this.phone,
    required this.password,
    required this.confirmPassword,
    required this.junkshopName,
  });

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
                builder: (context) => JunkshopRegisterScreen(userType: userType), // Pass userType
              ),
            );
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 50.0, 30.0, 30.0),
        child: RegisterJunkshopAddForm(
          userType: userType,
          captainName: captainName,
          email: email,
          phone: phone,
          password: password,
          confirmPassword: confirmPassword,
          junkshopName: junkshopName,
        ),
      ),
    );
  }
}

class RegisterJunkshopAddForm extends StatefulWidget {
  final String userType;
  final String captainName;
  final String email;
  final String phone;
  final String password;
  final String confirmPassword;
  final String junkshopName; 

  RegisterJunkshopAddForm({
    required this.userType,
    required this.captainName,
    required this.email,
    required this.phone,
    required this.password,
    required this.confirmPassword,
    required this.junkshopName,
  });

  @override
  _RegisterJunkshopAddFormState createState() => _RegisterJunkshopAddFormState();
}

class _RegisterJunkshopAddFormState extends State<RegisterJunkshopAddForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _addressController = TextEditingController();
  XFile? _junkshopImage;
  XFile? _validIdImage; 
  XFile? _barangayPermitImage; 

  @override
  Widget build(BuildContext context) {
    return Form(
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
            controller: _addressController,
            decoration: InputDecoration(
              hintText: 'Enter your address',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your address';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          _buildLabelWithAsterisk('Provide a photo of your junkshop'),
          GestureDetector(
            onTap: () => _pickImage(isJunkshopImage: true),
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: _junkshopImage == null
                  ? Center(
                      child: Text(
                        'Upload a photo',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    )
                  : Image.file(File(_junkshopImage!.path)),
            ),
          ),
          SizedBox(height: 20),
          _buildLabelWithAsterisk('Upload a Valid ID'),
          GestureDetector(
            onTap: () => _pickImage(isJunkshopImage: false),
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: _validIdImage == null
                  ? Center(
                      child: Text(
                        'Upload a Valid ID',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    )
                  : Image.file(File(_validIdImage!.path)),
            ),
          ),
          SizedBox(height: 20),
          _buildLabelWithAsterisk('Upload Barangay Permit'),
          GestureDetector(
            onTap: () => _pickImage(isJunkshopImage: false, isBarangayPermit: true),
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: _barangayPermitImage == null
                  ? Center(
                      child: Text(
                        'Upload Barangay Permit',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    )
                  : Image.file(File(_barangayPermitImage!.path)),
            ),
          ),
          SizedBox(height: 50),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  if (_junkshopImage == null || _validIdImage == null || _barangayPermitImage == null) {
                    _showMissingImageAlert(context);
                  } else if (_addressController.text.isEmpty) {
                    _showMissingAddressAlert(context);
                  } else {
                    var data = {
                      'userType': widget.userType,
                      'password': widget.password,
                      'email': widget.email,
                      'confirmPassword': widget.confirmPassword,
                      'phone': widget.phone,
                      'address': _addressController.text,
                      'ownerName': widget.captainName,
                      'junkShopName': widget.junkshopName,
                    };

                    File? junkshopImageFile;
                    String? validIdImageBase64;
                    String? barangayPermitImageBase64;

                    // Check image sizes before processing
                    if (_junkshopImage != null) {
                      junkshopImageFile = File(_junkshopImage!.path);
                      int junkshopImageSize = await junkshopImageFile.length();
                      if (junkshopImageSize > 3 * 1024 * 1024) { // Check if greater than 3MB
                        _showImageSizeAlert(context, 'Junkshop Photo');
                        return;
                      }
                      data['junkshopImage'] = base64Encode(await junkshopImageFile.readAsBytes());
                    }
                    if (_validIdImage != null) {
                      File validIdImageFile = File(_validIdImage!.path);
                      int validIdImageSize = await validIdImageFile.length();
                      if (validIdImageSize > 3 * 1024 * 1024) { // Check if greater than 3MB
                        _showImageSizeAlert(context, 'Valid ID');
                        return;
                      }
                      validIdImageBase64 = base64Encode(await validIdImageFile.readAsBytes());
                      data['validIdImage'] = validIdImageBase64;
                    }
                    if (_barangayPermitImage != null) {
                      File barangayPermitImageFile = File(_barangayPermitImage!.path);
                      int barangayPermitImageSize = await barangayPermitImageFile.length();
                      if (barangayPermitImageSize > 3 * 1024 * 1024) { // Check if greater than 3MB
                        _showImageSizeAlert(context, 'Barangay Permit');
                        return;
                      }
                      barangayPermitImageBase64 = base64Encode(await barangayPermitImageFile.readAsBytes());
                      data['barangayPermit'] = barangayPermitImageBase64;
                    }

                    // Show the registration progress dialog
                    _showRegistrationDialog(context);

                    try {
                      bool isSuccess = await Api.registrationJunkshop(context, data, junkshopImageFile!);
                      Navigator.of(context).pop(); // Close the loading dialog
                      if (isSuccess) {
                        _showSuccessDialog(context);
                      } else {
                        // If registration fails, show the error dialog with a dynamic message
                        throw Exception('Registration failed. Please check your entered credentials or email is already used.');
                      }
                    } catch (e) {
                      Navigator.of(context).pop(); // Close the loading dialog if there's an error
                      _showErrorDialog(context, e.toString()); // Pass the error message to the dialog
                    }
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
        ],
      ),
    );
  }

  // Pick an image
  Future<void> _pickImage({required bool isJunkshopImage, bool isBarangayPermit = false}) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (isJunkshopImage) {
        _junkshopImage = pickedFile;
      } else if (isBarangayPermit) {
        _barangayPermitImage = pickedFile;
      } else {
        _validIdImage = pickedFile;
      }
    });
  }

  // Dialogs and alerts
  void _showImageSizeAlert(BuildContext context, String imageName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$imageName too large'),
          content: Text('Please upload a $imageName smaller than 3MB.'),
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

  void _showMissingImageAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Missing Image'),
          content: Text('Please upload all required images.'),
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

  void _showMissingAddressAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Missing Address'),
          content: Text('Please enter your address.'),
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

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Registration Successful'),
          content: Text('Your junkshop has been registered successfully.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(), // Assuming this is correct
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Registration Failed'),
          content: Text(errorMessage),
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

  // Registration progress dialog
  void _showRegistrationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Registering...'),
            ],
          ),
        );
      },
    );
  }

  // Helper widget for labels with asterisks
  Widget _buildLabelWithAsterisk(String label) {
    return RichText(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'Roboto',
          fontSize: 18,
        ),
        children: [
          TextSpan(
            text: ' *',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
