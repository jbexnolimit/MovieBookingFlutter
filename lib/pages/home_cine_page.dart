import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie_booking_app/model/cinemaListModel.dart';
import 'package:movie_booking_app/model/userModel.dart';
import '../api/api.dart';
import '../model/movieListModel.dart';
import '../model/coming_soon_model.dart';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'details_movie_page.dart';



class HomeCinePage extends StatelessWidget {
  final UserModel userModel;
  final CinemaListModel cinemaModel;
  HomeCinePage({Key? key, required this.userModel, required this.cinemaModel}) : super(key: key);


  List<CinemaMovieModel> _movieList = [];

  Future getMovies(String _cinemaId) async {

    try{
      var response = await http.get(
        Uri.parse(Api.cinemaMoviesApi+_cinemaId),
      );

      if(response.statusCode == 200) {

        print(cinemaModel.name);
        print(cinemaModel.cinemaId);

        final data = json.decode(response.body);

        log(response.body);

        for (Map<String, dynamic> i in data){
          _movieList.add(CinemaMovieModel.fromJson(i));
        }

      }
    }catch(e){
      print("catch me! : " +e.toString());
    }


    print(_movieList.length);
    return _movieList;
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xff21242C),
      appBar: AppBar(
        backgroundColor: Color(0xff21242C),
        leading: Icon(Icons.menu, color: Colors.white, size: 30),
        elevation: 0,
        actions: [
          Icon(Icons.search, size: 30),
          SizedBox(width: 10.0),
          Icon(Icons.notifications_rounded, size: 30),
          SizedBox(width: 15.0),
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
                image: DecorationImage(
                    fit: BoxFit.contain,
                    image: NetworkImage(userModel.user.account.profile.imageUrl)
                )
            ),
          ),
          SizedBox(width: 15.0),
        ],
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 10.0),
        children: [

          _ItemTitle(title: 'Trailer'),

          SizedBox(height: 20.0),
          Container(
            margin: EdgeInsets.only(left: 20.0),
            height: 200,
            child:
            FutureBuilder(
              future: getMovies(this.cinemaModel.cinemaId.toString()),
              builder: (context, snapshot) =>
                ListView.builder(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: _movieList.length,
                itemBuilder: (context, i)
                => _ItemTrailers(movieModel: _movieList[i])
            ),
          ),
          ),

          SizedBox(height: 20.0),
          _ItemTitle(title: 'Now in Cinemas'),
          Container(
            margin: EdgeInsets.only(left: 20.0),
            height: 280,
            child:

                FutureBuilder(
                  future: getMovies(this.cinemaModel.cinemaId.toString()),
                  builder: (context, snapshot) =>

            ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: _movieList.length,
              itemBuilder: (context, i) => _ItemsNowCinemas(userModel: this.userModel, movieModel: _movieList[i], cinemaModel: this.cinemaModel),
            ),
           ),
          ),

          SizedBox(height: 20.0),
          _ItemTitle(title: 'Coming Soon'),
          Container(
            margin: EdgeInsets.only(left: 20.0),
            height: 280,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, i) => _ItemsSoonMovie(movieModel: ComingSoonMovie.listComingsoon[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemsSoonMovie extends StatelessWidget {

  final ComingSoonMovie movieModel;

  const _ItemsSoonMovie({Key? key, required this.movieModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {  },
      child: Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 210,
              width: 160,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(movieModel.image)
                  )
              ),
            ),
            SizedBox(height: 15.0),
            SizedBox(
              width: 160,
              child: Text(movieModel.name,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12),
              ),
            ),
            SizedBox(height: 5.0),
            RatingBar.builder(
                itemSize: 22,
                initialRating: 5,
                itemBuilder: (_, i) => Icon(Icons.star_rate_rounded, color: Colors.amber ),
                onRatingUpdate: (_){}
            )
          ],
        ),
      ),
    );
  }
}

class _ItemsNowCinemas extends StatelessWidget {
  final UserModel userModel;
  final CinemaMovieModel movieModel;
  final CinemaListModel cinemaModel;

  const _ItemsNowCinemas({Key? key, required this.userModel, required this.movieModel, required this.cinemaModel}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => () {
        print(movieModel.movie.title);
        Navigator.push(context, MaterialPageRoute(builder: (_) => DetailsMoviePage(userModel: userModel,movieModel: movieModel, cinemaModel: cinemaModel)));
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'movie-hero-${movieModel.movie.id}',
              child: Container(
                height: 210,
                width: 160,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(movieModel.movie.poster)
                    )
                ),
              ),
            ),
            SizedBox(height: 15.0),
            SizedBox(
              width: 160,
              child: Text(movieModel.movie.title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12),
              ),
            ),
            SizedBox(height: 5.0),
            RatingBar.builder(
                itemSize: 22,
                initialRating: 4.5,
                itemBuilder: (_, i) => Icon(Icons.star_rate_rounded, color: Colors.amber ),
                onRatingUpdate: (_){}
            )
          ],
        ),
      ),
    );
  }
}

class _ItemTitle extends StatelessWidget {

  final String title;

  const _ItemTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w500),
            ),

          ],
        ),
      ),
    );
  }
}

class _ItemTrailers extends StatelessWidget {

  final CinemaMovieModel movieModel;

  const _ItemTrailers({
    Key? key,
    required this.movieModel
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Stack(
        children: [
          Container(
            width: 300,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(movieModel.movie.poster)
                )
            ),
          ),
          Container(
            width: 300,
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
          )
        ],
      ),
    );
  }
}



