import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notirak/community_login_screen.dart';
import 'junkshop_register_screen_add.dart';

class JunkshopRegisterScreen extends StatelessWidget {
  final String userType;

  // Constructor to accept userType
  JunkshopRegisterScreen({required this.userType});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: JunkshopFormScreen(userType: userType),
    );
  }
}

class JunkshopFormScreen extends StatefulWidget {
  final String userType;

  // Constructor to accept userType
  JunkshopFormScreen({required this.userType});

  @override
  _JunkshopFormScreenState createState() => _JunkshopFormScreenState();
}

class _JunkshopFormScreenState extends State<JunkshopFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _captainNameController = TextEditingController();
  final TextEditingController _junkshopNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController(); // Added email controller
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Regex pattern for password validation
  final RegExp _passwordPattern =
      RegExp(r'^(?=.*[A-Z])(?=.*[!@#$%^&*(),.?":{}|<>])(?=.{8,})');

  // Regex pattern for Philippines phone number validation
  final RegExp _phonePattern = RegExp(r'^(\+63|0)\d{10}$');  // Matches +63 or 0 followed by 10 digits

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
                "( Junkshop )",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Roboto',
                ),
              ),
              SizedBox(height: 30),
              _buildLabelWithAsterisk('Junkshop Owner Name'),
              TextFormField(
                controller: _captainNameController,
                decoration: InputDecoration(
                  hintText: 'Enter your name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the Junkshop owner name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _buildLabelWithAsterisk('Junkshop Name'),
              TextFormField(
                controller: _junkshopNameController,
                decoration: InputDecoration(
                  hintText: 'Enter your junkshop name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the Junkshop name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _buildLabelWithAsterisk('Email'),
              TextFormField(
                controller: _emailController, // Use the controller here
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  // Email validation using regex
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Please enter a valid email';
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  } else if (!_phonePattern.hasMatch(value)) {
                    return 'Please enter a valid Philippines phone number (e.g., +639XXXXXXXXX or 09XXXXXXXXX)';
                  }
                  return null;
                },
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  } else if (!_passwordPattern.hasMatch(value)) {
                    return 'Password must be at least 8 characters long,\ncontain 1 uppercase letter and 1 special character';
                  }
                  return null;
                },
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterJunkshopAdd(
                            userType: widget.userType,
                            captainName: _captainNameController.text,
                            junkshopName: _junkshopNameController.text,
                            email: _emailController.text, // Pass the email here
                            phone: _phoneController.text,
                            password: _passwordController.text,
                            confirmPassword: _confirmPasswordController.text,
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF40A858),
                    foregroundColor: Colors.white,
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
