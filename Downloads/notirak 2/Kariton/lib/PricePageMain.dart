import 'package:flutter/material.dart';

class PricePage extends StatefulWidget {
  const PricePage({super.key});

  @override
  _PricePageState createState() => _PricePageState();
}

class _PricePageState extends State<PricePage> {
  final List<Map<String, dynamic>> _categories = [];
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  final List<String> _scrapTypes = ['Plastic', 'Paper', 'Metal', 'Glass'];
  String? _selectedScrapType;

  bool _showForm = false;

  void _toggleFormVisibility() {
    setState(() {
      _showForm = !_showForm;
    });
  }

  void _addCategory() {
    final scrapType = _selectedScrapType;
    final price = double.tryParse(_priceController.text);
    final description = _descriptionController.text;

    if (scrapType != null && price != null && description.isNotEmpty) {
      setState(() {
        _categories.add({
          'scrapType': scrapType,
          'price': price,
          'description': description,
        });
        _selectedScrapType = null;
        _priceController.clear();
        _descriptionController.clear();
        _showForm = false; // Hide the form after adding
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scrap Prices'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Set Price Section
            Text(
              'Set Price',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            // Add Category Button
            ElevatedButton(
              onPressed: _toggleFormVisibility,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48), // Make button full-width
                backgroundColor: Colors.green, // Background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                  side: BorderSide(color: Colors.green, width: 2), // Border color and width
                ),
                padding: EdgeInsets.symmetric(vertical: 16), // Adjust button padding
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Add Category'),
                  Icon(Icons.add),
                ],
              ),
            ),
            SizedBox(height: 16),
            // Show Form if _showForm is true
            if (_showForm) ...[
              // Form for Adding Category
              Container(
                color: Colors.green, // Background color for the form
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dropdown for Scrap Type
                    DropdownButtonFormField<String>(
                      value: _selectedScrapType,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Scrap Type',
                      ),
                      items: _scrapTypes.map((type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedScrapType = value;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    // Price TextField
                    TextField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Price',
                      ),
                    ),
                    SizedBox(height: 16),
                    // Description TextField
                    TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Description',
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: _addCategory,
                          child: Text('Add'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                        ),
                        SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _showForm = false;
                              _selectedScrapType = null;
                              _priceController.clear();
                              _descriptionController.clear();
                            });
                          },
                          child: Text('Cancel'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            SizedBox(height: 16),
            // Display Added Categories
            if (_categories.isNotEmpty) ...[
              Text(
                'Added Categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              // List of Added Categories
              Column(
                children: _categories.map((category) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      title: Text(category['scrapType']),
                      subtitle: Text(category['description']),
                      trailing: Text('\$${category['price'].toStringAsFixed(2)}'),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
