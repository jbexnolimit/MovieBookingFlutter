import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/common/common.dart';
import 'package:movie_booking_app/model/userModel.dart';
import 'package:movie_booking_app/pages/payment_page.dart';
import '../api/api.dart';
import '../api/google_signin_api.dart';
import 'dashboard.dart';

class GoogleSignIn extends StatefulWidget {


  GoogleSignIn({Key? key}) : super(key: key);


  @override
  _GoogleSignInState createState() => _GoogleSignInState();
}

class _GoogleSignInState extends State<GoogleSignIn> {

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar
        (title: const Text('Login')
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.black,
                    minimumSize: Size(double.infinity, 50),
                  ),
                  icon: FaIcon(
                    FontAwesomeIcons.google,
                    color: Colors.red,
                  ),
                  label: Text('Sign In with Google'),
                  onPressed: ()  {

                    signIn();

                  }
                    //
                    //
                  //  getCinemaById();
                   /* Navigator.push(context, MaterialPageRoute(
                        builder: (context) => Dashboard()));*/


              ),
              SizedBox(height: 40)

            ]
        ),
      ),


    );


  }




   register(String email, String password,String? imageUrl,String? name) async{

    Map body =
      {
        'email': email,
        'password': password,
        'account': {
          'profile': {
            'imageUrl': imageUrl,
            'familyName': "N/A",
            'givenName': "N/A",
            'name': name
          }
        }
      };
    String jsonBody = json.encode(body);

    log(body.toString());

    http.Response response = await http.post(Uri.parse(Api.registerApi),
          headers: {"Content-Type": "application/json"},
          body : jsonBody
        );


    if (response.statusCode == 200) {

    log(response.body.toString());

    //back to signIn
    signIn();

      }else{
      print('register!');
        print(response.statusCode);
        log(response.body);
        }
    }


   signIn() async {
    try {
    final user = await GoogleSignInApi.login();
    if (user == null) {
      Get.snackbar('Google Sign in', 'Error Sign in',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: const EdgeInsets.all(10),
          duration: const Duration(seconds: 2));
    } else {

      var response = await http.post(Uri.parse(Api.loginApi),
              body: {
                "email": user.email,
                "password": user.id
              }
          );

        if (response.statusCode == 200) {
          print('login!'+response.statusCode.toString());
          log(response.body);

          final data = json.decode(response.body);
          final UserModel _userModel = UserModel.fromJson(data);
          log(response.body);


          //Dashboard
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => Dashboard(userModel: _userModel)));

        }else{
          print('login!'+response.statusCode.toString());
          log(response.body);
          //Register
          register(user.email, user.id, user.photoUrl, user.displayName);
        }

      }

    } catch (e) {
      print(e);
    }

  }

}