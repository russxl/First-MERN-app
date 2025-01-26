import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notirak/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'community_login_screen.dart';
import 'EditJunkshopDetailPage.dart';

class ProfileJunkshop extends StatefulWidget {
  final Map<dynamic, dynamic> data;

  const ProfileJunkshop({Key? key, required this.data}) : super(key: key);

  @override
  _ProfileJunkshopState createState() => _ProfileJunkshopState();
}

class _ProfileJunkshopState extends State<ProfileJunkshop> {
  String name = '';
  String email = '';
  String phone = '';
  File? _profileImage;
  Uint8List? _profileImageData;
  Uint8List? _validId;
  Uint8List? _permit;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  void _loadProfileData() {
    name = widget.data['junkOwner']['jShopName'] ?? '';
    email = widget.data['junkOwner']['email'] ?? '';
    phone = widget.data['junkOwner']['phone'] ?? '';
    if (widget.data['junkOwner']['jShopImg'] != null) {
      _profileImageData = base64Decode(widget.data['junkOwner']['jShopImg']);
    }
    if (widget.data['junkOwner']['validID'] != null) {
      _validId = base64Decode(widget.data['junkOwner']['validID']);
    }
    if (widget.data['junkOwner']['permit'] != null) {
      _permit = base64Decode(widget.data['junkOwner']['permit']);
    }
  }

  Future<void> _fetchUpdatedData() async {
    var data = {
      "id": widget.data['junkOwner']['_id'],
      'type': "Junkshop",
    };

    try {
      // Fetch new data from the API
      var newData = await Api.getHome(context, data);
      // Update the state with new data
      setState(() {
        // Update profile data here if needed
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile data reloaded successfully.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to reload profile data.')),
      );
    }
  }

  void _onEditProfileButtonPressed() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditProfilePage(
          name: name,
          email: email,
          phone: phone,
          profileImageData: _profileImageData,
          profileImageFile: _profileImage,
          data: widget.data,
        ),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        name = result['name'] ?? name;
        email = result['email'] ?? email;
        phone = result['phone'] ?? phone;
        _profileImage = result['profileImageFile'] ?? _profileImage;
        _profileImageData = result['profileImageData'] ?? _profileImageData;
      });
    }
  }

  void _onMyAccountPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => EditJunkshopDetailPage()),
    );
  }

  Future<void> _onLogoutPressed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  void _showJunkshopPicture() {
    if (_profileImageData != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Junkshop Picture'),
          content: Image.memory(_profileImageData!),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No Junkshop Picture available')),
      );
    }
  }

  void _showValidIDPicture() {
    if (_validId != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Valid ID'),
          content: Image.memory(_validId!),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No Valid ID available')),
      );
    }
  }

  void _showPermitPicture() {
    if (_permit != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Permit'),
          content: Image.memory(_permit!),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No Permit available')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _fetchUpdatedData, // Link to the refresh function
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            CircleAvatar(
              radius: 50.0,
              backgroundImage: _profileImage != null
                  ? FileImage(_profileImage!)
                  : _profileImageData != null
                      ? MemoryImage(_profileImageData!)
                      : const AssetImage('assets/images/avatar.png')
                          as ImageProvider,
              backgroundColor: Colors.green,
            ),
            const SizedBox(height: 16.0),
            Text(name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 15.0)),
            const SizedBox(height: 8.0),
            Text(widget.data['junkOwner']['jShopName'] ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 10.0, color: Colors.grey)),
            const SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: _onEditProfileButtonPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 80.0, vertical: 25.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                ),
                child: const Text('Junk Shop Information'),
              ),
            ),
            const SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildProfileActionTile(
                    icon: Icons.description,
                    label: 'Business Permit',
                    onTap: _showPermitPicture),
                _buildProfileActionTile(
                    icon: Icons.perm_identity,
                    label: 'Valid ID',
                    onTap: _showValidIDPicture),
                _buildProfileActionTile(
                    icon: Icons.image,
                    label: 'Junkshop Picture',
                    onTap: _showJunkshopPicture),
              ],
            ),
            const SizedBox(height: 24.0),
            ListTile(
              leading: _buildLeadingIcon(Icons.logout),
              title: const Text('Logout',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              onTap: _onLogoutPressed,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileActionTile(
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 1.0),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2.0,
                blurRadius: 6.0)
          ],
        ),
        child: InkWell(
          onTap: onTap,
          child: Column(
            children: [
              Icon(icon, size: 30.0, color: Colors.green),
              const SizedBox(height: 8.0),
              Text(label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeadingIcon(IconData icon) {
    return CircleAvatar(
      backgroundColor: Colors.green,
      radius: 20.0,
      child: Icon(icon, color: Colors.white),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final Uint8List? profileImageData;
  final File? profileImageFile;
  final Map<dynamic, dynamic> data;

  const EditProfilePage({
    Key? key,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImageData,
    this.profileImageFile,
    required this.data,
  }) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  File? _profileImageFile;
  Uint8List? _profileImageData;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _emailController = TextEditingController(text: widget.email);
    _phoneController = TextEditingController(text: widget.phone);
    _profileImageFile = widget.profileImageFile;
    _profileImageData = widget.profileImageData;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImageFile = File(pickedFile.path);
      });
    }
  }

  bool _isValidPhoneNumber(String phoneNumber) {
    // Regular expression for validating Philippine phone numbers
    final RegExp phoneRegExp = RegExp(r'^(09|\+639)\d{9}$');
    return phoneRegExp.hasMatch(phoneNumber);
  }

  Future<void> _updateProfile() async {
    final String name = _nameController.text;
    final String email = _emailController.text;
    final String phone = _phoneController.text;

    if (name.isEmpty || email.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required.')),
      );
      return;
    }

    if (!_isValidPhoneNumber(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid Philippine phone number.')),
      );
      return;
    }

    Map<String, dynamic> pdata = {
      'junkShopName': name,
      'email': email,
      'phone': phone,
      'userType': 'Junkshop',
      'id': widget.data['junkOwner']['_id'],
      "type": "Junkshop"
    };

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saving changes...')),
    );

    File? imageFileToUpload = _profileImageFile ??
        (_profileImageData != null
            ? await base64ToFile(base64Encode(_profileImageData!), 'profile_image.png')
            : null);

    try {
      await Api.updateClient(context, pdata, imageFileToUpload!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
      Navigator.pop(context, {
        'name': name,
        'email': email,
        'phone': phone,
        'profileImageFile': _profileImageFile,
        'profileImageData': _profileImageData,
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile. Please try again.')),
      );
    }
  }

  Future<File?> base64ToFile(String base64String, String filename) async {
    try {
      final bytes = base64Decode(base64String);
      final directory = await Directory.systemTemp.createTemp(); // Create a temporary directory
      final file = File('${directory.path}/$filename');

      await file.writeAsBytes(bytes);
      return file;
    } catch (e) {
      print('Error converting base64 to file: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Edit Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          CircleAvatar(
            radius: 50.0,
            backgroundImage: _profileImageFile != null
                ? FileImage(_profileImageFile!)
                : _profileImageData != null
                    ? MemoryImage(_profileImageData!)
                    : const AssetImage('assets/images/avatar.png') as ImageProvider,
            backgroundColor: Colors.green,
          ),
          const SizedBox(height: 16.0),
          TextButton(
            onPressed: _pickImage,
            child: const Text('Change Profile Picture'),
          ),
          const SizedBox(height: 16.0),
          _buildTextField(controller: _nameController, label: 'Name'),
          const SizedBox(height: 8.0),
          _buildTextField(controller: _emailController, label: 'Email', keyboardType: TextInputType.emailAddress, readOnly: true), // Make email field read-only
          const SizedBox(height: 8.0),
          _buildTextField(controller: _phoneController, label: 'Phone Number', keyboardType: TextInputType.phone),
          const SizedBox(height: 24.0),
          ElevatedButton(
            onPressed: _updateProfile,
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false, // New parameter for read-only
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      readOnly: readOnly, // Set the read-only property
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
