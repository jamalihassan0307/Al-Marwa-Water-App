import 'package:al_marwa_water_app/core/constants/global_variable.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final double? width;
  final double? height;
  final Color? buttonColor;
  final Color? borderColor;
  final TextStyle? textStyle;
  final double borderRadius;
  final double borderWidth;
  final VoidCallback onPressed;
  final IconData? icon;
  final double? iconSize;
  final Color? iconColor;

  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
    this.buttonColor,
    this.borderColor,
    this.textStyle,
    this.borderRadius = 10.0,
    this.borderWidth = 2.0,
    this.icon,
    this.iconSize,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 50,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(
            buttonColor ?? colorScheme(context).primary,
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              side: BorderSide(
                color: borderColor ?? Colors.transparent,
                width: borderWidth,
              ),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: iconSize ?? 20,
                color: iconColor ?? Theme.of(context).colorScheme.onPrimary,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: textStyle ??
                  textTheme(context).titleSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
