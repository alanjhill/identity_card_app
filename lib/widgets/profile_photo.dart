import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class ProfilePhoto extends StatefulWidget {
  final bool editMode;
  final File image;
  final Function onPressedCallback;

  ProfilePhoto({this.editMode, this.image, this.onPressedCallback});

  @override
  _ProfilePhotoState createState() => _ProfilePhotoState();
}

class _ProfilePhotoState extends State<ProfilePhoto> {
  @override
  Widget build(BuildContext context) {
    if (widget.editMode) {
      return EditablePhoto(
        image: widget.image,
        onPressedCallback: widget.onPressedCallback,
      );
    } else {
      return StaticPhoto(
        image: widget.image,
      );
    }
  }
}

class EditablePhoto extends StatefulWidget {
  final image;
  final Function onPressedCallback;

  EditablePhoto({this.image, this.onPressedCallback});

  @override
  _EditablePhotoState createState() => _EditablePhotoState();
}

class _EditablePhotoState extends State<EditablePhoto> {
  MenuItem selectedMenuItem;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 140.0,
          width: 140.0,
          padding: EdgeInsets.all(10.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 60.0,
            backgroundImage: widget.image == null ? AssetImage("images/defaultPhoto.png") : Image.file(widget.image).image,
          ),
        ),
        Container(
          height: 140.0,
          width: 140.0,
          alignment: Alignment.topRight,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<MenuItem>(
              isDense: true,
              icon: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: Icon(
                  Icons.add_a_photo,
                  color: Colors.grey[400],
                ),
              ),
              iconSize: 28,
              onChanged: (MenuItem menuItem) {
                setState(() {
                  selectedMenuItem = menuItem;
                  widget.onPressedCallback(menuItem.text);
                });
              },
              items: choices.map((selection) {
                return DropdownMenuItem<MenuItem>(
                  value: selection,
                  child: Text(selection.text),
                );
              }).toList(),
            ),
          ),
        )
      ],
    );
  }
}

class StaticPhoto extends StatelessWidget {
  final image;

  StaticPhoto({this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140.0,
      width: 140.0,
      padding: EdgeInsets.all(10.0),
      child: CircleAvatar(
        radius: 60.0,
        backgroundImage: image == null ? AssetImage("images/defaultPhoto.png") : Image.file(image).image,
      ),
    );
  }
}

class MenuItem {
  String text;
  Function callback;

  MenuItem({this.text, this.callback});
}

List choices = [
  MenuItem(text: 'Camera', callback: null),
  MenuItem(text: 'Gallery', callback: null),
  MenuItem(text: 'Default', callback: null),
];
