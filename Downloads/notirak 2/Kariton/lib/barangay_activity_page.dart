import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notirak/api/api.dart';

class BarangayActivityPage extends StatefulWidget {
  final Map data;

  const BarangayActivityPage({Key? key, required this.data}) : super(key: key);

  @override
  _BarangayActivityPageState createState() => _BarangayActivityPageState();
}

class _BarangayActivityPageState extends State<BarangayActivityPage> {
  late List<dynamic> collectionLogs;
  late List<dynamic> userLogs;
  List<dynamic> combinedLogs = [];

  @override
  void initState() {
    super.initState();
    _initializeLogs();
  }

  void _initializeLogs() {
    collectionLogs = widget.data["collectionLogs"] ?? [];
    userLogs = widget.data["userLogs"] ?? [];
    _combineAndSortLogs();
  }

  void _combineAndSortLogs() {
    setState(() {
      combinedLogs = [
        ...collectionLogs.map((log) => {...log, 'type': 'collection'}),
        ...userLogs.map((log) => {...log, 'type': 'user'}),
      ];

      // Sort combined logs by date and time in descending order
      combinedLogs.sort((a, b) {
        DateTime dateTimeA = _parseDateTime(a['date'], a['time']);
        DateTime dateTimeB = _parseDateTime(b['date'], b['time']);
        return dateTimeB.compareTo(dateTimeA);
      });
    });
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Barangay Collection Activity',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Activity Records',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.filter_list, color: Colors.green),
                    onPressed: () {
                      // Add filter functionality here
                    },
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Time')),
                  DataColumn(label: Text('Activity Type')),
                  DataColumn(label: Text('Scrap Type / Action')),
                  DataColumn(label: Text('Weight / Info')),
                  DataColumn(label: Text('Points / Details')),
                ],
                rows: combinedLogs.map<DataRow>((record) {
                  bool isCollection = record['type'] == 'collection';
                  return DataRow(
                    cells: [
                      DataCell(Text(record['date'] ?? '')),
                      DataCell(Text(record['time'] ?? '')),
                      DataCell(Text(isCollection ? 'Collection' : 'Barangay Activity')),
                      DataCell(Text(record['logs'] ?? '')),
                      DataCell(Text(isCollection ? (record['weight'] ?? '') : (record['info'] ?? ''))),
                      DataCell(Text(isCollection ? (record['points'] ?? '') : (record['details'] ?? ''))),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DateTime _parseDateTime(String date, String time) {
    List<String> dateParts = date.split('/');
    int month = int.parse(dateParts[0]);
    int day = int.parse(dateParts[1]);
    int year = int.parse(dateParts[2]);

    List<String> timeParts = time.split(' ');
    List<String> hourMinuteSecond = timeParts[0].split(':');
    int hour = int.parse(hourMinuteSecond[0]);
    int minute = int.parse(hourMinuteSecond[1]);
    int second = int.parse(hourMinuteSecond[2]);

    if (timeParts[1] == 'PM' && hour != 12) {
      hour += 12;
    } else if (timeParts[1] == 'AM' && hour == 12) {
      hour = 0;
    }

    return DateTime(year, month, day, hour, minute, second);
  }
}
