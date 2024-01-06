// ignore_for_file: file_names

import 'package:burkina_transport_app/utils/api.dart';
import 'package:burkina_transport_app/utils/strings.dart';

class DeleteUserNotiRemoteDataSource {
  Future deleteUserNoti({required String id}) async {
    try {
      final body = {
        ID: id,
      };
      final result = await Api.post(
        body: body,
        url: Api.deleteUserNotiApi,
      );
      return result;
    } catch (e) {
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }
}
