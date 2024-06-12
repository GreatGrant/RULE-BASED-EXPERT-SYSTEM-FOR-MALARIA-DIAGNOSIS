import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rbes_for_malaria_diagnosis/services/patient_helper.dart';
import 'package:rbes_for_malaria_diagnosis/services/user_helper.dart';
import '../../services/diagnosis_result.dart';
import '../../util/malaria_diagnosis_chart.dart';

class DiagnosisScreen extends StatefulWidget {
  final String patientId;
  const DiagnosisScreen({super.key, required this.patientId});

  @override
  DiagnosisScreenState createState() => DiagnosisScreenState();
}

class DiagnosisScreenState extends State<DiagnosisScreen> {
  String diagnosisResult = 'Unknown';
  double diagnosisProbability = 0.0;
  List<String> selectedSymptoms = [];
  List<String> allSymptoms = DiagnosisService.getAllSymptoms();

  void _toggleSymptom(String symptom) {
    setState(() {
      if (selectedSymptoms.contains(symptom)) {
        selectedSymptoms.remove(symptom);
      } else {
        selectedSymptoms.add(symptom);
      }
    });
  }

  void _startDiagnosis() {
    DiagnosisResult result = DiagnosisService.diagnoseMalaria(selectedSymptoms);
    setState(() {
      diagnosisResult = result.diagnosis;
      diagnosisProbability = result.probability;
    });

    String recommendation = '';
    if (diagnosisResult == 'Malaria') {
      recommendation = 'Please consult a healthcare professional immediately for further evaluation and treatment.';
    } else if (diagnosisResult == 'Possible Malaria') {
      recommendation = 'Consider further assessment by a healthcare professional.';
    } else {
      recommendation = 'Monitor the symptoms closely and seek medical advice if they persist or worsen.';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Diagnosis Result'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Diagnosis: $diagnosisResult'),
                Text('Probability: ${(diagnosisProbability * 100).toStringAsFixed(2)}%'),
                Text('Recommendation: $recommendation'),
                SizedBox(
                  height: 250,
                  child: MalariaDiagnosisChart(probability: diagnosisProbability),
                ),
                const Text('Selected Symptoms:'),
                Column(
                  children: selectedSymptoms.map((symptom) => Text(symptom)).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () {
                _saveDiagnosisResult(diagnosisProbability);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _saveDiagnosisResult(double diagnosisProbability) {
    PatientHelper.saveDiagnosis(
      diagnosisResult: diagnosisResult,
      diagnosisProbability: diagnosisProbability,
      patientId: widget.patientId,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Malaria Diagnosis'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Symptoms',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: allSymptoms.length,
                itemBuilder: (context, index) {
                  final symptom = allSymptoms[index];
                  final isSelected = selectedSymptoms.contains(symptom);
                  return ElevatedButton(
                    onPressed: () => _toggleSymptom(symptom),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        isSelected ? Colors.blueGrey[900] : Colors.grey,
                      ),
                    ),
                    child: Text(symptom, style: const TextStyle(color: Colors.white)),
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: selectedSymptoms.isEmpty
                    ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select at least one symptom.')),
                  );
                }
                    : _startDiagnosis,
                child: const Text('Diagnose', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
