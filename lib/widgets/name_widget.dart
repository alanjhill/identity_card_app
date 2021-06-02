import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:identity_card_app/constants.dart';

class NameWidget extends StatelessWidget {
  final String labelText;
  final bool editMode;
  final TextEditingController controller;

  NameWidget({@required this.labelText, @required this.editMode, @required this.controller});

  @override
  Widget build(BuildContext context) {
    if (editMode) {
      return Container(
        child: TextField(
          textAlign: TextAlign.center,
          decoration: kTextFieldInputDecoration,
          controller: controller,
          style: kNameTextStyle,
        ),
      );
    } else {
      return AutoSizeText(
        controller.text,
        style: TextStyle(
          fontSize: 40.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: "Source Sans Serif",
          fontStyle: FontStyle.italic,
        ),
      );
    }
  }
}
