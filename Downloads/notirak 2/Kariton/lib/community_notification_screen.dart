import 'package:flutter/material.dart';
import 'package:notirak/api/api.dart';

class NotificationsScreen extends StatefulWidget {
  final Map data;

  const NotificationsScreen({Key? key, required this.data}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late List<dynamic> combinedHistory;

  @override
  void initState() {
    super.initState();
    combinedHistory = _extractCombinedHistory();
  }

  // Extract and combine the history logs from the data
  List<dynamic> _extractCombinedHistory() {
    Map historyData = widget.data['history'] ?? {};
    List<dynamic> historyList = [];

    historyData.forEach((key, value) {
      historyList.addAll(value);
    });

    // Reverse the history to show the latest first
    return historyList.reversed.toList();
  }

  // Simulate refreshing data with an API call
  Future<void> _refreshData() async {
    var requestData = {
      "id": widget.data['user']['_id'],
      "type": "Community"
    };

    try {
      // Simulating a network call to fetch updated logs
      final updatedData = await Api.getHome(context, requestData);

      // Update the state with new history data
     
    } catch (error) {
      // Handle the error (show message, log, etc.)
      print("Error refreshing data: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 40.0),
        child: RefreshIndicator(
          onRefresh: _refreshData, // Trigger refresh on pull
          child: ListView.builder(
            itemCount: combinedHistory.length,
            itemBuilder: (context, index) {
              var log = combinedHistory[index];
              return Column(
                children: [
                  NotificationItem(
                    iconPath: 'assets/profile_icon.png', // Replace with correct icon path
                    message: log['logs'] ?? 'No message available',
                    time: log['time'] ?? 'Unknown time',
                    type: log['type'] ?? 'General', // Notification type
                  ),
                  SizedBox(height: 16.0), // Space between notifications
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final String iconPath;
  final String message;
  final String time;
  final String type; // Add a new parameter for notification type

  const NotificationItem({
    Key? key,
    required this.iconPath,
    required this.message,
    required this.time,
    required this.type, // Include the notification type in constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Color(0xFF00AA5B), // Border color
          width: 1.0, // Border width
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // Align items vertically centered
        children: [
          ClipOval(
            child: Container(
              width: 52, // Set width to 52
              height: 52, // Set height to 52
              decoration: BoxDecoration(
                color: Colors.grey[200], // Placeholder color
                borderRadius: BorderRadius.circular(26.0), // Half of width or height for circle
              ),
              child: Center(
                child: Image.asset(
                  iconPath,
                  width: 52,
                  height: 52,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      type, // Display notification type instead of "Notification"
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      time,
                      style: TextStyle(color: const Color.fromARGB(255, 199, 197, 197)),
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                Text(
                  message,
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
