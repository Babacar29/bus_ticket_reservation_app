// ignore_for_file: file_names

import 'package:burkina_transport_app/utils/api.dart';
import 'package:burkina_transport_app/utils/strings.dart';

class SetFlagRemoteDataSource {
  Future<dynamic> setFlag({required String userId, required String commId, required String newsId, required String message}) async {
    try {
      final body = {USER_ID: userId, COMMENT_ID: commId, NEWS_ID: newsId, MESSAGE: message};
      final result = await Api.post(body: body, url: Api.setFlagApi);
      return result;
    } catch (e) {
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }
}
