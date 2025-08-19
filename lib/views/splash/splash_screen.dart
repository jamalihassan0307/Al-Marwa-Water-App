import 'dart:async';
import 'package:al_marwa_water_app/core/constants/global_variable.dart';
import 'package:al_marwa_water_app/routes/app_routes.dart';
import 'package:al_marwa_water_app/viewmodels/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:al_marwa_water_app/core/constants/app_images.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    Timer(const Duration(seconds: 3), () {
      _checkLogin();
    });
  }

  void _checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userIdString = prefs.getString('user_id');

    if (userIdString != null) {
      // Set the userId in your controller before navigating
      final authController =
          Provider.of<AuthController>(context, listen: false);
      authController.setUserId(int.parse(userIdString));

      // Now navigate to Home Screen
      Navigator.pushReplacementNamed(context, AppRoutes.homeScreen);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(AppImages.appLogo, width: 200, height: 200),
              const SizedBox(height: 10),
              Text(
                'Al Marwa',
                style: GoogleFonts.medievalSharp(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: colorScheme(context).primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
