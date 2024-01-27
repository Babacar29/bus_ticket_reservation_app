// ignore_for_file: file_names

import 'package:burkina_transport_app/utils/api.dart';

class SystemRepository {
  Future<dynamic> fetchSettings() async {
    try {
      final result = await Api.postSettings(
        url: Api.getSettingApi,
        body: {},
      );

      return result['data'];
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
