import 'package:flutter/material.dart';
import 'package:notirak/api/api.dart';
import 'package:notirak/community_forgot_password.dart';
import 'community_login_screen.dart'; // Import your LoginScreen

class PasswordResetScreen extends StatefulWidget {
  final Map userData; // Add this field to accept data

  const PasswordResetScreen({Key? key, required this.userData}) : super(key: key);

  @override
  _PasswordResetScreenState createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  bool showPassword = false;
  bool showConfirmPassword = false;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void togglePasswordVisibility() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  void toggleConfirmPasswordVisibility() {
    setState(() {
      showConfirmPassword = !showConfirmPassword;
    });
  }

  // Function to validate the password
  bool validatePassword(String password) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(password);
  }

  void savePasswordAndNavigateBack() {
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (!validatePassword(password)) {
      _showErrorDialog(context, 'Password must be at least 8 characters long, contain one uppercase letter, and one special character.');
      return;
    }

    if (password != confirmPassword) {
      _showErrorDialog(context, 'Passwords do not match.');
      return;
    }

    var data = {
      "email": widget.userData['email'],
      "password": _passwordController.text,
      "confirmPassword": _confirmPasswordController.text
    };

    Api.resetPassword(context, data); // Call your API method to reset password
  }

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
              MaterialPageRoute(builder: (context) => ForgotPasswordScreen()), // Navigate to ForgotPasswordScreen
            );
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 80.0, 30.0, 30.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Forgot Password",
                style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
              ),
              SizedBox(height: 30.0),
              Text(
                'New Password',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: _passwordController,
                obscureText: !showPassword,
                decoration: InputDecoration(
                  hintText: 'Enter your new password',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: togglePasswordVisibility,
                  ),
                ),
              ),
              SizedBox(height: 15.0),
              Text(
                'Confirm Password',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: !showConfirmPassword,
                decoration: InputDecoration(
                  hintText: 'Confirm your new password',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(showConfirmPassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: toggleConfirmPasswordVisibility,
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              Center(
                child: ElevatedButton(
                  onPressed: savePasswordAndNavigateBack,
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
                  child: Text('Save', style: TextStyle(fontFamily: 'Roboto')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
