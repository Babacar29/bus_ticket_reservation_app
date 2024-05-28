// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:io';

import 'package:burkina_transport_app/utils/api.dart';

import '../../../utils/constant.dart';

class CommandRemoteDataSource {


  Future<dynamic> command({required Map<String, dynamic> body}) async {
    try {
      final result = await Api.newPost(url: Api.commandApi, body: body);
      return result;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } catch (e) {
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }

  Future<dynamic> postPassengersData({required List<dynamic> body, required String commandId}) async {
    try {
      final result = await Api.listPost(url: "$base_url/commands/$commandId${Api.passengerApi}", body: body);
      return result;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } catch (e) {
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }

  Future<dynamic> getPlacesRepresentation({required String departureId}) async {
    try {
      final result = await Api.get(url: "$base_url/departures/$departureId${Api.placeRepresentation}");
      return result;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } catch (e) {
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }

  Future<dynamic> sendSeatsData({required String commandId, required Map<String, dynamic> body}) async {
    try {
      final result = await Api.normalPost(url: "$base_url/commands/$commandId${Api.seatsApi}", body: body);
      return result;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } catch (e) {
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }

  Future<dynamic> getCategories() async {
    try {
      final result = await Api.get(url: "$base_url/passengerCategories");
      return result;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } catch (e) {
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }

  Future<dynamic> getDocumentTypes() async {
    try {
      final result = await Api.get(url: "$base_url/identifications/documents");
      return result;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } catch (e) {
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }
}
