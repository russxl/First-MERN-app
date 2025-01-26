import 'package:flutter/material.dart';
import 'package:notirak/user_selection.dart'; // Ensure this import is correct
import 'large_junkshop.dart'; // Ensure this import is correct

class AdminLoginScreen extends StatefulWidget {
  @override
  _AdminLoginScreenState createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  bool _isObscure = true;
  bool _rememberMe = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _togglePasswordVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  void _toggleRememberMe(bool? newValue) {
    setState(() {
      _rememberMe = newValue ?? false;
    });
  }

  void _login() {
    // Hardcoded credentials
    const String correctEmail = 'admin2113@gmail.com';
    const String correctPassword = '123456789';

    if (_emailController.text == correctEmail && _passwordController.text == correctPassword) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LargeJunkshopScreen(userData: {},)),
      );
    } else {
      // Show error message if credentials are incorrect
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid email or password'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
              MaterialPageRoute(builder: (context) => UserTypeSelection(userData: {},)), // Navigate to UserTypeSelection
            );
          },
        ),
        title: Text('Admin Login'), // Updated title
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 30.0),
        children: <Widget>[
          Text(
            "Admin account",
            style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20.0),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'Enter your email',
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF40A858)),
              ),
            ),
          ),
          SizedBox(height: 10.0),
          TextFormField(
            controller: _passwordController,
            obscureText: _isObscure,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF40A858)),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _isObscure ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: _togglePasswordVisibility,
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Checkbox(
                    value: _rememberMe,
                    onChanged: _toggleRememberMe,
                  ),
                  Text('Remember me'),
                ],
              ),
            ],
          ),
          SizedBox(height: 50.0),
          ElevatedButton(
            onPressed: _login,
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
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
}
