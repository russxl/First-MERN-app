import 'dart:io'; // Import dart:io for File class
import 'dart:convert'; // For base64 encoding
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notirak/api/api.dart'; 

class EditBarangayDetailsPage extends StatefulWidget {
  final Map data;
  final String capName;
  final String email;
  final String phone;

  const EditBarangayDetailsPage({
    Key? key,
    required this.data,
    required this.capName,
    required this.email,
    required this.phone,
  }) : super(key: key);

  @override
  _EditBarangayDetailsPageState createState() => _EditBarangayDetailsPageState();
}

class _EditBarangayDetailsPageState extends State<EditBarangayDetailsPage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-populate the location text field with data
    _locationController.text = widget.data['barangay']['bLocation'] ?? '';
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _imageFile = pickedFile;
      }
    });
  }

  String? _getImageFromBase64() {
    // Get base64 image for barangay picture and decode it
    String? base64Image = widget.data['barangay']['bImg'];
    if (base64Image != null && base64Image.isNotEmpty) {
      return base64Image;
    }
    return null;
  }

  String? _getPermitImageFromBase64() {
    // Get base64 image for permit and decode it
    String? base64Image = widget.data['barangay']['permit'];
    if (base64Image != null && base64Image.isNotEmpty) {
      return base64Image;
    }
    return null;
  }

  String? _getValidIDImageFromBase64() {
    // Get base64 image for valid ID and decode it
    String? base64Image = widget.data['barangay']['validID'];
    if (base64Image != null && base64Image.isNotEmpty) {
      return base64Image;
    }
    return null;
  }

  Future<File?> base64ToFile(String base64String, String filename) async {
    try {
      // Decode the base64 string
      final bytes = base64Decode(base64String);
      final directory = await Directory.systemTemp.createTemp(); // Create a temporary directory
      final file = File('${directory.path}/$filename');
      
      // Write bytes to the file
      await file.writeAsBytes(bytes);

      return file;
    } catch (e) {
      print('Error converting base64 to file: $e');
      return null;
    }
  }

  void _saveChanges() async {
    final String location = _locationController.text;
    
    // Prepare the data map
    Map<String, dynamic> pdata = {
      'capName': widget.capName, // Assuming the barangay name is required
      'email': widget.email,
      'phone': widget.phone,
      'location': location,
      'userType': "Barangay",
      'id': widget.data['barangay']['_id'],
      "type": "Barangay"

      // Add any other fields you need to send
    };

    // Show a loading indicator while processing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Saving changes...')),
    );

    // Convert base64 image to file if available
    File? imageFileToUpload;
    if (_imageFile != null) {
      imageFileToUpload = File(_imageFile!.path);
    } else {
      String? base64Image = _getImageFromBase64();
      if (base64Image != null) {
        imageFileToUpload = await base64ToFile(base64Image, 'barangay_image.png');
      }
    }

    try {
      // Call the updateClient method
      await Api.updateClient(context, pdata, imageFileToUpload!);
      
      // Show a confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Barangay details saved successfully!')),
      );

    } catch (e) {
      // Show error message if update fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save details. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String? base64Image = _getImageFromBase64();
    String? base64PermitImage = _getPermitImageFromBase64();
    String? base64ValidIDImage = _getValidIDImageFromBase64();

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Barangay Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Location
            TextField(
              controller: _locationController,
              readOnly: true, // Make the location field non-editable
              decoration: InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),

            // Change Barangay Picture Section
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Barangay Picture',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 200.0,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                          image: _imageFile != null
                              ? DecorationImage(
                                  image: FileImage(File(_imageFile!.path)),
                                  fit: BoxFit.cover,
                                )
                              : (base64Image != null
                                  ? DecorationImage(
                                      image: MemoryImage(
                                        base64Decode(base64Image),
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                  : null),
                        ),
                        child: (_imageFile == null && base64Image == null)
                            ? Center(
                                child: Text(
                                  'No Image Selected',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            : null,
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            onPressed: _pickImage,
                            child: Text('Upload Picture'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black.withOpacity(0.5), // Semi-transparent background
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // Permit Image
                  Text(
                    'Permit',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 200.0,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                          image: base64PermitImage != null
                              ? DecorationImage(
                                  image: MemoryImage(
                                    base64Decode(base64PermitImage),
                                  ),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: (base64PermitImage == null)
                            ? Center(
                                child: Text(
                                  'No Image Selected',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            : null,
                      ),
                    ],
                  ),

                  // Valid ID Image
                  Text(
                    'Uploaded Valid ID',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 200.0,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                          image: base64ValidIDImage != null
                              ? DecorationImage(
                                  image: MemoryImage(
                                    base64Decode(base64ValidIDImage),
                                  ),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: (base64ValidIDImage == null)
                            ? Center(
                                child: Text(
                                  'No Image Selected',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            : null,
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                ],
              ),
            ),
            SizedBox(height: 20.0),

            // Save Button
            Center(
              child: ElevatedButton(
                onPressed: _saveChanges,
                child: Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
