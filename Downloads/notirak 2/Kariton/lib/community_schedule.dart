import 'package:flutter/material.dart';
import 'package:notirak/api/api.dart';

// Mock ScheduleDetailsScreen implementation
class ScheduleDetailsScreen extends StatelessWidget {
  final String day;
  final String location;
  final String time;
  final String scrapType;
  final String description;
  final String longDescription;
  final Map userData;

  ScheduleDetailsScreen({
    required this.day,
    required this.location,
    required this.time,
    required this.scrapType,
    required this.description,
    required this.longDescription,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              day,
              style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text('Location: $location'),
            Text('Time: $time'),
            Text('Scrap Type: $scrapType'),
            const SizedBox(height: 16.0),
            const Text(
              'Description:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(description),
            const SizedBox(height: 16.0),
            const Text(
              'Long Description:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(longDescription),
          ],
        ),
      ),
    );
  }
}

class ScheduleScreen extends StatefulWidget {
  final Map userData;

  // Define userData as a field
  ScheduleScreen({
    required this.userData,
  });

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late List collection;

  @override
  void initState() {
    super.initState();
    // Initializing with userData's collection data
    collection = widget.userData['collection'] ?? [];
  }

  Future<void> _refreshData() async {
    var requestData = {
      "id": widget.userData['user']['_id'],
      "type": "Community"
    };

    try {
      // Assuming Api.getHome returns a Future with the refreshed data
      final updatedData = await Api.getHome(context, requestData);

      // Update the data state and refresh the schedule list
  
    } catch (error) {
      // Handle the error (show message, log, etc.)
      print("Error refreshing data: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Schedule',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: collection.isEmpty
            ? _buildNoScheduleMessage()
            : ListView.builder(
                padding: const EdgeInsets.all(30.0),
                itemCount: collection.length,
                itemBuilder: (context, index) {
                  final item = collection[index];
                  return _buildScheduleItem(
                    context,
                    day: item['dayOfWeek'] ?? 'No data',
                    time: item['startTime'] ?? 'No time',
                    scrapType: item['scrapType'] ?? 'No scrap type',
                    longDescription: item['longDescription'] ?? 'No long description',
                  );
                },
              ),
      ),
    );
  }

  Widget _buildNoScheduleMessage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'No schedules available at the moment.',
          style: TextStyle(fontSize: 18.0, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildScheduleItem(
    BuildContext context, {
    required String day,
    required String time,
    required String scrapType,
    required String longDescription,
  }) {
    return GestureDetector(
      onTap: () {
        // Navigate to ScheduleDetailsScreen when tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScheduleDetailsScreen(
              day: day,
              location: 'Unknown', // You can add this information if available
              time: time,
              scrapType: scrapType,
              description: 'Short description', // Add a proper description here
              longDescription: longDescription,
              userData: widget.userData,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey[400]!,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.only(bottom: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  day,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Time: $time'),
                Text('Scrap Type: $scrapType'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
