import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notirak/api/api.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'junkshop_main.dart'; // Assuming your API call is defined here

class BookingPage extends StatefulWidget {
  final Map data;

  const BookingPage({Key? key, required this.data}) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _scrapType;
  String? _weight;
  final TextEditingController _nameController = TextEditingController(text: '');
  final TextEditingController _phoneController = TextEditingController(text: '');
  final TextEditingController _junkshopNameController = TextEditingController(text: '');
  final TextEditingController _commentsController = TextEditingController();
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _junkshopNameController.dispose();
    _commentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 252, 252),
        title: const Text(
          '',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [
                _buildBookingForm(),
                _buildScrapDetailsPage(),
                _buildPersonalInformationPage(),
                _buildAccurateInformationPage(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: SmoothPageIndicator(
              controller: _pageController,
              count: 4, // Number of pages
              effect: WormEffect(
                dotColor: Colors.grey,
                activeDotColor: Colors.green,
                dotHeight: 10,
                dotWidth: 40,
                spacing: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingForm() {
        print(widget.data['adminscrap'][0]['scrapType']);
    return ListView(
      padding: const EdgeInsets.all(20.0),
      children: [
        const Text(
          'Schedule For Pickup',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Choose what time and date',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 20),

        // Date Picker
        Text(
          'Date *',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: _selectedDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (pickedDate != null && pickedDate != _selectedDate) {
              setState(() {
                _selectedDate = pickedDate;
              });
            }
          },
          child: AbsorbPointer(
            child: TextFormField(
              decoration: InputDecoration(
                labelText: _selectedDate == null
                    ? 'Select Date'
                    : '${_selectedDate!.toLocal()}'.split(' ')[0],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              validator: (value) {
                if (_selectedDate == null) {
                  return 'Date is required';
                }
                return null;
              },
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Time Picker
        Text(
          'Time *',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () async {
            TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialTime: _selectedTime ?? TimeOfDay.now(),
            );
            if (pickedTime != null && pickedTime != _selectedTime) {
              setState(() {
                _selectedTime = pickedTime;
              });
            }
          },
          child: AbsorbPointer(
            child: TextFormField(
              decoration: InputDecoration(
                labelText: _selectedTime == null
                    ? 'Select Time'
                    : '${_selectedTime!.format(context)}',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              validator: (value) {
                if (_selectedTime == null) {
                  return 'Time is required';
                }
                return null;
              },
            ),
          ),
        ),
        const SizedBox(height: 20),

        ElevatedButton(
          onPressed: () {
            if (_selectedDate == null || _selectedTime == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Please select both date and time'),
                ),
              );
            } else {
              _pageController.nextPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeIn,
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 18.0,
              horizontal: 16.0,
            ),
          ),
          child: const Text(
            'Next',
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ),
      ],
    );
  }

 Widget _buildScrapDetailsPage() {
  return ListView(
    padding: const EdgeInsets.all(20.0),
    children: [
      const Text(
        'Scrap Details',
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      const SizedBox(height: 20),
      const Text(
        'Select the type of scrap and each weight',
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black,
        ),
      ),
      const SizedBox(height: 20),
      const Text(
        'Type of Scrap *',
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      const SizedBox(height: 20),

      // Scrap Type Dropdown
      DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        items: (widget.data["adminscrap"] as List<dynamic>).map((scrapType) {
          print(scrapType);
          return DropdownMenuItem<String>(
            value: scrapType['scrapType'].toString(),  // Ensure each value is treated as a string
            child: Text(scrapType['scrapType'].toString()), // Show scrapType in the dropdown
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _scrapType = value;
          });
        },
      ),

      const SizedBox(height: 20),
      
      // Weight Input Field
      const Text(
        'Weight *',
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      const SizedBox(height: 20),

      TextFormField(
        decoration: InputDecoration(
          labelText: 'Enter Weight (kg)',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')), // Accept only numbers and decimal
        ],
        onChanged: (value) {
          _weight = value;
        },
      ),
      const SizedBox(height: 20),

      // Next Button
      ElevatedButton(
        onPressed: () {
          if (_scrapType == null || _weight == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please select scrap type and enter weight'),
              ),
            );
          } else {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 18.0,
            horizontal: 16.0,
          ),
        ),
        child: const Text(
          'Next',
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    ],
  );
}


Widget _buildPersonalInformationPage() {
  return ListView(
    padding: const EdgeInsets.all(20.0),
    children: [
      const Text(
        'Personal Information',
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      const SizedBox(height: 20),
      const Text(
        'Name *',
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      const SizedBox(height: 10),
      TextFormField(
        controller: _nameController,
        decoration: InputDecoration(
          labelText: 'Enter your name',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
      const SizedBox(height: 20),
      const Text(
        'Phone Number *',
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      const SizedBox(height: 10),
      
      // Phone number input with validation for Philippine phone numbers
      TextFormField(
        controller: _phoneController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          labelText: 'Enter your phone number',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')), // Allow numbers and the "+" symbol
          LengthLimitingTextInputFormatter(13), // Limit to 13 characters
        ],
        onChanged: (value) {
          // Optional: You can add some validation logic here if needed
        },
      ),
      const SizedBox(height: 20),
      ElevatedButton(
        onPressed: () {
          // Validate the phone number for Philippine format
          final phone = _phoneController.text;
          final isValidPhoneNumber = _validatePhilippinePhoneNumber(phone);
          
          if (_nameController.text.isEmpty || phone.isEmpty || !isValidPhoneNumber) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please enter a valid name and phone number'),
              ),
            );
          } else {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 18.0,
            horizontal: 16.0,
          ),
        ),
        child: const Text(
          'Next',
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    ],
  );
}

// Function to validate Philippine phone numbers
bool _validatePhilippinePhoneNumber(String phone) {
  // Regex for Philippine phone numbers
  final RegExp phoneRegExp = RegExp(r'^(09|\+639)\d{9}$');
  return phoneRegExp.hasMatch(phone);
}


  Widget _buildAccurateInformationPage() {
    return ListView(
      padding: const EdgeInsets.all(20.0),
      children: [
        const Text(
          'Accurate Information',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Please double-check your information before submitting',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Any comments or additional information?',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _commentsController,
          decoration: InputDecoration(
            labelText: 'Enter any comments',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 20),

        ElevatedButton(
          onPressed: () async {
            // Call API to submit the final data with individual variables

            var data = {
              "name": _nameController.text,
              "phone": _phoneController.text,
              "date": _selectedDate?.toLocal().toString().split(' ')[0],
              "time": _selectedTime?.format(context),
              "scrapType": _scrapType,
              "weight": _weight,
              "comments": _commentsController.text,
              'id':widget.data['junkOwner']['_id'],
              "location":widget.data['junkOwner']['address']
            };
           await Api.pickUp(context,data);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 18.0,
              horizontal: 16.0,
            ),
          ),
          child: const Text(
            'Submit',
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ),
      ],
    );
  }
}
