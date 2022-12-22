
import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:movie_booking_app/pages/details_payment_page.dart';
import '../api/api.dart';
import '../model/cinemaListModel.dart';
import '../model/movieListModel.dart';
import '../model/userModel.dart';
import 'package:http/http.dart' as http;


class PaymentPage extends StatefulWidget {
  final UserModel userModel;
  final CinemaMovieModel movieModel;
  final CinemaListModel cinemaModel;
  final String selectedSeat;

  PaymentPage({Key? key,required this.userModel,required this.movieModel,required this.cinemaModel,required this.selectedSeat}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Stripe.publishableKey = 'pk_test_51Lize7DbhTM8s4NtaeW6xZ1mqM2Oc49oHjJIxroDWyOCgAPOuFr0nHn1u4PF9OueNCeVGFJzxK82LjiZASTT8mip00g3Zk3ioN';
    Stripe.instance.applySettings();
    //final paymentController = Get.put(PaymentController());

    return Scaffold(

      body: Stack(

          children: [
          Container(
          height: size.height,
          width: size.width,
          color: Color(0xff21242C)
             ),
            Positioned(
                top: 60,
                child: Container(
                  width: size.width,
                  child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Row(
                        children: [
                          Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white ),
                          SizedBox(width: 20.0),
                          Text('Payment Integration',
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
                top: 140,
                child: Container(
                  width: size.width,
                  child:
                          Text('Pay using Bank or Credit Card',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.yellow,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                  ),
                )
            ),
                  SizedBox(height: 20.0),
                      Center(
                        child:
                          InkWell(
                            onTap: () async {
                              await makePayment();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 55,
                              width: 300,
                              decoration: BoxDecoration(
                                  color: Colors.teal,
                                  borderRadius: BorderRadius.circular(8.0)
                              ),
                              child: Text('Make Payment',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                      )

       ]
    )
    );
  }


  Map<String, dynamic>? paymentIntentData;

  Future<void> makePayment () async {

    try {
      paymentIntentData = await createPaymentIntent(widget.movieModel.movie.price.toString(), 'PHP');
      if (paymentIntentData != null) {
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(

                paymentIntentClientSecret: paymentIntentData!['client_secret'],
                //googlePay: true,
                //customerId: paymentIntent!['customer'],
                style: ThemeMode.dark,
                merchantDisplayName: 'Prospects')).then((value){
        });
      }

      displayPaymentSheet();



    } catch (e, s) {
      print('exception:$e$s');
    }

  }


  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer sk_test_51Lize7DbhTM8s4NtDpmRR7iPcppW41EG2AYCHLmJjopgdCnUUP85FQVvmEt98rCnpnr59xQd6zOP7D4kfkMDXqKM00ejfzOuph',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      return json.decode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  displayPaymentSheet() async {

    await Stripe.instance.presentPaymentSheet();
    Get.snackbar('Payment', 'Payment Successful',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 2));

    paymentIntentData = null;
    paymentApi(widget.movieModel, widget.cinemaModel, widget.selectedSeat);

  }

  calculateAmount(String amount) {
    final a = (int.parse(amount)) * 100;
    return a.toString();
  }


  paymentApi(CinemaMovieModel movie, CinemaListModel cinema, String selectedSeat) async {


    print("AAAA selected seat : "+selectedSeat);

    print(movie.movie.title);
    log(cinema.name);

    Map body = {
      "cinema": {
        "address": {
          "coordinates": {
            "latitude": cinema.address.coordinates.latitude.toString(),
            "longitude": cinema.address.coordinates.longitude.toString()
          },
          "name": cinema.address.name
        },
        "dateTime": {
          "open": cinema.dateTime.open,
          "close": cinema.dateTime.close
        },
        "cinemaId": cinema.cinemaId,
        "name": cinema.name
      },
      "movie": {
        "_id": movie.movie.id,
        "cinemaId": movie.movie.cinemaId,
        "poster": movie.movie.poster,
        "title": movie.movie.title,
        "price": movie.movie.price,
        "dateTime": {
          "start": movie.movie.dateTime.start,
          "end": movie.movie.dateTime.end,
          "schedule": movie.movie.dateTime.schedule.toIso8601String()
        }
      },
      "customer": {
        "accountId": widget.userModel.user.id,
        "name": widget.userModel.user.account.profile.name,
        "email": widget.userModel.user.email
      }
    };

    String jsonBody = json.encode(body);

    http.Response response = await http.post(Uri.parse(Api.paymentApi),
        headers: {"Content-Type": "application/json"},
        body : jsonBody
    );

    if (response.statusCode == 200) {
      print('Goods na!');
      log(response.body);

      bookApi(selectedSeat);

    }else{
      print('error gg!');
    }

  }

  Future bookApi(String selectedSeat) async {
    http.Response response = await http.put(
        Uri.parse(Api.bookApi),
        body: {
          "_id": widget.movieModel.movie.id,
          "seat": selectedSeat,
          "occupied": 'true',
          "customer": widget.userModel.user.account.profile.name
        }

    );

    if (response.statusCode == 200) {
      log(response.body);
      log('wews \$\$\$');
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DetailsPaymentPage(userModel: widget.userModel, movieModel: widget.movieModel, seat: widget.selectedSeat)));

    }else{
      log(response.statusCode.toString());
      log(response.body);
      log('ngyooork!!');
    }

  }




}
