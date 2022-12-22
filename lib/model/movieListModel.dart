// To parse this JSON data, do
//
//     final cinemaMovieModel = cinemaMovieModelFromJson(jsonString);

import 'dart:convert';

List<CinemaMovieModel> cinemaMovieModelFromJson(String str) => List<CinemaMovieModel>.from(json.decode(str).map((x) => CinemaMovieModel.fromJson(x)));

String cinemaMovieModelToJson(List<CinemaMovieModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CinemaMovieModel {
  CinemaMovieModel({
    required this.movie,
    required this.seats,
  });

  Movie movie;
  Seats seats;

  factory CinemaMovieModel.fromJson(Map<String, dynamic> json) => CinemaMovieModel(
    movie: Movie.fromJson(json["movie"]),
    seats: Seats.fromJson(json["seats"]),
  );

  Map<String, dynamic> toJson() => {
    "movie": movie.toJson(),
    "seats": seats.toJson(),
  };
}

class Movie {
  Movie({
    required this.dateTime,
    required this.id,
    required this.cinemaId,
    required this.cinemaName,
    required this.poster,
    required this.summary,
    required this.title,
    required this.price,
  });

  _DateTime dateTime;
  String id;
  String cinemaId;
  String cinemaName;
  String poster;
  String summary;
  String title;
  int price;

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
    dateTime: _DateTime.fromJson(json["dateTime"]),
    id: json["_id"],
    cinemaId: json["cinemaId"],
    cinemaName: json["cinemaName"],
    poster: json["poster"],
    summary: json["summary"],
    title: json["title"],
    price: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "dateTime": dateTime.toJson(),
    "_id": id,
    "cinemaId": cinemaId,
    "cinemaName": cinemaName,
    "poster": poster,
    "summary": summary,
    "title": title,
    "price": price,
  };
}

class _DateTime {
  _DateTime({
    required this.start,
    required this.end,
    required this.schedule,
  });

  int start;
  int end;
  DateTime schedule;

  factory _DateTime.fromJson(Map<String, dynamic> json) => _DateTime(
    start: json["start"],
    end: json["end"],
    schedule: DateTime.parse(json["schedule"]),
  );

  Map<String, dynamic> toJson() => {
    "start": start,
    "end": end,
    "schedule": schedule.toIso8601String(),
  };
}

class Seats {
  Seats({
    required this.id,
    required this.rows,
    required this.cols,
    required this.seats,
  });

  String id;
  int rows;
  int cols;
  List<Seat> seats;

  factory Seats.fromJson(Map<String, dynamic> json) => Seats(
    id: json["_id"],
    rows: json["rows"],
    cols: json["cols"],
    seats: List<Seat>.from(json["seats"].map((x) => Seat.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "rows": rows,
    "cols": cols,
    "seats": List<dynamic>.from(seats.map((x) => x.toJson())),
  };
}

class Seat {
  Seat({
    required this.seat,
    required this.occupied,
    required this.customer,
  });

  String seat;
  dynamic occupied;
  Customer? customer;

  factory Seat.fromJson(Map<String, dynamic> json) => Seat(
    seat: json["seat"],
    occupied: json["occupied"],
    customer: customerValues.map[json["customer"]],
  );

  Map<String, dynamic> toJson() => {
    "seat": seat,
    "occupied": occupied,
    "customer": customerValues.reverse[customer],
  };
}

enum Customer { NONE }

final customerValues = EnumValues({
  "none": Customer.NONE
});

class EnumValues<T> {
  late Map<String, T> map;
  late Map<T, String> reverseMap;

   EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
