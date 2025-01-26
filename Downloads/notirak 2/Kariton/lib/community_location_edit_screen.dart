import 'package:flutter/material.dart';

class LocationEditScreen extends StatefulWidget {
  @override
  _LocationEditScreenState createState() => _LocationEditScreenState();
}

class _LocationEditScreenState extends State<LocationEditScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Location',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 60.0, 30.0, 30.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'House No.',
                  hintText: 'Enter your house number',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your house number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Street',
                  hintText: 'Enter your street name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your street name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Barangay',
                  hintText: 'Enter your barangay',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your barangay';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description (Optional)',
                  hintText: 'Enter additional details',
                ),
              ),
              SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Handle form submission
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Location updated')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF40A858),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text('Change'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
