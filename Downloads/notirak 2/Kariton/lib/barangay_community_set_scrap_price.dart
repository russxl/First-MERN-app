import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notirak/api/api.dart';

class BarangayCommunitySetScrapPrice extends StatefulWidget {
  final Map data;

  const BarangayCommunitySetScrapPrice({Key? key, required this.data})
      : super(key: key);

  @override
  _BarangayCommunitySetScrapPriceState createState() =>
      _BarangayCommunitySetScrapPriceState();
}

class _BarangayCommunitySetScrapPriceState
    extends State<BarangayCommunitySetScrapPrice> {
  final List<Map<String, dynamic>> _goodsList = [];

  @override
  void initState() {
    super.initState();
    // Initialize _goodsList with saved scraps from widget.data
    var savedScraps = widget.data['scrap'];
    if (savedScraps != null && savedScraps is List) {
      for (var scrap in savedScraps) {
        _goodsList.add({
          'scraps': scrap['scrapType'],
          'points': scrap['pointsEquivalent'],
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
          'Scrap Conversion Points',
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
              'Scraps Conversion Points (per kilo)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Add More Scrap Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  Map<String, dynamic>? newGoods =
                      await _showAddGoodsDialog(context);
                  if (newGoods != null) {
                    // Check if the scrap already exists (saved or added)
                    bool isDuplicate = _goodsList.any((item) =>
                        item['scraps'].toLowerCase() ==
                        newGoods['scraps'].toLowerCase());

                    if (isDuplicate) {
                      // Show an alert if duplicate
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('This scrap already exists.')),
                      );
                    } else {
                      setState(() {
                        _goodsList.add(newGoods);
                      });
                    }
                  }
                },
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text('Add More Scraps'),
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
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              color: Colors.grey[300],
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        'Scraps Name',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Points per Kilo',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Actions',
                        textAlign: TextAlign.center,
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
                  return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              _goodsList[index]['scraps'],
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              _goodsList[index]['points'].toString(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Edit Button
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () async {
                                    Map<String, dynamic>? editedGoods =
                                        await _showAddGoodsDialog(
                                      context,
                                      scraps: _goodsList[index]['scraps'],
                                      points: _goodsList[index]['points'].toString(),
                                    );
                                    if (editedGoods != null) {
                                      setState(() {
                                        _goodsList[index] = editedGoods;
                                      });
                                    }
                                  },
                                ),
                                // Delete Button
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    bool? isConfirmed =
                                        await _showDeleteConfirmationDialog(
                                            context,
                                            _goodsList[index]['scraps']);

                                    if (isConfirmed == true) {
                                      // Create goodsData before removing the item
                                      var goodsData = {
                                        "name": _goodsList[index]['scraps'],
                                        "conversion_rate": _goodsList[index]['points'].toString(),
                                        "id": widget.data['barangay']['_id'],
                                        "action": "Delete"
                                      };

                                      // Call API to delete
                                      Api.saveScrapConversion(context, goodsData).then((_) {
                                        setState(() {
                                          // Now safely remove the item from the list
                                          _goodsList.removeAt(index);
                                        });
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Scrap deleted successfully.')),
                                        );
                                      }).catchError((error) {
                                        // Handle any errors
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Error: $error')),
                                        );
                                      });
                                    }
                                  },
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
                  await Api.getHome(context, data);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Scraps list saved successfully.')),
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
  String? scraps,
  String? points,
}) async {
  TextEditingController scrapsController =
      TextEditingController(text: scraps);
  TextEditingController pointsController =
      TextEditingController(text: points?.toString());

  return showDialog<Map<String, dynamic>>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Add/Update Scraps'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: scrapsController,
              decoration: const InputDecoration(
                labelText: 'Scraps Name',
              ),
            ),
            TextField(
              controller: pointsController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, // Only allow digits
              ],
              decoration: const InputDecoration(
                labelText: 'Points per Kilo',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              String newScraps = scrapsController.text;
              int? newPoints = int.tryParse(pointsController.text);

              if (newScraps.isNotEmpty && newPoints != null) {
                // Prepare data for API call
                var data = {
                  'conversion_rate': newPoints,
                  'name': newScraps,
                  'id': widget.data['barangay']['_id'],
                };

                try {
                  // Call API to save the new scrap
                  await Api.saveScrapConversion(context, data);

                  // If successful, update the UI and add the scrap to the list
                  Navigator.of(context).pop({
                    'scraps': newScraps,
                    'points': newPoints,
                  });

                  // Show a success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Scrap added successfully.')),
                  );
                } catch (error) {
                  // Handle error case
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error saving scrap: $error')),
                  );
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}



  Future<bool?> _showDeleteConfirmationDialog(
      BuildContext context, String scraps) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete $scraps?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
