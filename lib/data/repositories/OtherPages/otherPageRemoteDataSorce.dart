// ignore_for_file: file_names
import 'package:flutter/cupertino.dart';
import 'package:burkina_transport_app/utils/api.dart';
import 'package:burkina_transport_app/utils/strings.dart';

class OtherPageRemoteDataSource {
  Future<dynamic> getOtherPages({required BuildContext context, required String langId}) async {
    try {
      final body = {LANGUAGE_ID: langId};
      final result = await Api.post(body: body, url: Api.getPagesApi);
      return result;
    } catch (e) {
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }
}
