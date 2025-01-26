import 'package:flutter/material.dart';
import 'package:notirak/api/api.dart';
import 'barangay_junkshop_detail.dart'; // Import the file with JunkshopDetailScreen

class BarangayJunkshopScreen extends StatelessWidget {
  final Map<dynamic, dynamic> data; // Keep type as Map to handle various keys

  const BarangayJunkshopScreen({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int junkCount = data['junk']?.length ?? 0; // Null check for 'junk' list
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Junkshop',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Nearby Junkshops Title
            const Text(
              'Nearby Junkshops',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 16.0),

            // Junkshop Containers
            Expanded(
              child: junkCount > 0
                  ? ListView.builder(
                      itemCount: junkCount, // Use the count of the junkshops
                      itemBuilder: (context, index) {
                        final junkshop = data['junk']?[index] ?? {}; // Null check for each junkshop
                        return _buildJunkshopItem(
                          context: context,
                          address: junkshop['address'] ?? 'No Address Available',
                          name: junkshop['jShopName'] ?? 'No Name Available',
                          owner: junkshop['_id'] ?? 'Unknown Owner',
                          data: data,
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'No nearby junkshops found',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ), // Display this when junkCount is 0
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJunkshopItem({
    required BuildContext context,
    required String address,
    required String name,
    required String owner,
    required Map data,
  }) {
    return GestureDetector(
      onTap: () {
        var datas = {
          "id": owner,
          "bID": data['barangay']?['_id'] ?? 'Unknown', // Null check for barangay ID
        };
        Api.junkShopList(context, datas);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.grey),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              address,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                fontFamily: 'Roboto',
                color: Colors.grey, // Make text grey
              ),
            ),
          ],
        ),
      ),
    );
  }
}
