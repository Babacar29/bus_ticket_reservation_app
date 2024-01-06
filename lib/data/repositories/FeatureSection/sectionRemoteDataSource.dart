// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:burkina_transport_app/utils/api.dart';
import 'package:burkina_transport_app/utils/strings.dart';

class SectionRemoteDataSource {
  Future<dynamic> getSections({
    required String langId,
    required BuildContext context,
    required String userId,
  }) async {
    try {
      final body = {LANGUAGE_ID: langId, USER_ID: userId};
      final result = await Api.post(body: body, url: Api.getFeatureSectionApi);
      return result;
    } catch (e) {
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }
}
