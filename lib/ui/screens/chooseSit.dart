import 'package:burkina_transport_app/cubits/commandCubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/uiUtils.dart';
import '../styles/colors.dart';
import '../widgets/circularProgressIndicator.dart';
import '../widgets/customTextBtn.dart';
import '../widgets/myAppBar.dart';
import 'Profile/ProfileScreen.dart';
import 'Tickets/TicketsScreen.dart';

class ChooseSit extends StatefulWidget {
  final int? from;
  final Map<String, dynamic> commandData;
  const ChooseSit({super.key, this.from, required this.commandData});

  @override
  State<ChooseSit> createState() => _ChooseSitState();

  static Route route(RouteSettings routeSettings) {
    final arguments = routeSettings.arguments as Map<String, dynamic>;
    return CupertinoPageRoute(
        builder: (_) => ChooseSit(
          from: arguments['from'],
          commandData: arguments['commandData'],
        )
    );
  }
}

class _ChooseSitState extends State<ChooseSit> {
  int _selectedIndex = 0;
  List<IconData> iconList = [
    Icons.bookmark,
    Icons.bookmark,
    Icons.account_circle,
  ];
  String representation = "";
  List<int> selectedSeats = [];


  Widget buildSeatsLayout(double height) {
    List<Widget> seatRows = [];
    final List<String> seatDisposition = representation.split('/');
    int index = 1;

    for (String row in seatDisposition) {
      List<Widget> rowWidgets = [];

      for (int i = 0; i < row.length; i++) {
        if (row[i] == 'U') {
          rowWidgets.add(buildSeatItem('${index++}', Colors.grey, height));
        } else if (row[i] == 'R') {
          rowWidgets.add(buildSeatItem('${index++}', Colors.yellow, height));
        } else if (row[i] == 'A') {
          rowWidgets.add(buildSeatItem('${index++}', Colors.white, height));
        } else if (row[i] == '_') {
          rowWidgets.add(buildEmptySpace());
        }
      }

      seatRows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: rowWidgets,
        ),
      );
    }

    return Column(
      children: seatRows,
    );
  }

  Widget buildSeatItem(String seatNumber, Color color, double height) {
    bool isSelected = selectedSeats.contains(int.parse(seatNumber));
    return Padding(
      padding: const EdgeInsets.all(9.0),
      child: GestureDetector(
        onTap: (){
          debugPrint("number of tickets ======>${widget.commandData["ticketIdList"].length}");
          if((!isSelected || selectedSeats.isEmpty) ){
            selectedSeats.add(int.parse(seatNumber));
            setState(() {});
          }
          else{
            setState(() {});
            selectedSeats.remove(int.parse(seatNumber));
          }
          debugPrint("selected items =====>$selectedSeats");
        },
        child: Row(
          children: [
            Container(
                width: 4,
                height: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(40)
                    ),
                    border: Border.all(color: isSelected ? Colors.greenAccent : Colors.grey),
                    color: isSelected ? Colors.greenAccent : color
                ),
                child: const SizedBox()
            ),
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 0, right: 0, bottom: 1),
                  width: 30,
                  height: height/46,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    ),
                    border: Border.all(color: isSelected ? Colors.greenAccent : Colors.grey),
                    color: isSelected ? Colors.greenAccent : color,
                  ),
                  child: Text(
                    seatNumber,
                    style: TextStyle(color: color == Colors.white ? Colors.grey : Colors.white),
                  ),
                ),
                Container(
                    margin: const EdgeInsets.all(0.5),
                    width: 35,
                    height: 8,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        border: Border.all(color: isSelected ? Colors.greenAccent : Colors.grey),
                        color: isSelected ? Colors.greenAccent : color
                    ),
                    child: const SizedBox()
                ),
              ],
            ),
            Container(
                width: 4,
                height: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(40)
                    ),
                    border: Border.all(color: isSelected ? Colors.greenAccent : Colors.grey),
                    color: isSelected ? Colors.greenAccent : color
                ),
                child: const SizedBox()
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEmptySpace() {
    return const SizedBox(
      width: 60,
      height: 20,
    );
  }

  getRepresentation() async{
    String result = await context.read<CommandCubit>().getPlacesRepresentationData();
    if(!mounted) return;
    setState(() {
      representation = result;
    });
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
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            buildSeatsLayout(height),
            Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: height/40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Container(
                        color: Colors.grey,
                        width: width/20,
                        height: height/50,
                      ),
                      const SizedBox(width: 8,),
                      const Text("Déjà prise", textScaler: TextScaler.linear(1.1), style: TextStyle(fontWeight: FontWeight.w600),)
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        color: Colors.greenAccent,
                        width: width/20,
                        height: height/50,
                      ),
                      const SizedBox(width: 8,),
                      const Text("Votre sélection", textScaler: TextScaler.linear(1.1), style: TextStyle(fontWeight: FontWeight.w600),)
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        color: Colors.white,
                        width: width/20,
                        height: height/50,
                      ),
                      const SizedBox(width: 8,),
                      const Text("Disponible", textScaler: TextScaler.linear(1.1), style: TextStyle(fontWeight: FontWeight.w600),)
                    ],
                  ),
                ],
              ),
            ),
            CustomTextButton(
              onTap: () async{
                if(selectedSeats.isEmpty){
                  showCustomSnackBar(context: context, message: "Vous n'avez fait aucun choix");
                  return;
                }

                if(selectedSeats.length > widget.commandData["ticketIdList"].length){
                  showCustomSnackBar(context: context, message: "Vous ne pouvez choisir que ${widget.commandData["ticketIdList"].length} siège(s)");
                  return;
                }

                if(selectedSeats.length < widget.commandData["ticketIdList"].length){
                  showCustomSnackBar(context: context, message: "Vous devez choisir ${widget.commandData["ticketIdList"].length} siège(s)");
                  return;
                }
                //Navigator.of(context).pushNamed(Routes.chooseSit, arguments: {"from": 1});
                context.read<CommandCubit>().sendSeatsData(seats: selectedSeats, commandData: widget.commandData, context: context);
              },
              color: darkBackgroundColor,
              text: "Valider",
            )
          ],
        )
      ),
    );
  }

  Widget showContent(){
    return Scaffold(
      appBar: const CustomAppBar(title: "Les passagers du voyage"),
      backgroundColor: darkBackgroundColor.withOpacity(0.15),
      body: showBody(context),
    );
  }

  @override
  void initState() {
    getRepresentation();
    super.initState();
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

class SeatWidget extends StatelessWidget {
  final String name;
  final Color? color;

  const SeatWidget({Key? key, required this.name, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width / 5 - 20;
    return Container(
      margin: const EdgeInsets.all(3.0),
      width: width,
      height: width / 1.5,
      color: color,
      child: Center(
          child: Text(name.toString(),
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold))),
    );
  }
}


