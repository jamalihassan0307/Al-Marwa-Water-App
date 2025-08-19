import 'package:al_marwa_water_app/core/constants/global_variable.dart';
import 'package:flutter/material.dart';

class QuantityRateRow extends StatelessWidget {
  final TextEditingController quantityController;
  final TextEditingController rateController;

  const QuantityRateRow({
    Key? key,
    required this.quantityController,
    required this.rateController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget numericTextField(
        String hint, TextEditingController controller, bool enable) {
      return TextFormField(
        enabled: enable,
        controller: controller,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Enter $hint';
          }
          if (double.tryParse(value) == null) {
            return 'Enter a valid number';
          }
          return null;
        },
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          hintStyle: TextStyle(
            color: Colors.grey[700],
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: colorScheme(context).primary,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: colorScheme(context).error,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: colorScheme(context).primary,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: colorScheme(context).error,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: numericTextField('Quantity', quantityController, true),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: numericTextField('Rate', rateController, true),
        ),
      ],
    );
  }
}
