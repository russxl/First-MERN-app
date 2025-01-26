import 'package:flutter/material.dart';
import 'junkshop_notification.dart'; 
import 'junkshop_history.dart'; 
import 'junkshop_profile.dart'; 

class SortingJunkshop extends StatefulWidget {
  final Map data;

  const SortingJunkshop({Key? key, required this.data}) : super(key: key);

  @override
  State<SortingJunkshop> createState() => _SortingJunkshopState();
}

class _SortingJunkshopState extends State<SortingJunkshop> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Sorting',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          // Header Section
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              'Let’s sort all scrap you have...',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.black87,
              ),
            ),
          ),
          Text(
            'Here is the correct way to sort them:',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 16.0), 
          _buildInfoBox(
            title: 'Plastic',
            subtitle: ' ( Types )',
            description: 'PET \nHDPE \nPVC \nLDPE \nPP \nPS \nOTHER PLASTIC',
          ),
          const SizedBox(height: 16.0), 
          _buildInfoBox(
            title: 'Paper',
            subtitle: ' ( Acceptable Paper )',
            description: 'Many different kinds of paper can be recycled, including white office paper, newspaper, colored office paper, cardboard, white computer paper, magazines, catalogs, and phone books. Types of paper that are not recyclable are coated and treated paper, paper with food waste, juice and cereal boxes, paper cups, paper towels, and paper or magazine laminated with plastic.',
          ),
          const SizedBox(height: 16.0), 
          _buildInfoBox(
            title: 'Glass',
            subtitle: ' ( Description )',
            description: 'Broken bottles and other containers should also be segregated by colors, i.e. amber (brown), flint (clear), and emerald green (green).',
          ),
        ],
      ),
    
    );
  }

  Widget _buildInfoBox({
    required String title,
    required String subtitle,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 4), 
            blurRadius: 8.0, 
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
              SizedBox(
                width: 150,
                child: Text(
                  subtitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13.0,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Text(
            description,
            style: const TextStyle(
              fontSize: 13.0,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
