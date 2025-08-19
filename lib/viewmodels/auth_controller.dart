import 'dart:developer';
import 'package:al_marwa_water_app/core/utils/custom_snackbar.dart';
import 'package:al_marwa_water_app/repositories/auth_repository.dart';
import 'package:al_marwa_water_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController with ChangeNotifier {
  final AuthRepository authRepository = AuthRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _token;
  int? _userId;

  // Getters to use these values in other screens
  String? get token => _token;
  int? get userId => _userId;

  Future<void> login(
      BuildContext context, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      context.loaderOverlay.show();
      final response = await authRepository.login(email, password);

      if (response['status'] == true) {
        // ✅ Store token and ID locally
        _token = response['token'];
        _userId = response['user']['id'];
        log("login Successful $response");
        log("✅ Token stored: $_token");
        log("✅ User ID stored: $_userId");

        showSnackbar(
          message: 'Login successful',
          isError: false,
        );

        Navigator.pushReplacementNamed(
          context,
          AppRoutes.homeScreen,
        );

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', _userId.toString());
      } else {
        throw Exception(response['message'] ?? 'Invalid credentials');
      }
    } catch (e) {
      final errorMessage = e.toString();
      print(e);
      if (errorMessage.contains('401') ||
          errorMessage.contains('credentials') ||
          errorMessage.contains('password') ||
          errorMessage.contains('usercode')) {
        showSnackbar(
          message: 'Incorrect usercode or password.',
          isError: true,
        );
      } else {
        showSnackbar(
          message: 'Something went wrong. Please try again.',
          isError: true,
        );
        print("❌ Login error: $e");
      }
    } finally {
      _isLoading = false;
      notifyListeners();
      context.loaderOverlay.hide();
    }
  }

  void setUserId(int id) {
    _userId = id;
    notifyListeners(); // optional, only if UI needs to rebuild
  }

  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // ❌ Clears all stored preferences

    _token = null;
    _userId = null;
    notifyListeners(); // Refresh dependent UI if needed

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.loginScreen,
      (route) => false,
    );
  }
}
