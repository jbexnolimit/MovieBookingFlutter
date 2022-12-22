import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:movie_booking_app/bloc/cinema_bloc.dart';
import 'package:movie_booking_app/model/cinemaListModel.dart';
import 'package:movie_booking_app/model/userModel.dart';
import '../model/movieListModel.dart';
import 'buy_ticket_page.dart';


class DetailsMoviePage extends StatelessWidget {
  final UserModel userModel;
  final CinemaMovieModel movieModel;
  final CinemaListModel cinemaModel;

  const DetailsMoviePage({Key? key,required this.userModel, required this.movieModel, required this.cinemaModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    // final cinemaBloc = BlocProvider.of<CinemaBloc>(context);


    return Scaffold(
        body:

        BlocProvider(
            create : (_) => CinemaBloc(),
            child : Builder(
                builder: (context) {
                  return Stack(
                    children: [

                      Container(
                          height: size.height,
                          width: size.width,
                          color: Color(0xff21242C)
                      ),

                      Container(
                        height: size.height * .6,
                        width: size.width,
                        child: Hero(
                            tag: 'movie-hero-${movieModel.movie.id}',
                            child: Container(
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
                                        Color(0xff21242C).withOpacity(.8),
                                        Color(0xff21242C).withOpacity(.1),
                                      ]
                                  ),
                                ),
                              ),
                            )
                        ),
                      ),

                      Positioned(
                        top: 250,
                        child: Column(
                          children: [
                            Container(
                              height: 80,
                              width: size.width,
                              child: Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50.0),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 10.0,
                                        sigmaY: 10.0,
                                      ),
                                      child: Container(
                                          padding: EdgeInsets.all(15),
                                          color: Colors.white.withOpacity(0.3),
                                          child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 45)
                                      ),
                                    ),
                                  )
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Text(movieModel.movie.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:25,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 15.0),
                            RatingBar.builder(
                                itemSize: 30,
                                initialRating: 5.0,
                                itemBuilder: (_, i) => Icon(Icons.star_rate_rounded, color: Colors.amber ),
                                onRatingUpdate: (_){}
                            ),
                            SizedBox(height: 25.0),
                            Text('Storyline',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25),
                            ),
                            SizedBox(height: 15.0),
                            Container(
                              width: size.width * .9,
                              child: Wrap(
                                children: [
                                  Text(movieModel.movie.summary,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 6,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      Positioned(
                          top: 30,
                          child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white )
                          )
                      ),

                      Positioned(
                        left: 60,
                        right: 60,
                        bottom: 30,
                        child:
                        InkWell(
                          onTap: (){
                            // ADD TO BLOC
                            final cinemaBloc = BlocProvider.of<CinemaBloc>(context);
                            cinemaBloc.add( OnSelectMovieEvent( movieModel.movie.title , movieModel.movie.poster, movieModel.movie.dateTime.start.toString(), movieModel.movie.dateTime.end.toString(), movieModel.movie.dateTime.schedule, movieModel.movie.price) );
                            Navigator.push(context, MaterialPageRoute(builder: (_) => BuyTicketPage(
                                userModel: userModel,
                                movieModel: movieModel,
                                cinemaModel: cinemaModel,
                            )));
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 60,
                            decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(8.0)
                            ),
                            child: Text('Buy Ticket',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold),
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