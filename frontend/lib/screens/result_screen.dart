import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String disease;
  final String specialist;
  final List remedies;

  const ResultScreen({
    super.key,
    required this.disease,
    required this.specialist,
    required this.remedies,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Prediction Result")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Predicted Disease:",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(
              disease,
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Text("Recommended Specialist:",
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(specialist, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),

            Text("Remedies:",
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...remedies.map((r) => Text("• $r")).toList(),
          ],
        ),
      ),
    );
  }
}
