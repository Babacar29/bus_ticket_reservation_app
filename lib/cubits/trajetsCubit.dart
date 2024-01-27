// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repositories/TrajetsRepositories/TrajetsRepository.dart';


@immutable
abstract class TrajetsState {}

class TrajetsInitial extends TrajetsState {}

class TrajetsProgress extends TrajetsState {}

class TrajetsSuccess extends TrajetsState {
  TrajetsSuccess();
}

class TrajetsFailure extends TrajetsState {
  final String errorMessage;

  TrajetsFailure(this.errorMessage);
}

class TrajetsCubit extends Cubit<TrajetsState> {
  final TrajetsRepository _trajetsRepository;

  TrajetsCubit(this._trajetsRepository) : super(TrajetsInitial());

  //to socialLogin user
  Future<dynamic> getTrajets({required BuildContext context, required String depId, required String arrId, required int placeCount, }) {
    late var result;

    Map<String, dynamic> body = {
      "arrivalCity": arrId,
      "company": "39b6a762-e14c-4595-888d-066beffe4e9c",
      "departureCity": depId,
      "placeCount": placeCount
    };

    try {
      emit(TrajetsProgress());
      result =  _trajetsRepository.getRoutes(context: context, body: body);
      emit(TrajetsSuccess());
    }
    catch(e){
      emit(TrajetsFailure(e.toString()));
    }
    return result;
  }
}
