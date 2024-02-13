import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import '../../../cubits/Payments/paymentCubit.dart';
import '../../../utils/ErrorMessageKeys.dart';
import '../../../utils/internetConnectivity.dart';
import '../../../utils/uiUtils.dart';
import '../../styles/colors.dart';
import '../../widgets/circularProgressIndicator.dart';
import '../../widgets/myAppBar.dart';
import '../Profile/ProfileScreen.dart';
import '../Tickets/TicketsScreen.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, this.from, required this.commandData,
   required this.otpData
  });
  final int? from;
  final Map<String, dynamic> commandData;
  final Map<String, dynamic> otpData;

  @override
  State<OtpScreen> createState() => _OtpScreenState();

  static Route route(RouteSettings routeSettings) {
    final arguments = routeSettings.arguments as Map<String, dynamic>;
    return CupertinoPageRoute(
        builder: (_) => OtpScreen(
          from: arguments['from'],
          commandData: arguments['commandData'],
          otpData: arguments['otpData'],
        )
    );
  }
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otpController = TextEditingController();
  int _selectedIndex = 0;
  List<IconData> iconList = [
    Icons.bookmark,
    Icons.bookmark,
    Icons.account_circle,
  ];
  var data = {};
  var paymentsAvailable = [];

  _callNumber(String code) async{
    await FlutterPhoneDirectCaller.callNumber(code);
  }


  @override
  void initState() {
    //_callNumber(widget.otpData["transactionCode"]);
    super.initState();
  }


  Widget buildNavBarItem(IconData icon, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        height: 60,
        width: MediaQuery.sizeOf(context).width / iconList.length,
        decoration: index == _selectedIndex
            ? const BoxDecoration(
          border: Border(
            top: BorderSide(width: 3, color: darkBackgroundColor),
          ),
        )
            : null,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            children: [
              Icon(
                icon,
                color: index == _selectedIndex ? darkBackgroundColor : UiUtils.getColorScheme(context).outline,
              ),
              index == 0 ? Text(
                "Réservations",
                style: TextStyle(
                    color: index == _selectedIndex ? darkBackgroundColor : null
                ),
              ) : const SizedBox(),
              index == 1 ? Text(
                "Mes billets",
                style: TextStyle(
                    color: index == _selectedIndex ? darkBackgroundColor : null
                ),
              ) : const SizedBox(),
              index == 2 ? Text(
                "Mon Compte",
                style: TextStyle(
                    color: index == _selectedIndex ? darkBackgroundColor : null
                ),
              ) : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  bottomBar() {
    List<Widget> navBarItemList = [];
    for (var i = 0; i < iconList.length; i++) {
      navBarItemList.add(buildNavBarItem(iconList[i], i));
    }

    return Container(
        decoration: BoxDecoration(
          color: UiUtils.getColorScheme(context).secondary,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
          boxShadow: [
            BoxShadow(blurRadius: 6, offset: const Offset(5.0, 5.0), color: darkBackgroundColor.withOpacity(0.4), spreadRadius: 0),
          ],
        ),
        child: ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
            child: Row(
              children: navBarItemList,
            )
        )
    );
  }

  Widget showBody (BuildContext context){
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(UiUtils.getImagePath("ic_new_logo-playstore.png"), height: height/8, fit: BoxFit.fill),
            SizedBox(height: height/50,),
            const Text(
              "Veuillez exécuter le code suivant et entrer\nl'OTP pour valider votre réservation:",
              textScaler: TextScaler.linear(1.4),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: darkBackgroundColor,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: height/50,),
            Text(
              "${widget.otpData["transactionCode"]}",
              textScaler: const TextScaler.linear(1.7),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: height/60,),
            const Text(
              "Vous recevrez une notification une fois le paiement sera validé",
              textScaler: TextScaler.linear(1.1),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: darkBackgroundColor,
                  fontWeight: FontWeight.w500
              ),
            ),
            SizedBox(height: height/80,),
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.2))
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: darkBackgroundColor, width: 3),
                    ),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.4))
                    ),
                    labelStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                    hintText: "Code de validation",
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () async{
                        if (await InternetConnectivity.isNetworkAvailable()) {
                          await context.read<PaymentCubit>().payCommand(
                              commandId: widget.commandData["id"],
                              value: otpController.text,
                              context: context
                          );
                          //Navigator.of(context).pop();
                          //Navigator.of(context).pop();
                        }
                        else {
                          showCustomSnackBar(context: context, message: ErrorMessageKeys.noInternet);
                        }
                      },
                      child: Container(
                        width: width/4,
                        color: darkBackgroundColor,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "PAYER",
                              textScaler: TextScaler.linear(1.3),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ),
                  validator: (val){
                    /*if(expirationDateController.text.isEmpty){
                          return Validators.notEmptyValidation(val!, context);
                        }*/
                  },
                  keyboardType: TextInputType.number,
                  cursorHeight: 18,
                  controller: otpController,
                  cursorColor: Colors.black,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16
                  ),
                  onChanged: (String value) {
                  },
                  textAlignVertical: TextAlignVertical.center,
                ),
              ),
            ),
          ],
        )
    );
  }

  Widget showContent(){
    return Scaffold(
      appBar: const CustomAppBar(title: "Validation du paiement"),
      backgroundColor: darkBackgroundColor.withOpacity(0.15),
      body: showBody(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          showContent(),
          //Add only if Category Mode is enabled From Admin panel.
          const TicketsScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: bottomBar(),
    );
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }
}
