// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:burkina_transport_app/cubits/appLocalizationCubit.dart';
import 'package:burkina_transport_app/utils/api.dart';
import 'package:burkina_transport_app/utils/strings.dart';

class NotificationRemoteDataSource {
  Future<dynamic> getNotifications({required String limit, required String offset, required BuildContext context}) async {
    try {
      final body = {LIMIT: limit, OFFSET: offset, LANGUAGE_ID: context.read<AppLocalizationCubit>().state.id};
      final result = await Api.post(body: body, url: Api.getNotificationApi);
      return result;
    } catch (e) {
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }
}
