import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class JunkshopDetailScreen extends StatelessWidget {
  final Map<String, dynamic> data; // Map for the junkshop data

  const JunkshopDetailScreen({Key? key, required this.data}) : super(key: key);

  // Open the map app (Google Maps, Waze, etc.) with the junkshop's location
  void _openDirections(BuildContext context) async {
    String address = data['junkShop']['address'] ?? '';
    String brgy = data['barangay']['bLocation'] ?? '';

    if (address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Address is not available')),
      );
      return;
    }

    if (brgy.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Barangay location is not available')),
      );
      return;
    }

    String urlString = '';
    Uri url = Uri.parse(urlString);

    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ensure 'junkScrap' is a List<Map<String, dynamic>>
    var categories = List<Map<String, dynamic>>.from(data['junkScrap'] ?? []);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Junkshop Details"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Junkshop Name
            Text(
              data['junkShop']['jShopName'] ?? 'Unknown Junkshop',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
            SizedBox(height: 16.0),

            // Location
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.grey, size: 20),
                SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    'Located at ${data['junkShop']['address'] ?? 'Unknown Location'}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),

            // Owner
            Row(
              children: [
                Icon(Icons.person, color: Colors.grey, size: 20),
                SizedBox(width: 8.0),
                Text(
                  data['junkShop']['ownerName'] ?? 'Unknown Owner',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),

            // Phone
            Row(
              children: [
                Icon(Icons.call, color: Colors.grey, size: 20),
                SizedBox(width: 8.0),
                Text(
                  data['junkShop']['phone'] ?? 'No phone number',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),

            // Email
            Row(
              children: [
                Icon(Icons.mail, color: Colors.grey, size: 20),
                SizedBox(width: 8.0),
                Text(
                  data['junkShop']['email'] ?? 'No email provided',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.0),

            // Details
            Text(
              'Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              data['junkShop']['description'] ?? 'No description available',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Roboto',
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 24.0),

            // Categories Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    'Price',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),

            // Categories List
            Expanded(
              child: ListView(
                children: categories.map<Widget>((category) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          category['scrapType'] ?? 'Unknown Type',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                          ),
                        ),
                        Text(
                          category['pointsEquivalent'].toString() ?? '0',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Roboto',
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 24.0),

            // Directions Button
            GestureDetector(
              onTap: () => _openDirections(context),
              child: Row(
                children: [
                  Icon(Icons.directions, color: Colors.grey, size: 20),
                  SizedBox(width: 8.0),
                  Text(
                    'Directions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
