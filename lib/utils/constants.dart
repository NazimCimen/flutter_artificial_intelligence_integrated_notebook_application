import 'package:flutter/material.dart';
import 'package:my_demo_app/utils/colors.dart';

TextEditingController titleController = TextEditingController();
TextEditingController noteController = TextEditingController();
FocusNode focusNodeNote = FocusNode();
FocusNode focusNodeTitle = FocusNode();

TextStyle styleLight = TextStyle(fontFamily: 'Riot', color: myWhite);
TextStyle styleDark = TextStyle(fontFamily: 'Riot', color: myDark1);
