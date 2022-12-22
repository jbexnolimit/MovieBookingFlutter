part of 'cinema_bloc.dart';

@immutable
class CinemaState {

  final String nameMovie;
  final String imageMovie;
  final String datetimeStart;
  final String datetimeEnd;
  final DateTime? schedule;
  final int price;
  final List<String> selectedSeats;


  CinemaState({
    this.nameMovie = '',
    this.imageMovie = '',
    this.datetimeStart = '0',
    this.datetimeEnd = '0',
    this.schedule,
    this.price = 0,
    List<String>? selectedSeats
  }) : this.selectedSeats = selectedSeats ?? [];


  CinemaState copyWith({
    String? datetimeStart,
    String? datetimeEnd,
    String? schedule,
    List<String>? selectedSeats,
    String? nameMovie,
    String? imageMovie,
    int? price,
  }) => CinemaState(
      nameMovie: nameMovie ?? this.nameMovie,
      imageMovie: imageMovie ?? this.imageMovie,
      datetimeStart: datetimeStart ?? this.datetimeStart,
      datetimeEnd: datetimeEnd ?? this.datetimeEnd,
      schedule: this.schedule,
      price: price ?? this.price,
      selectedSeats: selectedSeats ?? this.selectedSeats
  );


}

