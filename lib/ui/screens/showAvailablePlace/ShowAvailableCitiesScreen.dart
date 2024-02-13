import 'package:burkina_transport_app/cubits/availableCitiesCubit.dart';
import 'package:burkina_transport_app/cubits/commandCubit.dart';
import 'package:burkina_transport_app/cubits/trajetsCubit.dart';
import 'package:burkina_transport_app/ui/widgets/circularProgressIndicator.dart';
import 'package:burkina_transport_app/utils/hiveBoxKeys.dart';
import 'package:burkina_transport_app/utils/validators.dart';
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

class ShowAvailableCities extends StatefulWidget {
  final int? from;
  const ShowAvailableCities({super.key, this.from});

  @override
  State<ShowAvailableCities> createState() => _ShowAvailableCitiesState();

  static Route route(RouteSettings routeSettings) {
    final arguments = routeSettings.arguments as Map<String, dynamic>;
    return CupertinoPageRoute(
        builder: (_) => ShowAvailableCities(
          from: arguments['from'],
        )
    );
  }
}

class _ShowAvailableCitiesState extends State<ShowAvailableCities> {
  int _selectedIndex = 0;
  List<IconData> iconList = [
    Icons.bookmark,
    Icons.bookmark,
    Icons.account_circle,
  ];
  int numberPlaces = 0;
  String normalValue = "1";
  String disabledValue = "0";
  String ajsbValue = "0";
  String visuallyImpairedValue = "0";
  String retiredValue = "0";
  String childrenValue = "0";
  String studentValue = "0";
  String departureValue = "Ouagadougou";
  String arriveValue = "Bobo Dioulasso";
  bool showPlace = false;
  List routes = [];
  String departureId = "";
  List<String> selectedTimes = [];
  var box = Hive.box(authBoxKey);
  Map<String, int> categoryData = {
    "612fcda81dc3f60432acab85": 1
  };

  Map<String, dynamic> departureData = {
    "Ouagadougou": "Ouagadougou",
  };


  Map<String, dynamic> arriveData = {
    "Bobo Dioulasso": "Bobo Dioulasso",
  };

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

  Widget showTickets (){
    return BlocConsumer<AvailableCitiesCubit, AvailableCitiesState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Container(
          color: darkBackgroundColor.withOpacity(0.1),
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
              buildChoiceRow(title: "Normal", choosedValue: normalValue, numbersList: Validators.normalList()),
              buildChoiceRow(title: "Handicapé", choosedValue: disabledValue, numbersList: Validators.disabledList()),
              buildChoiceRow(title: "Ajsb", choosedValue: ajsbValue, numbersList: Validators.asjbList()),
              buildChoiceRow(title: "Malvoyant", choosedValue: visuallyImpairedValue, numbersList: Validators.visuallyImpairedList()),
              buildChoiceRow(title: "Retraité", choosedValue: retiredValue, numbersList: Validators.retiredList()),
              buildChoiceRow(title: "Enfant", choosedValue: childrenValue, numbersList: Validators.childrenList()),
              buildChoiceRow(title: "Etudiant", choosedValue: studentValue, numbersList: Validators.studentList()),
              const Spacer(),
              CustomTextButton(
                onTap: (){
                  getCities();
                },
                color: darkBackgroundColor,
                text: "Valider",
              ),
              const SizedBox(height: 20,),
            ],
          ),
        );
      },
    );
  }

  getCities() async{
    setState(() {
      showPlace = true;
      numberPlaces = int.parse(normalValue) + int.parse(disabledValue) + int.parse(ajsbValue) + int.parse(visuallyImpairedValue) + int.parse(retiredValue) + int.parse(childrenValue) + int.parse(studentValue);
    });
    box.put("categories", categoryData);
    final result = await context.read<AvailableCitiesCubit>().getAvailableCities(context: context);
    final arriveItems = result["arrivalCities"].cast<Map<String, dynamic>>();
    final departureItems = result["departureCities"].cast<Map<String, dynamic>>();
    List<City> arriveCities = arriveItems.map<City>((json) {
      return City.fromJson(json);
    }).toList();
    List<City> departureCities = departureItems.map<City>((json) {
      return City.fromJson(json);
    }).toList();
    Map<String, dynamic> depCitiesById = Map.fromIterable(
        departureCities,
        key: (v) => v.id, value: (e) => e.name
    );
    Map<String, dynamic> arrCitiesById = Map.fromIterable(
        arriveCities,
        key: (v) => v.id, value: (e) => e.name
    );
    setState(() {
      arriveData = arrCitiesById;
      departureData = depCitiesById;
    });
  }

  Widget showPlaces (){
    return BlocConsumer<TrajetsCubit, TrajetsState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Container(
          color: darkBackgroundColor.withOpacity(0.1),
          child: Column(
            children: [
              const SizedBox(height: 30,),
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
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: SizedBox(
                  height: 45,
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
              const SizedBox(height: 30,),
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
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: SizedBox(
                  height: 45,
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
              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: SizedBox(
                  height: 60,
                  child: CustomTextButton(
                    onTap: () async{
                      final result = await context.read<TrajetsCubit>().getTrajets(context: context, depId: departureValue, arrId: arriveValue, placeCount: numberPlaces);
                      //debugPrint("result: $result" );
                      setState(() {
                        routes = result;
                      });

                    },
                    color: darkBackgroundColor,
                    text: "RECHERCHER",
                  ),
                ),
              ),
              //const SizedBox(height: 20,),
              SizedBox(
                height: MediaQuery.sizeOf(context).height/2.5,
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
                                  textScaler: TextScaler.linear(1.1),
                                  style: const TextStyle(fontWeight: FontWeight.bold),),
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
                                                crossAxisCount: 4,
                                                childAspectRatio: 2,
                                            ),
                                            itemBuilder: (context, int i){
                                              var departureValue = departure[key][i];
                                              String hour = departureValue["trajectTime"].toString().substring(0, 2);
                                              String minute = departureValue["trajectTime"].toString().substring(3, 5);
                                              String hourTime = "$hour : $minute";
                                              return ChoiceChip(
                                                  label: Text(
                                                    hourTime,
                                                    textScaler: TextScaler.linear(1.3),
                                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                                  ),
                                                  selected: selectedTimes.contains("${data["date"]} $key $hourTime"),
                                                  backgroundColor: darkBackgroundColor,
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
                                                  }
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
                      context.read<CommandCubit>().getCommand(context: context, departureId: departureId, placesCat: cat);
                    },
                    color: darkBackgroundColor,
                    text: "Valider",
                  );
                },
              ),
              const SizedBox(height: 20,),
            ],
          ),
        );
      },
    );
  }

  Widget showContent(){
    return Scaffold(
      appBar: CustomAppBar(title: showPlace ? "Sélectionnez un trajet" : "Les passagers du voyage",),
      body: showPlace ? showPlaces() : showTickets(),
    );
  }

  Padding buildChoiceRow({required String title, required String choosedValue, required Map<String, String> numbersList }) {
    return Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          key: Key(title),
          child: SizedBox(
            //width: 300,
            height: 45,
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
                        if(title == "Normal"){
                          setState(() {
                            normalValue = value!;
                          });
                          if(int.parse(disabledValue) != 0 || int.parse(disabledValue) != 1){
                            categoryData.update("612fcda81dc3f60432acab85", (value) => int.parse(normalValue));
                          }
                        }
                        if(title == "Handicapé"){
                          setState(() {
                            disabledValue = value!;
                          });
                          if(int.parse(disabledValue) != 0 ){
                            categoryData.addAll(
                                {
                                  "614726ca649b883dcdbbc850" : int.parse(disabledValue)
                                }
                            );
                          }
                        }
                        if(title == "Ajsb"){
                          setState(() {
                            ajsbValue = value!;
                          });
                          if(int.parse(ajsbValue) != 0 ){
                            categoryData.addAll(
                                {
                                  "614726d2649b883dcdbbc851" : int.parse(ajsbValue)
                                }
                            );
                          }
                        }
                        if(title == "Malvoyant"){
                          setState(() {
                            visuallyImpairedValue = value!;
                          });
                          if(int.parse(visuallyImpairedValue) != 0 ){
                            categoryData.addAll(
                                {
                                  "614726d9649b883dcdbbc852" : int.parse(visuallyImpairedValue)
                                }
                            );
                          }
                        }
                        if(title == "Retraité"){
                          setState(() {
                            retiredValue = value!;
                          });
                          if(int.parse(retiredValue) != 0 ){
                            categoryData.addAll(
                                {
                                  "614726df649b883dcdbbc853" : int.parse(retiredValue)
                                }
                            );
                          }
                        }
                        if(title == "Enfant"){
                          setState(() {
                            childrenValue = value!;
                          });
                          if(int.parse(childrenValue) != 0 ){
                            categoryData.addAll(
                                {
                                  "614726e4649b883dcdbbc854" : int.parse(childrenValue)
                                }
                            );
                          }
                        }
                        if(title == "Etudiant"){
                          setState(() {
                            studentValue = value!;
                          });
                          if(int.parse(studentValue) != 0 ){
                            categoryData.addAll(
                                {
                                  "614726e8649b883dcdbbc855" : int.parse(studentValue)
                                }
                            );
                          }
                        }

                        debugPrint("category ========> $categoryData");
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
  }

  @override
  void initState() {
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
      bottomNavigationBar: bottomBar(),
    );
  }
}
