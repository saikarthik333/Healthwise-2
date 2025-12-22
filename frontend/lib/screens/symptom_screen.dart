import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'result_screen.dart';


class SymptomScreen extends StatefulWidget {
  const SymptomScreen({super.key});

  @override
  State<SymptomScreen> createState() => _SymptomScreenState();
}

class _SymptomScreenState extends State<SymptomScreen> {
  final List<String> symptoms = [
    "fever",
    "cough",
    "headache",
    "fatigue",
    "nausea",
    "dizziness"
  ];

  final Set<String> selectedSymptoms = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Symptom Checker"),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Select your symptoms",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: symptoms.length,
              itemBuilder: (context, index) {
                final symptom = symptoms[index];
                return CheckboxListTile(
                  title: Text(symptom),
                  value: selectedSymptoms.contains(symptom),
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        selectedSymptoms.add(symptom);
                      } else {
                        selectedSymptoms.remove(symptom);
                      }
                    });
                  },
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: selectedSymptoms.isEmpty
    ? null
    : () async {
        try {
          final result = await ApiService.predictDisease(
            selectedSymptoms.toList(),
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ResultScreen(
                disease: result["predicted_disease"],
                specialist: result["specialist"],
                remedies: result["remedies"],
              ),
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("API Error")),
          );
        }
      },

                child: const Text("Predict Disease"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
