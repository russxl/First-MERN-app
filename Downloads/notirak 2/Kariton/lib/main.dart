
import 'package:flutter/material.dart';

import 'package:notirak/api/api.dart';
import 'package:notirak/barangay_main_screen.dart';
import 'package:notirak/community_home.dart';
import 'package:notirak/community_login_screen.dart';
import 'package:notirak/community_main_screen.dart';
import 'package:notirak/junkshop_main.dart';
import 'package:notirak/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Junk Shop App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TokenHandler(),
    );
  }
}

class TokenHandler extends StatelessWidget {
  const TokenHandler({Key? key}) : super(key: key);

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

   Future<Map<String, dynamic>> fetchUserData(String token, BuildContext context) async {
    return await Api.userData({'token': token}, context); // Pass the context here
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: SplashScreen());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error fetching token'));
        } else {
          String? token = snapshot.data;
          print(token);
          if (token == null || token.isEmpty) {
            return LoginScreen();
          } else {
          return FutureBuilder<Map<String, dynamic>>(
  future: fetchUserData(token, context),
  builder: (context, userSnapshot) {
    if (userSnapshot.connectionState == ConnectionState.waiting) {
      return Center(child: SplashScreen());
    } else if (userSnapshot.hasError) {
      return Center(child: Text('Error fetching user data'));
    } else if (userSnapshot.hasData) {
      Map<String, dynamic>? userData = userSnapshot.data;
      if ((userData != null && userData['user'] != null && userData['user']['token'] != null && userData['user']['token'] == token)||
      (userData != null && userData['junkOwner'] != null && userData['junkOwner']['token'] != null && userData['junkOwner']['token'] == token) ||
      (userData != null && userData['barangay'] != null && userData['barangay']['token'] != null && userData['barangay']['token'] == token)
      ) {
        print(userData);
        if (userData['userType']== 'Community') {
          // Add your logic here for when the user is of type 'user'
           // Assuming you have a UserHomePage widget
              
 return MainScreen(data:userData);
        } else if(userData['userType']== 'Barangay') {
      return BarangayMainScreen(data:userData);
          
          
        }
        else{
          return JunkshopMainScreen(data:userData);
        }
      } else {
        print('tangina');
        return LoginScreen();
      }
    } else {
      print('taena naman');
      return LoginScreen(); // In case there's no data and no error
    }
  },
);

          }
        }
      },
    );
  }
}
