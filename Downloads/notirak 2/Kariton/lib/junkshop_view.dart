import 'package:flutter/material.dart';

class ViewPage extends StatelessWidget {
  final DateTime? date;
  final TimeOfDay? time;
  final String? scrapType;
  final String? weight;
  final String name;
  final String phone;
  final String junkshopName;
  final String location;
  

  const ViewPage({
    super.key,
    required this.date,
    required this.time,
    required this.scrapType,
    required this.weight,
    required this.name,
    required this.phone,
    required this.junkshopName,
    required this.location,
   
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Confirmation',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            const Text(
              'Booking Confirmation',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),

            // Display booking details
            Text(
              'Date: ${date?.toLocal().toString().split(' ')[0] ?? 'Not selected'}',
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
            Text(
              'Time: ${time?.format(context) ?? 'Not selected'}',
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
            Text(
              'Scrap Type: ${scrapType ?? 'Not selected'}',
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
            Text(
              'Weight: ${weight ?? 'Not specified'}',
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
            Text(
              'Name: $name',
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
            Text(
              'Phone: $phone',
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
            Text(
              'Junkshop Name: $junkshopName',
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
            Text(
              'Location: $location',
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
           
          ],
        ),
      ),
    );
  }
}
