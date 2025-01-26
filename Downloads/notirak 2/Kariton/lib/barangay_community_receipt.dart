import 'package:flutter/material.dart';
import 'package:notirak/barangay_main_screen.dart';

class ReceiptPage extends StatelessWidget {
  final Map data;

  const ReceiptPage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Transaction Receipt',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
          Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => BarangayMainScreen(data:data)) );
 // Go to home page (replace with your route to home page)
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: 80,
              color: Colors.blue,
            ),
            SizedBox(height: 20),
            Text(
              'Scrap Collection Receipt',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            _buildDetailsRow('User ID', data['member']['userID']),
            _buildDetailsRow('Scrap Type', data['scrapType']),
            _buildDetailsRow('Weight (kg)', data['weight']),
            _buildDetailsRow('Points Earned', data['points']),
            Spacer(),
            Text(
              'Thank you for contributing to waste management!',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
