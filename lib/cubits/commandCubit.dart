// ignore_for_file: file_names

import 'package:burkina_transport_app/utils/hiveBoxKeys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../app/routes.dart';
import '../data/repositories/Command/commandRepository.dart';
import '../ui/widgets/circularProgressIndicator.dart';


@immutable
abstract class CommandState {}

class CommandInitial extends CommandState {}

class CommandProgress extends CommandState {}

class CommandSuccess extends CommandState {
  CommandSuccess();
}

class CommandFailure extends CommandState {
  final String errorMessage;

  CommandFailure(this.errorMessage);
}

class CommandCubit extends Cubit<CommandState> {
  final CommandRepository _commandRepository;

  CommandCubit(this._commandRepository) : super(CommandInitial());

  Future<void> getCommand({required BuildContext context, required String departureId, required Map<String, int> placesCat, required int numberSeats }) async{
    late var result;

    Map<String, dynamic> body = {
        "departureId" : departureId,
        "placeToCategory": placesCat,
        "pasengerNumber": numberSeats

      /*"departureTicket": {
        "departureId" : departureId,
        "placeToCategory": placesCat
      },*/
    };

    try {
      emit(CommandProgress());
      Navigator.of(context).pushNamed(Routes.showUserInfo, arguments: {"commandData": body});
      /*result = await _commandRepository.command(body: body);
      if(result["message"] != null && result["message"] == "Le trajet a expiré"){
        debugPrint("----- here -----");
        showCustomSnackBar(context: context, message: "Le trajet a expiré, veuillez en choisir au autre");
      }
      if(result["id"] != null){
        Navigator.of(context).pushNamed(Routes.showUserInfo, arguments: {"commandData": result});
      }*/
      emit(CommandSuccess());
    }
    catch(e){
      emit(CommandFailure(e.toString()));
    }
    //return result;
  }

  Future<void> sendPassengerData({
    required BuildContext context, required List<dynamic> data,
    required Map<String, dynamic> commandData, bool? willChooseSeat
  }) async{
    //late var result;
    var box = Hive.box(authBoxKey);

    try {
      emit(CommandProgress());
      box.put("passengers", data);
      //result = await _commandRepository.postPassengersData(body: data, commandId: commandData["id"]);
      //debugPrint("send users data result =======>$result");
      if(willChooseSeat == true){
        Navigator.of(context).pushNamed(Routes.chooseSit, arguments: {"from": 1, "commandData": commandData});
      }
      else {
        Navigator.of(context).pushNamed(Routes.startPayment, arguments: {"from": 1, "commandData": commandData});
      }
      emit(CommandSuccess());
    }
    catch(e){
      emit(CommandFailure(e.toString()));
    }
    //return result;
  }

  Future<dynamic> getPlacesRepresentationData() async{
    late var result;
    var box = Hive.box(authBoxKey);

    try {
      emit(CommandProgress());
      String departureId = box.get("departureId");
      result = await _commandRepository.getPlaceRepresentationData(departureId: departureId);
      debugPrint("get Place data result =======>$result");
      emit(CommandSuccess());
      return result["representation"];

    }
    catch(e){
      emit(CommandFailure(e.toString()));
    }
    return result;
  }

  Future<dynamic> sendSeatsData({required List seats, required Map<String, dynamic> commandData, required BuildContext context}) async{
    var result;
    var box = Hive.box(authBoxKey);

    try {
      emit(CommandProgress());
      List passengers = box.get("passengers");

      debugPrint("seats data =======>$seats");
      for (int i = 0; i < passengers.length; i++) {
        passengers[i]["seatNumber"] = seats[i].toString();
      }
      box.put("passengers", passengers);
      //result = await _commandRepository.sendSeatsData(commandId: commandData["departureId"], body: body);
      Navigator.of(context).pushNamed(Routes.startPayment, arguments: {"from": 1, "commandData": commandData});
      /*if(result.statusCode == 200){
        Navigator.of(context).pushNamed(Routes.startPayment, arguments: {"from": 1, "commandData": commandData});
      }*/
      emit(CommandSuccess());
      //return result;
    }
    catch(e){
      emit(CommandFailure(e.toString()));
    }
    return result;
  }

  Future<dynamic> getCategories({required BuildContext context}) async{
    late var result;

    try {
      emit(CommandProgress());
      result = await _commandRepository.getCategories();
      emit(CommandSuccess());
      //return result;
    }
    catch(e){
      emit(CommandFailure(e.toString()));
    }
    return result;
  }

  Future<dynamic> getDocumentTypes() async{
    late var result;

    try {
      emit(CommandProgress());
      result = await _commandRepository.getDocumentTypes();
      emit(CommandSuccess());
    }
    catch(e){
      emit(CommandFailure(e.toString()));
    }
    return result;
  }
}
