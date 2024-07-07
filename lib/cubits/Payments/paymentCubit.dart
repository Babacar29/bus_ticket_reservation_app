// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../../app/routes.dart';
import '../../data/repositories/Payments/PaymentsRepository.dart';
import '../../utils/hiveBoxKeys.dart';



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
  var box = Hive.box(authBoxKey);

  Future<dynamic> getCommandDetails({required String commandId }) async{
    late var result;
    var cat = box.get("categories");
    Map<String, dynamic> body = {
      "departureIds": [commandId],
      "placeToCategory": cat
    };

    try {
      emit(PaymentProgress());
      result = await _paymentRepository.commandDetails(body: body);
      emit(PaymentSuccess());
      return result;
    }
    catch(e){
      emit(PaymentFailure(e.toString()));
    }
    return result;
  }

  Future<dynamic> payCommand({required Map<String, dynamic> command, required BuildContext context,
    required String paymentMethod, required String phoneNumber }) async{
    late var result;
    var cat = box.get("categories");
    var passengers = box.get("passengers");
    debugPrint("command data ===========>$command");

    Map<String, dynamic> body = {
      "departures": [command["departureId"]],
      "placeToCategory": cat,
      "passengers": passengers,
      "payment": {
        "paymentNumber": phoneNumber,
        "paymentMethod": paymentMethod
      }
    };

    try {
      emit(PaymentProgress());
      result = await _paymentRepository.payCommand(commandId: command["departureId"], body: body);
      debugPrint("pay result ========> $result");
      if(result["commandId"] != null){
        Navigator.of(context).pushNamed(Routes.otp, arguments: {"from": 1, "commandData": command, "otpData": result});
      }
      emit(PaymentSuccess());
      return result;
    }
    catch(e){
      emit(PaymentFailure(e.toString()));
    }
    return result;
  }

  Future<dynamic> getAvailablePayments() async{
    late var result;

    try {
      emit(PaymentProgress());
      result = await _paymentRepository.getAvailablePayments();
      emit(PaymentSuccess());
      return result;
    }
    catch(e){
      emit(PaymentFailure(e.toString()));
    }
    return result;
  }


  Future<dynamic> sendOtp({required String commandId, required BuildContext context, required String otp, required bool canCall }) async{
    late var result;
    Map<String, dynamic> body = {
      "otp": otp
    };


    try {
      emit(PaymentProgress());
      result = await _paymentRepository.sentOtp(commandId: commandId, body: body);
      debugPrint("send otp response ======>$result");
      if(result == "success"){
        Navigator.of(context).pushReplacementNamed(Routes.tickets, arguments: {"from": 0});
        /*if(canCall){
          return result;
        }
        else{
          Navigator.of(context).pushNamed(Routes.tickets, arguments: {"from": 1});
        }*/
      }
      emit(PaymentSuccess());
      return result;
    }
    catch(e){
      emit(PaymentFailure(e.toString()));
    }
    return result;
  }
}
