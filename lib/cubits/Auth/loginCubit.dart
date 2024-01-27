// ignore_for_file: file_names

import 'package:burkina_transport_app/utils/hiveBoxKeys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../../data/repositories/Auth/authRepository.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginProgress extends LoginState {}

class LoginSuccess extends LoginState {
  LoginSuccess();
}

class LoginFailure extends LoginState {
  final String errorMessage;

  LoginFailure(this.errorMessage);
}

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit(this._authRepository) : super(LoginInitial());

  //to socialLogin user
  void loginUser({required BuildContext context}) {
    emit(LoginProgress());
    var box = Hive.box(authBoxKey);
    _authRepository.signInUser(context: context).then((result) {
      box.put(tokenKey, result["token"]);
      emit(LoginSuccess());
    }).catchError((e) {
      emit(LoginFailure(e.toString()));
    });
  }
}
