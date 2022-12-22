import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Bloc/cinema_bloc.dart';
import '../Helpers/paint_chair.dart';
import '../model/movieListModel.dart';

class SeatsRow extends StatelessWidget {
  final String seat;
  final bool isOccupied;
  final String customer;

  const SeatsRow({Key? key,
    required this.seat,
    required this.isOccupied,
    required this.customer,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {

    final cinemaBloc = BlocProvider.of<CinemaBloc>(context);


    return Center(
      child:
      Row(
        mainAxisSize: MainAxisSize.min,
        children:

          List.generate(seat.length, (i) {

              if (isOccupied == false) {

                return InkWell(
                    onTap: () =>
                        cinemaBloc.add(
                            OnSelectedSeatsEvent(seat[i])),
                    child: BlocBuilder<CinemaBloc, CinemaState>(
                        builder: (_, state) =>
                            PaintChair(
                                color: state.selectedSeats.contains(seat
                                    [i]) ? Colors.amber : Colors
                                    .white
                            )
                    )
                );
              }

          return PaintChair();

        }),
      ),
    );
  }
}