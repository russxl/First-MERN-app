import 'package:flutter/material.dart';
import 'package:notirak/barangay_register_screen.dart';
import 'package:notirak/community_signup_screen.dart';
import 'package:notirak/junkshop_register_screen.dart';
import 'community_login_screen.dart';
import 'admin_login.dart';

class UserTypeSelection extends StatefulWidget {
  final Map userData; // This should include 'name', 'points', and 'goods' data

  const UserTypeSelection({Key? key, required this.userData}) : super(key: key);
  @override
  _UserTypeSelectionState createState() => _UserTypeSelectionState();
}

class _UserTypeSelectionState extends State<UserTypeSelection> {
  String? selectedUserType;

  @override
  Widget build(BuildContext context) {
    print(widget.userData);
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(30.0, 120.0, 30.0, 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'So before we start.',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Can you identify what type of user are you?',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text('User Type ',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Roboto',
                        )),
                    Text('*',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                          fontFamily: 'Roboto',
                        )),
                  ],
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedUserType,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    hintText: 'Select a user',
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 20.0,
                      horizontal: 20.0,
                    ),
                  ),
                  items: [
                    DropdownMenuItem<String>(
                      value: 'Community',
                      child: Text('Community',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Roboto',
                          )),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Barangay',
                      child: Text('Barangay',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Roboto',
                          )),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Junkshop',
                      child: Text('Junkshop',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Roboto',
                          )),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedUserType = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a user type';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 100.0),
                    child: TextButton(
                      onPressed: () {
                        if (selectedUserType == null) {
                          // Show a dialog if no user type is selected
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('No User Type Selected'),
                                content: Text('Please select a user type to continue.'),
                                actions: [
                                  TextButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Close the dialog
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          Widget nextScreen;
                          if (selectedUserType == 'Community') {
                            nextScreen = SignUpScreen(
                                userType: selectedUserType!, userData: widget.userData);
                          } else if (selectedUserType == 'Barangay') {
                            nextScreen = BarangayRegisterScreen(userType: selectedUserType!);
                          } else if (selectedUserType == 'Junkshop') {
                            nextScreen = JunkshopRegisterScreen(userType: selectedUserType!);
                          } else {
                            // Handle other user types or show an error
                            return;
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => nextScreen),
                          );
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xFF40A858),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 100),
                      ),
                      child: Text('Continue',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Roboto',
                          )),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: IconButton(
                icon: Icon(Icons.admin_panel_settings, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminLoginScreen()),
                  );
                },
                iconSize: 30.0,
                splashRadius: 24.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
