// To parse this JSON data, do
//
//     final cinemaListModel = cinemaListModelFromJson(jsonString);

import 'dart:convert';

List<CinemaListModel> cinemaListModelFromJson(String str) => List<CinemaListModel>.from(json.decode(str).map((x) => CinemaListModel.fromJson(x)));

String cinemaListModelToJson(List<CinemaListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CinemaListModel {
  CinemaListModel({
   required this.address,
    required this.dateTime,
    required this.id,
    required this.cinemaId,
    required this.name,
    required this.visibility,
    required this.distanceBetween,
  });

  Address address;
  _DateTime dateTime;
  String id;
  String cinemaId;
  String name;
  bool visibility;
  String distanceBetween;

  factory CinemaListModel.fromJson(Map<String, dynamic> json) => CinemaListModel(
    address: Address.fromJson(json["address"]),
    dateTime: _DateTime.fromJson(json["dateTime"]),
    id: json["_id"],
    cinemaId: json["cinemaId"],
    name: json["name"],
    visibility: json["visibility"],
    distanceBetween: json["distanceBetween"],
  );

  Map<String, dynamic> toJson() => {
    "address": address.toJson(),
    "dateTime": dateTime.toJson(),
    "_id": id,
    "cinemaId": cinemaId,
    "name": name,
    "visibility": visibility,
    "distanceBetween": distanceBetween,
  };
}

class Address {
  Address({
    required this.coordinates,
    required this.name,
  });

  Coordinates coordinates;
  String name;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    coordinates: Coordinates.fromJson(json["coordinates"]),
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "coordinates": coordinates.toJson(),
    "name": name,
  };
}

class Coordinates {
  Coordinates({
    required this.latitude,
    required this.longitude,
  });

  String latitude;
  String longitude;

  factory Coordinates.fromJson(Map<String, dynamic> json) => Coordinates(
    latitude: json["latitude"],
    longitude: json["longitude"],
  );

  Map<String, dynamic> toJson() => {
    "latitude": latitude,
    "longitude": longitude,
  };
}

class _DateTime {
  _DateTime({
    required this.open,
    required this.close,
  });

  int open;
  int close;

  factory _DateTime.fromJson(Map<String, dynamic> json) => _DateTime(
    open: json["open"],
    close: json["close"],
  );

  Map<String, dynamic> toJson() => {
    "open": open,
    "close": close,
  };
}
