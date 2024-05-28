// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:io';

import 'package:burkina_transport_app/utils/api.dart';

import '../../../utils/constant.dart';


class PaymentRemoteDataSource {


  Future<dynamic> commandDetails({required Map<String, dynamic> body}) async {
    try {
      final result = await Api.normalPost(url: "$base_url/estimations", body: body);
      return result;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } catch (e) {
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }

  Future<dynamic> getAvailablePayments() async {
    try {
      final result = await Api.get(url: "$base_url${Api.availablePayment}");
      return result;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } catch (e) {
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }

  Future<dynamic> payCommand({required String commandId, required Map<String, dynamic> body}) async {
    try {
      final result = await Api.newPost(url: "$base_url/commands", body: body);
      return result;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } catch (e) {
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }

  Future<dynamic> sendOtp({required String commandId, required Map<String, dynamic> body}) async {
    try {
      final result = await Api.newPost(url: "$base_url/commands/$commandId${Api.otp}", body: body);
      return result;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } catch (e) {
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }
}
