
import 'dart:developer';

import 'package:http/http.dart';
import 'package:movie_booking_app/model/movieListModel.dart';
import 'dart:convert';

import 'api/api.dart';


class GetMovies{
  final String cinemaId;

  GetMovies({required this.cinemaId});

  List<CinemaMovieModel> _movieList = [];

  Future<List<CinemaMovieModel>> getMovies() async {

    try {
      var response = await get(
        Uri.parse(Api.cinemaMoviesApi+cinemaId),
      );

      if(response.statusCode == 200) {
        final data = json.decode(response.body);

            log(response.body);

            for (Map<String, dynamic> i in data){
              _movieList.add(CinemaMovieModel.fromJson(i));
            }
      }
    }catch (e){
      print(e);
    }

    return _movieList;
  }
}