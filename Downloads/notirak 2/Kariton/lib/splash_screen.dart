import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'onboarding.dart'; // Import the onboarding screen

class SplashScreen extends StatefulWidget {


  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to OnboardingScreen after 2 seconds
    Future.delayed(Duration(seconds: 2), () {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          'Kariton',
          style: GoogleFonts.kaiseiTokumin(
            textStyle: TextStyle(
              color: Color(0xFF40A858),
              fontSize: 40, // Adjust the font size as needed
            ),
          ),
        ),
      ),
    );
  }
}
