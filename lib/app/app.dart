import 'dart:io';
import 'dart:ui';

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
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:burkina_transport_app/cubits/Auth/deleteUserCubit.dart';
import 'package:burkina_transport_app/cubits/Auth/registerCubit.dart';
import 'package:burkina_transport_app/cubits/Auth/updateFCMCubit.dart';
import 'package:burkina_transport_app/cubits/Auth/updateUserCubit.dart';
import 'package:burkina_transport_app/cubits/UserPreferences/setUserPreferenceCatCubit.dart';
import 'package:burkina_transport_app/cubits/appLocalizationCubit.dart';
import 'package:burkina_transport_app/cubits/Auth/authCubit.dart';
import 'package:burkina_transport_app/cubits/getUserDataByIdCubit.dart';
import 'package:burkina_transport_app/cubits/languageCubit.dart';
import 'package:burkina_transport_app/cubits/settingCubit.dart';
import 'package:burkina_transport_app/cubits/UserPreferences/userByCategoryCubit.dart';
import 'package:burkina_transport_app/cubits/appSystemSettingCubit.dart';
import 'package:burkina_transport_app/cubits/languageJsonCubit.dart';
import 'package:burkina_transport_app/cubits/themeCubit.dart';
import 'package:burkina_transport_app/data/repositories/Auth/authRepository.dart';
import 'package:burkina_transport_app/data/repositories/GetUserById/getUserByIdRepository.dart';
import 'package:burkina_transport_app/data/repositories/SetUserPreferenceCat/setUserPrefCatRepository.dart';
import 'package:burkina_transport_app/data/repositories/UserByCategory/userByCatRepository.dart';
import 'package:burkina_transport_app/data/repositories/language/languageRepository.dart';
import 'package:burkina_transport_app/data/repositories/Settings/settingRepository.dart';
import 'package:burkina_transport_app/data/repositories/AppSystemSetting/systemRepository.dart';
import 'package:burkina_transport_app/data/repositories/LanguageJson/languageJsonRepository.dart';
import 'package:burkina_transport_app/ui/styles/appTheme.dart';
import 'package:burkina_transport_app/utils/uiUtils.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' as intl;

import '../cubits/Payments/paymentCubit.dart';
import '../data/repositories/OtherPages/otherPagesRepository.dart';
import '../data/repositories/Settings/settingsLocalDataRepository.dart';
import '../utils/hiveBoxKeys.dart';

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  //await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  await Hive.initFlutter();

  await Hive.openBox(authBoxKey);

  await Hive.openBox(settingsBoxKey);

  runApp(MultiBlocProvider(providers: [
    BlocProvider<AppConfigurationCubit>(create: (context) => AppConfigurationCubit(SystemRepository())),
    //BlocProvider<SettingsCubit>(create: (_) => SettingsCubit(SettingsRepository())),
    BlocProvider<LanguageJsonCubit>(create: (_) => LanguageJsonCubit(LanguageJsonRepository())),
    BlocProvider<LanguageCubit>(create: (context) => LanguageCubit(LanguageRepository())),
    BlocProvider<AuthCubit>(create: (_) => AuthCubit(AuthRepository())),
    BlocProvider<LoginCubit>(create: (_) => LoginCubit(AuthRepository())),
    BlocProvider<UpdateFcmIdCubit>(create: (_) => UpdateFcmIdCubit(AuthRepository())),
    BlocProvider<UserByCatCubit>(create: (_) => UserByCatCubit(UserByCatRepository())),
    BlocProvider<SetUserPrefCatCubit>(create: (_) => SetUserPrefCatCubit(SetUserPrefCatRepository())),
    BlocProvider<UpdateUserCubit>(create: (_) => UpdateUserCubit(AuthRepository())),
    BlocProvider<DeleteUserCubit>(create: (_) => DeleteUserCubit(AuthRepository())),
    BlocProvider<ThemeCubit>(create: (_) => ThemeCubit(SettingsLocalDataRepository())),
    BlocProvider<GetUserByIdCubit>(create: (_) => GetUserByIdCubit(GetUserByIdRepository())),
    BlocProvider<AppLocalizationCubit>(create: (_) => AppLocalizationCubit(SettingsLocalDataRepository())),
    BlocProvider<SettingsCubit>(create: (_) => SettingsCubit(SettingsRepository())),
    BlocProvider<OtherPageCubit>(create: (_) => OtherPageCubit(OtherPageRepository())),
    BlocProvider<OtherPageCubit>(create: (_) => OtherPageCubit(OtherPageRepository())),
    BlocProvider<LoginCubit>(create: (_) => LoginCubit(AuthRepository())),
    BlocProvider<RegisterCubit>(create: (_) => RegisterCubit(AuthRepository())),
    BlocProvider<AvailableCitiesCubit>(create: (_) => AvailableCitiesCubit(AvailableCitiesRepository())),
    BlocProvider<TrajetsCubit>(create: (_) => TrajetsCubit(TrajetsRepository())),
    BlocProvider<CommandCubit>(create: (_) => CommandCubit(CommandRepository())),
    BlocProvider<PaymentCubit>(create: (_) => PaymentCubit(PaymentRepository())),
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

  @override
  void initState() {
    var brightness = PlatformDispatcher.instance.platformBrightness;
    if (SettingsLocalDataRepository().getCurrentTheme().isEmpty) {
      (brightness == Brightness.dark) ? context.read<ThemeCubit>().changeTheme(AppTheme.Dark) : context.read<ThemeCubit>().changeTheme(AppTheme.Light);
    }
    context.read<LoginCubit>().loginUser(context: context);
    //debugPrint("token ======> ${box.get(tokenKey)}");
    if(box.get(tokenKey) == null) context.read<RegisterCubit>().register(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (Hive.box(settingsBoxKey).get(currentLanguageCodeKey) != null || Hive.box(settingsBoxKey).get(currentLanguageCodeKey) != "") {
      initializeDateFormatting();
      intl.Intl.defaultLocale = Hive.box(settingsBoxKey).get(currentLanguageCodeKey); //set default Locale @Start
    }

    return Builder(builder: (context) {
      final currentTheme = context.watch<ThemeCubit>().state.appTheme;
      return BlocBuilder<AppLocalizationCubit, AppLocalizationState>(
        builder: (context, state) {
          return MaterialApp(
              navigatorKey: UiUtils.rootNavigatorKey,
              theme: appThemeData[currentTheme],
              debugShowCheckedModeBanner: false,
              initialRoute: Routes.splash,
              onGenerateRoute: Routes.onGenerateRouted,
              builder: (context, widget) {
                return ScrollConfiguration(
                    behavior: GlobalScrollBehavior(), child: Directionality(textDirection: state.isRTL == '' || state.isRTL == "0" ? TextDirection.ltr : TextDirection.rtl, child: widget!));
              });
        },
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
