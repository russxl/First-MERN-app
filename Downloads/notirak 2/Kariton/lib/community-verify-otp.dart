import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import this for FilteringTextInputFormatter
import 'package:notirak/api/api.dart';
import 'package:notirak/community_login_screen.dart';
import 'community_password_reset_screen.dart'; // Import your PasswordResetScreen

class VerifyOtp extends StatelessWidget {
  
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final Map userData; // Add this field to accept data

  VerifyOtp({Key? key, required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()), // Navigate to LoginScreen
            );
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 80.0, 30.0, 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Enter Verification Code",
              style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15.0),
            Text(
              "The code has been sent to your email.", // New message added here
              style: TextStyle(fontSize: 16.0, color: Colors.grey),
            ),
            SizedBox(height: 15.0),
            Text(
              "Please enter the 6-digit code that was sent to your email.",
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 40.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) {
                return _buildOtpBox(context, index);
              }),
            ),
            SizedBox(height: 60.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _verifyOtp(context); // Function to verify OTP
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF40A858)),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  minimumSize: MaterialStateProperty.all<Size>(Size(double.infinity, 50)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                child: Text('Verify'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpBox(BuildContext context, int index) {
    return SizedBox(
      width: 50.0,
      child: TextFormField(
        focusNode: _focusNodes[index],
        controller: _controllers[index],
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Restrict to digits only
        textAlign: TextAlign.center,
        maxLength: 1, // Only allow one digit per box
        decoration: InputDecoration(
          counterText: '', // Hide the character counter
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            // Move to next box if the current one is filled
            if (index < 5) {
              FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
            } else {
              // Dismiss keyboard after the last input
              FocusScope.of(context).unfocus();
            }
          }
          if (value.isEmpty && index > 0) {
            // Move back to the previous box if the current one is empty
            FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
          }
        },
      ),
    );
  }

  // Combine OTP inputs to form a complete 6-digit OTP code
  String _getEnteredOtp() {
    return _controllers.map((controller) => controller.text).join('');
  }

  // Function to handle OTP verification
  void _verifyOtp(BuildContext context) async {
    String enteredOtp = _getEnteredOtp(); // Ensure this gets the correct OTP

    if (enteredOtp.length == 6) {
      var data = {
        "otp": enteredOtp,
        "email": userData['email']
      };

      bool isVerified = await Api.verifyOtp(context, data); // Use the updated API method

      if (isVerified) {
        // OTP verified successfully
        _showVerificationDialog(context); 
      } else {
        // OTP verification failed
        _showErrorDialog(context, "Invalid OTP. Please try again.");
      }
    } else {
      _showErrorDialog(context, "Please enter the complete 6-digit OTP.");
    }
  }

  // Dialog shown on successful OTP verification
  void _showVerificationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Your code has been verified successfully!',
                  style: TextStyle(fontSize: 16.0, color: Colors.grey),
                ),
                SizedBox(height: 20.0),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                      _navigateToPasswordResetScreen(context); // Navigate to password reset screen
                    },
                    child: Text(
                      'DONE',
                      style: TextStyle(
                        color: Color(0xFF40A858),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Error dialog for invalid OTP or API error
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Navigate to password reset screen
  void _navigateToPasswordResetScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PasswordResetScreen(userData: userData)),
    );
  }
}
