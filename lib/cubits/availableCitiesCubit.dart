// ignore_for_file: file_names

import 'package:burkina_transport_app/data/repositories/AvailableCities/AvailableCitiesRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


@immutable
abstract class AvailableCitiesState {}

class AvailableCitiesInitial extends AvailableCitiesState {}

class AvailableCitiesProgress extends AvailableCitiesState {}

class AvailableCitiesSuccess extends AvailableCitiesState {
  AvailableCitiesSuccess();
}

class AvailableCitiesFailure extends AvailableCitiesState {
  final String errorMessage;

  AvailableCitiesFailure(this.errorMessage);
}

class AvailableCitiesCubit extends Cubit<AvailableCitiesState> {
  final AvailableCitiesRepository _availableCitiesRepository;

  AvailableCitiesCubit(this._availableCitiesRepository) : super(AvailableCitiesInitial());


  Future<dynamic> getAvailableCities({required BuildContext context}) {
    late Future<dynamic> result;
    try {
      emit(AvailableCitiesProgress());
      result =  _availableCitiesRepository.getCities(context: context);
      emit(AvailableCitiesSuccess());
    }
    catch(e){
      emit(AvailableCitiesFailure(e.toString()));
    }
    return result;
  }

  Future<dynamic> getPassengerCategory({required BuildContext context}) {
    late Future<dynamic> result;
    try {
      emit(AvailableCitiesProgress());
      result =  _availableCitiesRepository.getCategory(context: context);
      emit(AvailableCitiesSuccess());
    }
    catch(e){
      emit(AvailableCitiesFailure(e.toString()));
    }
    return result;
  }
}
