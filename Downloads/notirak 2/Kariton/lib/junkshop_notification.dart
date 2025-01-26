import 'package:flutter/material.dart';
import 'package:notirak/api/api.dart';

class NotificationJunkshop extends StatelessWidget {
  final Map data;

  const NotificationJunkshop({Key? key, required this.data}) : super(key: key);

  Future<void> _refreshData(BuildContext context) async {
    // Prepare data for API call
    var newData = {
      "id": data['junkOwner']['_id'],
      'type': "Junkshop",
    };

    // Fetch new data
    await Api.getHome(context, newData);
    
    // Show a message indicating successful refresh
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Scraps list saved successfully.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Check if userLogs exists and is a list
    List userLogs = data['userLogs'] ?? [];
    print(userLogs); // Debug print

    // Reverse the logs to display the latest first
    List reversedLogs = userLogs.reversed.toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Notification',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshData(context), // Link to the refresh function
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'New',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: reversedLogs.length, // Length of reversedLogs
                itemBuilder: (context, index) {
                  // For each log, display a notification tile
                  var log = reversedLogs[index];
                  return _buildNotificationTile(
                    title: log['logs'] ?? 'No Title', // Title from log
                    subtitle: 'Date: ${log['date'] ?? 'Unknown'} - ${log['scrapType'] ?? 'No Scrap Type'}',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationTile({required String title, required String subtitle}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
          width: 1.0,
        ),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
      ),
    );
  }
}
