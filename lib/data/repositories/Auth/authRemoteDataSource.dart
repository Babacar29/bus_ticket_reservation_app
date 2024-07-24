// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:burkina_transport_app/utils/api.dart';
import 'package:burkina_transport_app/utils/strings.dart';
import 'package:burkina_transport_app/cubits/Auth/authCubit.dart' as auth;
import 'package:hive/hive.dart';

import '../../../utils/constant.dart';
import '../../../utils/hiveBoxKeys.dart';

class AuthRemoteDataSource {


  Future<dynamic> loginAuth(
      {required BuildContext context, required String firebaseId, required String name, required String email, required String type, required String profile, required String mobile}) async {
    try {
      final body = {FIREBASE_ID: firebaseId, NAME: name, TYPE: type, EMAIL: email};
      if (profile != "") {
        body[PROFILE] = profile;
      }
      if (mobile != "") {
        body[MOBILE] = mobile;
      }
      var result = await Api.post(body: body, url: Api.getUserSignUpApi);
      return result;
    } catch (e) {
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }

  Future<dynamic> deleteUserAcc({required BuildContext context, required String userId}) async {
    try {
      final body = {USER_ID: userId};

      final result = await Api.post(body: body, url: Api.userDeleteApi);

      return result;
    } catch (e) {
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }

  //to update fcmId of user's
  Future<dynamic> updateUserData({
    required String userId,
    String? name,
    String? mobile,
    String? email,
    String? filePath,
  }) async {
    try {
      Map<String, dynamic> body = {USER_ID: userId};
      Map<String, dynamic> result = {};

      if (filePath != null) {
        body[IMAGE] = await MultipartFile.fromFile(filePath);
        result = await Api.post(body: body, url: Api.setProfileApi);
      } else {
        if (name != null) {
          body[NAME] = name;
        }
        if (mobile != null) {
          body[MOBILE] = mobile;
        }
        if (email != null) {
          body[EMAIL] = email;
        }
        result = await Api.post(body: body, url: Api.setUpdateProfileApi);
      }
      return result;
    } catch (e) {
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }

  //to update fcmId of user's
  Future<dynamic> updateFcmId({required String userId, required String fcmId, required BuildContext context}) async {
    try {
      //body of post request
      final body = {USER_ID: userId, FCM_ID: fcmId};
      final result = await Api.post(body: body, url: Api.updateFCMIdApi);

      return result;
    } catch (e) {
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }

  static String getRandomString(int length) {
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }


  Future<dynamic> register({required BuildContext context}) async {
    String platform = Platform.isAndroid ? "Android" : "iOS";
    try {
      final body = {"login": "$platform-${getRandomString(30)}"};
      final result = await Api.registerPost(body: body, url: Api.registerApi,);
      debugPrint("Register response =========> $result");
      return result;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } catch (e) {
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }

  Future<dynamic> signInUser({required BuildContext context}) async {
    var box = Hive.box(authBoxKey);

    try {
      final body = {"login": "ankatasengt1", "password": "m4WrMCAPK4bkgeqF"};
      final result = await Api.newPost(body: body, url: Api.signInApi, isAuth: true);
      debugPrint("result status code ======>$result");
      box.put(tokenKey, result["token"]);
      return result;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } catch (e) {
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }


  Future<void> signOut(auth.AuthProvider? authProvider) async {
    if (authProvider == auth.AuthProvider.gmail) {
      //_googleSignIn.signOut();
    } else if (authProvider == auth.AuthProvider.fb) {
      //_facebookSignin.logOut();
    } else {
      //_firebaseAuth.signOut();
    }
  }

  Future<dynamic> sendApnToken({required String token}) async {
    try {
      //body of post request
      final body = {
        "token" : token
      };
      final result = await Api.normalPost(body: body, url: "$base_url/pushTokens");

      return result;
    } catch (e) {
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }
}
