import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notirak/api/api.dart';
import 'community_login_screen.dart'; // Adjust the path if necessary

class SignUpScreen extends StatefulWidget {
  final String userType;
  final Map userData;

  SignUpScreen({Key? key, required this.userData, required this.userType}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isObscurePassword = true;
  bool _isObscureConfirmPassword = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? _selectedBarangay;
  String? _nameError;
  String? _emailError;
  String? _phoneError;
  String? _barangayError;
  String? _passwordError;
  String? _confirmPasswordError;

  bool _isLoading = false; // Add loading state

  void _togglePasswordVisibility() {
    setState(() {
      _isObscurePassword = !_isObscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _isObscureConfirmPassword = !_isObscureConfirmPassword;
    });
  }

  bool _isValidPhoneNumber(String phone) {
    final RegExp phoneRegExp = RegExp(r'^(?:\+63|0)\d{10}$');
    return phoneRegExp.hasMatch(phone);
  }

  bool _isValidEmail(String email) {
    final RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegExp.hasMatch(email);
  }

  bool _isValidPassword(String password) {
    final RegExp passwordRegExp = RegExp(r'^(?=.*[A-Z])(?=.*\W).{8,}$');
    return passwordRegExp.hasMatch(password);
  }

  // Show loading dialog
  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Registering..."),
            ],
          ),
        );
      },
    );
  }

  // Dismiss loading dialog
  void _hideLoadingDialog() {
    Navigator.pop(context);
  }

  // Show success dialog for successful registration
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Registration Successful'),
          content: Text('You have successfully registered. You can now log in.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // Show error dialog for failed registration
  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Registration Failed'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _registerUser() {
    final String name = _nameController.text;
    final String email = _emailController.text;
    final String phone = _phoneController.text;
    final String password = _passwordController.text;
    final String confirmPassword = _confirmPasswordController.text;

    setState(() {
      _nameError = name.isEmpty ? 'Name is required' : null;
      _emailError = email.isEmpty
          ? 'Email is required'
          : !_isValidEmail(email)
              ? 'Enter a valid email'
              : null;
      _phoneError = phone.isEmpty
          ? 'Phone number is required'
          : !_isValidPhoneNumber(phone)
              ? 'Enter a valid Philippine phone number'
              : null;
      _barangayError = _selectedBarangay == null ? 'Please select a barangay' : null;
      _passwordError = password.isEmpty
          ? 'Password is required'
          : !_isValidPassword(password)
              ? 'Password must be at least 8 characters, have 1 uppercase letter, and 1 special character'
              : null;
      _confirmPasswordError = confirmPassword.isEmpty
          ? 'Please confirm your password'
          : confirmPassword != password
              ? 'Passwords do not match'
              : null;
    });

    if (_nameError == null &&
        _emailError == null &&
        _phoneError == null &&
        _barangayError == null &&
        _passwordError == null &&
        _confirmPasswordError == null) {
      final Map<String, String> data = {
        "name": name,
        "email": email,
        "phone": phone,
        "barangay": _selectedBarangay ?? '',
        "password": password,
        "confirmPassword": confirmPassword,
        "userType": widget.userType
      };

      _showLoadingDialog(); // Show loading dialog when registration starts

      Api.registrationCommunity(context, data).then((success) {
        _hideLoadingDialog(); // Hide loading dialog after API response
        if (success) {
          _showSuccessDialog(); // Show success dialog when registration is successful
        } else {
          _showErrorDialog("Registration failed. Please try again."); // Error handling
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> _barangays = List<String>.from(
      widget.userData['barangay'].map((barangay) => barangay['bName']),
    );

    InputDecoration _inputDecoration({String? hintText, bool isValid = true}) {
      return InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: isValid ? Color(0xFF40A858) : Colors.red),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: isValid ? Color(0xFF40A858) : Colors.red),
        ),
      );
    }

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
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20.0),
            Text(
              "Create an account",
              style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
            ),
            SizedBox(height: 10),
            Text(
              "( Community )",
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Roboto',
              ),
            ),
            SizedBox(height: 30.0),
            _buildRequiredText('Name'),
            TextFormField(
              controller: _nameController,
              decoration: _inputDecoration(hintText: 'Enter your name', isValid: _nameError == null),
            ),
            if (_nameError != null)
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(_nameError!, style: TextStyle(color: Colors.red)),
              ),
            SizedBox(height: 15.0),
            _buildRequiredText('Email'),
            TextFormField(
              controller: _emailController,
              decoration: _inputDecoration(hintText: 'Enter your email', isValid: _emailError == null),
            ),
            if (_emailError != null)
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(_emailError!, style: TextStyle(color: Colors.red)),
              ),
            SizedBox(height: 15.0),
            _buildRequiredText('Select Barangay'),
            DropdownButtonFormField<String>(
              decoration: _inputDecoration(isValid: _barangayError == null),
              hint: Text('Select your barangay'),
              value: _selectedBarangay,
              items: _barangays.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedBarangay = newValue;
                });
              },
            ),
            if (_barangayError != null)
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child:                Text(_barangayError!, style: TextStyle(color: Colors.red)),
              ),
            SizedBox(height: 15.0),
            _buildRequiredText('Phone Number'),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: _inputDecoration(hintText: 'Enter your phone number', isValid: _phoneError == null),
            ),
            if (_phoneError != null)
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(_phoneError!, style: TextStyle(color: Colors.red)),
              ),
            SizedBox(height: 15.0),
            _buildRequiredText('Password'),
            TextFormField(
              controller: _passwordController,
              obscureText: _isObscurePassword,
              decoration: _inputDecoration(hintText: 'Enter your password', isValid: _passwordError == null).copyWith(
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscurePassword ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: _togglePasswordVisibility,
                ),
              ),
            ),
            if (_passwordError != null)
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(_passwordError!, style: TextStyle(color: Colors.red)),
              ),
            SizedBox(height: 15.0),
            _buildRequiredText('Confirm Password'),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: _isObscureConfirmPassword,
              decoration: _inputDecoration(hintText: 'Re-enter your password', isValid: _confirmPasswordError == null).copyWith(
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: _toggleConfirmPasswordVisibility,
                ),
              ),
            ),
            if (_confirmPasswordError != null)
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(_confirmPasswordError!, style: TextStyle(color: Colors.red)),
              ),
            SizedBox(height: 30.0),
            Center(
              child: ElevatedButton(
                onPressed: _registerUser,
                child: Text('Register'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF40A858),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 100),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  Widget _buildRequiredText(String label) {
    return Row(
      children: <Widget>[
        Text(
          label,
          style: TextStyle(fontSize: 16.0, fontFamily: 'Roboto'),
        ),
        Text(
          " *",
          style: TextStyle(fontSize: 16.0, fontFamily: 'Roboto', color: Colors.red),
        ),
      ],
    );
  }
}

