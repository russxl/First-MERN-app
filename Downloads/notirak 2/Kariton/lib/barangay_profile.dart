import 'dart:convert'; // Import the convert library to decode Base64
import 'package:flutter/material.dart';
import 'package:notirak/community_login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'barangay_edit_profile.dart'; // Import the EditProfile page
import 'barangay_activity_page.dart'; // Import the BarangayActivityPage

class BarangayProfileScreen extends StatefulWidget {
  final Map data;

  const BarangayProfileScreen({Key? key, required this.data}) : super(key: key);

  @override
  _BarangayProfileScreenState createState() => _BarangayProfileScreenState();
}

class _BarangayProfileScreenState extends State<BarangayProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(20.0, 70.0, 20.0, 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Text(
                'Profile',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              color: Color(0xFF40A858),
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: widget.data['barangay']['bImg'] != null
                        ? MemoryImage(
                            base64Decode(widget.data['barangay']['bImg']), // Decode the Base64 string
                          )
                        : AssetImage('assets/barangay_icon.png'), // Default image if bImg is null
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.data['barangay']['bName']}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Roboto',
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.white),
                    onPressed: () {
                      // Navigate to the EditProfilePage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfilePage(data: widget.data),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),

            // Profile Details Container
            Expanded(
              child: ListView(
                children: <Widget>[
                  // Container for Activity with border
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.history),
                      title: Text(
                        'Activity',
                        style: TextStyle(
                          fontWeight: FontWeight.bold, // Make text bold
                        ),
                      ),
                      subtitle: Text('View all transactions and activities'),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16.0),
                      onTap: () {
                        // Navigate to the BarangayActivityPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BarangayActivityPage(data: widget.data),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 8.0),

                  // Container for Log Out option
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.logout),
                      title: Text(
                        'Log out',
                        style: TextStyle(
                          fontWeight: FontWeight.bold, // Make text bold
                        ),
                      ),
                      subtitle: Text('Further secure your account for safety'),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16.0),
                      onTap: () async {
                        // Clear shared preferences and navigate to LoginScreen
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        await prefs.clear();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                          (Route<dynamic> route) => false,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
