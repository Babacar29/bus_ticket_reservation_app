import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../utils/uiUtils.dart';
import '../styles/colors.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key, required this.title
  });
  final String title;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

class _CustomAppBarState extends State<CustomAppBar> {

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        widget.title,
        textScaler: TextScaler.linear(1.0),
        style: const TextStyle(
            color: Colors.white,
        ),
      ),
      centerTitle: true,
      leading: Image(image: AssetImage(UiUtils.getImagePath("ic_new_logo-playstore.png"))),
      actions: [
        IconButton(
            onPressed: (){
              showDialog(
                  context: context,
                  builder: (context){
                    return GestureDetector(
                      onTap: (){
                        Navigator.of(context).pushNamed(Routes.privacy, arguments: {"from": "0"});
                      },
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: MediaQuery.sizeOf(context).height/1.3, left: MediaQuery.sizeOf(context).width/4),
                          child: SimpleDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero
                            ),
                            children: [
                              Text(
                                "Conditions générales",
                                textAlign: TextAlign.center,
                                textScaler: TextScaler.linear(1.2),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }
              );
            },
            icon: Icon(Icons.more_vert, color: Colors.white,)
        )
      ],
      backgroundColor: darkBackgroundColor,
    );
  }
}
