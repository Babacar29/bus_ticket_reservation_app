// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:burkina_transport_app/data/repositories/Auth/authRepository.dart';

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

  RegisterCubit(this._authRepository) : super(RegisterInitial());

  void register({required BuildContext context}) {
    emit(RegisterProgress());
    _authRepository
        .register(
      context: context,
    ).then((result) {
      emit(RegisterSuccess());
    }).catchError((e) {
      emit(RegisterFailure(e.toString()));
    });
  }
}
