// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/routes.dart';
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

  Future<dynamic> getCommandDetails({required String commandId }) async{
    late var result;

    try {
      emit(PaymentProgress());
      result = await _paymentRepository.commandDetails(commandId: commandId);
      emit(PaymentSuccess());
      return result;
    }
    catch(e){
      emit(PaymentFailure(e.toString()));
    }
    return result;
  }

  Future<dynamic> payCommand({required String commandId, required String value, required BuildContext context }) async{
    late var result;
    Map<String, dynamic> body = {
      "otp": value
    };

    try {
      emit(PaymentProgress());
      result = await _paymentRepository.payCommand(commandId: commandId, body: body);
      if(result == "success"){
        debugPrint("pay result ========> $result");
        Navigator.of(context).pushNamed(Routes.tickets, arguments: {"from": 0});
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


  Future<dynamic> sendOtp({required Map<String, dynamic> command, required BuildContext context, String? paymentMethod, String? phoneNumber, required bool canCall }) async{
    late var result;
    Map<String, dynamic> body = {
      "paymentMethod": paymentMethod,
      "paymentNumber": phoneNumber
    };


    try {
      emit(PaymentProgress());
      result = await _paymentRepository.sentOtp(commandId: command["id"], body: body);
      if(result["transactionCode"] != null){
        debugPrint("transaction code is ======>${result["transactionCode"]}");
        if(canCall){
          return result;
        }
        else{
          Navigator.of(context).pushNamed(Routes.otp, arguments: {"from": 1, "commandData": command, "otpData": result});
        }
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
