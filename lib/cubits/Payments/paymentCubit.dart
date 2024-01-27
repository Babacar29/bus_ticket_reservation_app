// ignore_for_file: file_names

import 'package:burkina_transport_app/utils/hiveBoxKeys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../../data/repositories/Payments/PaymentsRepository.dart';



@immutable
abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentProgress extends PaymentState {}

class PaymentSuccess extends PaymentState {
  PaymentSuccess();
}

class PaymentFailure extends PaymentState {
  final String errorMessage;

  PaymentFailure(this.errorMessage);
}

class PaymentCubit extends Cubit<PaymentState> {
  final PaymentRepository _paymentRepository;

  PaymentCubit(this._paymentRepository) : super(PaymentInitial());

  /*Future<dynamic> getCommand({required BuildContext context, required String departureId, required Map<String, int> placesCat }) async{
    late var result;

    Map<String, dynamic> body = {
      "departureTicket": {
        "departureId" : departureId,
        "placeToCategory": placesCat
      },
    };

    try {
      emit(PaymentProgress());
      result = await _commandRepository.command(body: body);
      if(result["message"] != null && result["message"] == "Le trajet a expiré"){
        debugPrint("----- here -----");
        showCustomSnackBar(context: context, message: "Le trajet a expiré, veuillez en choisir au autre");
      }
      if(result["id"] != null){
        Navigator.of(context).pushNamed(Routes.showUserInfo, arguments: {"commandData": result});
      }
      emit(PaymentSuccess());
    }
    catch(e){
      emit(PaymentFailure(e.toString()));
    }
    return result;
  }*/
  
}
