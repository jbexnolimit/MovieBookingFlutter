import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:movie_booking_app/api/api.dart';
import 'package:movie_booking_app/model/cinemaListModel.dart';
import 'package:movie_booking_app/model/userModel.dart';
import 'dart:developer';

import 'package:movie_booking_app/pages/home_cine_page.dart';


class Dashboard extends StatefulWidget {
  final UserModel userModel;

  Dashboard({Key? key, required this.userModel}) : super(key: key);


  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  List<CinemaListModel> _cinemaList = [];

  Future getCinema() async{
    Position position = await _determinePosition();

    try{

      var response = await http.get(Uri.parse(Api.cinemaApi).replace(
          queryParameters: {
            "latitude" :  position.latitude.toString(),
            "longitude" : position.longitude.toString()
          }));


      if(response.statusCode == 200) {
        final data = json.decode(response.body);
        log(response.statusCode.toString());
        log(response.body);
          for (Map<String, dynamic> i in data){
            _cinemaList.add(CinemaListModel.fromJson(i));
          }

      }

    }catch(e){
      print(e);
    }
      return _cinemaList;
  }

  String convertTime(String time){
    String hourString='0', minuteString='0';
    if(time.length==3){
      hourString = time.substring(0,1);
      minuteString = time.substring(1, 3);
    }else if(time.length==4){
      hourString = time.substring(0,2);
      minuteString = time.substring(2, 4);
    }

    int pHour = int.parse(hourString);

    String _time='0';

    if(pHour>12){
      pHour = pHour%12;
      _time = pHour.toString()+':'+minuteString.toString()+' PM';
    }else if(pHour<12){
      _time = pHour.toString()+':'+minuteString.toString()+' AM';
    }else if(pHour==12){
      _time = pHour.toString()+':'+minuteString.toString()+' PM';
    }else if(pHour==24){
      pHour = pHour%12;
      _time = pHour.toString()+':'+minuteString.toString()+' AM';
    }
    return _time;
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar
          (title: const Text('Dashboard')
        ),
      body: Container(
        child:
            FutureBuilder(
            future: getCinema(),
            builder: (context, snapshot) =>

            ListView.builder(
            itemCount: _cinemaList.length,
            itemBuilder: (context, i){
              final cinemaModel = _cinemaList[i];
              return Container(
                child: Card(
                  color: Colors.black87,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Ink.image(image: AssetImage('images/theater.jpg'),
                            height: 240,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child:
                        Align(
                          alignment: Alignment.topLeft,
                          child : Container(
                              child :
                              Text(cinemaModel.name,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 20
                                ),
                              )
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child:
                        Align(
                          alignment: Alignment.topLeft,
                          child : Container(
                            child :
                            Text('Address: '+cinemaModel.address.name,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child:
                        Align(
                          alignment: Alignment.topLeft,
                          child : Container(
                            child :
                                //+cinemaModel.dateTime!.open.toString()
                            Text('Opening Time : '+convertTime(cinemaModel.dateTime.open.toString()),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child:
                        Align(
                          alignment: Alignment.topLeft,
                          child : Container(
                            child :
                            Text('Closing Time : '+convertTime(cinemaModel.dateTime.close.toString()),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child:
                        Align(
                          alignment: Alignment.topLeft,
                          child : Container(
                            child :
                            Text('Distance : '+cinemaModel.distanceBetween.toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      ButtonBar(
                        alignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: Colors.red,
                            ),
                            child: Text('VISIT'),
                            onPressed: () {
                              print("Cinema selected : ");
                              print(cinemaModel.cinemaId);

                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => HomeCinePage(userModel: widget.userModel ,cinemaModel: cinemaModel)));
                            },
                          )
                        ],

                      )
                    ],
                  ),
                ),
              );
      },
        ),
      ),
      ),

    );
  }



 Future<Position> _determinePosition() async{
   bool serviceEnabled;
   LocationPermission permission;

   serviceEnabled = await Geolocator.isLocationServiceEnabled();
   if(!serviceEnabled){
      await Geolocator.openLocationSettings();
     return Future.error('Location services are disabled.');
   }

   permission = await Geolocator.checkPermission();
   if(permission == LocationPermission.denied){
     permission == await Geolocator.requestPermission();
     if(permission == LocationPermission.denied) {

       return Future.error('Location permissions are denied');

     }
   }

   if(permission == LocationPermission.deniedForever) {
     return Future.error('Location permissions are permanently denied, we cannot request permissions.');
   }

   return await Geolocator.getCurrentPosition();

 }



}