import 'package:al_marwa_water_app/core/constants/app_colors.dart';
import 'package:al_marwa_water_app/core/utils/validation.dart';
import 'package:al_marwa_water_app/viewmodels/auth_controller.dart';
import 'package:al_marwa_water_app/viewmodels/password_visibility_provider.dart';
import 'package:al_marwa_water_app/widgets/custom_elevated_button.dart';
import 'package:al_marwa_water_app/widgets/custom_textform_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:al_marwa_water_app/core/utils/custom_snackbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _salesCodeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // bool _rememberMe = false;
  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/back.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      height: 455,
                      width: 400,
                      decoration: BoxDecoration(
                        border:
                            Border.all(width: 2, color: colorScheme.primary),
                        color: colorScheme.primary.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              'Welcome Back',
                              style: textTheme.headlineSmall?.copyWith(
                                  color: AppColors.darkblue,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Account Login',
                            style: textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 32),
                          CustomTextFormField(
                              controller: _salesCodeController,
                              hint: 'Sales Code',
                              validator: (value) => Validation.fieldValidation(
                                  value, "Sales code")),
                          const SizedBox(height: 16),
                          Consumer<PasswordVisibilityProvider>(
                            builder: (context, provider, _) {
                              return CustomTextFormField(
                                controller: _passwordController,
                                hint: 'Password',
                                obscureText: !provider.isVisible,
                                validator: (value) =>
                                    Validation.passwordValidation(value),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    provider.isVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: provider.toggleVisibility,
                                ),
                              );
                            },
                          ),
                          // const SizedBox(height: 10),
                          // Row(
                          //   children: [
                          //     Checkbox(
                          //       value: _rememberMe,
                          //       onChanged: (value) {
                          //         setState(() {
                          //           _rememberMe = value ?? false;
                          //         });
                          //       },
                          //     ),
                          //     const SizedBox(width: 8),
                          //     Text(
                          //       'Remember Me',
                          //       style: textTheme.bodyMedium?.copyWith(
                          //         color: colorScheme.onSurface,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          const SizedBox(height: 24),
                          CustomElevatedButton(
                            text: "Login",
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                authController.login(
                                  context,
                                  _salesCodeController.text.trim(),
                                  _passwordController.text.trim(),
                                );
                              } else {
                                if (_salesCodeController.text.isEmpty ||
                                    _passwordController.text.isEmpty) {
                                  showSnackbar(
                                    message: "Please fill in all fields.",
                                    isError: true,
                                  );
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
