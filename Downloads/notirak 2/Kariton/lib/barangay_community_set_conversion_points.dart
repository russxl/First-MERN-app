import 'package:flutter/material.dart';
import 'barangay_community_cash_points.dart'; // Import your Cash Points page
import 'barangay_community_goods_points.dart'; // Import your Goods Points page

class BarangayCommunitySetConversionPoints extends StatelessWidget {
  final Map data;

  const BarangayCommunitySetConversionPoints({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Set Conversion Points',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Make title bold
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Select Type',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Container for Cash
            InkWell(
              onTap: () {
                // Navigate to BarangayCommunityCashPoints
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BarangayCommunityCashPoints(data: data),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Cash',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Enter the equivalent points in exchange for cash ..',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Container for Goods
            InkWell(
              onTap: () {
                // Navigate to BarangayCommunityGoodsPoints
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BarangayCommunityGoodsPoints(data: data),
                  ),
                );  
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Goods',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Enter the equivalent points in exchange for goods ..',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  // Define the data map to pass to the widget
  final Map<String, dynamic> data = {
    'exampleKey': 'exampleValue',
    // Add more key-value pairs as needed
  };

  runApp(MaterialApp(
    home: BarangayCommunitySetConversionPoints(data: data),
  ));
}
