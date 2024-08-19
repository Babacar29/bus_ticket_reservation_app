import 'dart:async';

import 'package:bus_ticket_reservation_app/cubits/availableCitiesCubit.dart';
import 'package:bus_ticket_reservation_app/cubits/commandCubit.dart';
import 'package:bus_ticket_reservation_app/cubits/trajetsCubit.dart';
import 'package:bus_ticket_reservation_app/ui/widgets/circularProgressIndicator.dart';
import 'package:bus_ticket_reservation_app/utils/hiveBoxKeys.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../../../data/models/CityModel.dart';
import '../../../utils/uiUtils.dart';
import '../../styles/colors.dart';
import '../../widgets/customTextBtn.dart';
import '../../widgets/myAppBar.dart';
import '../Tickets/TicketsScreen.dart';
import '../Profile/ProfileScreen.dart';

class ChooseDeparture extends StatefulWidget {
  final int? from;
  const ChooseDeparture({super.key, this.from});

  @override
  State<ChooseDeparture> createState() => _ChooseDepartureState();

  static Route route(RouteSettings routeSettings) {
    final arguments = routeSettings.arguments as Map<String, dynamic>;
    return CupertinoPageRoute(
        builder: (_) => ChooseDeparture(
          from: arguments['from'],
        )
    );
  }
}

class _ChooseDepartureState extends State<ChooseDeparture> {
  int _selectedIndex = 0;
  List<IconData> iconList = [
    Icons.bookmark,
    Icons.bookmark,
    Icons.account_circle,
  ];
  int numberPlaces = 0;
  String normalValue = "1";
  String departureValue = "";
  String arriveValue = "";
  bool showPlace = false;
  List routes = [];
  String departureId = "";
  List<String> selectedTimes = [];
  var box = Hive.box(authBoxKey);

  Map<String, dynamic> departureData = {
    "Ouagadougou": "Ouagadougou",
  };


  Map<String, dynamic> arriveData = {
    "Bobo Dioulasso": "Bobo Dioulasso",
  };

   Widget buildNavBarItem(IconData icon, int index) {
    return Material(
      color: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height/12,
          width: MediaQuery.of(context).size.width / iconList.length,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: index == _selectedIndex ? darkBackgroundColor : darkBackgroundColor.withOpacity(0.5),
                ),
                index == 0 ? Text(
                  "Réservations",
                  style: TextStyle(
                      color: index == _selectedIndex ? darkBackgroundColor : darkBackgroundColor.withOpacity(0.5),
                      fontWeight: FontWeight.w700
                  ),
                ) : const SizedBox(),
                index == 1 ? Text(
                  "Mes billets",
                  style: TextStyle(
                      color: index == _selectedIndex ? darkBackgroundColor : darkBackgroundColor.withOpacity(0.5),
                      fontWeight: FontWeight.w700
                  ),
                ) : const SizedBox(),
                index == 2 ? Text(
                  "Mon Compte",
                  style: TextStyle(
                      color: index == _selectedIndex ? darkBackgroundColor : darkBackgroundColor.withOpacity(0.5),
                      fontWeight: FontWeight.w700
                  ),
                ) : const SizedBox(),
              ],
            ),
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
          //borderRadius: const BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
          boxShadow: [
            BoxShadow(blurRadius: 6, offset: const Offset(5.0, 5.0), color: darkBackgroundColor.withOpacity(0.4), spreadRadius: 0),
          ],
        ),
        child: ClipRRect(
            //borderRadius: const BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
            child: Row(
              children: navBarItemList,
            )
        )
    );
  }

  Future<dynamic> getCategories() async{
    final result = await context.read<CommandCubit>().getCategories(context: context);
    return result;
  }

  /*Widget showTickets (){
    return BlocConsumer<AvailableCitiesCubit, AvailableCitiesState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Container(
          color: finexsBackgroundColor,
          child: Column(
            children: [
              const SizedBox(height: 20,),
              const Padding(
                padding:  EdgeInsets.only(left: 20.0, right: 20),
                child:  SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Type de ticket",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                      Text(
                        "Nombre de place",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              FutureBuilder(
                  future: getCategories(),
                  builder: (context, AsyncSnapshot snap){
                    List<Widget> children;
                    if(snap.hasData){
                      children = <Widget>[
                        ListView.builder(
                          //itemCount: widget.tickets?.length,
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snap.data.length,
                            itemBuilder: (context, int i){
                              var category = snap.data[i];
                              return buildChoiceRow(title: category["name"], choosedValue: category["name"] == "Classique" ? normalValue : "0", numbersList: Validators.normalList(), id: category["id"]);
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
                        const SizedBox(
                          height: 300,
                        ),
                        const Center(
                          child: CircularProgressIndicator( color: darkBackgroundColor,),
                        ),
                        const Center(
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
              ),
              const Spacer(),
              CustomTextButton(
                onTap: (){
                  if(categoryData.isEmpty){
                    return;
                  }
                  getCities();
                },
                color: categoryData.isEmpty ? Colors.grey : darkBackgroundColor,
                text: "VALIDER",
                width: MediaQuery.sizeOf(context).width,
              ),
              const SizedBox(height: 10,),
            ],
          ),
        );
      },
    );
  }*/

  getCities() async{
    var categoryData = box.get("categories");
    List values = categoryData.values.toList();
    int n = 0;
    for (var element in values) {
      n = n + int.parse("$element");
    }

    setState(() {
      showPlace = true;
      numberPlaces = n;
    });
    debugPrint("number places ======+> $numberPlaces");
    final result = await context.read<AvailableCitiesCubit>().getAvailableCities(context: context);
    final arriveItems = result["arrivalCities"].cast<Map<String, dynamic>>();
    final departureItems = result["departureCities"].cast<Map<String, dynamic>>();
    List<City> arriveCities = arriveItems.map<City>((json) {
      return City.fromJson(json);
    }).toList();
    List<City> departureCities = departureItems.map<City>((json) {
      return City.fromJson(json);
    }).toList();
    Map<String, dynamic> depCitiesById = { for (var e in departureCities) e.id : e.name };
    Map<String, dynamic> arrCitiesById = { for (var e in arriveCities) e.id : e.name };
    setState(() {
      arriveData = arrCitiesById;
      departureData = depCitiesById;
    });
  }

  Widget showPlaces (){
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return BlocConsumer<TrajetsCubit, TrajetsState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Container(
          color: backgroundColor,
          child: Column(
            children: [
              SizedBox(height: height/60,),
              const Padding(
                padding:  EdgeInsets.only(left: 20.0, right: 20),
                child:  SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Ville de départ",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: height/80,),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: SizedBox(
                  height: height/20,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: DropdownButtonFormField(
                              isExpanded: true,
                              iconEnabledColor: Colors.grey,
                              dropdownColor: Colors.white,
                              iconSize: 30,
                              items: departureData.map((value, key) {
                                return MapEntry(
                                  value,
                                  DropdownMenuItem<String>(
                                      value: value.toString(),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Text(
                                          key,
                                          style: const TextStyle(
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16
                                          ),
                                        ),
                                      )
                                  ),
                                );
                              }).values.toList(),
                              hint: const Text("Chosir une ville de départ"),
                              //value: departureValue,
                              onChanged: (value) {
                                setState(() {
                                  departureValue = value!;
                                });
                              },
                              style: const TextStyle(color: Colors.black87),
                              decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none
                                  )
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: height/35,),
              const Padding(
                padding:  EdgeInsets.only(left: 20.0, right: 20),
                child:  SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Ville d'arrivée",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: height/80,),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: SizedBox(
                  height: height/20,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: DropdownButtonFormField(
                              isExpanded: true,
                              iconEnabledColor: Colors.grey,
                              dropdownColor: Colors.white,
                              iconSize: 30,
                              items: arriveData.map((value, key) {
                                return MapEntry(
                                  value,
                                  DropdownMenuItem<String>(
                                      value: value.toString(),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Text(
                                          key,
                                          style: const TextStyle(
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16
                                          ),
                                        ),
                                      )
                                  ),
                                );
                              }).values.toList(),
                              hint: const Text("Chosir une ville d'arrivée"),
                              //value: arriveValue,
                              onChanged: (value) {
                                setState(() {
                                  arriveValue = value!;
                                });
                              },
                              style: const TextStyle(color: Colors.black87),
                              decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none
                                  )
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: height/60,),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: SizedBox(
                  height: height/16,
                  child: CustomTextButton(
                    onTap: () async{
                      if(arriveValue.isEmpty || departureValue.isEmpty){
                        return;
                      }
                      search();
                    },
                    color: (arriveValue.isEmpty || departureValue.isEmpty) ? Colors.grey : darkBackgroundColor,
                    text: "RECHERCHER",
                    width: MediaQuery.sizeOf(context).width,
                  ),
                ),
              ),
              //const SizedBox(height: 20,),
              SizedBox(
                height: height/2.4,
                child: ListView.builder(
                    itemCount: routes.length,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (context, int i){
                      var data = routes[i];
                      var departure = data["departures"];
                      //debugPrint("departures ==========> $departure");
                      return Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0, top: 15),
                                child: Text(
                                  DateFormat('d-MMMM-yyyy').format(DateTime.tryParse("${data["date"]}")!),
                                  textScaler: const TextScaler.linear(1.1),
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
                              )
                            ],
                          ),
                          departure != null ? ListView.builder(
                              itemCount: departure.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, int i){
                                var key = departure.keys.toList()[i].toString();
                                //debugPrint("data =========>${departure[key]}");
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 5.0, top: 5),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 10,),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20.0),
                                            child: Text(
                                              key.replaceAll("//", " - "),
                                              textScaler: const TextScaler.linear(1.1),
                                              style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 5,),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 20.0, right: 20),
                                        child: GridView.builder(
                                          physics: const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: departure[key].toList().length,
                                          gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            childAspectRatio: 2,
                                          ),
                                          itemBuilder: (context, int i){
                                            var departureValue = departure[key][i];
                                            String hour = departureValue["trajectTime"].toString().substring(0, 2);
                                            String minute = departureValue["trajectTime"].toString().substring(3, 5);
                                            String hourTime = "$hour : $minute";
                                            return departureValue["full"] == true ? Stack(
                                              children: [
                                                ChoiceChip(
                                                  label: Text(
                                                    hourTime,
                                                    textScaler: const TextScaler.linear(1.3),
                                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                                  ),
                                                  selected: false,
                                                  backgroundColor: Colors.grey,
                                                  selectedColor: Colors.grey,
                                                  showCheckmark: false,
                                                  onSelected: (bool selected) {
                                                  },
                                                ),
                                                Positioned(
                                                  top: height/150,
                                                  left: width/80,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        color: Colors.red,
                                                        border: Border.all(color: Colors.white)
                                                    ),
                                                    child: const Padding(
                                                      padding: EdgeInsets.all(2.0),
                                                      child: Text(
                                                        "Plein",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 8
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ) : Stack(
                                              children: [
                                                ChoiceChip(
                                                    label: Text(
                                                      hourTime,
                                                      textScaler: const TextScaler.linear(1.3),
                                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                                    ),
                                                    selected: selectedTimes.contains("${data["date"]} $key $hourTime"),
                                                    backgroundColor: departureValue["full"] == true ? Colors.grey : darkBackgroundColor,
                                                    selectedColor: Colors.greenAccent,
                                                    showCheckmark: false,
                                                    onSelected: (bool selected) {
                                                      setState(() {
                                                        if(selected){
                                                          selectedTimes.clear();
                                                          selectedTimes.add("${data["date"]} $key $hourTime");
                                                          departureId = departureValue["id"];
                                                          box.put("departureId", departureId);
                                                        }
                                                        else{
                                                          selectedTimes.remove("${data["date"]} $key $hourTime");
                                                        }
                                                      });
                                                    },
                                                ),
                                                departureValue["full"] == true ? Positioned(
                                                  top: height/150,
                                                  right: height/25,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        color: Colors.red,
                                                        border: Border.all(color: Colors.white)
                                                    ),
                                                    child: const Padding(
                                                      padding: EdgeInsets.all(2.0),
                                                      child: Text(
                                                        "Plein",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 8
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ) : const SizedBox(),
                                                departureValue["vip"] == true ? Positioned(
                                                  top: height/150,
                                                  right: height/25,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(color: Colors.white),
                                                        color: Colors.yellow
                                                    ),
                                                    child: const Padding(
                                                      padding: EdgeInsets.all(3.0),
                                                      child: Text(
                                                        "VIP",
                                                        style: TextStyle(
                                                            color: darkBackgroundColor,
                                                            fontSize: 8
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ) : const SizedBox(),
                                                (departureValue["vip"] == false && departureValue["full"] == false) ? Positioned(
                                                  top: height/150,
                                                  right: height/25,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(color: Colors.yellow),
                                                        color: Colors.white
                                                    ),
                                                    child: const Padding(
                                                      padding: EdgeInsets.all(3.0),
                                                      child: Text(
                                                        "Eco",
                                                        style: TextStyle(
                                                            color: darkBackgroundColor,
                                                            fontSize: 7.5
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ) : const SizedBox(),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                          ) : const SizedBox(),
                          const Divider(color: Colors.black26,)
                        ],
                      );
                    }
                ),
              ),
              const Spacer(),
              BlocConsumer<CommandCubit, CommandState>(
                listener: (context, state) {
                  if(state is CommandFailure){
                    showCustomSnackBar(context: context, message: state.errorMessage);
                  }
                },
                builder: (context, state) {
                  return CustomTextButton(
                    onTap: () async{
                      if(selectedTimes.isEmpty){
                        showCustomSnackBar(context: context, message: "Veuillez choisir une horaire");
                        return;
                      }
                      var cat = box.get("categories");
                      //Navigator.of(context).pushNamed(Routes.chooseSit, arguments: {"from": 1});
                      debugPrint('category =======+> $cat');
                      debugPrint('number seat =======+> $numberPlaces');
                      context.read<CommandCubit>().getCommand(context: context, departureId: departureId, placesCat: cat, numberSeats: numberPlaces);
                    },
                    color: selectedTimes.isEmpty ? Colors.grey : darkBackgroundColor,
                    text: "VALIDER",
                    width: MediaQuery.sizeOf(context).width,
                  );
                },
              ),
              const SizedBox(height: 10,),
            ],
          ),
        );
      },
    );
  }

  void search() async{
    if(departureValue == arriveValue){
      setState(() {
        routes.clear();
      });
      showCustomSnackBar(context: context, message: "Oops! Vous devez choisir une ville de départ et une ville d'arrivée différentes");
      return;
    }
    final result = await context.read<TrajetsCubit>().getTrajets(context: context, depId: departureValue, arrId: arriveValue, placeCount: numberPlaces);
    //debugPrint("result: $result" );
    setState(() {
      routes = result;
    });
  }

  Widget showContent(){
    return Scaffold(
      appBar: const CustomAppBar(title: "Sélectionnez un trajet"),
      //appBar: CustomAppBar(title: showPlace ? "Sélectionnez un trajet" : "Les passagers du voyage",),
      //body: showPlace ? showPlaces() : showTickets(),
      body: showPlaces(),
    );
  }

  /*Padding buildChoiceRow({required String title, required String choosedValue, required Map<String, String> numbersList, required String id }) {
    return Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          key: Key(title),
          child: SizedBox(
            //width: 300,
            height: 35,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                      title,
                    style: const TextStyle(
                      fontSize: 17,
                      color: Colors.black87
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: DropdownButtonFormField(
                      isExpanded: true,
                      iconEnabledColor: Colors.grey,
                      iconSize: 30,
                      items: numbersList.map((key, value) {
                        return MapEntry(
                          value,
                          DropdownMenuItem<String>(
                              value: value.toString(),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  key,
                                  style: const TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17
                                  ),
                                ),
                              )
                          ),
                        );
                      }).values.toList(),
                      value: choosedValue,
                      onChanged: (value) {
                        if(value != "0"){
                          setState(() {
                            categoryData.addAll(
                                {
                                  id : int.parse(value ?? "")
                                }
                            );
                          });
                        }
                        debugPrint("keys ========> $value");
                      },
                      style: const TextStyle(color: Colors.black87),
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide.none
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide.none
                          )
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
  }*/

  @override
  void initState() {
    getCities();
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
          const TicketsScreen( ),
          const ProfileScreen(),
        ],
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: bottomBar(),
    );
  }
}
