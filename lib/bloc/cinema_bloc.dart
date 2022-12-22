
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'cinema_event.dart';
part 'cinema_state.dart';

class CinemaBloc extends Bloc<CinemaEvent, CinemaState> {

  CinemaBloc() : super( CinemaState()) {


    on<OnSelectedSeatsEvent>( _onSelectedSeats );
    on<OnSelectMovieEvent>( _onSelectedMovie );

  }

  List<String> seats = [];



  Future<void> _onSelectedSeats( OnSelectedSeatsEvent event, Emitter<CinemaState> emit) async {

    if( seats.contains( event.selectedSeats ) ){

      seats.remove( event.selectedSeats );
      emit( state.copyWith( selectedSeats: seats ) );

    }else {
      if(seats.isEmpty)
      seats.add( event.selectedSeats );
      seats[0] = (event.selectedSeats);
      emit( state.copyWith( selectedSeats: seats ) );

    }



  }

  Future<void> _onSelectedMovie( OnSelectMovieEvent event, Emitter<CinemaState> emit ) async {

    emit( state.copyWith( nameMovie: event.name, imageMovie: event.image, datetimeStart: event.dateTime_start, datetimeEnd: event.dateTime_end, schedule: event.schedule.toIso8601String(), price: event.price ) );

  }


}
