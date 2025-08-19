import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  final String label1;
  final String value1;

  const InfoRow({
    Key? key,
    required this.label1,
    required this.value1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget labelWithValue(String label, String value) {
      final color = Theme.of(context).colorScheme.secondary;
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.blue.shade100),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: color,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    return Row(
      children: [
        Expanded(flex: 3, child: labelWithValue(label1, value1)),
      ],
    );
  }
}
