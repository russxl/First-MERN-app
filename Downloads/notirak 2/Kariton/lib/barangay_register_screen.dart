import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notirak/community_login_screen.dart';
import 'barangay_register_screen_add.dart'; // Import the new screen

class BarangayRegisterScreen extends StatelessWidget {
  final String userType; // Field to accept the user type

  // Constructor to accept the user type
  BarangayRegisterScreen({required this.userType});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BarangayFormScreen(userType: userType),
    );
  }
}

class BarangayFormScreen extends StatefulWidget {
  final String userType; // Field to accept the user type

  // Constructor to accept the user type
  BarangayFormScreen({required this.userType});

  @override
  _BarangayFormScreenState createState() => _BarangayFormScreenState();
}

class _BarangayFormScreenState extends State<BarangayFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _captainNameController = TextEditingController();
  final TextEditingController _barangayNameController = TextEditingController(); // Controller for Barangay Name
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    } else if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one capital letter';
    } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one unique character';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    } else if (!RegExp(r'^09\d{9}$').hasMatch(value)) {
      return 'Please enter a valid Philippine phone number (11 digits, starting with 09)';
    }
    return null;
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
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 50.0, 30.0, 30.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                "Create an account",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
              SizedBox(height: 10),
              Text(
                "( Barangay )",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Roboto',
                ),
              ),
              SizedBox(height: 30),
              
              // Barangay Name Field
              _buildLabelWithAsterisk('Barangay Name'),
              TextFormField(
                controller: _barangayNameController,
                decoration: InputDecoration(
                  hintText: 'Enter barangay name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the barangay name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              _buildLabelWithAsterisk('Barangay Captain Name'),
              TextFormField(
                controller: _captainNameController,
                decoration: InputDecoration(
                  hintText: 'Enter your name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the captain name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              
             _buildLabelWithAsterisk('Email'),
TextFormField(
  controller: _emailController,
  decoration: InputDecoration(
    hintText: 'Enter your email',
    border: OutlineInputBorder(),
  ),
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
      .hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  },
),
              SizedBox(height: 20),
              _buildLabelWithAsterisk('Phone Number'),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  hintText: 'Enter your phone number',
                  border: OutlineInputBorder(),
                ),
                validator: _validatePhone,
              ),
              SizedBox(height: 20),
              _buildLabelWithAsterisk('Password'),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: _validatePassword,
              ),
              SizedBox(height: 20),
              _buildLabelWithAsterisk('Confirm Password'),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  hintText: 'Confirm password',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              SizedBox(height: 50),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Pass the form data to RegisterBarangayAdd
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterBarangayAdd(
                            userType: widget.userType,
                            barangayName: _barangayNameController.text, // Include barangay name
                            captainName: _captainNameController.text,
                            email: _emailController.text,
                            phone: _phoneController.text,
                            password: _passwordController.text,
                            confirmPassword: _confirmPasswordController.text,
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF40A858), // Background color
                    foregroundColor: Colors.white, // Text color
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 100),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabelWithAsterisk(String label) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Roboto',
          ),
        ),
        Text(
          '*',
          style: TextStyle(
            fontSize: 18,
            color: Colors.red,
            fontFamily: 'Roboto',
          ),
        ),
      ],
    );
  }
}
