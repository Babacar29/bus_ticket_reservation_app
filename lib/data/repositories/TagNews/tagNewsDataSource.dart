// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:burkina_transport_app/utils/api.dart';
import 'package:burkina_transport_app/utils/strings.dart';

class TagNewsRemoteDataSource {
  Future<dynamic> getTagNews({required BuildContext context, required String tagId, required String userId, required String langId}) async {
    try {
      final body = {TAG_ID: tagId, USER_ID: userId, LANGUAGE_ID: langId};
      final result = await Api.post(body: body, url: Api.getNewsByTagApi);
      return result;
    } catch (e) {
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }
}
