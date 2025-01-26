import 'dart:convert';
import 'dart:io';

import 'package:notirak/barangay_collect_scrap_page.dart';
import 'package:notirak/barangay_community_receipt.dart';
import 'package:notirak/barangay_community_save_sched.dart';
import 'package:notirak/barangay_junkshop_detail.dart';
import 'package:notirak/barangay_main_screen.dart';
import 'package:notirak/community-verify-otp.dart';
import 'package:notirak/community_login_screen.dart';
import 'package:notirak/community_main_screen.dart';
import 'package:notirak/junkshop_main.dart';
import 'package:notirak/main.dart';
import 'package:notirak/user_selection.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



class Api {
 static const baseUrl = "https://kariton-mobile-server.onrender.com/api/";
static Future<void> authenticationCommunity(BuildContext context, Map pdata) async {
  var url = Uri.parse("${baseUrl}login");
  print("$pdata hi");
  try {
    final res = await http.post(url, body: pdata);
    final data = jsonDecode(res.body.toString());

    if (res.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      
      // Navigate to the next screen if successful
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MyApp()),
      );
    } else {
      // Show an error dialog or message if authentication fails
      _showErrorDialog(context, data['message'] ?? 'Please check your Email or Password.');
    }
  } catch (e) {
    debugPrint(e.toString());
    _showErrorDialog(context, 'Something went wrong. Please try again.');
  }
}

// Function to show an error dialog
static void _showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Login Failed'),
        content: Text(message),
        actions: [
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


static Future<bool> registrationCommunity(BuildContext context, Map pdata) async {
  var url = Uri.parse("${baseUrl}registerCommunity");
  print("$pdata hi");
  try {
    final res = await http.post(url, body: pdata);
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body.toString());
      print('Success: ${data['message']}');
      
      // Return true to indicate success
      return true;
    } else {
      throw Exception("Failed to authenticate");
    }
  } catch (e) {
    debugPrint(e.toString());
    // Return false to indicate failure
    return false;
  }
}

  static Future<void> registrationBarangay(BuildContext context, Map<String, dynamic> pdata, File imageFile) async {
  var url = Uri.parse("${baseUrl}register");
  var request = http.MultipartRequest('POST', url);
print(pdata);
  // Convert the pdata values to strings and add to the request fields
  pdata.forEach((key, value) {
    request.fields[key] = value.toString();
  });

  // Add image file to the request if it's not null
  if (imageFile != null) {
    var stream = http.ByteStream(imageFile.openRead());
    var length = await imageFile.length();
    var multipartFile = http.MultipartFile('img', stream, length, filename: basename(imageFile.path));
    request.files.add(multipartFile);
    print('Image file: ${imageFile.path}');
  }

  try {
    // Send the multipart request
    var response = await request.send();

    // Process the response
    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      var data = jsonDecode(responseBody);
      print('Success: ${data['message']}');
      
      // Navigate to the next page after successful authentication
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyApp()),
      );
    } else {
      throw Exception("Failed to authenticate");
      
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}
   static Future<bool> registrationJunkshop(BuildContext context, Map<String, dynamic> pdata, File imageFile) async {
    var url = Uri.parse("${baseUrl}register");
    var request = http.MultipartRequest('POST', url);

    // Convert the pdata values to strings and add to the request fields
    pdata.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    // Add image file to the request if it's not null
    if (imageFile != null) {
      var stream = http.ByteStream(imageFile.openRead());
      var length = await imageFile.length();
      var multipartFile = http.MultipartFile('img', stream, length, filename: basename(imageFile.path));
      request.files.add(multipartFile);
      print('Image file: ${imageFile.path}');
    }

    try {
      // Send the multipart request
      var response = await request.send();

      // Process the response
      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var data = jsonDecode(responseBody);
        print('Success: ${data['message']}');
        
        // Optionally navigate to another page if registration is successful
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyApp()), // Adjust to your app's navigation
        );
        
        return true; // Registration successful
      } else {
        var responseBody = await response.stream.bytesToString();
        var data = jsonDecode(responseBody);
        print('Error: ${data['msg']}');
        throw Exception("Failed to register");
      }
    } catch (e) {
      debugPrint(e.toString());
      return false; // Return false on error
    }
    
    return false; // Default return value (should not reach here)
  }
 static Future<Map<String, dynamic>> userData(
    Map<String, String?> pdata,
    BuildContext context, // Added BuildContext as parameter to allow navigation
  ) async {
    var url = Uri.parse("${baseUrl}userData");
    print(pdata);
    try {
      final res = await http.post(url, body: pdata);

      // If the request is successful
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body.toString());

        print(data['collection']);
        return data; // Return the data if successful
      } else {
        // Handle failed requests
        var data = jsonDecode(res.body.toString());
        print(data['message']);

        // Use BuildContext to navigate
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );

        throw Exception("Failed to authenticate");
      }
    } catch (e) {
      // Handle network or JSON decoding errors
      debugPrint("Error: ${e.toString()}");

      // You can also return a specific error map if needed
      return {
        "error": true,
        "message": e.toString(),
      };
    }
  }
  static Future<void> saveSched(BuildContext context,Map<String, dynamic> scheduleData) async {
    // Replace with your API endpoint
     var url = Uri.parse("${baseUrl}saveSched");
   print(scheduleData['Monday']['collectionTime']);
    // Make the POST request
    final response = await http.post(
     url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(scheduleData),
    );

    if (response.statusCode == 200) {
      print(' ule saved successfully.');

     var data =  jsonDecode(response.body.toString());
             Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) =>BarangayCommunitySaveSchedScreen(
                          day1: 'Monday',
                          day2: 'Tuesday',
                          day3: 'Wednesday',
                          day4: 'Thursday',
                          day5: 'Friday',
                          scrapTypeDay1: scheduleData['Monday']['scrapType'],
                          scrapTypeDay2: scheduleData['Tuesday']['scrapType'],
                          scrapTypeDay3: scheduleData['Wednesday']['scrapType'],
                          scrapTypeDay4: scheduleData['Thursday']['scrapType'],
                          scrapTypeDay5: scheduleData['Friday']['scrapType'],
                          timeDay1: scheduleData['Monday']['collectionTime'],
                          timeDay2: scheduleData['Tuesday']['collectionTime'],
                          timeDay3: scheduleData['Wednesday']['collectionTime'],
                          timeDay4: scheduleData['Thursday']['collectionTime'],
                          timeDay5: scheduleData['Friday']['collectionTime'],
                          data: data,
                        )) );

    } else {
      print('Failed to save schedule.');
    }
  }
    static Future<void> redemptionDate(BuildContext context,Map<String, dynamic> scheduleData) async {
    // Replace with your API endpoint
     var url = Uri.parse("${baseUrl}redeemDate");
   print(scheduleData);
    // Make the POST request
    final response = await http.post(
     url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(scheduleData),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString()) ;
      print('Schedule saved successfully.');
    Navigator.push(
                  context,
                    MaterialPageRoute(builder: (context) => BarangayMainScreen(data:data)),
                );

    } else {
      print('Failed to save schedule.');
    }
  }
   static Future<void> saveCashConversion(BuildContext context,Map<String, dynamic> cash) async {
    // Replace with your API endpoint
     var url = Uri.parse("${baseUrl}rewardConversion");
   print(cash);
    // Make the POST request
    final response = await http.post(
     url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(cash),
    );

    if (response.statusCode == 200) {
      print('Schedule saved successfully.');
            final data = jsonDecode(response.body.toString());
            print(data);
       Navigator.push(
                  context,
                    MaterialPageRoute(builder: (context) => BarangayMainScreen(data:data)),
                );
    } else {
      print('Failed to save schedule.');
    }
  } 
     static Future<void> saveGoodsConversion(BuildContext context,Map<String, dynamic> cash) async {
    // Replace with your API endpoint
     var url = Uri.parse("${baseUrl}rewardConversion");
   print(cash);
    // Make the POST request
    final response = await http.post(
     url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(cash),
    );

    if (response.statusCode == 200) {
      print('Schedule saved successfully.');
            final data = jsonDecode(response.body.toString());
            print(data);
    } else {
      print('Failed to save schedule.');
    }
  }

  static Future<void> saveScrapConversion(BuildContext context,Map<String, dynamic> cash) async {

    // Replace with your API endpoint
     var url = Uri.parse("${baseUrl}scrapConversion");
   print(cash);
    // Make the POST request
    final response = await http.post(
     url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(cash),
    );
    
    if (response.statusCode == 200) {
      print('Schedule saved successfully.');
    } else {
      print('Failed to save schedule.');
          var data = jsonDecode(response.body.toString());
            print(data);
      print(data['message']);
    }
  }
 static Future<void> getBarangay(BuildContext context, Map pdata) async {
       var url = Uri.parse("${baseUrl}getBarangay");
    print("$pdata hi");
    try {
      final res = await http.post(url, body: pdata);
      if (res.statusCode == 200) {
       final data = jsonDecode(res.body.toString());
        print(data['message']);
        Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => UserTypeSelection(userData: data)) );
      } else {
     
         final data = jsonDecode(res.body.toString());
         print(data['message']);
        throw Exception("Failed to authenticate fuck");
     
      
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

static Future<bool> collectScrap(BuildContext context, Map pdata) async {
  var url = Uri.parse("${baseUrl}collectScrap");
  print("$pdata hi");

  try {
    final res = await http.post(url, body: pdata);


    if (res.statusCode == 200) {
      final data = jsonDecode(res.body.toString());
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ReceiptPage(data: data)),
      );
      return true;  // Proceed if status is 200
    } else {
      final data = jsonDecode(res.body.toString());
      print(data['message']);
      throw Exception("Failed to authenticate");
    }
  } catch (e) {
    debugPrint(e.toString());
    return false;  // Return false in case of an error
  }
}

 static Future<void> redeem(BuildContext context, Map pdata) async {
  var url = Uri.parse("${baseUrl}redeem");
  print("$pdata hi");

  // Convert all values in pdata to String
  Map<String, String> stringifiedData = pdata.map((key, value) => MapEntry(key, value.toString()));

  try {
    final res = await http.post(url, body: stringifiedData);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body.toString());
      print(data['message']);
   var id = {
                    "id":pdata['user_id'].toString(),
                    "type":"Community"
                  };
                  Api.getHome(context, id);// Go back to the previous screen
    } else {
      final data = jsonDecode(res.body.toString());
      print(data['message']);
      throw Exception("Failed to authenticate");
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}
 static Future<void> pickUp(BuildContext context, Map pdata) async {
  var url = Uri.parse("${baseUrl}pickUp");
  print("$pdata hi");

  // Convert all values in pdata to String
  Map<String, String> stringifiedData = pdata.map((key, value) => MapEntry(key, value.toString()));
 
  try {
    final res = await http.post(url, body: stringifiedData);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body.toString());
      print(data['message']);
     Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JunkshopMainScreen(data:data),
          ),
        );
    } else {
      final data = jsonDecode(res.body.toString());
      print(data['message']);
      throw Exception("Failed to authenticate");
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}
 static Future<void> junkShopList(BuildContext context, Map id) async {
  var url = Uri.parse("${baseUrl}junkShopList");
print(id);
  // Convert all values in pdata to String
 
  try {
    final res = await http.post(url, body: id);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body.toString());
      print(data['message']);
   Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JunkshopDetailScreen( data:data),
          ),
        );
    } else {
      final data = jsonDecode(res.body.toString());
      print(data['message']);
      throw Exception("Failed to authenticate");
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}

 static Future<void> getHome(BuildContext context, Map id) async {
  var url = Uri.parse("${baseUrl}getHome");
var type = id['type'];
  // Convert all values in pdata to String
 
  try {
    final res = await http.post(url, body: id);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body.toString());
      print(data);
      if(id['type'].toString() == "Barangay"){
                print('2');
   Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BarangayMainScreen(data:data),
          ),
        );
      }
    else if(id['type'].toString() == "Community"){
   Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(data:data),
          ),
        );
      }
      else{
        print('1');
         Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JunkshopMainScreen(data:data),
          ),
        );
      }
      

    } else {
      final data = jsonDecode(res.body.toString());
      print(data['message']);
      throw Exception("Failed to authenticate");
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}
  static Future<void> updateClient(BuildContext context, Map<String, dynamic> pdata, File imageFile) async {
  var url = Uri.parse("${baseUrl}updateClient");
  var request = http.MultipartRequest('POST', url);

  // Convert the pdata values to strings and add to the request fields
  pdata.forEach((key, value) {
    request.fields[key] = value.toString();
  });

  // Add image file to the request if it's not null
  if (imageFile != null) {
    var stream = http.ByteStream(imageFile.openRead());
    var length = await imageFile.length();
    var multipartFile = http.MultipartFile('img', stream, length, filename: basename(imageFile.path));
    request.files.add(multipartFile);
    print('Image file: ${imageFile.path}');
  }

  try {
    // Send the multipart request
    var response = await request.send();

    // Process the response
    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      var data = jsonDecode(responseBody);
      print('Success: ${data['message']}');
      if(pdata['type'] == "Barangay"){
         Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BarangayMainScreen(data:data),
          ),
        );
      }
      else{
           Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JunkshopMainScreen(data:data),
          ),
        );
      }
 
      
      // Navigate to the next page after successful authentication
    } else {
      throw Exception("Failed to authenticate");
      
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}
  static Future<void> updateCommunity(BuildContext context, Map pdata) async {
    var url = Uri.parse("${baseUrl}updateClient");
    print("$pdata hi");
    try {
      final res = await http.post(url, body: pdata);
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body.toString());
         var id = {
                    "id":pdata['user_id'].toString(),
                    "type":"Community"
                  };
        print('Success: ${data['message']}');
        // Navigate to the next page after successful authentication
    Api.getHome(context, id);
      } else {
        throw Exception("Failed to authenticate");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

 static Future<void> sendOtp(BuildContext context, Map name) async {
  var url = Uri.parse("${baseUrl}send-otp");

  try {
    final res = await http.post(url, body: name);

    if (res.statusCode == 200) {
      
      final data = jsonDecode(res.body.toString());
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyOtp(userData: name),
        ),
      );
    } else {
      final data = jsonDecode(res.body.toString());
      throw Exception(data['message'] ?? "Failed to authenticate");
    }
  } catch (e) {
    // Pass the error message back to the calling function
    throw Exception(e.toString());
  }
}

static Future<bool> verifyOtp(BuildContext context, Map data) async {
  var url = Uri.parse("${baseUrl}verify-otp");

  try {
    final res = await http.post(url, body: data);

    if (res.statusCode == 200) {
      final responseData = jsonDecode(res.body);
      
      // Assuming that the response contains a success message or status
      if (responseData['status_code'] == 200) {
        print('true');
        return true; // OTP verified successfully
        
      } else {
        print(responseData['message']);
        return false; // OTP verification failed
      }
    } else {
      final errorData = jsonDecode(res.body);
      print(errorData['message']);
      throw Exception("Failed to authenticate");
    }
  } catch (e) {
    debugPrint(e.toString());
    return false; // An error occurred
  }
}static Future<bool> checkUserExist(Map<String, dynamic> data) async {
  var url = Uri.parse("${baseUrl}checkUserExist");

  try {
    final res = await http.post(url, body: data);

    if (res.statusCode == 200) {
      final responseData = jsonDecode(res.body);

      // Check if the API returned status_code 200 for success
      if (responseData['status_code'] == 200) {
        print('User exists: true');
        return true; // User exists
      } else {
        print('User does not exist: ${responseData['message']}');
        return false; // User doesn't exist
      }
    } else {
      final errorData = jsonDecode(res.body);
      print('API Error: ${errorData['message']}');
      throw Exception("Failed to check user existence");
    }
  } catch (e) {
    debugPrint('Error checking user: $e');
    return false; // An error occurred
  }
}


  static Future<void> resetPassword(BuildContext context, Map data) async {
  var url = Uri.parse("${baseUrl}reset-password");

  // Convert all values in pdata to String
 
  try {
    final res = await http.post(url, body: data);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body.toString());
     Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen()
          ),
        );

    } else {
      final data = jsonDecode(res.body.toString());
      print(data['message']);
      throw Exception("Failed to authenticate");
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}

}






 