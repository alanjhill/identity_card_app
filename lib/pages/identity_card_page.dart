import 'dart:io';
import 'package:flutter/material.dart';
import 'package:identity_card_app/utils/prefs.dart';
import 'package:identity_card_app/widgets/card_widget.dart';
import 'package:identity_card_app/widgets/profile_photo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:identity_card_app/widgets/name_widget.dart';
import 'package:identity_card_app/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class IdentityCardPage extends StatefulWidget {
  @override
  _IdentityCardPageState createState() => _IdentityCardPageState();
}

class _IdentityCardPageState extends State<IdentityCardPage> {
  final _nameController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();

  bool _editMode = false;
  final imagePicker = ImagePicker();
  File _image;

  @override
  void initState() {
    super.initState();
    setState(() {
      _nameController.text = Prefs.getString('name') ?? '';
      _emailController.text = Prefs.getString('email') ?? '';
      _telephoneController.text = Prefs.getString('telephone') ?? '';
      _addressController.text = Prefs.getString('address') ?? '';
      _image = Prefs.getString('imagePath') != null ? File(Prefs.getString('imagePath')) : null;
    });
  }

  Future _selectPhoto(String selection) async {
    if (selection == 'Camera') {
      await _imageFromCamera();
    } else if (selection == 'Gallery') {
      await _imageFromGallery();
    } else if (selection == 'Default') {
      await _imageDefault();
    }
  }

  Future _imageFromCamera() async {
    final pickedFile = await imagePicker.getImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
    );

    final directory = await getApplicationDocumentsDirectory();

    setState(() {
      if (pickedFile?.path != null) {
        if (pickedFile.path != null) {
          File file = File(pickedFile.path);
          String filename = basename(file.path);
          file.copy('${directory.path}/${filename}');
          _image = File('${directory.path}/${filename}');
        }
      }
    });
  }

  Future _imageFromGallery() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

    final directory = await getApplicationDocumentsDirectory();

    setState(() {
      if (pickedFile.path != null) {
        File file = File(pickedFile.path);
        String filename = basename(file.path);
        file.copy('${directory.path}/${filename}');
        _image = File('${directory.path}/${filename}');
      }
    });
  }

  Future _imageDefault() async {
    setState(() {
      _image = null;
    });
  }

  void _editDetails() {
    // Update Text to Text Field
    setState(() {
      _editMode = true;
    });
  }

  void _saveDetails() {
    setState(() {
      Prefs.setString('name', _nameController.text);
      Prefs.setString('email', _emailController.text);
      Prefs.setString('telephone', _telephoneController.text);
      Prefs.setString('address', _addressController.text);
      Prefs.setString('imagePath', _image?.path);
      _editMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: kBackgroundColor,
          elevation: 1,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                _editMode ? Icons.check : Icons.edit,
              ),
              tooltip: 'Edit Details',
              onPressed: () {
                setState(() {
                  _editMode ? _saveDetails() : _editDetails();
                });
              },
            ),
          ],
        ),
        backgroundColor: kBackgroundColor,
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 50),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    child: ProfilePhoto(
                  editMode: this._editMode,
                  image: this._image,
                  onPressedCallback: this._selectPhoto,
                )),
                NameWidget(
                  labelText: 'Name',
                  editMode: _editMode,
                  controller: _nameController,
                ),
                SizedBox(
                  height: 20.0,
                  width: 150.0,
                  child: Divider(
                    color: Colors.white,
                  ),
                ),
                CardWidget(
                  icon: Icons.phone,
                  labelText: 'Telephone',
                  editMode: _editMode,
                  controller: _telephoneController,
                ),
                CardWidget(
                  icon: Icons.email,
                  labelText: 'Email',
                  editMode: _editMode,
                  controller: _emailController,
                ),
                CardWidget(
                  icon: Icons.house,
                  labelText: 'Address',
                  editMode: _editMode,
                  controller: _addressController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _addressController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _telephoneController.dispose();

    super.dispose();
  }
}
