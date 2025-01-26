import 'package:flutter/material.dart';
import 'package:notirak/api/api.dart';

class CommunityGeneralProf extends StatefulWidget {
  final Map userData;

  const CommunityGeneralProf({Key? key, required this.userData}) : super(key: key);

  @override
  _CommunityGeneralProfState createState() => _CommunityGeneralProfState();
}

class _CommunityGeneralProfState extends State<CommunityGeneralProf> {
  Map userData = {}; // Local copy of userData

  @override
  void initState() {
    super.initState();
    userData = widget.userData; // Initialize user data
  }

  Future<void> _refreshData() async {
    var requestData = {
      "id": userData['user']['_id'],
      "type": "Community"
    };

    try {
      // Assuming Api.getHome returns updated data
      final updatedData = await Api.getHome(context, requestData);

      // Update the state with the refreshed data
    
    } catch (error) {
      print("Error refreshing data: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: ListView(
          padding: EdgeInsets.fromLTRB(30.0, 60.0, 30.0, 30.0),
          children: <Widget>[
            // Profile Details
            Text(
              'UserID: ${userData['user']['userID'].toString()}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 10.0),
            Text(
              'Name: ${userData['user']['fullname']}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 10.0),
            Text(
              'Email: ${userData['user']['email']}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 10.0),
            Text(
              'Phone: ${userData['user']['phone'].toString()}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 10.0),
            Text(
              'Barangay: ${userData['user']['barangay']}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 30.0),
            // Edit Profile Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(userData: userData),
                  ),
                );
              },
              icon: Icon(
                Icons.edit,
                color: Colors.white,
              ),
              label: Text(
                'Edit Profile',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF40A858),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  final Map userData;

  const EditProfileScreen({Key? key, required this.userData}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userData['user']['fullname']);
    _emailController = TextEditingController(text: widget.userData['user']['email']);
    _phoneController = TextEditingController(text: widget.userData['user']['phone'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 30.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'Change your name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _emailController,
                readOnly: true,  // Make the email field non-editable
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(color: Colors.grey), // Optional: visually indicate that it's non-editable
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  hintText: 'Enter your phone number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  String pattern = r'^(09|\+639)\d{9}$';
                  RegExp regex = RegExp(pattern);
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  } else if (!regex.hasMatch(value)) {
                    return 'Please enter a valid Philippine phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    var data = {
                      'fullname': _nameController.text,
                      'email': _emailController.text,
                      'phone': _phoneController.text,
                      'userType': 'Community',
                      'user_id': widget.userData['user']['_id']
                    };

                    // Call the API to update the profile
                    Api.updateCommunity(context, data);

                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Profile updated successfully')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF40A858), // Button background color
                  foregroundColor: Colors.white, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
