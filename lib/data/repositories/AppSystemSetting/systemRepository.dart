// ignore_for_file: file_names

import 'package:bus_ticket_reservation_app/utils/api.dart';

class SystemRepository {
  Future<dynamic> fetchSettings() async {
    try {
      /*final result = await Api.postSettings(
        url: Api.getSettingApi,
        body: {},
      );*/
      //debugPrint("config result ======>$result");
      return {};
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
