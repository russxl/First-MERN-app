import 'package:flutter/material.dart';

class BarangayCommunityAddGoodsCategory extends StatelessWidget {
  
       final Map data;

  const BarangayCommunityAddGoodsCategory({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Goods',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Make title bold
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Category (points) Title
            const Text(
              'Category ( points )',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Cash TextField
            const Text(
              'Goods',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter the goods',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),

            // Equivalent Points TextField
            const Text(
              'Equivalent Points',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Points',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 40),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Implement save functionality here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF40A858), // Button color
                  foregroundColor: Colors.white, // Text color
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                ),
                child: const Text('hi'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
