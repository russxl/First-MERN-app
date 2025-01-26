import 'package:flutter/material.dart';
import 'package:notirak/api/api.dart';
import 'community_redeem_cash_screen.dart';
import 'community_redeem_goods_screen.dart';
import 'community_scrap_points_screen.dart'; // Import the new screen

class PointsScreen extends StatefulWidget {
  final Map userData; // Add this field to accept data

  const PointsScreen({Key? key, required this.userData}) : super(key: key);

  @override
  _PointsScreenState createState() => _PointsScreenState();
}

class _PointsScreenState extends State<PointsScreen> {
 
  Future<void> _refreshData() async {
    var requestData = {
      "id": widget.userData['user']['_id'],
      "type": "Community"
    };

    try {
      // Assuming Api.getHome returns a Future with the refreshed data
      final updatedData = await Api.getHome(context, requestData);

      // Update the data state with refreshed data
     
    } catch (error) {
      // Handle the error (show message, log, etc.)
      print("Error refreshing data: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    var name = widget.userData['user']['points'];
    var points =  widget.userData['user']['points'];
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Collect Points',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(30.0, 60.0, 30.0, 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Hi, ${widget.userData['user']['fullname']}',
                style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              const Text(
                'You have earned',
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 16.0),
              Container(
                color: const Color.fromARGB(197, 233, 255, 182),
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '$points',
                          style: const TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF40A858),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        const Text(
                          'Total Points',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
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
                      child: const Icon(
                        Icons.more_vert,
                        color: Color(0xFF40A858),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'You can redeem your points here...',
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _buildItem('Cash', 'assets/cash_icon.png', context),
                  ),
                  const SizedBox(width: 16.0), // Space between items
                  Expanded(
                    child: _buildItem('Goods', 'assets/goods_icon.png', context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(String label, String imagePath, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (label == 'Cash') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RedeemCashScreen(userData: widget.userData),
            ),
          );
        }

        if (label == 'Goods') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RedeemGoodsScreen(userData: widget.userData),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(imagePath, width: 40, height: 40),
            const SizedBox(height: 8.0),
            Text(
              label,
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
