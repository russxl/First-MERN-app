import 'package:flutter/material.dart';
import 'package:notirak/api/api.dart';

class HistoryJunkshop extends StatefulWidget {
  final Map data;

  const HistoryJunkshop({Key? key, required this.data}) : super(key: key);

  @override
  _HistoryJunkshopState createState() => _HistoryJunkshopState();
}

class _HistoryJunkshopState extends State<HistoryJunkshop> {
  int _selectedIndex = 0;
  late List<Map<dynamic, dynamic>> pendingData;
  late List<Map<dynamic, dynamic>> declinedData;
  late List<Map<dynamic, dynamic>> approvedData;
  late List<Map<dynamic, dynamic>> doneData;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    // Extract and reverse data from widget.data to display latest first
    pendingData = List<Map<dynamic, dynamic>>.from(widget.data['pending'] ?? []).reversed.toList();
    declinedData = List<Map<dynamic, dynamic>>.from(widget.data['declined'] ?? []).reversed.toList();
    approvedData = List<Map<dynamic, dynamic>>.from(widget.data['approved'] ?? []).reversed.toList();
    doneData = List<Map<dynamic, dynamic>>.from(widget.data['done'] ?? []).reversed.toList();
  }

  Future<void> _reloadData() async {
    // Prepare data for API call
    var data = {
      "id": widget.data['junkOwner']['_id'],
      'type': "Junkshop",
    };

    // Fetch new data from the API
    await Api.getHome(context, data);

    // Re-initialize data after fetching
    setState(() {
      _initializeData();
    });

    // Show a message indicating successful refresh
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Scraps list saved successfully.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'History',
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
          Expanded(
            child: RefreshIndicator(
              onRefresh: _reloadData, // Link to the refresh function
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    List<Map<dynamic, dynamic>> currentData;
    String title;

    if (_selectedIndex == 1) {
      // Pending records
      currentData = pendingData;
      title = 'Pending Records';
    } else if (_selectedIndex == 0) {
      // Approved records
      currentData = approvedData;
      title = 'Approved Records';
    } else if (_selectedIndex == 2) {
      // Declined records
      currentData = declinedData;
      title = 'Declined Records';
    } else {
      // Done records
      currentData = doneData;
      title = 'Done Records';
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
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
        // Data Table wrapped in a SingleChildScrollView for horizontal scrolling
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Location')),
              DataColumn(label: Text('Phone No.')),
              DataColumn(label: Text('Weight')),
              DataColumn(label: Text('Scrap Type')),
            ],
            rows: currentData.map((record) {
              return DataRow(
                cells: [
                  DataCell(Text(record['name'] ?? '')),
                  DataCell(Text(record['location'] ?? '')),
                  DataCell(Text(record['phone'] ?? '')),
                  DataCell(Text("${record['weight'] ?? ''} KG")),
                  DataCell(Text(record['scrapType'] ?? '')),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
