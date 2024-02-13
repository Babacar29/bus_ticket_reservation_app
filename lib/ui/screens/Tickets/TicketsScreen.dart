// ignore_for_file: file_names

import 'package:burkina_transport_app/cubits/ticketsCubit.dart';
import 'package:burkina_transport_app/ui/screens/HomePage/HomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../app/routes.dart';
import '../../../cubits/Auth/authCubit.dart';
import '../../../data/models/Ticket.dart';
import '../../../utils/uiUtils.dart';
import '../../styles/colors.dart';
import '../../widgets/customTextBtn.dart';
import '../../widgets/myAppBar.dart';
import '../Profile/ProfileScreen.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({super.key, this.from});
  final int? from;

  @override
  TicketsScreenState createState() => TicketsScreenState();

  static Route route(RouteSettings routeSettings) {
    final arguments = routeSettings.arguments as Map<String, dynamic>;
    return CupertinoPageRoute(
      builder: (_) => TicketsScreen(
        from: arguments["from"]
      ),
    );
  }
}

class TicketsScreenState extends State<TicketsScreen> with TickerProviderStateMixin {
  int _selectedIndex = 1;
  List<IconData> iconList = [
    Icons.bookmark,
    Icons.bookmark,
    Icons.account_circle,
  ];
  List<Ticket> myTicketList = [];
  late TabController controller;
  int _currentIndex = 0;

  void _handleTabSelection() {
    setState(() {
      _currentIndex = controller.index;
    });
  }

  getPassedTickets() async{
    List<Ticket> tickets = [];
    var result = await context.read<TicketsCubit>().getTickets(context: context);
    //
    for(var ticket in result["passedTicketList"].toList()){
      //widget.tickets?.add(Ticket.fromMap(ticket));
      tickets.add(Ticket.fromMap(ticket));
    }
    return tickets;
  }

  getUpComingTickets() async{
    List<Ticket> tickets = [];
    var result = await context.read<TicketsCubit>().getTickets(context: context);
    //
    for(var ticket in result["upcomingTicketList"].toList()){
      //widget.tickets?.add(Ticket.fromMap(ticket));
      tickets.add(Ticket.fromMap(ticket));
    }
    return tickets;
  }

  @override
  void initState() {
    controller = TabController(vsync: this, length: 2);
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
        width: MediaQuery.of(context).size.width / iconList.length,
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
  
  Widget showPassedTickets(BuildContext context){
    return FutureBuilder(
      future: getPassedTickets(),
      builder: (context, AsyncSnapshot snap){
        List<Widget> children;
        if(snap.hasData){
          children = <Widget>[
            snap.data.toList() == [] ? const SizedBox() : ListView.builder(
              //itemCount: widget.tickets?.length,
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: snap.data.length,
                itemBuilder: (context, int i){
                  Ticket ticket = snap.data[i];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(Routes.ticketDetails, arguments: {"ticket": ticket});
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                  color: darkBackgroundColor,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)
                                  )
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      "${ticket.departureCity} > ${ticket.arrivalCity}",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            paddingText(title: "Date: ", subtitle: DateFormat("d MMMM yyyy").format(DateTime.parse("${ticket.departureDate}"))),
                            paddingText(title: "Heure: ", subtitle: ticket.departureTime),
                            paddingText(title: "Statut: ", subtitle: ticket.paymentStatus),
                            paddingText(title: "Numéro de place: ", subtitle: "${ticket.seatNumber}"),
                            const SizedBox(height: 5,),
                          ],
                        ),
                      ),
                    ),
                  );
                }
            )
          ];
        }
        else if (snap.hasError) {
          children = <Widget>[
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('Erreur: ${snap.error}'),
            ),
          ];
        } else {
          children = <Widget>[
            SizedBox(
              height: 300,
            ),
            Center(
              child: CircularProgressIndicator( color: darkBackgroundColor,),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Chargement...'),
              ),
            ),
          ];
        }
        return ListView(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          children: children,
        );

      }
    );
  }

  Widget showUpComingTickets(BuildContext context){
    return FutureBuilder(
      future: getUpComingTickets(),
      builder: (context, AsyncSnapshot snap){
        List<Widget> children;
        if(snap.hasData){
          children = <Widget>[
            snap.data.toList() == [] ? const SizedBox() : ListView.builder(
              //itemCount: widget.tickets?.length,
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: snap.data.length,
                itemBuilder: (context, int i){
                  Ticket ticket = snap.data[i];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(Routes.ticketDetails, arguments: {"ticket": ticket});
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                  color: darkBackgroundColor,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)
                                  )
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      "${ticket.departureCity} > ${ticket.arrivalCity}",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            paddingText(title: "Date: ", subtitle: DateFormat("d MMMM yyyy").format(DateTime.parse("${ticket.departureDate}"))),
                            paddingText(title: "Heure: ", subtitle: ticket.departureTime),
                            paddingText(title: "Statut: ", subtitle: ticket.paymentStatus),
                            paddingText(title: "Numéro de place: ", subtitle: "${ticket.seatNumber}"),
                            const SizedBox(height: 5,),
                          ],
                        ),
                      ),
                    ),
                  );
                }
            )
          ];
        }
        else if (snap.hasError) {
          children = <Widget>[
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('Erreur: ${snap.error}'),
            ),
          ];
        } else {
          children = <Widget>[
            SizedBox(
              height: 300,
            ),
            Center(
              child: CircularProgressIndicator( color: darkBackgroundColor,),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Chargement...'),
              ),
            ),
          ];
        }
        return ListView(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          children: children,
        );

      }
    );
  }

  Padding paddingText({required String title, required String subtitle}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: RichText(
        text:  TextSpan(
          text: title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: darkBackgroundColor
          ),
          children: [
            TextSpan(
              text: subtitle,
              style: const TextStyle(
                color: darkBackgroundColor,
                fontWeight: FontWeight.normal
              )
            )
          ]
        )
      )
    );
  }

  Widget content() {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return  Container(
      color: darkBackgroundColor.withOpacity(0.1),
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 9,
            child: SizedBox(
              height: height - 30,
              width: width/1.1,
              //child: (widget.tickets != null && widget.tickets != []) ? showTickets(context) : const SizedBox(),
              //child: myTicketList.isEmpty ? showTickets(context) : const SizedBox(),
              child: TabBarView(
                controller: controller,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    showUpComingTickets(context),
                    showPassedTickets(context),
                  ]
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: DefaultTabController(
              initialIndex: 0,
              length: 2,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: TabBar(
                  unselectedLabelColor: darkBackgroundColor,
                  controller: controller,
                  indicatorColor: Colors.transparent,
                  onTap: (int index){
                    controller.addListener(() {
                      return _handleTabSelection();
                    });
                  },
                  tabs: [
                    CustomTextButton(
                      onTap: (){
                        setState(() {
                          controller.animateTo(controller.index - 1);
                        });
                      },
                      color: controller.index == 0 ? darkBackgroundColor : darkBackgroundColor.withOpacity(0.6),
                      text: "A VENIR",
                    ),
                    CustomTextButton(
                      onTap: (){
                        setState(() {
                          controller.animateTo(controller.index + 1);
                        });
                      },
                      color: controller.index == 1 ? darkBackgroundColor : darkBackgroundColor.withOpacity(0.6),
                      text: "PASSÉS",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget showContent(){
    return Scaffold(
      appBar: const CustomAppBar(title: "Mes billets",),
      body: content(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Scaffold(
            body: IndexedStack(
            index: _selectedIndex,
            children: [
              const HomeScreen(),
              showContent(),
              //Add only if Category Mode is enabled From Admin panel.
              const ProfileScreen(),
            ],
          ),
          bottomNavigationBar: widget.from == 0 ? bottomBar() : const SizedBox()
        );
      },
    );
  }
}
