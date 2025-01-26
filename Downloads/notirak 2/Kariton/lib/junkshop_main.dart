import 'package:flutter/material.dart';
import 'package:notirak/api/api.dart';
import 'package:notirak/community_login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'junkshop_notification.dart';
import 'junkshop_history.dart';
import 'junkshop_profile.dart';
import 'junkshop_scrap_price.dart';
import 'junkshop_sorting.dart';
import 'junkshop_booking_page.dart';
import 'junkshop_view_sched.dart';

class JunkshopMainScreen extends StatefulWidget {
  final Map data;

  const JunkshopMainScreen({Key? key, required this.data}) : super(key: key);

  @override
  _JunkshopMainScreenState createState() => _JunkshopMainScreenState();
}

class _JunkshopMainScreenState extends State<JunkshopMainScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  bool _isLoading = false; // Loading state variable

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true; // Set loading state to true
    });

    // Prepare data for API call
    var data = {
      "id": widget.data['junkOwner']['_id'],
      'type': "Junkshop",
    };

    // Fetch new data
    await Api.getHome(context, data);

    setState(() {
      _isLoading = false; // Reset loading state after data is fetched
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
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

  @override
  Widget build(BuildContext context) {
    var data = widget.data;
    bool isApproved = data['junkOwner']['isApproved'] == true;

    // If the account is not approved, show the under review screen
    if (!isApproved) {
      return _buildUnderReviewScreen();
    }

    // Main content
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false, // Remove back button
        title: const Text(
          'KARITON',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: <Widget>[
          // The first page contains the refreshable content
          RefreshIndicator(
            onRefresh: _refreshData,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Hello, ${data['junkOwner']['ownerName']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _buildActionContainer(
                      context,
                      icon: Icons.attach_money,
                      label: 'Set Price',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SetPriceJunkshop(data: data),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16.0),
                  ],
                ),
                const SizedBox(height: 16.0),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Schedule your first scrap collection',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingPage(data: data),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: const BorderSide(
                        color: Colors.green,
                        width: 2.0,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 18.0, horizontal: 16.0),
                  ),
                  child: const Text(
                    'Schedule Now',
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Other pages in the PageView
          NotificationJunkshop(data: data),
          HistoryJunkshop(data: data),
          ProfileJunkshop(data: data),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
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
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedLabelStyle: const TextStyle(color: Colors.black),
        unselectedLabelStyle: const TextStyle(color: Colors.grey),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  // Widget for the under review screen
  Widget _buildUnderReviewScreen() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  _isLoading = true; // Start loading when the button is pressed
                });
                await _refreshData(); // Refresh data
                setState(() {
                  _isLoading = false; // Stop loading after data is refreshed
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Set your button color
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              ),
              child: _isLoading // Show loading spinner if loading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text(
                      'Reload',
                      style: TextStyle(color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionContainer(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onPressed}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2.0,
            blurRadius: 6.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(
              icon,
              color: Colors.green.withOpacity(0.7),
              size: 32.0,
            ),
            onPressed: onPressed,
          ),
          const SizedBox(height: 8.0),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}
