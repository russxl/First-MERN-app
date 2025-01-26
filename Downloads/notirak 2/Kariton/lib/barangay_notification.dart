import 'package:flutter/material.dart';
import 'package:notirak/api/api.dart';

class BarangayNotificationScreen extends StatefulWidget {
  final Map data;

  const BarangayNotificationScreen({Key? key, required this.data}) : super(key: key);

  @override
  _BarangayNotificationScreenState createState() => _BarangayNotificationScreenState();
}

class _BarangayNotificationScreenState extends State<BarangayNotificationScreen> {
  late List<dynamic> userLogs;

  @override
  void initState() {
    super.initState();
    userLogs = widget.data['userLogs'] ?? [];
  }

  Future<void> _refreshData() async {
    var requestData = {
      "id": widget.data['barangay']['_id'],
      "type": "Barangay"
    };

    try {
      // Assuming Api.getHome returns updated data
      final updatedData = await Api.getHome(context, requestData);

      // Update the state with the refreshed data
     
    } catch (error) {
      print("Error refreshing data: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> reversedUserLogs = userLogs.reversed.toList();

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(20.0, 70.0, 20.0, 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Centered Title
            Center(
              child: Text(
                'Notification',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
            SizedBox(height: 10.0),

            // Left-aligned Latest Text
            Text(
              'Latest',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
            SizedBox(height: 16.0),

            // Notification Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshData, // Trigger refresh on pull down
                child: ListView.builder(
                  itemCount: reversedUserLogs.length,
                  itemBuilder: (context, index) {
                    var log = reversedUserLogs[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 16.0),
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                log['date'] ?? 'Unknown date',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                              Text(
                                log['type'] ?? 'General',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                  color: Color(0xFF40A858),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            log['time'] ?? 'Unknown time',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto',
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            log['logs'] ?? 'No details available',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
