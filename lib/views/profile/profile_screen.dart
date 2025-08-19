import 'package:al_marwa_water_app/routes/app_routes.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, AppRoutes.homeScreen, (route) => false);
            },
            icon: Icon(Icons.home, color: Colors.white),
          ),
        ],
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Profile Screen', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
