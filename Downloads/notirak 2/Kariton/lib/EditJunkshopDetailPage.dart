import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditJunkshopDetailPage extends StatefulWidget {
  @override
  _EditJunkshopDetailPageState createState() => _EditJunkshopDetailPageState();
}

class _EditJunkshopDetailPageState extends State<EditJunkshopDetailPage> {
  late TextEditingController _nameController;
  late TextEditingController _locationController;
  File? _businessPermitImage;
  File? _validIdImage;
  File? _junkshopImage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _locationController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(String type) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        switch (type) {
          case 'Business Permit':
            _businessPermitImage = File(pickedFile.path);
            break;
          case 'Valid ID':
            _validIdImage = File(pickedFile.path);
            break;
          case 'Junkshop Picture':
            _junkshopImage = File(pickedFile.path);
            break;
        }
      });
    }
  }

  void _saveDetails() {
    Navigator.of(context).pop({
      'name': _nameController.text,
      'location': _locationController.text,
      'businessPermitImage': _businessPermitImage,
      'validIdImage': _validIdImage,
      'junkshopImage': _junkshopImage,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'Edit Junkshop Detail',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Junkshop Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: _locationController,
            decoration: InputDecoration(
              labelText: 'Location',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16.0),
          _buildImagePicker('Replace your Business Permit'),
          const SizedBox(height: 16.0),
          _buildImagePicker('Replace your Valid ID'),
          const SizedBox(height: 16.0),
          _buildImagePicker('Replace your Junkshop Picture'),
          const SizedBox(height: 24.0),
          Center(
            child: ElevatedButton(
              onPressed: _saveDetails,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 80.0, vertical: 20.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('Change'),
            ),
          ),
        ],
      ),
    );
  }

 Widget _buildImagePicker(String type) {
  File? image;
  String buttonText;

  // Determine which image and button text to use based on the type
  switch (type) {
    case 'Business Permit':
      image = _businessPermitImage;
      buttonText = image == null ? 'Select Image' : 'Change Image';
      break;
    case 'Valid ID':
      image = _validIdImage;
      buttonText = image == null ? 'Select Image' : 'Change Image';
      break;
    case 'Junkshop Picture':
      image = _junkshopImage;
      buttonText = image == null ? 'Select Image' : 'Change Image';
      break;
    default:
      buttonText = 'Change Image';
      break;
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        type,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8.0),
      GestureDetector(
        onTap: () => _pickImage(type),
        child: Container(
          height: 150.0,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: image != null
              ? Image.file(image, fit: BoxFit.cover)
              : const Center(child: Text('Upload image here')),
        ),
      ),
      const SizedBox(height: 8.0),
      if (image != null) 
        Center(
          child: ElevatedButton(
            onPressed: () => _pickImage(type),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 80.0, vertical: 20.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Text(buttonText),
          ),
        ),
    ],
  );
}
}