import 'package:flutter/material.dart';

class ConversionPointsCashScreen extends StatefulWidget {
  
  @override
  _ConversionPointsCashScreenState createState() => _ConversionPointsCashScreenState();
}

class _ConversionPointsCashScreenState extends State<ConversionPointsCashScreen> {
  final TextEditingController _pointsController = TextEditingController();
  final TextEditingController _cashController = TextEditingController();
  final double _conversionRate = 0.5; // 1 point = 0.5 PHP

  @override
  void initState() {
    super.initState();
    _pointsController.addListener(_updateCash);
    _cashController.addListener(_updatePoints);
  }

  void _updateCash() {
    final points = double.tryParse(_pointsController.text) ?? 0;
    final cash = points * _conversionRate;
    if (_cashController.text != cash.toStringAsFixed(2)) {
      _cashController.text = cash.toStringAsFixed(2);
    }
  }

  void _updatePoints() {
    final cash = double.tryParse(_cashController.text) ?? 0;
    final points = cash / _conversionRate;
    if (_pointsController.text != points.toStringAsFixed(0)) {
      _pointsController.text = points.toStringAsFixed(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversion of Points - Cash'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Conversion Rate: 1 Point = $_conversionRate PHP',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.0),
            TextField(
              controller: _pointsController,
              decoration: InputDecoration(
                labelText: 'Points',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _cashController,
              decoration: InputDecoration(
                labelText: 'Cash (PHP)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                // Add redeem functionality here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF40A858), // Button background color
                foregroundColor: Colors.white, // Button text color
                padding: EdgeInsets.symmetric(vertical: 15.0),
              ),
              child: Text('Redeem'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pointsController.dispose();
    _cashController.dispose();
    super.dispose();
  }
}
