import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:identity_card_app/constants.dart';

class CardWidget extends StatefulWidget {
  final IconData icon;
  final String labelText;
  final bool editMode;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final int maxLines;

  CardWidget({@required this.icon, @required this.labelText, @required this.editMode, @required this.controller, this.keyboardType = TextInputType.text, this.maxLines = 1});

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(seconds: 2), vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      child: ListTileTheme(
        child: cardListTile(
          onTap: (() {
            displayPopup(context);
          }),
        ),
      ),
    );
  }

  displayPopup(BuildContext context) {
    showGeneralDialog(
      barrierLabel: 'x',
      barrierDismissible: true,
      context: context,
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            elevation: 10,
            titlePadding: EdgeInsets.all(10),
            contentPadding: EdgeInsets.all(10),
            backgroundColor: Colors.white,
            contentTextStyle: kTextStyle,
            content: Container(
              padding: EdgeInsets.all(10.0),
              child: AutoSizeText(
                widget.controller.text,
                style: kTextStyle.copyWith(fontSize: 18.0),
              ),
            ) /*cardListTile(fontSize: 18.0)*/,
          ),
        );
      },
      transitionBuilder: _buildSlideTransition,
    );
  }

  Widget _buildSlideTransition(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
      position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(animation),
      child: child,
    );
  }

  Widget _buildRotationTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return RotationTransition(
      turns: CurvedAnimation(
        parent: animation,
        curve: Curves.decelerate,
        reverseCurve: Curves.decelerate,
      ),
      child: child,
    );
  }

  Widget cardListTile({onTap, fontSize}) {
    return ListTile(
      enabled: true,
      leading: Icon(
        widget.icon,
        color: Colors.grey[800],
        size: 24.0,
      ),
      title: widget.editMode
          ? TextField(
              keyboardType: widget.keyboardType,
              maxLines: widget.maxLines,
              decoration: kTextFieldInputDecoration.copyWith(
                labelText: widget.labelText,
                contentPadding: EdgeInsets.all(11.0),
              ),
              controller: widget.controller,
              style: kTextStyle,
            )
          : AutoSizeText(
              widget.controller.text,
              maxLines: widget.maxLines,
              style: (fontSize == null) ? kTextStyle : kTextStyle.copyWith(fontSize: fontSize),
            ),
      onTap: () {
        if (!widget.editMode) {
          if (onTap != null) {
            onTap();
          }
        }
      },
    );
  }
}
