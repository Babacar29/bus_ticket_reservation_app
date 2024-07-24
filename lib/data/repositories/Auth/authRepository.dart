// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';

import '../../../cubits/Auth/authCubit.dart';
import '../../../utils/strings.dart';
import 'authLocalDataSource.dart';
import 'authRemoteDataSource.dart';

class AuthRepository {
  static final AuthRepository _authRepository = AuthRepository._internal();
  late AuthLocalDataSource _authLocalDataSource;
  late AuthRemoteDataSource _authRemoteDataSource;

  factory AuthRepository() {
    _authRepository._authLocalDataSource = AuthLocalDataSource();
    _authRepository._authRemoteDataSource = AuthRemoteDataSource();
    return _authRepository;
  }

  AuthRepository._internal();

  AuthLocalDataSource get authLocalDataSource => _authLocalDataSource;

  //to get auth detials stored in hive box
  getLocalAuthDetails() {
    return {
      "isLogIn": _authLocalDataSource.checkIsAuth(),
      ID: _authLocalDataSource.getId(),
      NAME: _authLocalDataSource.getName(),
      EMAIL: _authLocalDataSource.getEmail(),
      MOBILE: _authLocalDataSource.getMobile(),
      TYPE: _authLocalDataSource.getType(),
      PROFILE: _authLocalDataSource.getProfile(),
      STATUS: _authLocalDataSource.getStatus(),
      ROLE: _authLocalDataSource.getRole(),
    };
  }

  setLocalAuthDetails(
      {required bool authStatus,
      required String id,
      required String name,
      required String email,
      required String mobile,
      required String type,
      required String profile,
      required String status,
      required String role}) {
    _authLocalDataSource.changeAuthStatus(authStatus);
    _authLocalDataSource.setId(id);
    _authLocalDataSource.setName(name);
    _authLocalDataSource.setEmail(email);
    _authLocalDataSource.setMobile(mobile);
    _authLocalDataSource.setType(type);
    _authLocalDataSource.setProfile(profile);
    _authLocalDataSource.setStatus(status);
    _authLocalDataSource.setRole(role);
  }

  //First we signin user with given provider then add user details
  Future signInUser({required BuildContext context}) async {
    final result = await _authRemoteDataSource.signInUser( context: context);
    return result;
  }

  //to update fcmId user's data to database. This will be in use when authenticating using fcmId
  Future<Map<String, dynamic>> updateFcmId({required String userId, required String fcmId, required BuildContext context}) async {
    final result = await _authRemoteDataSource.updateFcmId(userId: userId, fcmId: fcmId, context: context);
    return result;
  }

  Future<dynamic> updateUserData({required String userId, String? name, String? mobile, String? email, String? filePath, required BuildContext context}) async {
    final result = await _authRemoteDataSource.updateUserData(userId: userId, email: email, name: name, mobile: mobile, filePath: filePath);
    if (name != null) {
      _authLocalDataSource.setName(name);
    }
    if (mobile != null) {
      _authLocalDataSource.setMobile(mobile);
    }
    if (email != null) {
      _authLocalDataSource.setEmail(email);
    }
    if (filePath != null) {
      _authLocalDataSource.setProfile(result['file_path']);
    }

    return result;
  }

  Future<Map<String, dynamic>> register({required BuildContext context}) async {
    final result = await _authRemoteDataSource.register(context: context);
    return result;
  }

  //to delete my account
  Future<dynamic> deleteUser({required BuildContext context, required String userId}) async {
    final result = await _authRemoteDataSource.deleteUserAcc(userId: userId, context: context);
    return result;
  }

  Future<void> signOut(AuthProvider authProvider) async {
    _authRemoteDataSource.signOut(authProvider);
    await _authLocalDataSource.changeAuthStatus(false);
    await _authLocalDataSource.setId("0");
    await _authLocalDataSource.setName("");
    await _authLocalDataSource.setEmail("");
    await _authLocalDataSource.setMobile("");
    await _authLocalDataSource.setType("");
    await _authLocalDataSource.setProfile("");
    await _authLocalDataSource.setRole("");
    await _authLocalDataSource.setStatus("");
  }

  Future<Map<String, dynamic>> sendApnToken({required String token }) async {
    final result = await _authRemoteDataSource.sendApnToken(token: token);
    return result;
  }
}
