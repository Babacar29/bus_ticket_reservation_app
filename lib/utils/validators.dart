import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:bus_ticket_reservation_app/utils/uiUtils.dart';

class Validators {
  //name validation check
  static String? nameValidation(String value, BuildContext context) {
    if (value.isEmpty) {
      return UiUtils.getTranslatedLabel(context, 'nameRequired');
    }
    if (value.length <= 1) {
      return UiUtils.getTranslatedLabel(context, 'nameLength');
    }
    return null;
  }

//email validation check
  static String? emailValidation(String value, BuildContext context) {
    if (value.isEmpty) {
      return UiUtils.getTranslatedLabel(context, 'emailRequired');
    } else if (!RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)"
            r"*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+"
            r"[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
        .hasMatch(value)) {
      return UiUtils.getTranslatedLabel(context, 'emailValid');
    } else {
      return null;
    }
  }

//password validation check
  static String? passValidation(String value, BuildContext context) {
    if (value.isEmpty) {
      return UiUtils.getTranslatedLabel(context, 'pwdRequired');
    } else if (value.length <= 5) {
      return UiUtils.getTranslatedLabel(context, 'pwdLength');
    } else {
      return null;
    }
  }

  static String? mobValidation(String value, BuildContext context) {
    if (value.isEmpty) {
      return UiUtils.getTranslatedLabel(context, 'mblRequired');
    }
    if (value.length < 9) {
      return UiUtils.getTranslatedLabel(context, 'mblValid');
    }
    return null;
  }

  static String? titleValidation(String value, BuildContext context) {
    if (value.isEmpty) {
      return UiUtils.getTranslatedLabel(context, 'newsTitleReqLbl');
    } else if (value.length < 2) {
      return UiUtils.getTranslatedLabel(context, 'plzAddValidTitleLbl');
    }
    return null;
  }


  static String? notEmptyValidation(String value, BuildContext context) {
    if (value.isEmpty) {
      return "Ce champ ne peut pas ètre vide";
    }
    return null;
  }

  static String? urlValidation(String value, BuildContext context) {
    bool? test;
    if (value.isEmpty) {
      return UiUtils.getTranslatedLabel(context, 'urlReqLbl');
    } else {
      validUrl(value).then((result) {
        test = result;
        if (test!) {
          return UiUtils.getTranslatedLabel(context, 'plzValidUrlLbl');
        }
      });
    }
    return null;
  }

  static Future<bool> validUrl(String value) async {
    final response = await Dio().head(value);

    if (response.statusCode == 200) {
      return false;
    } else {
      return true;
    }
  }

  static Map<String, String> normalList (){
    return {
      "00": "0",
      "01": "1",
      "02": "2",
      "03": "3",
      "04": "4",
      "05": "5",
      "06": "6",
      "07": "7",
      "08": "8",
      "09": "9",
      "10": "10",
    };
  }


  static Map<String, String> disabledList (){
    return {
      "00": "0",
      "01": "1",
      "02": "2",
      "03": "3",
      "04": "4",
      "05": "5",
      "06": "6",
      "07": "7",
      "08": "8",
      "09": "9",
      "10": "10",
    };
  }


  static Map<String, String> asjbList (){
    return {
      "00": "0",
      "01": "1",
      "02": "2",
      "03": "3",
      "04": "4",
      "05": "5",
      "06": "6",
      "07": "7",
      "08": "8",
      "09": "9",
      "10": "10",
    };
  }


  static Map<String, String> visuallyImpairedList (){
    return {
      "00": "0",
      "01": "1",
      "02": "2",
      "03": "3",
      "04": "4",
      "05": "5",
      "06": "6",
      "07": "7",
      "08": "8",
      "09": "9",
      "10": "10",
    };
  }


  static Map<String, String> retiredList (){
    return {
      "00": "0",
      "01": "1",
      "02": "2",
      "03": "3",
      "04": "4",
      "05": "5",
      "06": "6",
      "07": "7",
      "08": "8",
      "09": "9",
      "10": "10",
    };
  }


  static Map<String, String> childrenList (){
    return {
      "00": "0",
      "01": "1",
      "02": "2",
      "03": "3",
      "04": "4",
      "05": "5",
      "06": "6",
      "07": "7",
      "08": "8",
      "09": "9",
      "10": "10",
    };
  }

  static Map<String, String> studentList (){
    return {
      "00": "0",
      "01": "1",
      "02": "2",
      "03": "3",
      "04": "4",
      "05": "5",
      "06": "6",
      "07": "7",
      "08": "8",
      "09": "9",
      "10": "10",
    };
  }

}
