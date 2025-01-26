import 'package:flutter/material.dart';

class ScrapPointsScreen extends StatelessWidget {
  final Map userData; // Accepts data from userData['scraps']

  const ScrapPointsScreen({Key? key, required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List scraps = userData['scraps']; // Assuming it's a list of scrap types and points
    return Scaffold(
      appBar: AppBar(
        title: Text('Scrap Equivalent Points'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: scraps.length,
                itemBuilder: (context, index) {
                  final scrap = scraps[index];
                  return _buildScrapOption(scrap['scrapType'], scrap['pointsEquivalent']);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScrapOption(String type, String pointsPerKg) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(type),
          Text('$pointsPerKg Points/kg'),
        ],
      ),
    );
  }
}
