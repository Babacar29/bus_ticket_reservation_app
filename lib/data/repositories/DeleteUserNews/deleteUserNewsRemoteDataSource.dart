// ignore_for_file: file_names

import 'package:burkina_transport_app/utils/api.dart';
import 'package:burkina_transport_app/utils/strings.dart';

class DeleteUserNewsRemoteDataSource {
  Future deleteUserNews({required String newsId}) async {
    try {
      final body = {
        ID: newsId,
      };
      final result = await Api.post(
        body: body,
        url: Api.setDeleteNewsApi,
      );
      return result;
    } catch (e) {
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }
}
