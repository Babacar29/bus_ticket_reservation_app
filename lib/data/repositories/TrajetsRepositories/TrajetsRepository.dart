// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';

import 'TrajetsRemoteDataSource.dart';



class TrajetsRepository {
  static final TrajetsRepository _trajetsRepository = TrajetsRepository._internal();
  late TrajetsRemoteDataSource _trajetsRemoteDataSource;

  factory TrajetsRepository() {
    _trajetsRepository._trajetsRemoteDataSource = TrajetsRemoteDataSource();
    return _trajetsRepository;
  }

  TrajetsRepository._internal();



  //to update fcmId user's data to database. This will be in use when authenticating using fcmId
  Future<dynamic> getRoutes({required BuildContext context, required String departureCity,
    required String arrivalCity, required String placeCount, required String date}) async {
    final result = await _trajetsRemoteDataSource.getRoutes(context: context, departureCity: departureCity, arrivalCity: arrivalCity, placeCount: placeCount, date: date);
    return result;
  }

}
