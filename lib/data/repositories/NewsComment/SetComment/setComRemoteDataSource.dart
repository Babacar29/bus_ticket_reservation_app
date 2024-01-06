// ignore_for_file: file_names

import 'package:burkina_transport_app/utils/api.dart';
import 'package:burkina_transport_app/utils/strings.dart';

class SetCommentRemoteDataSource {
  Future<dynamic> setComment({required String userId, required String parentId, required String newsId, required String langId, required String message}) async {
    try {
      final body = {USER_ID: userId, PARENT_ID: parentId, NEWS_ID: newsId, MESSAGE: message, LANGUAGE_ID: langId};
      final result = await Api.post(body: body, url: Api.setCommentApi);
      return result;
    } catch (e) {
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }
}
