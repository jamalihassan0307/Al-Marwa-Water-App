import 'package:al_marwa_water_app/models/bills_model.dart';
import 'package:flutter/material.dart';

ColorScheme colorScheme(context) => Theme.of(context).colorScheme;

TextTheme textTheme(context) => Theme.of(context).textTheme;

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

const String isFirstTimeText = 'isFirstTime';
const String isJobSeekerText = 'isUser';
const String isLoggedInText = 'isLoggedIn';
String emailText = 'email';
String passwordText = 'password';
String nameText = 'name';
