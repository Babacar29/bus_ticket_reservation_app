import 'package:burkina_transport_app/ui/screens/Payments/PaymentStarted.dart';
import 'package:burkina_transport_app/ui/screens/Tickets/TicketDetails.dart';
import 'package:burkina_transport_app/ui/screens/chooseSit.dart';
import 'package:burkina_transport_app/ui/screens/showAvailablePlace/ShowAvailableCitiesScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:burkina_transport_app/ui/screens/PrivacyPolicyScreen.dart';
import 'package:burkina_transport_app/ui/screens/Profile/userProfile.dart';
import 'package:burkina_transport_app/ui/screens/auth/ForgotPassword.dart';
import 'package:burkina_transport_app/ui/screens/dashBoard/dashBoardScreen.dart';
import 'package:burkina_transport_app/ui/screens/languageList.dart';
import 'package:burkina_transport_app/ui/screens/splashScreen.dart';
import 'package:burkina_transport_app/ui/screens/auth/loginScreen.dart';

import '../ui/screens/GetUserInfos.dart';
import '../ui/screens/Tickets/TicketsScreen.dart';

class Routes {
  static const String splash = "splash";
  static const String home = "/";
  static const String introSlider = "introSlider";
  static const String languageList = "languageList";
  static const String login = "login";
  static const String privacy = "privacy";
  static const String requestOtp = "requestOtp";
  static const String verifyOtp = "verifyOtp";
  static const String managePref = "managePref";
  static const String imagePreview = "imagePreview";
  static const String tagScreen = "tagScreen";
  static const String forgotPass = "forgotPass";
  static const String editUserProfile = "editUserProfile";
  static const String showAvailablePLace = "showAvailablePLace";
  static const String showUserInfo = "showUserInfo";
  static const String chooseSit = "chooseSit";
  static const String startPayment = "startPayment";
  static const String ticketDetails = "ticketDetails";
  static const String tickets = "tickets";

  static String currentRoute = splash;

  static Route<dynamic> onGenerateRouted(RouteSettings routeSettings) {
    currentRoute = routeSettings.name ?? "";
    switch (routeSettings.name) {
      case splash:
        {
          return CupertinoPageRoute(builder: (_) => const Splash());
        }
      case home:
        {
          return DashBoard.route(routeSettings);
        }
      case login:
        {
          return LoginScreen.route(routeSettings);
        }
      case languageList:
        {
          return LanguageList.route(routeSettings);
        }
      case privacy:
        {
          return PrivacyPolicy.route(routeSettings);
        }
      case forgotPass:
        {
          return CupertinoPageRoute(builder: (_) => const ForgotPassword());
        }
      case editUserProfile:
        {
          return UserProfileScreen.route(routeSettings);
        }
      case showAvailablePLace:
        {
          return ShowAvailableCities.route(routeSettings);
        }
      case showUserInfo:
        {
          return GetUserInfos.route(routeSettings);
        }
      case chooseSit:
        {
          return ChooseSit.route(routeSettings);
        }
      case startPayment:
        {
          return PaymentStarted.route(routeSettings);
        }
      case ticketDetails:
        {
          return TicketDetailsScreen.route(routeSettings);
        }
      case tickets:
        {
          return TicketsScreen.route(routeSettings);
        }
      default:
        {
          return CupertinoPageRoute(builder: (context) => const Scaffold());
        }
    }
  }
}
