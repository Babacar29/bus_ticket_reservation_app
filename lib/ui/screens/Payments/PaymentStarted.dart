import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utils/uiUtils.dart';
import '../../styles/colors.dart';
import '../../widgets/myAppBar.dart';
import '../Profile/ProfileScreen.dart';
import '../Tickets/TicketsScreen.dart';

class PaymentStarted extends StatefulWidget {
  const PaymentStarted({super.key, this.from, required this.commandData});
  final int? from;
  final Map<String, dynamic> commandData;

  @override
  State<PaymentStarted> createState() => _PaymentStartedState();

  static Route route(RouteSettings routeSettings) {
    final arguments = routeSettings.arguments as Map<String, dynamic>;
    return CupertinoPageRoute(
        builder: (_) => PaymentStarted(
          from: arguments['from'],
          commandData: arguments['commandData'],
        )
    );
  }
}

class _PaymentStartedState extends State<PaymentStarted> {
  TextEditingController numController = TextEditingController();
  int _selectedIndex = 0;
  List<IconData> iconList = [
    Icons.bookmark,
    Icons.bookmark,
    Icons.account_circle,
  ];


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
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Container(
               color: Colors.white,
                width: width,
                child: const Padding(
                  padding: EdgeInsets.only(left: 10.0, top: 10, bottom: 10),
                  child: Text(
                    "Le vendredi 12 Janv, 2024 à 18:30",
                    style: TextStyle(
                      color: darkBackgroundColor
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              Container(
                color: darkBackgroundColor,
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Ouagadougou",
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "Ville de départ",
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              Container(
                color: darkBackgroundColor,
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Bobo Dioulasso",
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "Ville d'arrivée",
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              Container(
                color: Colors.white,
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Cout total du billet:",
                        style: TextStyle(
                          color: darkBackgroundColor
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "8500 FCFA",
                        style: TextStyle(
                            color: darkBackgroundColor
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30,),
              Text(
                "Choisissez votre mode de paiement",
                style: TextStyle(
                    color: darkBackgroundColor
                ),
              ),
              const SizedBox(height: 5,),
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
                      hintText: "Numéro de téléphone",
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    validator: (val){
                      /*if(expirationDateController.text.isEmpty){
                        return Validators.notEmptyValidation(val!, context);
                      }*/
                    },
                    keyboardType: TextInputType.number,
                    cursorHeight: 18,
                    controller: numController,
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
              const SizedBox(height: 10,),
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Image.asset("assets/orange_money.jpeg", height: height/25,),
                      SizedBox(width: width/20,),
                      Text(
                        "Oranege Money",
                        textScaler: TextScaler.linear(1.5),
                        style: TextStyle(
                          color: darkBackgroundColor,
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )
      ),
    );
  }

  Widget showContent(){
    return Scaffold(
      appBar: const CustomAppBar(title: "Récapulatif et paiement"),
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
}
