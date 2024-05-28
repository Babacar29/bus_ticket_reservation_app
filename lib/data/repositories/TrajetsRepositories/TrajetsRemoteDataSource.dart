// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:burkina_transport_app/utils/api.dart';

class TrajetsRemoteDataSource {


  Future<dynamic> getRoutes({
    required BuildContext context, required String departureCity,
    required String arrivalCity, required String placeCount, required String date
  }) async {
    try {
      final result = await Api.get(url: "${Api.getRouteApi}?departureCity=$departureCity&arrivalCity=$arrivalCity&placeCount=$placeCount&date=$date");
      return result;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } catch (e) {
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }
}
