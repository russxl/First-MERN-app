import 'package:flutter/material.dart';
import 'package:notirak/api/api.dart'; // Make sure this import is correct

class BarangayCommunityCashPoints extends StatefulWidget {
  final Map data;

  const BarangayCommunityCashPoints({Key? key, required this.data}) : super(key: key);

  @override
  _BarangayCommunityCashPointsState createState() => _BarangayCommunityCashPointsState();
}

class _BarangayCommunityCashPointsState extends State<BarangayCommunityCashPoints> {
  late double _conversionRate; // Declare late variable to avoid initialization error

  @override
  void initState() {
    super.initState();
    // Initialize _conversionRate in initState from widget.data
    // Set _conversionRate to 0.0 if the cash field is null or invalid
    _conversionRate = double.tryParse(widget.data['cash']?['pointsEquivalent'] ?? '0') ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Cash',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Make title bold
          ),
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Display the current conversion rate
              Text(
                '1 Peso = $_conversionRate Points',
                style: const TextStyle(
                  fontSize: 24, // Increase font size
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Button to set conversion rate
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    double? newRate = await _showConversionRateDialog(context);
                    if (newRate != null) {
                      setState(() {
                        _conversionRate = newRate;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF40A858), // Green color
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                  ),
                  child: const Text(
                    'Set Conversion Rate',
                    style: TextStyle(fontSize: 18), // Adjust font size
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    // Implement the functionality for saving the conversion rate
                    var data = {
                      'conversion_rate': _conversionRate.toString(),
                      'name': 'Cash',
                      'id': widget.data['barangay']['_id']
                    };
                    await Api.saveCashConversion(context, data);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Conversion rate saved successfully!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Blue color
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(fontSize: 18), // Adjust font size
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<double?> _showConversionRateDialog(BuildContext context) async {
    TextEditingController controller = TextEditingController(text: _conversionRate.toString());
    String errorText = '';

    return showDialog<double>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Set Conversion Rate'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Points per Peso',
                  errorText: errorText.isEmpty ? null : errorText, // Show error message if invalid
                ),
                onChanged: (value) {
                  // Clear error when the user starts typing again
                  setState(() {
                    errorText = '';
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                double? newRate = double.tryParse(controller.text);
                if (newRate == null || newRate <= 0) {
                  // If the input is invalid or 0 or negative, show an error
                  setState(() {
                    errorText = 'Please enter a valid positive number';
                  });
                } else {
                  Navigator.of(context).pop(newRate);
                }
              },
              child: const Text('Set'),
            ),
          ],
        );
      },
    );
  }
}
