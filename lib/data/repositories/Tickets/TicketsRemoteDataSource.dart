// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:io';

import 'package:bus_ticket_reservation_app/utils/api.dart';

import '../../../utils/constant.dart';

class TicketsRemoteDataSource {


  Future<dynamic> getTickets() async {
    try {
      final result = await Api.get(url: "$base_url${Api.tickets}");
      return result;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } catch (e) {
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }
}
