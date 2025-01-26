import 'package:flutter/material.dart';
import 'community_redeemable_item_details_screen.dart'; // Import the new screen

class AvailableRedeemableGoodsScreen extends StatelessWidget {
  final Map data;

  const AvailableRedeemableGoodsScreen({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Redeemable Goods'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Recent',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: data['reward'].length,
                itemBuilder: (context, index) {
                  final item = data['reward'][index];

                  // Don't render the item if the nameOfGood is "cash"
                  if (item['nameOfGood'] == 'Cash') {
                    return const SizedBox.shrink(); // Return an empty widget
                  }

                  return _buildRedeemableItem(
                    context,
                    item['nameOfGood'],
                    item['pointsEquivalent'],
                    'Redeem your ${item['pointsEquivalent']} points in exchange for this item.',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRedeemableItem(BuildContext context, String itemName, String points, String description) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(itemName, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8.0),
                Text(description, style: const TextStyle(fontSize: 14.0)),
              ],
            ),
          ),
          const SizedBox(width: 16.0),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RedeemableItemDetailsScreen(
                    itemName: itemName,
                    points: points,
                    description: description,
                    userData: data, // Pass any relevant user data if necessary
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF40A858), // Button background color
              foregroundColor: Colors.white, // Button text color
            ),
            child: const Text('Use Now'),
          ),
        ],
      ),
    );
  }
}
