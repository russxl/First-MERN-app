import 'package:flutter/material.dart';
import 'package:notirak/api/api.dart';

class HistoryScreen extends StatefulWidget {
  final Map data;

  const HistoryScreen({Key? key, required this.data}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late List combinedLogs;

  @override
  void initState() {
    super.initState();
    _prepareLogs(); // Initialize the logs when the screen is created
  }

  void _prepareLogs() {
    Map? useLogs = widget.data['history'];
    combinedLogs = [];

    if (useLogs != null && useLogs.isNotEmpty) {
      useLogs.forEach((key, value) {
        if (value != null) {
          combinedLogs.addAll(value);
        }
      });

      combinedLogs.sort((a, b) {
        DateTime dateTimeA = _parseDateTime(a['date'], a['time']);
        DateTime dateTimeB = _parseDateTime(b['date'], b['time']);
        return dateTimeB.compareTo(dateTimeA);
      });
    }
  }

  Future<void> _refreshData() async {
  // Simulating a delay, replace it with the actual API call
  var requestData = {
    "id": widget.data['user']['_id'],
    "type": "Community"
  };

  try {
    // Assuming Api.getHome returns a Future with the refreshed data
    final updatedData = await Api.getHome(context, requestData);

    // Update the data state
 
  } catch (error) {
    // Handle the error (show message, log, etc.)
    print("Error refreshing data: $error");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData, // Pull-to-refresh action
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Enable horizontal scrolling
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Type')),
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Time')),
                  DataColumn(label: Text('Logs')),
                ],
                rows: combinedLogs.map<DataRow>((log) {
                  return DataRow(cells: [
                    DataCell(Text(log['type'] ?? 'N/A')),
                    DataCell(Text(log['date'] ?? 'N/A')),
                    DataCell(Text(log['time'] ?? 'N/A')),
                    DataCell(Text(log['logs'] ?? 'N/A')),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  DateTime _parseDateTime(String? date, String? time) {
    if (date == null || time == null) {
      return DateTime.now(); // Return the current date and time as a fallback
    }

    List<String> dateParts = date.split('/');
    int month = int.parse(dateParts[0]);
    int day = int.parse(dateParts[1]);
    int year = int.parse(dateParts[2]);

    List<String> timeParts = time.split(' ');
    List<String> hourMinuteSecond = timeParts[0].split(':');
    int hour = int.parse(hourMinuteSecond[0]);
    int minute = int.parse(hourMinuteSecond[1]);
    int second = int.parse(hourMinuteSecond[2]);

    if (timeParts.length > 1 && timeParts[1] == 'PM' && hour != 12) {
      hour += 12;
    } else if (timeParts.length > 1 && timeParts[1] == 'AM' && hour == 12) {
      hour = 0;
    }

    return DateTime(year, month, day, hour, minute, second);
  }
}
