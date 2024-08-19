// ignore_for_file: file_names

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bus_ticket_reservation_app/ui/styles/colors.dart';
import 'package:bus_ticket_reservation_app/utils/uiUtils.dart';
import 'package:bus_ticket_reservation_app/app/routes.dart';
import 'package:bus_ticket_reservation_app/ui/widgets/Slideanimation.dart';

import 'dashBoard/dashBoardScreen.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<Splash> with TickerProviderStateMixin {
  AnimationController? _splashIconController;
  AnimationController? _newsImgController;
  AnimationController? _slideControllerBottom;
  double opacity = 0.0;

  @override
  void initState() {
    super.initState();
    //fetchAppConfigurations();
    _slideControllerBottom = AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _splashIconController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _newsImgController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    changeOpacity();
  }


  changeOpacity() {
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        opacity = (opacity == 0.0) ? 1.0 : 0.0;
      });
    });
  }

  @override
  void dispose() {
    _splashIconController!.dispose();
    _newsImgController!.dispose();
    _slideControllerBottom!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //if (Platform.isAndroid) UiUtils.setUIOverlayStyle(appTheme: context.read<ThemeCubit>().state.appTheme); //set UiOverlayStyle according to selected theme
    Timer(
        const Duration(seconds: 3),
            () =>
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => const DashBoard()
            )
        )
    );
    return Scaffold(backgroundColor: backgroundColor, body: buildScale());
  }

  Future<void> navigationPage() async {
    Navigator.of(context).pushReplacementNamed(Routes.home);
  }

  Widget buildScale() {
    return Container(
        color: darkBackgroundColor,
        child: splashLogoIcon()
    );
  }

  Widget splashLogoIcon() {
    return Center(
        child: SlideAnimation(
            position: 2,
            itemCount: 3,
            slideDirection: SlideDirection.fromRight,
            animationController: _splashIconController!,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(UiUtils.getImagePath("ic_new_logo-playstore.png"), height: 250.0, fit: BoxFit.fill),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height/10,
                ),
                const Text(
                  "chargement en cours...",
                  style: TextStyle(
                      color: Colors.white
                  ),
                )
              ],
            )
        )
    );
  }

  Widget subTitle() {
    return AnimatedOpacity(
        opacity: opacity,
        duration: const Duration(seconds: 1),
        child: Container(
          margin: const EdgeInsets.only(top: 20.0),
          child: Text(UiUtils.getTranslatedLabel(context, 'fastTrendNewsLbl'), textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: backgroundColor)),
        ));
  }
}
