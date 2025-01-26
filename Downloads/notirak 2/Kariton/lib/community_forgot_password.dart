import 'package:flutter/material.dart';
import 'package:notirak/api/api.dart';
import 'package:notirak/community-verify-otp.dart';
import 'package:notirak/community_login_screen.dart';
import 'community_password_reset_screen.dart'; // Import your PasswordResetScreen

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController(); // Controller to capture email input
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  String? _errorMessage; // Variable to hold error messages
  bool _isLoading = false; // Variable to manage loading state

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
        child: Form(
          key: _formKey, // Wrap the form key around the Form widget
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Forgot Password",
                style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30.0),
              Text(
                "Please enter your email address to receive a link to create a new password via email.",
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 40.0),
              TextFormField(
                controller: _emailController, // Use the controller
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF40A858)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null; // Input is valid
                },
              ),
              SizedBox(height: 60.0),
              Center(
                child: _isLoading
                    ? CircularProgressIndicator() // Show loading indicator
                    : ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            _sendOtp(context);
                          }
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
                        child: Text('Send'),
                      ),
              ),
              SizedBox(height: 20.0),
              if (_errorMessage != null) // Display error message if any
                Center(
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to handle sending the OTP
  Future<void> _sendOtp(BuildContext context) async {
    setState(() {
      _isLoading = true; // Start loading
      _errorMessage = null; // Clear any previous error message
    });

    var email = _emailController.text.trim(); // Get the entered email
    var data = {'email': email};

    try {
      // Call the API to send OTP
      await Api.sendOtp(context, data);

      // If successful, navigate to OTP verification screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyOtp(userData: data),
        ),
      );
    } catch (error) {
      // Handle the error by showing an error message
      setState(() {
        _errorMessage = "Email not found, please check."; // Update error message
      });
    } finally {
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
  }
}
