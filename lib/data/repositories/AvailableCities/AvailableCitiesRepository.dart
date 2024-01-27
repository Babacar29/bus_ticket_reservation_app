// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';

import 'AvailableCitiesRemoteDataSource.dart';


class AvailableCitiesRepository {
  static final AvailableCitiesRepository _availableCitiesRepository = AvailableCitiesRepository._internal();
  late AvailableCitiesRemoteDataSource _availableCitiesRemoteDataSource;

  factory AvailableCitiesRepository() {
    _availableCitiesRepository._availableCitiesRemoteDataSource = AvailableCitiesRemoteDataSource();
    return _availableCitiesRepository;
  }

  AvailableCitiesRepository._internal();



  //to update fcmId user's data to database. This will be in use when authenticating using fcmId
  Future<dynamic> getCities({required BuildContext context}) async {
    final result = await _availableCitiesRemoteDataSource.getCities(context: context);
    return result;
  }

  Future<dynamic> getCategory({required BuildContext context}) async {
    final result = await _availableCitiesRemoteDataSource.getCategories(context: context);
    return result;
  }

}
