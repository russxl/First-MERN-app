import 'package:flutter/material.dart';
import 'package:notirak/api/api.dart';

class CommunitySetDatePage extends StatefulWidget {
  final Map data;

  const CommunitySetDatePage({Key? key, required this.data}) : super(key: key);

  @override
  _CommunitySetDatePageState createState() => _CommunitySetDatePageState();
}

class _CommunitySetDatePageState extends State<CommunitySetDatePage> {
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedStartTime = TimeOfDay.now();
  TimeOfDay _selectedEndTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Community - Set Date',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Make title bold
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            // Set Schedule Title
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Set Date for\nRedemption',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                  ),
                ),
                SizedBox(width: 8.0),
                Text(
                  '(redeemable)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Roboto',
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.0),

            // Date Picker
            GestureDetector(
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null && pickedDate != _selectedDate)
                  setState(() {
                    _selectedDate = pickedDate;
                  });
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF40A858)), // Color of the border
                  ),
                ),
                child: Text(
                  '${_selectedDate.toLocal()}'.split(' ')[0],
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 20.0),

            // Start and End Time Picker
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      TimeOfDay? pickedStartTime = await showTimePicker(
                        context: context,
                        initialTime: _selectedStartTime,
                      );
                      if (pickedStartTime != null && pickedStartTime != _selectedStartTime)
                        setState(() {
                          _selectedStartTime = pickedStartTime;
                        });
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Start Time',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF40A858)), // Color of the border
                        ),
                      ),
                      child: Text(
                        _selectedStartTime.format(context),
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20.0),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      TimeOfDay? pickedEndTime = await showTimePicker(
                        context: context,
                        initialTime: _selectedEndTime,
                      );
                      if (pickedEndTime != null && pickedEndTime != _selectedEndTime)
                        setState(() {
                          _selectedEndTime = pickedEndTime;
                        });
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'End Time',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF40A858)), // Color of the border
                        ),
                      ),
                      child: Text(
                        _selectedEndTime.format(context),
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),

            // Description
            TextFormField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF40A858)), // Color of the border
                ),
                alignLabelWithHint: true,
              ),
            ),
            SizedBox(height: 20.0),

            // Save Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Collect all the data to pass to the API
                  Map<String, dynamic> requestData = {
                    'date': _selectedDate.toLocal().toString().split(' ')[0],
                    'startTime': _selectedStartTime.format(context),
                    'endTime': _selectedEndTime.format(context),
                    'description': _descriptionController.text,
                    'id': widget.data['barangay']['_id'],
                  };

                  // Call the API method with the collected data
                  Api.redemptionDate(context,requestData);

                  // Show a snackbar to confirm the action
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Schedule saved!'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF40A858), // Background color
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 32), // Adjust button size
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                ),
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white, // Text color
                    fontSize: 16, // Text size
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
