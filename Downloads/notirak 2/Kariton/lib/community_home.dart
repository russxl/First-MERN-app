import 'package:flutter/material.dart';
import 'package:notirak/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'community_notification_screen.dart';
import 'community_general_prof.dart';
import 'community_login_screen.dart';

class HomeScreen extends StatefulWidget {
  final Map data; // Assuming data['scraps'] is a list of scrap items

  const HomeScreen({Key? key, required this.data}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Simulating a refresh by reloading the data (you can replace this with your real data fetching logic)
 Future<void> _refreshData() async {
  // Simulating a delay, replace it with the actual API call
  var requestData = {
    "id": widget.data['user']['_id'],
    "type": "Community"
  };

  try {
    // Assuming Api.getHome returns a Future with the refreshed data
    final updatedData = await Api.getHome(context, requestData);

    // Update the data state
 
  } catch (error) {
    // Handle the error (show message, log, etc.)
    print("Error refreshing data: $error");
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData, // Pull-to-refresh handler
        child: SingleChildScrollView( // Makes the entire screen scrollable
          physics: AlwaysScrollableScrollPhysics(), // Always allows scroll even if content is smaller
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context),
                _buildContent(),
                _buildCategories(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 100,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      color: Color(0xFFC9e4B9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PopupMenuButton<String>(
            onSelected: (value) {
              _handleMenuSelection(context, value);
            },
            itemBuilder: (BuildContext context) {
              return {'View Profile'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
            child: ClipOval(
              child: Icon(
                Icons.person,
                size: 20.0,
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationsScreen(data: widget.data),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _handleMenuSelection(BuildContext context, String value) async {
    if (value == 'View Profile') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CommunityGeneralProf(userData: widget.data),
        ),
      );
    }
  }

 Widget _buildContent() {
  return Container(
    height: 300, // Specify a height for the container to make the image larger
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/home_background.png'),
        fit: BoxFit.cover, // Ensures the image covers the entire container
      ),
    ),
    child: Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'By collecting,\nsorting, and \nselling scraps',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}


  Widget _buildCategories() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Container(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.data['scraps'].length, // Use the length of the scraps list
            itemBuilder: (context, index) {
              final scrap = widget.data['scraps'][index]; // Get each scrap from data
              return _buildCategoryItem(scrap);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(Map scrap) {
    return Container(
      width: 120,
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      color: Color(0xFFC9e4B9),
      child: Center(
        child: Text(
          scrap['scrapType'], // Assuming each scrap has a name property
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
