// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bus_ticket_reservation_app/data/repositories/Auth/authRepository.dart';
import 'package:hive/hive.dart';

import '../../core/services/local_storage/sharedPreferences.dart';
import '../../utils/hiveBoxKeys.dart';

@immutable
abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterProgress extends RegisterState {
  RegisterProgress();
}

class RegisterSuccess extends RegisterState {
  RegisterSuccess();
}

class RegisterFailure extends RegisterState {
  final String errorMessage;

  RegisterFailure(this.errorMessage);
}

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository _authRepository;
  final SharedPreferencesServices services;

  RegisterCubit(this._authRepository, this.services) : super(RegisterInitial());

  void register({required BuildContext context}) {
    var box = Hive.box(authBoxKey);
    emit(RegisterProgress());
    _authRepository.register(context: context,).then((result) {
      box.put(tokenKey, result["api_key"] ?? result["apiKey"]);
      services.setApiKeyInSharedPref(result["apiKey"]);
      services.setTokenKeyInSharedPref(result["api_key"]);
      services.storeApiInSecureStorage(result["apiKey"]);
      services.storeTokenInSecureStorage(result["api_key"]);

      //debugPrint("Register result ============+>${result["api_key"]}");
      emit(RegisterSuccess());
    }).catchError((e) {
      emit(RegisterFailure(e.toString()));
    });
  }
}
