
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_booking_app/pages/sign_in_page.dart';
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);


  runApp(MyApp());


}


class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);


 
  @override
  Widget build(BuildContext context) {
   
    return MaterialApp(
      title: 'Movie Booking',
        debugShowCheckedModeBanner: false,
        home: GoogleSignIn(),
    );
  }
}
