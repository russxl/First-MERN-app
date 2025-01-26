import 'package:flutter/material.dart';
import 'package:notirak/barangay_main_screen.dart';

class BarangayCommunitySaveSchedScreen extends StatelessWidget {
  final String day1;
  final String day2;
  final String day3;
  final String day4;
  final String day5;
  final String scrapTypeDay1;
  final String scrapTypeDay2;
  final String scrapTypeDay3;
  final String scrapTypeDay4;
  final String scrapTypeDay5;
  final String timeDay1;
  final String timeDay2;
  final String timeDay3;
  final String timeDay4;
  final String timeDay5;
       final Map data;
       Key? key;
 

  BarangayCommunitySaveSchedScreen({
    Key? key,
    required this.day1,
    required this.day2,
    required this.day3,
    required this.day4,
    required this.day5,
    required this.data,
    required this.scrapTypeDay1,
    required this.scrapTypeDay2,
    required this.scrapTypeDay3,
    required this.scrapTypeDay4,
    required this.scrapTypeDay5,
    required this.timeDay1,
    required this.timeDay2,
    required this.timeDay3,
    required this.timeDay4,
    required this.timeDay5,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Community',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Saved Schedule Title
            Row(
              children: [
                Text(
                  'Saved Schedule',
                  style: TextStyle(
                    fontSize: 20,
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

            // Schedule Containers
            Expanded(
              child: ListView(
                children: [
                  _buildScheduleItem(
                    day: day1,
                    scrapType: scrapTypeDay1,
                    time: timeDay1,
                  ),
                  _buildScheduleItem(
                    day: day2,
                    scrapType: scrapTypeDay2,
                    time: timeDay2,
                  ),
                  _buildScheduleItem(
                    day: day3,
                    scrapType: scrapTypeDay3,
                    time: timeDay3,
                  ),
                  _buildScheduleItem(
                    day: day4,
                    scrapType: scrapTypeDay4,
                    time: timeDay4,
                  ),
                  _buildScheduleItem(
                    day: day5,
                    scrapType: scrapTypeDay5,
                    time: timeDay5,
                  ),
                ],
              ),
            ),

            // Back to Home Button
            SizedBox(height: 20.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BarangayMainScreen(data:data)));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF40A858),
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Back to Home',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleItem({required String day, required String scrapType, required String time}) {
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
        children: [
          Text(
            day,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            'Scrap Type: $scrapType',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              fontFamily: 'Roboto',
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            'Collection Time: $time',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Roboto',
            ),
          ),
        ],
      ),
    );
  }
}
