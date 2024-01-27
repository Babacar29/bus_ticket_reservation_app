// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:burkina_transport_app/utils/api.dart';

class AvailableCitiesRemoteDataSource {


  Future<dynamic> getCities({required BuildContext context}) async {
    try {
      final result = await Api.get(url: Api.getCitiesApi);
      return result;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } catch (e) {
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }

  Future<dynamic> getCategories({required BuildContext context}) async {
    try {
      final result = await Api.get(url: "${Api.getPassengerCategoryApi}39b6a762-e14c-4595-888d-066beffe4e9c");
      return result;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } catch (e) {
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }
}
