import 'package:flutter/material.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  int _selectedIndex = 0; 

  final List<Map<String, String>> _activities = [
    // Example data
    {'Date': '2024-08-15', 'Activity': 'Scrap Collection', 'Location': 'Barangay 1', 'Details': 'Collected 50 kg of paper and plastic.'},
    {'Date': '2024-08-16', 'Activity': 'Scrap Sorting', 'Location': 'Barangay 2', 'Details': 'Sorted and prepared for recycling.'},
    // Add more sample data as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Activities',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ),
      body: Column(
        children: [
          BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.check_circle),
                label: 'Approve',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.hourglass_empty),
                label: 'Pending',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.cancel),
                label: 'Cancelled',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: 'History',
              ),
              
            ],
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.green,
            backgroundColor: Colors.white,
          ),
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
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Activity')),
                  DataColumn(label: Text('Location')),
                  DataColumn(label: Text('Details')),
                ],
                rows: _activities.map((record) {
                  return DataRow(
                    cells: [
                      DataCell(Text(record['Date'] ?? '')),
                      DataCell(Text(record['Activity'] ?? '')),
                      DataCell(Text(record['Location'] ?? '')),
                      DataCell(Text(record['Details'] ?? '')),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ActivityPage(),
  ));
}
