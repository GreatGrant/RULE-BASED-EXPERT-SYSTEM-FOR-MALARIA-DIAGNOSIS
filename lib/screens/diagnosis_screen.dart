/// Package import
library;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DiagnosisScreen extends StatefulWidget {
  final String title;
  const DiagnosisScreen({super.key, required this.title});

  @override
  State<DiagnosisScreen> createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends State<DiagnosisScreen> {
  List<String> selectedSymptoms = [];
  String diagnosisResult = '';
  double diagnosisProbability = 0.0;

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
    // Call diagnosis function with selected symptoms
    DiagnosisResult result = diagnoseMalaria(selectedSymptoms);
    // Assign diagnosis result and probability
    diagnosisResult = result.diagnosis;
    diagnosisProbability = result.probability;

    // Show diagnosis result after diagnosis
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
                SizedBox(
                  height: 250,
                  child: MalariaDiagnosisChart(probability: diagnosisProbability),
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
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      backgroundColor: Colors.blueGrey[100],
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Welcome to Malaria Diagnosis App',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Please select your symptoms below:',
                style: TextStyle(
                  fontSize: 16.0,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20.0),
              SymptomInput(selectedSymptoms: selectedSymptoms, toggleSymptom: _toggleSymptom),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  _startDiagnosis();
                },
                child: const Text('Start Diagnosis'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SymptomInput extends StatelessWidget {
  final List<String> selectedSymptoms;
  final Function(String) toggleSymptom;

  const SymptomInput({required this.selectedSymptoms, required this.toggleSymptom});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CheckboxListTile(
          title: const Text('Fever'),
          value: selectedSymptoms.contains('Fever'),
          onChanged: (value) {
            toggleSymptom('Fever');
          },
        ),
        CheckboxListTile(
          title: const Text('Shivering'),
          value: selectedSymptoms.contains('Shivering'),
          onChanged: (value) {
            toggleSymptom('Shivering');
          },
        ),
        CheckboxListTile(
          title: const Text('Headache'),
          value: selectedSymptoms.contains('Headache'),
          onChanged: (value) {
            toggleSymptom('Headache');
          },
        ),
        CheckboxListTile(
          title: const Text('Muscle Aches'),
          value: selectedSymptoms.contains('Muscle Aches'),
          onChanged: (value) {
            toggleSymptom('Muscle Aches');
          },
        ),
        CheckboxListTile(
          title: const Text('Fatigue'),
          value: selectedSymptoms.contains('Fatigue'),
          onChanged: (value) {
            toggleSymptom('Fatigue');
          },
        ),
        CheckboxListTile(
          title: const Text('Nausea'),
          value: selectedSymptoms.contains('Nausea'),
          onChanged: (value) {
            toggleSymptom('Nausea');
          },
        ),
        CheckboxListTile(
          title: const Text('Vomiting'),
          value: selectedSymptoms.contains('Vomiting'),
          onChanged: (value) {
            toggleSymptom('Vomiting');
          },
        ),
        CheckboxListTile(
          title: const Text('Diarrhea'),
          value: selectedSymptoms.contains('Diarrhea'),
          onChanged: (value) {
            toggleSymptom('Diarrhea');
          },
        ),
        CheckboxListTile(
          title: const Text('Sweating'),
          value: selectedSymptoms.contains('Sweating'),
          onChanged: (value) {
            toggleSymptom('Sweating');
          },
        ),
        // Add more symptom checkboxes here
      ],
    );
  }
}

class DiagnosisResult {
  final String diagnosis;
  final double probability;

  DiagnosisResult(this.diagnosis, this.probability);
}

DiagnosisResult diagnoseMalaria(List<String> symptoms) {
  // Rule-based logic for diagnosing malaria
  // Simulating complex rules for demonstration purposes

  // Initialize diagnosis and probability
  String diagnosis = 'Unknown';
  double probability = 0.0;

  // Define symptom combinations and their corresponding diagnoses and probabilities
  Map<List<String>, Map<String, double>> rules = {
    ['Fever', 'Shivering', 'Headache', 'Muscle Aches', 'Fatigue', 'Vomiting', 'Nausea']: {'Malaria': 0.9},
    ['Fever', 'Shivering', 'Headache', 'Muscle Aches', 'Fatigue', 'Vomiting']: {'Malaria': 0.85},
    ['Fever', 'Shivering', 'Headache', 'Muscle Aches', 'Fatigue']: {'Possible Malaria': 0.7},
    ['Fever', 'Shivering', 'Headache', 'Muscle Aches']: {'Possible Malaria': 0.65},
    ['Fever', 'Shivering', 'Headache']: {'Possible Malaria': 0.6},
    ['Headache']: {'Migraine': 0.8},
    // Add more rules for other symptom combinations
    ['Fever', 'Headache']: {'Possible Cold': 0.5},
    ['Fever', 'Muscle Aches', 'Fatigue']: {'Flu': 0.7},
    ['Fatigue']: {'Fatigue Syndrome': 0.6},
    ['Fever', 'Headache', 'Vomiting']: {'Gastroenteritis': 0.6},
    ['Fever', 'Muscle Aches']: {'Dengue Fever': 0.7},
    ['Fever', 'Shivering', 'Muscle Aches']: {'Typhoid Fever': 0.8},
    ['Shivering', 'Headache']: {'Flu': 0.6},
    ['Fever', 'Shivering', 'Muscle Aches', 'Fatigue']: {'Influenza': 0.8},
    ['Shivering', 'Muscle Aches']: {'Common Cold': 0.6},
    ['Fever', 'Nausea', 'Vomiting']: {'Stomach Flu': 0.7},
    ['Vomiting', 'Diarrhea']: {'Food Poisoning': 0.8},
    ['Fever', 'Sweating']: {'Heat Exhaustion': 0.6},
    ['Sweating']: {'Hyperhidrosis': 0.7},
    ['Fever', 'Diarrhea']: {'Possible Food Poisoning': 0.5},
    ['Diarrhea']: {'Gastrointestinal Infection': 0.6},
    ['Muscle Aches']: {'Muscle Strain': 0.6},
  };

  // Check if any symptom combination matches the selected symptoms
  for (var entry in rules.entries) {
    List<String> symptomsCombination = entry.key;
    Map<String, double> diagnosisInfo = entry.value;

    if (symptoms.every((symptom) => symptomsCombination.contains(symptom))) {
      // Calculate probability based on the number of matching symptoms
      probability = diagnosisInfo.values.first * (symptoms.length / symptomsCombination.length);
      diagnosis = diagnosisInfo.keys.first;
      break;
    }
  }

  return DiagnosisResult(diagnosis, probability);
}

class MalariaDiagnosisChart extends StatelessWidget {
  final double probability;

  const MalariaDiagnosisChart({super.key, required this.probability});

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      title: const ChartTitle(text: 'Diagnosis Result'),
      legend: const Legend(isVisible: true),
      series: <DoughnutSeries<ChartSampleData, String>>[
        DoughnutSeries<ChartSampleData, String>(
          dataSource: [
            ChartSampleData(x: 'Malaria', y: probability * 100),
            ChartSampleData(x: 'Other', y: 100 - (probability * 100)),
          ],
          xValueMapper: (ChartSampleData data, _) => data.x as String,
          yValueMapper: (ChartSampleData data, _) => data.y,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }
}

class ChartSampleData {
  final String? x;
  final double y;

  ChartSampleData({this.x, required this.y});
}
