// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:burkina_transport_app/app/routes.dart';
import 'package:burkina_transport_app/cubits/Auth/authCubit.dart';
import 'package:burkina_transport_app/cubits/languageJsonCubit.dart';
import 'package:burkina_transport_app/ui/styles/colors.dart';
import 'package:burkina_transport_app/utils/labelKeys.dart';
import 'package:burkina_transport_app/ui/styles/appTheme.dart';

class UiUtils {
  static GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

  //used for IntroSlider Images only
  static String getImagePath(String imageName) {
    return "assets/images/$imageName";
  }

  static String getSvgImagePath(String imageName) {
    return "assets/images/svgImage/$imageName.svg";
  }

  static ColorScheme getColorScheme(BuildContext context) {
    return Theme.of(context).colorScheme;
  }

// get app theme
  static String getThemeLabelFromAppTheme(AppTheme appTheme) {
    if (appTheme == AppTheme.Dark) {
      return darkThemeKey;
    }
    return lightThemeKey;
  }

  static AppTheme getAppThemeFromLabel(String label) {
    if (label == darkThemeKey) {
      return AppTheme.Dark;
    }
    return AppTheme.Light;
  }

  static String getTranslatedLabel(BuildContext context, String labelKey) {
    return context.read<LanguageJsonCubit>().getTranslatedLabels(labelKey);
  }

  static String? convertToAgo(BuildContext context, DateTime input, int from) {
    Duration diff = DateTime.now().difference(input);
    initializeDateFormatting(); //locale according to location
    bool isNegative = diff.isNegative;
    if (diff.inDays >= 1 || (isNegative && diff.inDays < 1)) {
      if (from == 0) {
        var newFormat = DateFormat("MMM dd, yyyy", ('fr'));
        final newsDate1 = newFormat.format(input);
        return newsDate1;
      } else if (from == 1) {
        return "${diff.inDays} ${getTranslatedLabel(context, 'days')} ${getTranslatedLabel(context, 'ago')}";
      } else if (from == 2) {
        var newFormat = DateFormat("dd MMMM yyyy HH:mm:ss", 'fr');
        final newsDate1 = newFormat.format(input);
        return newsDate1;
      }
    } else if (diff.inHours >= 1 || (isNegative && diff.inMinutes < 1)) {
      if (input.minute == 00) {
        return "${diff.inHours} ${getTranslatedLabel(context, 'hours')} ${getTranslatedLabel(context, 'ago')}";
      } else {
        if (from == 2) {
          return "${getTranslatedLabel(context, 'about')} ${diff.inHours} ${getTranslatedLabel(context, 'hours')} ${input.minute} ${getTranslatedLabel(context, 'minutes')} ${getTranslatedLabel(context, 'ago')}";
        } else {
          return "${diff.inHours} ${getTranslatedLabel(context, 'hours')} ${input.minute} ${getTranslatedLabel(context, 'minutes')} ${getTranslatedLabel(context, 'ago')}";
        }
      }
    } else if (diff.inMinutes >= 1 || (isNegative && diff.inMinutes < 1)) {
      return "${diff.inMinutes} ${getTranslatedLabel(context, 'minutes')} ${getTranslatedLabel(context, 'ago')}";
    } else if (diff.inSeconds >= 1) {
      return "${diff.inSeconds} ${getTranslatedLabel(context, 'seconds')} ${getTranslatedLabel(context, 'ago')}";
    } else {
      return getTranslatedLabel(context, 'justNow');
    }
    return null;
  }

  static setUIOverlayStyle({required AppTheme appTheme}) {
    appTheme == AppTheme.Light
        ? SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: backgroundColor.withOpacity(0.8), statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark))
        : SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(statusBarColor: darkSecondaryColor.withOpacity(0.8), statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.light));
  }

  static userLogOut({required BuildContext contxt}) {
    for (int i = 0; i < AuthProvider.values.length; i++) {
      if (AuthProvider.values[i].name == contxt.read<AuthCubit>().getType()) {
        //contxt.read<BookmarkCubit>().resetState();
        contxt.read<AuthCubit>().signOut(AuthProvider.values[i]).then((value) {
          Navigator.of(contxt).pushNamedAndRemoveUntil(Routes.login, (route) => false);
        });
      }
    }
  }

//widget for User Profile Picture in Comments
  static Widget setFixedSizeboxForProfilePicture({required Widget childWidget}) {
    return SizedBox(height: 35, width: 35, child: childWidget);
  }


  //calculate time in Minutes to Read News Article
  static int calculateReadingTime(String text) {
    const wordsPerMinute = 200;
    final wordCount = text.trim().split(' ').length;
    final readTime = (wordCount / wordsPerMinute).ceil();
    return readTime;
  }

  Future<String> getDocumentType(String docType) async{
    String ret;
    ret = switch (docType) {
      'DocumentType.CNIB' => 'CNIB',
      'DocumentType.Passeport' => 'Passeport',
      _ => 'CNIB'
    };
    return ret;
  }
}
