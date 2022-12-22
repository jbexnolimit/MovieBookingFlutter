import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:movie_booking_app/bloc/cinema_bloc.dart';
import 'package:movie_booking_app/model/movieListModel.dart';
import 'package:movie_booking_app/model/userModel.dart';
import 'package:movie_booking_app/pages/payment_page.dart';
import '../Helpers/paint_chair.dart';
import '../Helpers/painter.dart';
import '../model/cinemaListModel.dart';
import 'package:http/http.dart' as http;


class BuyTicketPage extends StatelessWidget {
  final UserModel userModel;
  final CinemaMovieModel movieModel;
  final CinemaListModel cinemaModel;


  const BuyTicketPage({
    Key? key,
    required this.userModel,
    required this.movieModel,
    required this.cinemaModel,
  }) : super(key: key);


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
    // Stripe.publishableKey = 'pk_test_51Lize7DbhTM8s4NtaeW6xZ1mqM2Oc49oHjJIxroDWyOCgAPOuFr0nHn1u4PF9OueNCeVGFJzxK82LjiZASTT8mip00g3Zk3ioN';
    final size = MediaQuery.of(context).size;
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");

    return Scaffold(
      body:  BlocProvider(
        create : (_) => CinemaBloc(),
    child : Builder(
        builder: (context) {
          return
      Stack(
        children: [

          Container(
              height: size.height,
              width: size.width,
              color: Color(0xff21242C)
          ),

          Container(
            height: size.height * .7,
            width: size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(movieModel.movie.poster)
                )
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomRight,
                    colors: [
                      Color(0xff21242C),
                      Color(0xff21242C).withOpacity(.9),
                      Color(0xff21242C).withOpacity(.1),
                    ]
                ),
              ),
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 20.0,
                    sigmaY: 20.0,
                  ),
                  child: Container(
                    color: Color(0xff21242C).withOpacity(0.1),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
              top: 30,
              child: Container(
                width: size.width,
                child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Row(
                      children: [
                        Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white ),
                        SizedBox(width: 10.0),
                        Text(movieModel.movie.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                ),
              )
          ),

          Positioned(
              top: 100,
              child: Container(
                child: Column(
                  children: [

                    Container(
                      padding: EdgeInsets.only(left: 20.0),
                      height: 20,
                      width: size.width,
                      child: Text('Schedule : '+dateFormat.format(movieModel.movie.dateTime.schedule),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20.0),
                      height: 20,
                      width: size.width,
                      child: Text(convertTime(movieModel.movie.dateTime.start.toString()) + ' - '+convertTime(movieModel.movie.dateTime.end.toString()),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize:12,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),

                    SizedBox(height: 10.0),
                    PainterScreenMovie(),

                    Text('Screen',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    //TextFrave(text: 'Screen', color: Colors.white, fontWeight: FontWeight.w500),

                    SizedBox(height: 10.0),

                    Container(
                        height: 400,
                        width: size.width,
                        child:
                            Center(
                              child:
                                GridView.count(
                                crossAxisCount: movieModel.seats.rows,
                                children:
                                List.generate(movieModel.seats.seats.length, (i) {

                                  if (movieModel.seats.seats[i].occupied == false) {

                                    return
                                      InkWell(
                                        onTap: () => BlocProvider.of<CinemaBloc>(context).add(
                                                OnSelectedSeatsEvent(movieModel.seats.seats[i].seat)),
                                        child: BlocBuilder<CinemaBloc, CinemaState>(
                                            builder: (_, state) =>
                                                PaintChair(
                                                    color: state.selectedSeats.contains(movieModel.seats.seats[i].seat) ? Colors.amber : Colors
                                                        .white
                                                )
                                        )
                                    );
                                  }

                                  return PaintChair();

                                }
                                ),

                            )
                            )


                        ),
                    SizedBox(height: 10.0),
                    _ItemsDescription(size: size)
                  ],
                ),
              )
          ),

          Positioned(
            left: 60,
            right: 60,
            bottom: 20,
            child: InkWell(
              onTap: () async {
                //print(BlocProvider.of<CinemaBloc>(context).state.selectedSeats[0]);
                //final seat = BlocProvider.of<CinemaBloc>(context).state.selectedSeats[0];

                // final paymentController = Get.put(PaymentController(userModel,movieModel, cinemaModel,BlocProvider.of<CinemaBloc>(context).state.selectedSeats[0]));
                // await paymentController.makePayment();
                String seat = BlocProvider.of<CinemaBloc>(context).state.selectedSeats[0];
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PaymentPage(userModel: userModel, movieModel: movieModel, cinemaModel: cinemaModel, selectedSeat: seat)));
              },

              child: Container(
                alignment: Alignment.center,
                height: 55,
                decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(8.0)
                ),
                child: Text('BOOK TICKET',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
          ),

        ],
      );
        }
    )
      )
    );
  }
}


class _ItemsDescription extends StatelessWidget {
  const _ItemsDescription({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              Icon(Icons.circle, color: Colors.white, size: 10),
              SizedBox(width: 10.0),
              Text('Vacant',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.circle, color: Color(0xff4A5660), size: 10),
              SizedBox(width: 10.0),
              Text('Reserved',
                style: TextStyle(
                  color: Color(0xff4A5660),
                  fontSize: 20,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.circle, color: Colors.amber, size: 10),
              SizedBox(width: 10.0),
              Text('Selected',
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ],
      ),


    );
  }

}




