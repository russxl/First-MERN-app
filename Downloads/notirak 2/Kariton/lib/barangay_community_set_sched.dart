import 'package:flutter/material.dart';
import 'package:notirak/api/api.dart';
import 'barangay_community_save_sched.dart'; // Import the new screen



class BarangayCommunitySetSchedScreen extends StatefulWidget {
         final Map data;

  const BarangayCommunitySetSchedScreen({Key? key, required this.data}) : super(key: key);
  @override
  _BarangayCommunitySetSchedScreenState createState() => _BarangayCommunitySetSchedScreenState();
}

class _BarangayCommunitySetSchedScreenState extends State<BarangayCommunitySetSchedScreen> {
  final Map<String, _Schedule> _schedules = {
    'Monday': _Schedule(),
    'Tuesday': _Schedule(),
    'Wednesday': _Schedule(),
    'Thursday': _Schedule(),
    'Friday': _Schedule(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Community - Set Schedule',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Make title bold
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            // Set Schedule Title
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Set Schedule',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                  ),
                ),
                SizedBox(width: 8.0),
                Text(
                  '(for pickup)',
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

            // Weekday Buttons
            Expanded(
              child: ListView(
                children: _schedules.keys.map((day) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0), // Space between buttons
                    child: SizedBox(
                      width: double.infinity, // Make button full width
                      child: ElevatedButton(
                        onPressed: () => _showScheduleDialog(day),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF40A858), // Background color
                          padding: EdgeInsets.symmetric(vertical: 14), // Adjust button size
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Rounded corners
                          ),
                        ),
                        child: Text(
                          day,
                          style: TextStyle(
                            color: Colors.white, // Text color
                            fontSize: 16, // Text size
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20.0),

            // Save Button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0), // Space around Save button
              child: SizedBox(
                width: double.infinity, // Make button full width
                child: ElevatedButton(
                  onPressed: () async {
                    // Extract schedule details for each day
                    final monday = _schedules['Monday']!;
                    final tuesday = _schedules['Tuesday']!;
                    final wednesday = _schedules['Wednesday']!;
                    final thursday = _schedules['Thursday']!;
                    final friday = _schedules['Friday']!;

                    // Prepare the schedule data for API
                    final scheduleData = {
                      'Monday': {
                        'scrapType': monday.scrapType,
                        'collectionTime': monday.collectionTime.format(context),
                      },
                      'Tuesday': {
                        'scrapType': tuesday.scrapType,
                        'collectionTime': tuesday.collectionTime.format(context),
                      },
                      'Wednesday': {
                        'scrapType': wednesday.scrapType,
                        'collectionTime': wednesday.collectionTime.format(context),
                      },
                      'Thursday': {
                        'scrapType': thursday.scrapType,
                        'collectionTime': thursday.collectionTime.format(context),
                      },
                      'Friday': {
                        'scrapType': friday.scrapType,
                        'collectionTime': friday.collectionTime.format(context),
                      },
                       'barangayID' :widget.data['barangay']['_id'],
                    };
                
                    // Save the schedule to the API
                    await Api.saveSched(context,scheduleData);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF40A858), // Background color
                    padding: EdgeInsets.symmetric(vertical: 14), // Adjust button size
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
            ),
          ],
        ),
      ),
    );
  }

Future<void> _showScheduleDialog(String day) async {
  final _schedule = _schedules[day]!;
  
  // Ensure we get the scrap types from the data

  List<String> scrapTypes = List<String>.from(
  widget.data['scrap'].map((scrap) => scrap['scrapType'])
);
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Set Schedule for $day'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Scrap Type
            DropdownButtonFormField<String>(
              value: _schedule.scrapType.isNotEmpty ? _schedule.scrapType : null,
              onChanged: (String? newValue) {
                setState(() {
                  _schedule.scrapType = newValue!;
                });
              },
              items: scrapTypes.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Select Category',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF40A858)), // Color of the border
                ),
              ),
            ),
            SizedBox(height: 20.0),

            // Collection Time
            GestureDetector(
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: _schedule.collectionTime,
                );
                if (pickedTime != null && pickedTime != _schedule.collectionTime)
                  setState(() {
                    _schedule.collectionTime = pickedTime;
                  });
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Collection Time',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF40A858)), // Color of the border
                  ),
                ),
                child: Text(
                  _schedule.collectionTime.format(context),
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
              // Print schedule details for the selected day
              final schedule = _schedules[day];
              print('$day Schedule:');
              print('Scrap Type: ${schedule?.scrapType}');
              print('Collection Time: ${schedule?.collectionTime.format(context)}');
            },
          ),
        ],
      );
    },
  );
}

}

class _Schedule {
  String scrapType = '';
  TimeOfDay collectionTime = TimeOfDay.now();
}
