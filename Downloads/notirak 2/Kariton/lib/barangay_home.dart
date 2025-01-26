import 'package:flutter/material.dart';
import 'barangay_community_page.dart'; // Import the file with BarangayCommunitySetSchedScreen
import 'barangay_junkshop.dart';
import 'barangay_collect_scrap_page.dart'; // Import the file with BarangayJunkshopScreen

class BarangayHomeScreen extends StatelessWidget {
  final Map data;

  const BarangayHomeScreen({Key? key, required this.data}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background color for the top half
          Container(
            height: MediaQuery.of(context).size.height / 2.8,
            color: Color.fromARGB(184, 162, 207, 125),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 70.0, 20.0, 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Location Icon and Greeting
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.grey),
                        SizedBox(width: 8.0),
                        Text(
                          'Located at ${data['barangay']['bLocation']}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
                    ),
                
                  ],
                ),
                SizedBox(height: 16.0),

                // Total Points
                Text(
                  '',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                  ),
                ),
                SizedBox(height: 16.0),

                // Display Barangay Name instead of Search Box
                Center(
                  child: Text(
                    '${data['barangay']['bName']}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
                SizedBox(height: 16.0),

                // Sort Trash Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BarangayCollectScrapPage(data: data)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF40A858), // Background color
                      foregroundColor: Colors.white, // Text color
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 100),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Collect Scrap',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20.0),

                // Category Row
           
                SizedBox(height: 16.0),

                // Category Items
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CategoryItem(
                      title: 'Community',
                      assetPath: 'assets/COMMUNITYAA.png',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CommunityPage(data: data),
                          ),
                        );
                      },
                    ),
                    CategoryItem(
                      title: 'Junkshop',
                      assetPath: 'assets/JSHOPAAA.png',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BarangayJunkshopScreen(data: data),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String title;
  final String assetPath;
  final VoidCallback onTap; // Add onTap callback

  CategoryItem({
    required this.title,
    required this.assetPath,
    required this.onTap, // Initialize onTap
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.grey),
        ),
        child: Column(
          children: [
            Image.asset(assetPath),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: onTap, // Use the onTap callback
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF40A858), // Background color
                foregroundColor: Colors.white, // Text color
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Click here',
                style: TextStyle(
                  fontFamily: 'Roboto',
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
            SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }
}
