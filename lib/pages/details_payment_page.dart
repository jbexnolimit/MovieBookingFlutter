import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movie_booking_app/model/userModel.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../model/movieListModel.dart';

class DetailsPaymentPage extends StatelessWidget {
    final UserModel userModel;
    final CinemaMovieModel movieModel;
    final String seat;

    const DetailsPaymentPage({Key? key,required this.userModel, required this.movieModel, required this.seat}) : super(key: key);


  String convertTime(String time){
    String hourString='0', minuteString='0';
    if(time.length==3){
      hourString = time.substring(0,1);
      minuteString = time.substring(1, 3);
    }else if(time.length==4){
      hourString = time.substring(0,2);
      minuteString = time.substring(2, 4);
    }

    int pHourString = int.parse(hourString);

    String _time='0';

    if(pHourString>12){
      pHourString = pHourString%12;
       _time = pHourString.toString()+':'+minuteString.toString()+' PM';
    }else if(pHourString<12){
      _time = pHourString.toString()+':'+minuteString.toString()+' AM';
    }else if(pHourString==12){
      _time = pHourString.toString()+':'+minuteString.toString()+' PM';
    }
    return _time;
  }


  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");

    return Scaffold(
      backgroundColor: Color(0xff21242C),
      body:
      SafeArea(
        child: Stack(
          children: [

            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Container(
                height: size.height,
                width: size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  children: [

                    Container(
                      height: size.height * .45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(movieModel.movie.poster)
                          )
                      ),
                    ),

                    SizedBox(height: 20.0),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                            Text('DATE',
                            style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16
                             )
                            ),
                              Text(dateFormat.format(movieModel.movie.dateTime.schedule))
                            ],
                          ),
                          Column(
                            children: [
                              Text('TICKETS',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16
                                  )
                              ),
                              Text('1')
                            ],
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text('TIME',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16
                                  )
                              ),
                              Text(convertTime(movieModel.movie.dateTime.start.toString()) + ' - '+convertTime(movieModel.movie.dateTime.end.toString()))
                            ],
                          ),
                          Column(
                            children: [
                              Text('SEATS',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16
                                  )
                              ),
                             Text(seat)
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(31, (index) => Text('- ',
                          style: TextStyle(
                            color: Colors.grey,
                          )
                      )),
                    ),
                    SizedBox(height: 10.0),
                    SizedBox(
                      height: 120,
                      width: 120,
                      child: QrImage(
                        data: userModel.user.account.profile.name+"\n"+
                            movieModel.movie.title+"\n"+
                            seat+"\n"+
                            dateFormat.format(movieModel.movie.dateTime.schedule),
                        version: QrVersions.auto,
                        size: 120,
                      ),
                    )

                  ],
                ),
              ),
            ),

            Positioned(
                top: size.height * .695,
                left: 15,
                child: Icon(Icons.circle, color: Color(0xff21242C))
            ),

            Positioned(
                top: size.height * .695,
                right: 15,
                child: Icon(Icons.circle, color: Color(0xff21242C))
            ),

          ],
        ),
        ),
      );
  }
}