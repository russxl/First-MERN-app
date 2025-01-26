import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notirak/api/api.dart';

class BarangayCommunityGoodsPoints extends StatefulWidget {
  final Map data;

  const BarangayCommunityGoodsPoints({Key? key, required this.data})
      : super(key: key);

  @override
  _BarangayCommunityGoodsPointsState createState() =>
      _BarangayCommunityGoodsPointsState();
}

class _BarangayCommunityGoodsPointsState
    extends State<BarangayCommunityGoodsPoints> {
  final List<Map<String, dynamic>> _goodsList = [];

  @override
  void initState() {
    super.initState();
    // Initialize _goodsList with rewards from widget.data
    var savedRewards = widget.data['reward'];
    if (savedRewards != null && savedRewards is List) {
      for (var reward in savedRewards) {
        _goodsList.add({
          'goods': reward['nameOfGood'],
          'points': reward['pointsEquivalent'],
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Goods',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Conversion Points (Equivalent)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Add More Category Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  Map<String, dynamic>? newGoods =
                      await _showAddGoodsDialog(context);
                  if (newGoods != null) {
                    setState(() {
                      _goodsList.add(newGoods);
                    });
                  }
                },
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text('Add More Category'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF40A858),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Table Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              color: Colors.grey[300],
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Center( // Center align the Name label
                      child: Text(
                        'Name',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center( // Center align the Points label
                      child: Text(
                        'Points',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center( // Center align the Action label
                      child: Text(
                        'Action',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Conversion Points List
            Expanded(
              child: ListView.builder(
                itemCount: _goodsList.length,
                itemBuilder: (context, index) {
                  if (_goodsList[index]['goods'] == 'Cash') {
                    // Skip "Cash" entry
                    return const SizedBox.shrink();
                  }
                  return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Center( // Center align the Name column content
                            child: Text(_goodsList[index]['goods']),
                          ),
                        ),
                        Expanded(
                          child: Center( // Center align the Points column content
                            child: Text(_goodsList[index]['points'].toString()),
                          ),
                        ),
                        Expanded(
                          child: Center( // Center align the Action column content
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center, // Ensure buttons are centered
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () async {
                                    Map<String, dynamic>? editedGoods =
                                        await _showAddGoodsDialog(
                                      context,
                                      goods: _goodsList[index]['goods'],
                                      points: _goodsList[index]['points'].toString(),
                                    );
                                    if (editedGoods != null) {
                                      setState(() {
                                        _goodsList[index] = editedGoods;
                                      });
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
  // Copy the data before removing it from the list
  var goodsData = {
    "name": _goodsList[index]['goods'],
    "conversion_rate": _goodsList[index]['points'].toString(),
    "id": widget.data['barangay']['_id'],
    "action":"Delete"
  };

  // Perform async operations outside of setState
  Api.saveGoodsConversion(context, goodsData).then((_) {
    setState(() {
      // Now safely remove the item from the list
      _goodsList.removeAt(index);
    });
  }).catchError((error) {
    // Handle any errors, e.g., show a Snackbar or AlertDialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $error')),
    );
  });
}

                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                    var data = {
                      "id":widget.data['barangay']['_id'],
                      'type':"Barangay"
                    };
                     await Api.getHome(context,data); 
                  // Save the updated goods data
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Goods list saved successfully.')),
                  );
                },
                child: const Text('Back to Home'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>?> _showAddGoodsDialog(
    BuildContext context, {
    String? goods,
    String? points,
  }) async {
    TextEditingController goodsController = TextEditingController(text: goods);
    TextEditingController pointsController =
        TextEditingController(text: points);

    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add/Update Goods'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: goodsController,
                decoration: const InputDecoration(
                  labelText: 'Goods Name',
                ),
              ),
              TextField(
  controller: pointsController,
  keyboardType: TextInputType.number, // Ensure numeric input
  inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Allow only digits
  decoration: const InputDecoration(
    labelText: 'Equivalent Points',
  ),
  onChanged: (value) {
    // You can add logic to handle the input in real-time, if needed
  },
),

            ],
          ),
          actions: [
            TextButton(
  onPressed: () async {
    String newGoods = goodsController.text.trim();
    String pointsString = pointsController.text.trim();
    
    // Check if the points input is not empty and is a valid number
    if (newGoods.isNotEmpty && pointsString.isNotEmpty && int.tryParse(pointsString) != null) {
      int newPoints = int.parse(pointsString); // Safe to parse now
      Navigator.of(context).pop({
        'goods': newGoods,
        'points': newPoints,
      });

      // Save the new or updated data
      var data = {
        'conversion_rate': newPoints,
        'name': newGoods,
        'id': widget.data['barangay']['_id'],
      };
      await Api.saveGoodsConversion(context, data);

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid data (number for points).')),
      );
    }
  },
  child: const Text('Save'),
),

          ],
        );
      },
    );
  }
}
