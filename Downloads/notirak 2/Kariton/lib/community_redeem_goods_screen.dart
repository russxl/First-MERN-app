import 'dart:async';
import 'package:flutter/material.dart';
import 'package:notirak/api/api.dart';
import 'community_scrap_points_screen.dart'; // Import the new screen
import 'community_available_redeemable_goods_screen.dart';

class RedeemGoodsScreen extends StatefulWidget {
  final Map userData; // This should include 'name', 'points', and 'rewards' data

  const RedeemGoodsScreen({Key? key, required this.userData}) : super(key: key);

  @override
  _RedeemGoodsScreenState createState() => _RedeemGoodsScreenState();
}

class _RedeemGoodsScreenState extends State<RedeemGoodsScreen> {
  late Map userData;
  
  @override
  void initState() {
    super.initState();
    userData = widget.userData; // Initialize the data
  }

  // Function to refresh data
  Future<void> _refreshData() async {
    var requestData = {
      "id": widget.userData['user']['_id'],
      "type": "Community"
    };

    try {
      // Assuming Api.getHome returns a Future with the refreshed data
      final updatedData = await Api.getHome(context, requestData);

      // Update the state with the new data
     
    } catch (error) {
      // Handle the error (show message, log, etc.)
      print("Error refreshing data: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Safely access user data
    final userFullName = userData['user']?['fullname'] ?? 'User';
    final totalPoints = userData['user']?['points']?.toString() ?? '0';
    final rewards = userData['reward'] ?? [];
    
    // Check if redemption is active
    final redeemIsActive = userData['barangay']?['redeemIsActive'];

    // If redeemIsActive is null or false, show the unavailable screen
    if (redeemIsActive == null || redeemIsActive == false) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Redemption Unavailable'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'The redemption period is not yet available.',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    var data = {
                      "id": userData['user']['_id'],
                      "type": "Community"
                    };
                    Api.getHome(context, data);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 32.0), // Increased padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0), // Rounded corners
                    ),
                    elevation: 8.0, // Adds shadow for raised effect
                    backgroundColor: const Color(0xFF40A858), // Green background color
                    foregroundColor: Colors.white, // White text color
                    shadowColor: Colors.grey.withOpacity(0.5), // Subtle shadow color
                  ),
                  child: const Text(
                    'Go Back to Home',
                    style: TextStyle(
                      fontSize: 18.0, // Larger font size
                      fontWeight: FontWeight.bold, // Bold text
                      letterSpacing: 1.2, // Slight letter spacing
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Normal redeem goods screen if redemption is active
    return Scaffold(
      appBar: AppBar(
        title: const Text('Redeem Points - Goods'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            Text(
              'Hi, $userFullName!',
              style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'You have earned',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            Container(
              color: const Color.fromARGB(197, 233, 255, 182),
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        totalPoints,
                        style: const TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF40A858),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      const Text(
                        'Total Points',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScrapPointsScreen(userData: userData),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.more_vert,
                      color: Color(0xFF40A858),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Redeem some goods in exchange for points...',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), // Prevent scrolling inside the list
              itemCount: rewards.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8.0),
              itemBuilder: (context, index) {
                final reward = rewards[index];

                // Skip rewards where the name of the good is "Cash"
                if (reward['nameOfGood'] == 'Cash') {
                  return const SizedBox.shrink();
                }

                return _buildRedeemOption(
                  reward['pointsEquivalent']?.toString() ?? '0',
                  reward['nameOfGood'] ?? 'Unknown Item',
                );
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AvailableRedeemableGoodsScreen(data: userData),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF40A858), // Button background color
                foregroundColor: Colors.white, // Button text color
                padding: const EdgeInsets.symmetric(vertical: 15.0),
              ),
              child: const Text('Redeem'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRedeemOption(String points, String item) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('$points Points'),
          Text(item),
        ],
      ),
    );
  }
}
