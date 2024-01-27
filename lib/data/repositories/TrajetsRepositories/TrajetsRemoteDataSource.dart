// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:burkina_transport_app/utils/api.dart';

class TrajetsRemoteDataSource {


  Future<dynamic> getRoutes({required BuildContext context, required Map<String, dynamic> body}) async {
    try {
      final result = await Api.newPost(url: Api.getRouteApi, body: body);
      return result;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } catch (e) {
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }
}
