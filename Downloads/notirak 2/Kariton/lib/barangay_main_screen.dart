import 'package:flutter/material.dart';
import 'package:notirak/api/api.dart';
import 'package:notirak/barangay_notification.dart';
import 'package:notirak/community_login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'barangay_home.dart';
import 'barangay_profile.dart';

class BarangayMainScreen extends StatefulWidget {
  final Map data;

  const BarangayMainScreen({Key? key, required this.data}) : super(key: key);

  @override
  _BarangayMainScreenState createState() => _BarangayMainScreenState();
}

class _BarangayMainScreenState extends State<BarangayMainScreen> {
  int _selectedIndex = 0;
  late bool isApproved;
  bool _isLoading = false; // Loading state variable
  String? _errorMessage; // Variable to hold error message

  @override
  void initState() {
    super.initState();
    // Initialize `isApproved` when the widget is created
    isApproved = widget.data['barangay']['isApproved'] == true;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  Future<void> _reloadData() async {
    setState(() {
      _isLoading = true; // Start loading when the reload button is pressed
      _errorMessage = null; // Clear previous error message
    });

    // Prepare data for API call
    var data = {
      "id": widget.data['barangay']['_id'],
      'type': "Barangay",
    };

    try {
      // Fetch new data
      await Api.getHome(context, data); // Replace with your actual API method
    } catch (e) {
      // Handle errors and set error message
      setState(() {
        _errorMessage = 'Failed to reload data: $e'; // Capture error
      });
    } finally {
      setState(() {
        _isLoading = false; // Stop loading after data is refreshed
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // If the barangay is not approved, show the pending approval screen
    if (!isApproved) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'KARITON',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.hourglass_empty, size: 100, color: Colors.green),
              const SizedBox(height: 24),
              const Text(
                'Your account is under review.',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Please wait for your approval to fully access the app.',
                style: TextStyle(
                  fontSize: 16.0,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // Reload button
              ElevatedButton(
                onPressed: _reloadData, // Call the reload function
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Button background color
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 32.0),
                ),
                child: _isLoading // Show loading spinner if loading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        'Reload',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white, // Button text color
                        ),
                      ),
              ),
              if (_errorMessage != null) // Display error message if any
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 16),
              // Logout button
              ElevatedButton(
                onPressed: _logout, // Call the logout function
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Button background color
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 32.0),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white, // Button text color
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // If the barangay is approved, show the main content
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          BarangayHomeScreen(data: widget.data),
          BarangayNotificationScreen(data: widget.data),
          BarangayProfileScreen(data: widget.data),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Color(0xFF40A858),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
    );
  }
}
