import 'package:flutter/material.dart';
import 'package:notirak/api/api.dart';
import 'package:notirak/community_main_screen.dart';

class RedeemableItemDetailsScreen extends StatelessWidget {
  final String itemName;
  final String points;
  final String description;
  final Map userData;

  RedeemableItemDetailsScreen({
    required this.itemName,
    required this.points,
    required this.description,
    Key? key,
    required this.userData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If the name of the good is "cash", we return an empty container or handle it differently
    if (itemName.toLowerCase() == "cash") {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Redeem Item'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('This item is not redeemable here.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(itemName),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              itemName,
              style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Til ${userData['redeemDate']['date']}',
              style: const TextStyle(fontSize: 16.0, color: Colors.grey),
            ),
            const SizedBox(height: 8.0),
            Text(
              '$points points',
              style: const TextStyle(fontSize: 16.0, color: Colors.grey),
            ),
            const SizedBox(height: 8.0),
            Text(
              '${userData['redeemDate']['endTime']} ',
              style: const TextStyle(fontSize: 16.0, color: Colors.grey),
            ),
            const SizedBox(height: 16.0),
            Text(
              description,
              style: const TextStyle(fontSize: 16.0),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                _redeemItem(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF40A858), // Button background color
                foregroundColor: Colors.white, // Button text color
                padding: const EdgeInsets.symmetric(vertical: 15.0),
              ),
              child: const Text('Use Now'),
            ),
          ],
        ),
      ),
    );
  }

  void _redeemItem(BuildContext context) async {
    // Convert points to double for comparison
    final double userPoints = double.tryParse(userData['user']['points'].toString()) ?? 0.0;
    final double requiredPoints = double.tryParse(points) ?? 0.0;

    // Check if user has enough points
    if (userPoints < requiredPoints) {
      _showErrorDialog(context, 'You do not have enough points to redeem this item.');
      return; // Stop execution if points are insufficient
    }

    try {
      // Call the API to redeem the item here
      var data = {
        'user_id': userData['user']['_id'],
        'points': points,
        'barangay': userData['user']['barangay']
      };
      await Api.redeem(context, data);

      // If the API call is successful, show the redemption alert
      _showRedemptionAlert(context);
    } catch (e) {
      // Handle any errors during the API call
      _showErrorDialog(context, e.toString());
    }
  }

  void _showRedemptionAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Pending Request',
            style: TextStyle(color: Colors.black),
          ),
          content: const Text(
            'For the time being, the request will remain pending while we verify the redemption you made.',
            style: TextStyle(color: Color.fromARGB(255, 87, 92, 88)),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Done',
                style: TextStyle(color: Color(0xFF40A858)),
              ),
              onPressed: () {
                var id ={
                  "id":userData['user']["_id"],
                  "type":"Community"
                };
             Api.getHome(context, id);
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Error',
            style: TextStyle(color: Colors.red),
          ),
          content: Text(
            errorMessage,
            style: const TextStyle(color: Color.fromARGB(255, 87, 92, 88)),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Close',
                style: TextStyle(color: Color(0xFF40A858)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
