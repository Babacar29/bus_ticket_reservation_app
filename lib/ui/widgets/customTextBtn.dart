// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../styles/colors.dart';

class CustomTextButton extends StatefulWidget {
  final Function onTap;
  final Color color;
  final String text;
  final double width;

  const CustomTextButton({Key? key, required this.onTap, required this.color, required this.text, required this.width}) : super(key: key);

  @override
  State<CustomTextButton> createState() => _CustomTextButtonState();
}

class _CustomTextButtonState extends State<CustomTextButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        widget.onTap();
      },
      child: Container(
        color: widget.color,
        width: widget.width,
        child: TextButton(
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            foregroundColor: MaterialStateProperty.all(darkBackgroundColor),
          ),
          onPressed: () {
            widget.onTap();
          },
          child: Text(widget.text, style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20)),
        ),
      ),
    );
  }
}
