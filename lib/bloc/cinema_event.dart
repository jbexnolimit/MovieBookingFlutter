part of 'cinema_bloc.dart';

@immutable
abstract class CinemaEvent {}

class OnSelectMovieEvent extends CinemaEvent {
  final String name;
  final String dateTime_start;
  final String dateTime_end;
  final DateTime schedule;
  final String image;
  final int price;



  OnSelectMovieEvent(this.name, this.image, this.dateTime_start, this.dateTime_end, this.schedule, this.price);
}


class OnSelectedSeatsEvent extends CinemaEvent {
  final String selectedSeats;

  OnSelectedSeatsEvent(this.selectedSeats);
}



