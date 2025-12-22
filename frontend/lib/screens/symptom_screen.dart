import 'package:flutter/material.dart';

import '../services/api_service.dart';
import 'result_screen.dart';

class SymptomScreen extends StatefulWidget {
  const SymptomScreen({super.key});

  @override
  State<SymptomScreen> createState() => _SymptomScreenState();
}

class _SymptomScreenState extends State<SymptomScreen> {
  List<String> symptoms = [];
  final Set<String> selectedSymptoms = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadSymptoms();
  }

  Future<void> loadSymptoms() async {
    try {
      final data = await ApiService.fetchSymptoms();
      setState(() {
        symptoms = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load symptoms")),
      );
    }
  }

  Future<void> predictDisease() async {
    if (selectedSymptoms.isEmpty) return;

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
            symptoms: selectedSymptoms.toList(), // ✅ REQUIRED
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Prediction failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Symptom Checker"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Select your symptoms",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Dynamic symptom list
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
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

          // Predict button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed:
                    selectedSymptoms.isEmpty ? null : predictDisease,
                child: const Text(
                  "Predict Disease",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
