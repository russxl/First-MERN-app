import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notirak/api/api.dart'; // Ensure the API is correctly imported

class BarangayCollectScrapPage extends StatefulWidget {
  final Map data;

  const BarangayCollectScrapPage({Key? key, required this.data}) : super(key: key);

  @override
  _BarangayCollectScrapPageState createState() => _BarangayCollectScrapPageState();
}

class _BarangayCollectScrapPageState extends State<BarangayCollectScrapPage> {
  final _pageController = PageController();
  final _idController = TextEditingController();
  bool _userExists = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Collect Scrap',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Disable swipe to prevent invalid index
        children: [
          _buildInitialPage(context),
          Builder(
            builder: (context) {
              return DetailPage(userId: _idController.text, data: widget.data);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInitialPage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Collection of Scraps',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Please enter the member ID',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'ID No. *',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
            ),
          ),
          TextField(
            controller: _idController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number, // Accept only numbers
            inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Ensure only digits are accepted
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                if (_idController.text.isNotEmpty) {
                  // Check if the user exists using the API
                  _userExists = await _checkUserExists(_idController.text);
                  
                  if (_userExists) {
                    setState(() {}); // Update UI
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    // Show an alert if user does not exist
                    _showUserNotExistAlert(context);
                  }
                } else {
                  // Show an alert if ID is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter an ID')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF40A858),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Next',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _checkUserExists(String userId) async {
    try {
      // Pass the user ID as part of the data map
      Map<String, String> data = {'userId': userId};  // Adjust based on your backend needs
      bool userExists = await Api.checkUserExist(data); // Call the updated API method

      return userExists; // Return true or false based on the API response
    } catch (e) {
      // Handle error cases and print if needed
      print('Error checking user: $e');
      return false;
    }
  }

  void _showUserNotExistAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text('User does not exist. Please check the ID.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class DetailPage extends StatefulWidget {
  final String userId;
  final Map data;

  const DetailPage({Key? key, required this.userId, required this.data}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String _selectedScrapType = '';
  late List<String> _scrapTypes;
  final _weightController = TextEditingController();
  final _pointsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrapTypes = List<String>.from(widget.data['scrap'].map((scrap) => scrap['scrapType']));
    _selectedScrapType = _scrapTypes.isNotEmpty ? _scrapTypes.first : '';
    _weightController.addListener(_calculatePoints);
  }

  @override
  void dispose() {
    _weightController.removeListener(_calculatePoints);
    _weightController.dispose();
    _pointsController.dispose();
    super.dispose();
  }

  void _calculatePoints() {
    if (_weightController.text.isEmpty) {
      _pointsController.text = '0';
      return;
    }

    double weight = double.tryParse(_weightController.text) ?? 0.0;
    int scrapPoints = _getScrapPoints(_selectedScrapType);
    int equivalentPoints = (weight * scrapPoints).toInt();
    _pointsController.text = equivalentPoints.toString();
  }

  int _getScrapPoints(String scrapType) {
    var scrap = widget.data['scrap'].firstWhere(
      (scrap) => scrap['scrapType'] == scrapType,
      orElse: () => {'pointsEquivalent': '0'},
    );
    return int.tryParse(scrap['pointsEquivalent'].toString()) ?? 0;
  }

 Future<void> _confirmCollection() async {
  // Check if all required fields are filled
  if (_selectedScrapType.isEmpty || _weightController.text.isEmpty || _pointsController.text == '0') {
    // Show a validation alert
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text('Please complete all the required fields and ensure the weight is valid.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
    return; // Exit the function to prevent further processing
  }

  // Show confirmation dialog before collecting the scrap
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Collection'),
        content: const Text('Are you sure you want to collect the scraps?'),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Close confirmation dialog

              // Show success alert
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: const Text('Scrap collection confirmed!'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () async {
                          // Proceed with the scrap collection
                          Map<String, dynamic> collectionData = {
                            'userId': widget.userId,
                            'scrapType': _selectedScrapType,
                            'weight': _weightController.text,
                            'points': _pointsController.text,
                            'barangayID': widget.data['barangay']['_id'],
                            'barangayName': widget.data['barangay']['bName'],
                          };

                          await Api.collectScrap(context, collectionData);

                        },
                        child: const Text('Done'),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('No'),
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text(
          'Details',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Complete all the information',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Scrap Type *',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
        ),
        DropdownButtonFormField<String>(
          value: _selectedScrapType,
          items: _scrapTypes.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedScrapType = newValue!;
              _calculatePoints();
            });
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Weight (kg) *',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
        ),
        TextField(
  controller: _weightController,
  keyboardType: TextInputType.numberWithOptions(decimal: true),
  inputFormatters: [
    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')), // Allows numbers with up to two decimal places
  ],
  decoration: const InputDecoration(
    border: OutlineInputBorder(),
    hintText: 'Enter weight in kg',
  ),
),

        const SizedBox(height: 20),
        const Text(
          'Points Equivalent',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
        ),
        TextField(
          controller: _pointsController,
          readOnly: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Calculated points',
          ),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: _confirmCollection,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF40A858),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text(
            'Confirm Collection',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
