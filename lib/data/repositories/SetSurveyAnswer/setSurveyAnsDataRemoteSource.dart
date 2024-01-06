// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:burkina_transport_app/utils/api.dart';
import 'package:burkina_transport_app/utils/strings.dart';

class SetSurveyAnsRemoteDataSource {
  Future<dynamic> setSurveyAns({required BuildContext context, required String userId, required String queId, required String optId}) async {
    try {
      final body = {USER_ID: userId, QUESTION_ID: queId, OPTION_ID: optId};
      final result = await Api.post(body: body, url: Api.setQueResultApi);
      return result;
    } catch (e) {
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }
}
