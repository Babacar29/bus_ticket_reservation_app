import 'dart:io';

import 'package:burkina_transport_app/app/routes.dart';
import 'package:burkina_transport_app/cubits/Auth/loginCubit.dart';
import 'package:burkina_transport_app/cubits/availableCitiesCubit.dart';
import 'package:burkina_transport_app/cubits/commandCubit.dart';
import 'package:burkina_transport_app/cubits/otherPagesCubit.dart';
import 'package:burkina_transport_app/cubits/trajetsCubit.dart';
import 'package:burkina_transport_app/data/repositories/AvailableCities/AvailableCitiesRepository.dart';
import 'package:burkina_transport_app/data/repositories/Command/commandRepository.dart';
import 'package:burkina_transport_app/data/repositories/Payments/PaymentsRepository.dart';
import 'package:burkina_transport_app/data/repositories/TrajetsRepositories/TrajetsRepository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:burkina_transport_app/cubits/Auth/deleteUserCubit.dart';
import 'package:burkina_transport_app/cubits/Auth/registerCubit.dart';
import 'package:burkina_transport_app/cubits/Auth/updateUserCubit.dart';
import 'package:burkina_transport_app/cubits/UserPreferences/setUserPreferenceCatCubit.dart';
import 'package:burkina_transport_app/cubits/appLocalizationCubit.dart';
import 'package:burkina_transport_app/cubits/Auth/authCubit.dart';
import 'package:burkina_transport_app/cubits/languageCubit.dart';
import 'package:burkina_transport_app/cubits/settingCubit.dart';
import 'package:burkina_transport_app/cubits/languageJsonCubit.dart';
import 'package:burkina_transport_app/cubits/themeCubit.dart';
import 'package:burkina_transport_app/data/repositories/Auth/authRepository.dart';
import 'package:burkina_transport_app/data/repositories/SetUserPreferenceCat/setUserPrefCatRepository.dart';
import 'package:burkina_transport_app/data/repositories/language/languageRepository.dart';
import 'package:burkina_transport_app/data/repositories/Settings/settingRepository.dart';
import 'package:burkina_transport_app/data/repositories/LanguageJson/languageJsonRepository.dart';
import 'package:burkina_transport_app/utils/uiUtils.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sentry_logging/sentry_logging.dart';

import '../core/services/local_storage/sharedPreferences.dart';
import '../cubits/Auth/updateFCMCubit.dart';
import '../cubits/Payments/paymentCubit.dart';
import '../cubits/ticketsCubit.dart';
import '../data/repositories/OtherPages/otherPagesRepository.dart';
import '../data/repositories/Settings/settingsLocalDataRepository.dart';
import '../data/repositories/Tickets/TicketsRepositories.dart';
import '../utils/hiveBoxKeys.dart';
import '../firebase_options.dart';

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  HttpOverrides.global = MyHttpOverrides();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SharedPreferencesServices.init();

  //await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  await Hive.initFlutter();

  await Hive.openBox(authBoxKey);

  await Hive.openBox(settingsBoxKey);

  await SentryFlutter.init(
          (options) {
        options.dsn = 'https://fee6332cfe1b46f28bcb78509b0df719@sentry.ankata.net/16';
        options.tracesSampleRate = 1.0;
        options.release = "ankata-rahimo@1.1.5+16";
        options.enableAutoPerformanceTracing = true;
        options.environment = "Production";
        options.addIntegration(LoggingIntegration());
      }
  );

  runApp(MultiBlocProvider(providers: [
    //BlocProvider<AppConfigurationCubit>(create: (context) => AppConfigurationCubit(SystemRepository())),
    //BlocProvider<SettingsCubit>(create: (_) => SettingsCubit(SettingsRepository())),
    BlocProvider<LanguageJsonCubit>(create: (_) => LanguageJsonCubit(LanguageJsonRepository())),
    BlocProvider<LanguageCubit>(create: (context) => LanguageCubit(LanguageRepository())),
    BlocProvider<AuthCubit>(create: (_) => AuthCubit(AuthRepository())),
    BlocProvider<LoginCubit>(create: (_) => LoginCubit(AuthRepository())),
    BlocProvider<UpdateFcmIdCubit>(create: (_) => UpdateFcmIdCubit(AuthRepository())),
    //BlocProvider<UserByCatCubit>(create: (_) => UserByCatCubit(UserByCatRepository())),
    BlocProvider<SetUserPrefCatCubit>(create: (_) => SetUserPrefCatCubit(SetUserPrefCatRepository())),
    BlocProvider<UpdateUserCubit>(create: (_) => UpdateUserCubit(AuthRepository())),
    BlocProvider<DeleteUserCubit>(create: (_) => DeleteUserCubit(AuthRepository())),
    BlocProvider<ThemeCubit>(create: (_) => ThemeCubit(SettingsLocalDataRepository())),
    //BlocProvider<GetUserByIdCubit>(create: (_) => GetUserByIdCubit(GetUserByIdRepository())),
    BlocProvider<AppLocalizationCubit>(create: (_) => AppLocalizationCubit(SettingsLocalDataRepository())),
    BlocProvider<SettingsCubit>(create: (_) => SettingsCubit(SettingsRepository())),
    BlocProvider<OtherPageCubit>(create: (_) => OtherPageCubit(OtherPageRepository())),
    //BlocProvider<OtherPageCubit>(create: (_) => OtherPageCubit(OtherPageRepository())),
    BlocProvider<LoginCubit>(create: (_) => LoginCubit(AuthRepository())),
    BlocProvider<RegisterCubit>(create: (_) => RegisterCubit(AuthRepository(), SharedPreferencesServices())),
    BlocProvider<AvailableCitiesCubit>(create: (_) => AvailableCitiesCubit(AvailableCitiesRepository())),
    BlocProvider<TrajetsCubit>(create: (_) => TrajetsCubit(TrajetsRepository())),
    BlocProvider<CommandCubit>(create: (_) => CommandCubit(CommandRepository())),
    BlocProvider<PaymentCubit>(create: (_) => PaymentCubit(PaymentRepository())),
    BlocProvider<TicketsCubit>(create: (_) => TicketsCubit(TicketsRepository())),
  ], child: const MyApp()));
}

class GlobalScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var box = Hive.box(authBoxKey);
  var service = SharedPreferencesServices();
  var secureStorage = const FlutterSecureStorage();
  String? _apiKey;

   getApiKey() async{
    String keY = "";
    String? key = await service.getApiKeyFromSharedPref();
    String? _key = await service.getApiKeyInSecureStorage();
    if(_key != null){
      keY = _key;
    }
    else if(key.isNotEmpty){
      keY = key;
    }
    if(!mounted) return;
    setState(() {
      _apiKey = keY;
    });
  }

   getTokenKey() async{
    String keY = "";
    String? key = service.getTokenKeyFromSharedPref();
    String? _key = await service.getTokenKeyInSecureStorage();
    if(_key != null){
      keY = _key;
    }
    else if(key.isNotEmpty){
      keY = key;
    }
    debugPrint("api key ==========>${box.get(tokenKey)}");
    if(!mounted) return;
    setState(() {
      _apiKey = keY;
    });
   }

   void checkApiKey() async{
     try{
       if(box.get(tokenKey) == null && box.get(apiKey) == null && (_apiKey == null || _apiKey!.isEmpty)){
         context.read<RegisterCubit>().register(context: context);
       }
       debugPrint("api_key =========>${box.get(tokenKey)}");
       debugPrint("apiKey =========>${box.get(apiKey)}");
     }
     catch(e, stackTrace) {
       await Sentry.captureException(
         e,
         stackTrace: stackTrace,
       );
     }
  }

  getAPNToken() async{
    try{
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      if(settings.authorizationStatus == AuthorizationStatus.authorized){
        final apnsToken = await FirebaseMessaging.instance.getToken();
        debugPrint("APNSToken ====+> $apnsToken");
        if (apnsToken != null) {
          context.read<UpdateFcmIdCubit>().sendAPNToken(token: apnsToken);
        }
      }
    }
    catch(e){
      debugPrint("exception ****************>$e");
    }
  }

  @override
  void initState() {
     getTokenKey();
     getApiKey();
    //var brightness = PlatformDispatcher.instance.platformBrightness;
    /*if (SettingsLocalDataRepository().getCurrentTheme().isEmpty) {
      (brightness == Brightness.dark) ? context.read<ThemeCubit>().changeTheme(AppTheme.Dark) : context.read<ThemeCubit>().changeTheme(AppTheme.Light);
    }*/
    //context.read<LoginCubit>().loginUser(context: context);
    //debugPrint("token ======> ${box.get(tokenKey)}");
    checkApiKey();
    getAPNToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /*if (Hive.box(settingsBoxKey).get(currentLanguageCodeKey) != null || Hive.box(settingsBoxKey).get(currentLanguageCodeKey) != "") {
      initializeDateFormatting();
      intl.Intl.defaultLocale = Hive.box(settingsBoxKey).get(currentLanguageCodeKey); //set default Locale @Start
    }*/

    return Builder(builder: (context) {
      return MaterialApp(
          navigatorKey: UiUtils.rootNavigatorKey,
          //theme: appThemeData[currentTheme],
          debugShowCheckedModeBanner: false,
          initialRoute: Routes.splash,
          onGenerateRoute: Routes.onGenerateRouted,
          );
    });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
