import 'package:flutter/material.dart';
import 'package:notirak/api/api.dart';
import 'community_scrap_points_screen.dart'; // Import the new screen

class RedeemCashScreen extends StatefulWidget {
  final Map userData; // Accept user data

  const RedeemCashScreen({Key? key, required this.userData}) : super(key: key);

  @override
  _RedeemCashScreenState createState() => _RedeemCashScreenState();
}

class _RedeemCashScreenState extends State<RedeemCashScreen> {
  final TextEditingController _pointsController = TextEditingController();
  final TextEditingController _cashController = TextEditingController();
  late double _conversionRate; // Declare conversion rate
  String _errorMessage = ''; // Variable to hold error message

  @override
  void initState() {
    super.initState();
    _conversionRate = _safeParseDouble(widget.userData['cash']?['pointsEquivalent']);
    _pointsController.addListener(_updateCash);
    _cashController.addListener(_updatePoints);
  }

  double _safeParseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is String) return double.tryParse(value) ?? 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return 0.0;
  }

  String _safeParseString(dynamic value) {
    return value?.toString() ?? '0';
  }

  void _updateCash() {
    final points = _safeParseDouble(_pointsController.text);
    final cash = points * _conversionRate;
    if (_cashController.text != cash.toStringAsFixed(2)) {
      _cashController.text = cash.toStringAsFixed(2);
    }
  }

  void _updatePoints() {
    final cash = _safeParseDouble(_cashController.text);
    final points = cash / _conversionRate;
    if (_pointsController.text != points.toStringAsFixed(0)) {
      _pointsController.text = points.toStringAsFixed(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final redeemIsActive = widget.userData['barangay']?['redeemIsActive'] ?? false;

    if (!redeemIsActive) {
      return _buildRedemptionUnavailableScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Redeem Points - Cash'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            Text(
              'Hi, ${_safeParseString(widget.userData['user']?['fullname'])}!',
              style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            const Text('You have earned', style: TextStyle(fontSize: 16.0)),
            const SizedBox(height: 16.0),
            _buildPointsSummary(),
            const SizedBox(height: 16.0),
            Text(
              'Conversion Rate: 1 Point = ${_safeParseString(widget.userData['cash']?['pointsEquivalent'])} PHP',
              style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            _buildInputFields(),
            const SizedBox(height: 16.0),
            _buildRedeemButton(),
            const SizedBox(height: 16.0),
            _buildErrorMessage(),
          ],
        ),
      ),
    );
  }

  Widget _buildRedemptionUnavailableScreen() {
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
                    "id": widget.userData['user']['_id'],
                    "type": "Community"
                  };
                  Api.getHome(context, data);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 32.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  elevation: 8.0,
                  backgroundColor: const Color(0xFF40A858),
                  foregroundColor: Colors.white,
                  shadowColor: Colors.grey.withOpacity(0.5),
                ),
                child: const Text(
                  'Go Back to Home',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPointsSummary() {
    return Container(
      color: const Color.fromARGB(197, 233, 255, 182),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${_safeParseString(widget.userData['user']?['points'])}',
                style: const TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF40A858),
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                'Total Points',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScrapPointsScreen(userData: widget.userData),
                ),
              );
            },
            child: const Icon(Icons.more_vert, color: Color(0xFF40A858)),
          ),
        ],
      ),
    );
  }

  Widget _buildInputFields() {
    return Column(
      children: [
        TextField(
          controller: _pointsController,
          decoration: const InputDecoration(
            labelText: 'Points',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16.0),
        TextField(
          controller: _cashController,
          decoration: const InputDecoration(
            labelText: 'Cash (PHP)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildRedeemButton() {
    return ElevatedButton(
      onPressed: () {
        redeemPoints();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF40A858),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 15.0),
      ),
      child: const Text('Redeem'),
    );
  }

  Widget _buildErrorMessage() {
    return Visibility(
      visible: _errorMessage.isNotEmpty,
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Text(
          _errorMessage,
          style: const TextStyle(color: Colors.red, fontSize: 14.0),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    var requestData = {
      "id": widget.userData['user']['_id'],
      "type": "Community"
    };

    try {
      final updatedData = await Api.getHome(context, requestData);
    } catch (error) {
      print("Error refreshing data: $error");
    }
  }

  Future<void> redeemPoints() async {
    final points = _safeParseDouble(_pointsController.text);
    final cash = _safeParseDouble(_cashController.text);
    final totalPoints = _safeParseDouble(widget.userData['user']?['points']);

    if (points == 0 || cash == 0) {
      setState(() {
        _errorMessage = 'Please enter valid points and cash values.';
      });
      return;
    }

    if (points > totalPoints) {
      setState(() {
        _errorMessage = 'You cannot redeem more points than you currently have.';
      });
      return;
    }

    // Perform redemption logic
    var redeemData = {
      "userId": widget.userData['user']['_id'],
      "points": points,
      "cash": cash,
    };

    
    try {
      var data = {
        'user_id': widget.userData['user']?['_id'],
        'points': points,
        'cash': cash,
        'barangay': widget.userData['user']?['barangay']
      };
      await Api.redeem(context, data);
      // Clear error message after successful redeem
      setState(() {
        _errorMessage = '';
        _pointsController.clear();
        _cashController.clear();
      });
    }  catch (error) {
      print("Error redeeming points: $error");
    }
  }

  @override
  void dispose() {
    _pointsController.dispose();
    _cashController.dispose();
    super.dispose();
  }
}
