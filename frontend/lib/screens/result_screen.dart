import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

import '../services/api_service.dart';
import 'doctor_locator_screen.dart';

class ResultScreen extends StatelessWidget {
  final String disease;
  final String specialist;
  final List remedies;
  final List<String> symptoms;

  const ResultScreen({
    super.key,
    required this.disease,
    required this.specialist,
    required this.remedies,
    required this.symptoms,
  });

  Future<void> downloadPdf(BuildContext context) async {
    try {
      final bytes = await ApiService.downloadReport(
        symptoms: symptoms,
        disease: disease,
        specialist: specialist,
        remedies: remedies,
      );

      final dir = await getApplicationDocumentsDirectory();
      final file = File("${dir.path}/health_report.pdf");
      await file.writeAsBytes(bytes);

      OpenFile.open(file.path);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to generate PDF report")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Prediction Result"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Predicted Disease
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Predicted Disease",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      disease,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Specialist
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Recommended Specialist",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      specialist,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Remedies
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "General Remedies & Precautions",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...remedies.map(
                      (remedy) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text("• $remedy"),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Doctor Locator Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.local_hospital),
                label: const Text("Find Nearby Doctors"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DoctorLocatorScreen(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // PDF Download Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text("Download Health Report"),
                onPressed: () => downloadPdf(context),


              ),
            ),
          ],
        ),
      ),
    );
  }
}
