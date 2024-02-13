import 'package:burkina_transport_app/cubits/commandCubit.dart';
import 'package:burkina_transport_app/utils/hiveBoxKeys.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

import '../../../utils/uiUtils.dart';
import '../../cubits/Payments/paymentCubit.dart';
import '../../utils/ErrorMessageKeys.dart';
import '../../utils/internetConnectivity.dart';
import '../../utils/validators.dart';
import '../styles/colors.dart';
import '../widgets/circularProgressIndicator.dart';
import '../widgets/customTextBtn.dart';
import '../widgets/customTextLabel.dart';
import '../widgets/myAppBar.dart';
import 'Profile/ProfileScreen.dart';
import 'Tickets/TicketsScreen.dart';

enum DocumentType { CNIB, Passeport }

class GetUserInfos extends StatefulWidget {
  final int? from;
  final Map<String, dynamic> commandData;
  const GetUserInfos({super.key, this.from, required this.commandData});

  @override
  State<GetUserInfos> createState() => _GetUserInfosState();

  static Route route(RouteSettings routeSettings) {
    final arguments = routeSettings.arguments as Map<String, dynamic>;
    return CupertinoPageRoute(
        builder: (_) => GetUserInfos(
          from: arguments['from'],
          commandData: arguments['commandData'],
        )
    );
  }
}

class _GetUserInfosState extends State<GetUserInfos> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController firstNameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  TextEditingController docController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController expirationDateController = new TextEditingController();
  DocumentType documentType = DocumentType.CNIB;
  List<TextEditingController> firstNameControllers = [];
  List<TextEditingController> lastNameControllers = [];
  List data = [];

  int _selectedIndex = 0;
  List<IconData> iconList = [
    Icons.bookmark,
    Icons.bookmark,
    Icons.account_circle,
  ];
  var box = Hive.box(authBoxKey);


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

  showDateTimeDialog() async{
    return await showOmniDateTimePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 3652),
      ),
      is24HourMode: false,
      isShowSeconds: false,
      minutesInterval: 1,
      secondsInterval: 1,
      type: OmniDateTimePickerType.date,
      theme: ThemeData(
        cardColor: darkBackgroundColor,
        primaryColor: Colors.white,
      ),
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      constraints: const BoxConstraints(
        maxWidth: 350,
        maxHeight: 650,
      ),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1.drive(
            Tween(
              begin: 0,
              end: 1,
            ),
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true
    );
  }

  Widget showBody (BuildContext context){
    final width = MediaQuery.sizeOf(context).width;
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Voyageur principal", style: TextStyle(fontWeight: FontWeight.bold,), textScaler: TextScaler.linear(1.2), ),
              const SizedBox(height: 20),
              buildField(width: width, title: "Nom", controller: lastNameController, hintText: ""),
              const SizedBox(height: 20),
              buildField(width: width, title: "Prénom", controller: firstNameController, hintText: ""),
              const SizedBox(height: 20),
              buildField(width: width, title: "Numéro de téléphone", controller: phoneController, hintText: ""),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Type de document",
                    textScaler: TextScaler.linear(1.12),
                  ),
                  const SizedBox(width: 20,),
                  Row(
                    children: [
                      Radio<DocumentType>(
                        value: DocumentType.CNIB,
                        groupValue: documentType,
                        onChanged: (DocumentType? value){
                          setState(() {
                            documentType = value!;
                          });
                        },
                        activeColor: Colors.greenAccent,
                      ),
                      const Text("CNIB")
                    ],
                  ),
                  const SizedBox(width: 10,),
                  Row(
                    children: [
                      Radio<DocumentType>(
                        value: DocumentType.Passeport,
                        groupValue: documentType,
                        onChanged: (DocumentType? value){
                          setState(() {
                            documentType = value!;
                          });
                        },
                        activeColor: Colors.greenAccent,
                      ),
                      const Text("Passeport")
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              buildField(width: width, title: "Numéro du document", controller: docController, hintText: ""),
              const SizedBox(height: 20),
              SizedBox(
                width: width,
                height: 70,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Flexible(
                        flex: 2,
                        child: Text("Date d'expiration", textScaler: TextScaler.linear(1.1),)
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Flexible(
                      flex: 4,
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
                          hintText: "",
                          hintStyle: TextStyle(
                            color: Colors.grey.withOpacity(0.4),
                            fontSize: 16,
                          ),
                        ),
                        validator: (val){
                          if(expirationDateController.text.isEmpty){
                            return Validators.notEmptyValidation(val!, context);
                          }
                        },
                        onTap: () async{
                          DateTime dateTime = await showDateTimeDialog();
                          expirationDateController.text = DateFormat('yyyy-MM-dd').format(dateTime);
                        },
                        cursorHeight: 18,
                        controller: expirationDateController,
                        cursorColor: Colors.black,
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16
                        ),
                        onChanged: (String value) {
                          _formkey.currentState!.validate();
                        },
                        textAlignVertical: TextAlignVertical.center,
                      ),
                    ),
                  ],
                ),
              ),
              (widget.commandData["ticketIdList"].length > 1) ? const SizedBox(height: 20) : const SizedBox(),
              (widget.commandData["ticketIdList"].length > 1) ? const Text("Autres passagers", style: TextStyle(fontWeight: FontWeight.bold,), textScaler: TextScaler.linear(1.2), ) : const SizedBox(),
              (widget.commandData["ticketIdList"].length > 1) ? buildOtherPassengerFields(width) : const SizedBox(),
              const SizedBox(height: 20),
              CustomTextButton(
                onTap: () async{
                  //Navigator.of(context).pushNamed(Routes.chooseSit, arguments: {"from": 1});
                  chooseSeatHintDialog();
                },
                color: darkBackgroundColor,
                text: "Valider",
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  chooseSeatHintDialog() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (BuildContext context, StateSetter setStater) {
            return AlertDialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
              content: CustomTextLabel(text: 'chooseSitHintLbl', textStyle: Theme.of(this.context).textTheme.titleMedium?.copyWith(color: UiUtils.getColorScheme(context).primaryContainer)),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        child: CustomTextLabel(
                            text: 'noLbl', textStyle: Theme.of(this.context).textTheme.titleSmall?.copyWith(color: UiUtils.getColorScheme(context).primaryContainer, fontWeight: FontWeight.bold)),
                        onPressed: () async{
                          FocusScope.of(context).unfocus();
                          submit(false);
                        }
                    ),
                    TextButton(
                        child: CustomTextLabel(
                            text: 'yesLbl', textStyle: Theme.of(this.context).textTheme.titleSmall?.copyWith(color: UiUtils.getColorScheme(context).primaryContainer, fontWeight: FontWeight.bold)),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          submit(true);
                        })
                  ],
                ),
              ],
            );
          });
        });
  }

  void submit(bool willChooseSit) async{
    //debugPrint("is validate ===>${validateAndSave()}");
    if(validateAndSave()){
      data.clear();
      var principal = {
        "firstName" : firstNameController.text,
        "lastName": lastNameController.text,
        "ticketId": "${widget.commandData["ticketIdList"][0]}",
        "phoneNumber": phoneController.text,
        "documentType": await UiUtils().getDocumentType(documentType.toString()),
        "issueDate": expirationDateController.text,
        "serialNumber": docController.text,
        "main": true
      };
      if(!data.contains(principal)){
        data.add(principal);
      }

      //widget.commandData["ticketIdList"].removeAt(0);
      for(var i = 0; i < (widget.commandData["ticketIdList"].length - 1); i++) {
        var other = {
          "firstName" : firstNameControllers[i].text,
          "lastName": lastNameControllers[i].text,
          "ticketId": "${widget.commandData["ticketIdList"][i + 1]}"
        };
        if(!data.contains(other)){
          data.add(other);
        }
        debugPrint("data ==>$data");
      }
      context.read<CommandCubit>().sendPassengerData(context: context, data: data, commandData: widget.commandData, willChooseSeat: willChooseSit);
    }
  }

  SizedBox buildField(
      {required double width, required String title,
        required TextEditingController controller, required String hintText,
        TextInputType? textInputType, bool? isPhone
      }) {
    return SizedBox(
      width: width,
      height: 70,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 2,
            child: Text(title, textScaler: const TextScaler.linear(1.1),)
          ),
          Flexible(
            flex: 3,
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
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Colors.grey.withOpacity(0.4),
                  fontSize: 16,
                ),
              ),
              validator: (val){
                if(title == "Nom" || title == "Prénom" || title == "Numéro du document"){
                  return Validators.notEmptyValidation(val!, context);
                }
              },
              cursorHeight: 18,
              controller: controller,
              cursorColor: Colors.black,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16
              ),
              onChanged: (String value) {
                _formkey.currentState!.validate();
              },
              textAlignVertical: TextAlignVertical.center,
              keyboardType: textInputType ?? TextInputType.text,
            ),
          ),
        ],
      ),
    );
  }

  bool validateAndSave() {
    final form = _formkey.currentState;
    form!.save();
    if (form.validate()) {
      return true;
    } else {
      return false;
    }
  }

  Widget buildOtherPassengerFields(double width){
    //debugPrint("other pass ========>${}");
    //widget.commandData["ticketIdList"].removeAt(0);
    return ListView.builder(
        itemCount: widget.commandData["ticketIdList"].length - 1,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, int i){
          firstNameControllers.add( TextEditingController());
          lastNameControllers.add( TextEditingController());
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text("Passager ${i + 1}", style: const TextStyle(fontWeight: FontWeight.w500,), textScaler: const TextScaler.linear(1.2), ),
              const SizedBox(height: 10),
              SizedBox(
                width: width,
                height: 65,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Flexible(
                        flex: 2,
                        child: Text("Nom", textScaler: TextScaler.linear(1.1),)
                    ),
                    Flexible(
                      flex: 3,
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
                          hintText: "",
                          hintStyle: TextStyle(
                            color: Colors.grey.withOpacity(0.4),
                            fontSize: 16,
                          ),
                        ),
                        controller: lastNameControllers[i],
                        validator: (val) => Validators.notEmptyValidation(val!, context),
                        cursorHeight: 18,
                        cursorColor: Colors.black,
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16
                        ),
                        onChanged: (String value) {
                          _formkey.currentState!.validate();
                        },
                        textAlignVertical: TextAlignVertical.center,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: width,
                height: 70,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Flexible(
                        flex: 2,
                        child: Text("Prénom", textScaler: TextScaler.linear(1.1),)
                    ),
                    Flexible(
                      flex: 3,
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
                          hintText: "",
                          hintStyle: TextStyle(
                            color: Colors.grey.withOpacity(0.4),
                            fontSize: 16,
                          ),
                        ),
                        controller: firstNameControllers[i],
                        validator: (val) => Validators.notEmptyValidation(val!, context),
                        cursorHeight: 18,
                        cursorColor: Colors.black,
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16
                        ),
                        onChanged: (String value) {
                          _formkey.currentState!.validate();
                        },
                        textAlignVertical: TextAlignVertical.center,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          );
        }
    );
  }

  Widget showContent(){
    return Scaffold(
      appBar: const CustomAppBar(title: "Informations du voyageur"),
      backgroundColor: darkBackgroundColor.withOpacity(0.1),
      body: showBody(context),
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
          const TicketsScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: bottomBar(),
    );
  }
}
