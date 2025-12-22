import 'package:flutter/material.dart';
import '../services/api_service.dart';

class DoctorLocatorScreen extends StatefulWidget {
  const DoctorLocatorScreen({super.key});

  @override
  State<DoctorLocatorScreen> createState() => _DoctorLocatorScreenState();
}

class _DoctorLocatorScreenState extends State<DoctorLocatorScreen> {
  final TextEditingController locationController = TextEditingController();
  List<dynamic> doctors = [];
  bool isLoading = false;



  Future<void> searchDoctors() async {
    if (locationController.text.isEmpty) return;

    setState(() {
      isLoading = true;
      doctors = [];
    });

    if (locationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid city name")),
        );
        return;
        }


    try {
      final result =
          await ApiService.fetchDoctors(locationController.text.trim());

      setState(() {
        doctors = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to fetch doctors")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Doctor Locator"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: locationController,
              decoration: const InputDecoration(
                labelText: "Enter your city",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: searchDoctors,
                child: const Text("Find Nearby Doctors"),
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : doctors.isEmpty
                      ? const Center(child: Text("No doctors found"))
                      : ListView.builder(
                          itemCount: doctors.length,
                          itemBuilder: (context, index) {
                            final doctor = doctors[index];
                            return Card(
                              child: ListTile(
                                leading: const Icon(Icons.local_hospital),
                                title: Text(doctor["name"] ?? "Unknown"),
                                subtitle: Text(
                                    "Lat: ${doctor["lat"]}, Lon: ${doctor["lon"]}"),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
