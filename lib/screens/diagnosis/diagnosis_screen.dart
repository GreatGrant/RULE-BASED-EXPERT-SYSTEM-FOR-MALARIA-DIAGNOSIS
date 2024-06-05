import 'package:flutter/material.dart';
import 'package:rbes_for_malaria_diagnosis/services/patient_helper.dart';
import 'package:rbes_for_malaria_diagnosis/services/user_helper.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DiagnosisScreen extends StatefulWidget {
  final String patientId;
  const DiagnosisScreen({super.key, required this.patientId});

  @override
  DiagnosisScreenState createState() => DiagnosisScreenState();
}

class DiagnosisScreenState extends State<DiagnosisScreen> {
  String diagnosisResult = 'Unknown'; // Initialize diagnosis result
  double diagnosisProbability = 0.0;
  List<String> selectedSymptoms = [];
  List<String> allSymptoms = [
    'Fever',
    'Chills',
    'Headache',
    'Nausea',
    'Cough',
    'Sore throat',
    'Muscle Aches',
    'Fatigue',
    'Vomiting',
    'Diarrhea',
    'Sweating',
    'Weakness',
    'Loss of Appetite',
    'Dizziness',
    'Abdominal Pain',
    'Jaundice',
    'Rapid Heart Rate',
  ];

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

    // Define recommendations based on diagnosis
    String recommendation = '';
    if (diagnosisResult == 'Malaria') {
      recommendation = 'Please advise the patient to consult a healthcare professional immediately for further evaluation and treatment.';
    } else if (diagnosisResult == 'Possible Malaria') {
      recommendation = 'Please consider further assessment by a healthcare professional.';
    } else {
      recommendation = "It's advisable to monitor the patient's symptoms closely and recommend seeking medical advice if they persist or worsen.";
    }

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
                Text('Recommendation: $recommendation'), // Add recommendation here
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
        context: context
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        title: Text('Malaria Diagnosis'),
        backgroundColor: Colors.blueGrey[100],
        actions: [
          IconButton(
            onPressed: () {
              UserHelper.logOut();
            },
            icon: Icon(Icons.logout, color: Colors.blueGrey[700],),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Select Symptoms',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    color: Colors.grey[300],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'All Symptoms',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: allSymptoms.map((symptom) {
                                bool isSelected = selectedSymptoms.contains(symptom);
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _toggleSymptom(symptom);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(isSelected ? Colors.blueGrey[900] : Colors.grey),
                                    ),
                                    child: Text(symptom, style: const TextStyle(color: Colors.white)),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.grey[300],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Selected Symptoms',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: selectedSymptoms.map((symptom) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _toggleSymptom(symptom);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.blueGrey[900]),
                                    ),
                                    child: Text(symptom, style: const TextStyle(color: Colors.white)),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blueGrey[900])),
            onPressed: () {
              if (selectedSymptoms.isEmpty) {
                // Show error message if no symptoms are selected
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please select at least one symptom.'),
                  ),
                );
              } else {
                _startDiagnosis();
              }
            },
            child: const Text('Diagnose', style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
  }
}

class DiagnosisResult {
  final String diagnosis;
  final double probability;
  final List<String> symptoms;

  DiagnosisResult(this.diagnosis, this.probability, this.symptoms);
}

DiagnosisResult diagnoseMalaria(List<String> symptoms) {
  // Rule-based logic for diagnosing malaria
  // Simulating complex rules for demonstration purposes

  // Initialize diagnosis and probability
  String diagnosis = 'Unknown';
  double probability = 0.0;
  List<String> matchedSymptoms = [];

  // Define all symptom combinations and their corresponding diagnoses and probabilities
  Map<List<String>, Map<String, double>> rules = {
    // Malaria
    ['Fever', 'Chills', 'Headache', 'Nausea', 'Muscle Aches', 'Fatigue', 'Vomiting']: {'Malaria': 0.9},
    ['Fever', 'Chills', 'Headache', 'Nausea', 'Muscle Aches', 'Fatigue']: {'Possible Malaria': 0.85},
    ['Fever', 'Chills', 'Headache', 'Nausea', 'Muscle Aches']: {'Possible Malaria': 0.7},
    ['Fever', 'Chills', 'Headache', 'Nausea']: {'Possible Malaria': 0.65},
    ['Fever', 'Chills', 'Headache']: {'Possible Malaria': 0.6},

    // Other Diagnoses
    ['Headache']: {'Migraine': 0.8},
    ['Fever', 'Headache']: {'Possible Cold': 0.5},
    ['Fever', 'Muscle Aches', 'Fatigue']: {'Flu': 0.7},
    ['Fatigue']: {'Fatigue Syndrome': 0.6},
    ['Fever', 'Headache', 'Vomiting']: {'Gastroenteritis': 0.6},
    ['Fever', 'Muscle Aches']: {'Dengue Fever': 0.7},
    ['Fever', 'Chills', 'Muscle Aches']: {'Typhoid Fever': 0.8},
    ['Chills', 'Headache']: {'Flu': 0.6},
    ['Fever', 'Chills', 'Muscle Aches', 'Fatigue']: {'Influenza': 0.8},
    ['Chills', 'Muscle Aches']: {'Common Cold': 0.6},
    ['Fever', 'Nausea', 'Vomiting']: {'Stomach Flu': 0.7},
    ['Vomiting', 'Diarrhea']: {'Food Poisoning': 0.8},
    ['Fever', 'Sweating']: {'Heat Exhaustion': 0.6},
    ['Sweating']: {'Hyperhidrosis': 0.7},
    ['Fever', 'Diarrhea']: {'Possible Food Poisoning': 0.5},
    ['Diarrhea']: {'Gastrointestinal Infection': 0.6},
    ['Muscle Aches']: {'Muscle Strain': 0.6},

    // Additional Rules
    ['Fever', 'Chills', 'Headache', 'Fatigue', 'Sweating']: {'Possible Malaria': 0.75},
    ['Fever', 'Chills', 'Headache', 'Muscle Aches', 'Sweating']: {'Possible Malaria': 0.8},
    ['Fever', 'Chills', 'Headache', 'Fatigue', 'Loss of Appetite']: {'Possible Malaria': 0.7},
    ['Fever', 'Chills', 'Headache', 'Fatigue', 'Rapid Heart Rate']: {'Possible Malaria': 0.7},
    ['Fever', 'Chills', 'Headache', 'Nausea', 'Dizziness']: {'Possible Malaria': 0.65},
    ['Fever', 'Chills', 'Headache', 'Nausea', 'Abdominal Pain']: {'Possible Malaria': 0.65},
    ['Fever', 'Chills', 'Headache', 'Nausea', 'Jaundice']: {'Possible Malaria': 0.8},
    ['Fever', 'Chills', 'Headache', 'Nausea', 'Weakness']: {'Possible Malaria': 0.7},
  };

  // Check if any symptom combination matches the selected symptoms
  for (var entry in rules.entries) {
    List<String> symptomsCombination = entry.key;
    Map<String, double> diagnosisInfo = entry.value;

    if (symptoms.every((symptom) => symptomsCombination.contains(symptom))) {
      // Calculate probability based on the number of matching symptoms
      probability = diagnosisInfo.values.first * (symptoms.length / symptomsCombination.length);
      diagnosis = diagnosisInfo.keys.first;
      matchedSymptoms = symptomsCombination;
      break;
    }
  }

  return DiagnosisResult(diagnosis, probability, matchedSymptoms);
}

class MalariaDiagnosisChart extends StatelessWidget {
  final double probability;

  const MalariaDiagnosisChart({Key? key, required this.probability}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      title: ChartTitle(text: 'Diagnosis Result'),
      legend: Legend(isVisible: true),
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
