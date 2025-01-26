import 'package:flutter/material.dart';
import 'package:notirak/community_login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'community_general_prof.dart'; // Import the new screen
import 'community_history_screen.dart'; // Import the history screen
import 'api/api.dart'; // Import the API for logout

class ProfileScreen extends StatefulWidget {
  final Map userData; // Add this field to accept data

  const ProfileScreen({Key? key, required this.userData}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true, // Center align the title horizontally
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildListTiles(), // Build the list tiles
            SizedBox(height: 30.0),
           
            // Sorting guides section
            SizedBox(height: 30.0),
            _buildLogoutButton(), // Logout button
          ],
        ),
      ),
    );
  }

  Widget _buildListTiles() {
    return Column(
      children: [
        ListTile(
          leading: Image.asset('assets/profile.png', width: 54, height: 54),
          title: Text('General'),
          subtitle: Text('Edit Profile, Change Password..'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CommunityGeneralProf(userData: widget.userData),
              ),
            );
          },
        ),
        Divider(), // Divider between list items
        ListTile(
          leading: Image.asset('assets/transaction.png', width: 54, height: 54),
          title: Text('History'),
          subtitle: Text('View all transaction history..'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HistoryScreen(data: widget.userData),
              ),
            );
          },
        ),
      ],
    );
  }



  Widget _buildGuideItem(String text, String imagePath) {
    return Container(
      width: 100.0, // Adjust width as needed
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(imagePath, width: 54, height: 54),
          SizedBox(height: 8.0),
          Text(
            text,
            style: TextStyle(fontSize: 16.0),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return ElevatedButton.icon(
      onPressed: () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
      },
      icon: Icon(
        Icons.logout,
        color: Colors.white,
      ),
      label: Text(
        'Logout',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red, // Logout button color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
