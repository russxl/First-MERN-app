import 'package:flutter/material.dart';
import 'package:notirak/api/api.dart';
import 'community_signup_screen.dart';
import 'community_forgot_password.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false, // This removes the back button
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 80.0, 30.0, 30.0),
        child: LoginScreenForm(),
      ),
    );
  }
}

class LoginScreenForm extends StatefulWidget {
  @override
  _LoginScreenFormState createState() => _LoginScreenFormState();
}

class _LoginScreenFormState extends State<LoginScreenForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;
  bool _isLoading = false; // Loading state variable
  String _emailError = ''; // Email error message
  String _passwordError = ''; // Password error message

  void _togglePasswordVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  void _navigateToSignUpScreen() async {
    var data = {
      'email': _usernameController.text,
      'password': _passwordController.text,
    };
    Api.getBarangay(context, data); // Make sure this API method is implemented
  }

  void _navigateToForgotPasswordScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
    );
  }

  Future<void> _login() async {
    // Clear any previous error messages
    setState(() {
      _emailError = '';
      _passwordError = '';
    });

    // Check if fields are not empty before proceeding
    if (_usernameController.text.isEmpty) {
      setState(() {
        _emailError = 'Email cannot be empty';
      });
      return;
    }

    if (_passwordController.text.isEmpty) {
      setState(() {
        _passwordError = 'Password cannot be empty';
      });
      return;
    }

    setState(() {
      _isLoading = true; // Start loading
    });

    var data = {
      'email': _usernameController.text,
      'password': _passwordController.text,
    };

    try {
      // Call the API and wait for the result
      await Api.authenticationCommunity(context, data);
    } catch (e) {
      setState(() {
        _emailError = 'Login failed: $e'; // Display an error if login fails
      });
    }

    setState(() {
      _isLoading = false; // Stop loading after API call completes
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: ListView(
        children: <Widget>[
          Text(
            "Login to your\naccount",
            style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20.0),
          
          // Email TextFormField
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'Enter your email',
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF40A858)),
              ),
              errorText: _emailError.isNotEmpty ? _emailError : null,
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2.0),
              ),
            ),
          ),
          SizedBox(height: 10.0),

          // Password TextFormField
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
              errorText: _passwordError.isNotEmpty ? _passwordError : null,
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2.0),
              ),
            ),
          ),
          SizedBox(height: 10.0),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TextButton(
                onPressed: _navigateToForgotPasswordScreen,
                child: Text(
                  'Forgot Password',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
          SizedBox(height: 50.0),

          // Stack to overlay CircularProgressIndicator and Login button
          Stack(
            children: [
              ElevatedButton(
                onPressed: _isLoading ? null : _login, // Disable button if loading
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
              if (_isLoading)
                Positioned(
                  right: 16,
                  top: 8,
                  bottom: 8,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
            ],
          ),

          SizedBox(height: 10.0),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Not a member?"),
              TextButton(
                onPressed: _navigateToSignUpScreen,
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Color(0xFF40A858),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
