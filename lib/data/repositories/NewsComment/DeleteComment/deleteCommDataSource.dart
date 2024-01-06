// ignore_for_file: file_names

import 'package:burkina_transport_app/utils/api.dart';
import 'package:burkina_transport_app/utils/strings.dart';

class DeleteCommRemoteDataSource {
  Future deleteComm({required String userId, required String commId}) async {
    try {
      final body = {
        USER_ID: userId,
        COMMENT_ID: commId,
      };
      final result = await Api.post(
        body: body,
        url: Api.setCommentDeleteApi,
      );
      return result;
    } catch (e) {
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }
}
