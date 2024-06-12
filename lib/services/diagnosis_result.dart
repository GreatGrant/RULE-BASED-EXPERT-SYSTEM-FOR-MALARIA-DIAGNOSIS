class DiagnosisResult {
  final String diagnosis;
  final double probability;

  DiagnosisResult(this.diagnosis, this.probability);
}

class DiagnosisService {

  static List<String> getAllSymptoms(){
    return [
      'Fever', 'Chills', 'Headache', 'Nausea', 'Cough', 'Sore throat', 'Muscle Aches',
      'Fatigue', 'Vomiting', 'Diarrhea', 'Sweating', 'Weakness', 'Loss of Appetite',
      'Dizziness', 'Abdominal Pain', 'Jaundice', 'Rapid Heart Rate',
    ];
  }

  static DiagnosisResult diagnoseMalaria(List<String> symptoms) {
    String diagnosis = 'Unknown';
    double probability = 0.0;

    Map<List<String>, Map<String, double>> rules = {
      ['Fever', 'Chills', 'Headache', 'Nausea', 'Muscle Aches', 'Fatigue', 'Vomiting']: {'Malaria': 0.9},
      ['Fever', 'Chills', 'Headache', 'Nausea', 'Muscle Aches', 'Fatigue']: {'Possible Malaria': 0.85},
      ['Fever', 'Chills', 'Headache', 'Nausea', 'Muscle Aches']: {'Possible Malaria': 0.7},
      ['Fever', 'Chills', 'Headache', 'Nausea']: {'Possible Malaria': 0.65},
      ['Fever', 'Chills', 'Headache']: {'Possible Malaria': 0.6},
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
      ['Fever', 'Chills', 'Headache', 'Fatigue', 'Sweating']: {'Possible Malaria': 0.75},
      ['Fever', 'Chills', 'Headache', 'Muscle Aches', 'Sweating']: {'Possible Malaria': 0.8},
      ['Fever', 'Chills', 'Headache', 'Fatigue', 'Loss of Appetite']: {'Possible Malaria': 0.7},
      ['Fever', 'Chills', 'Headache', 'Fatigue', 'Rapid Heart Rate']: {'Possible Malaria': 0.7},
      ['Fever', 'Chills', 'Headache', 'Nausea', 'Dizziness']: {'Possible Malaria': 0.65},
      ['Fever', 'Chills', 'Headache', 'Nausea', 'Abdominal Pain']: {'Possible Malaria': 0.65},
      ['Fever', 'Chills', 'Headache', 'Nausea', 'Jaundice']: {'Possible Malaria': 0.8},
      ['Fever', 'Chills', 'Headache', 'Nausea', 'Weakness']: {'Possible Malaria': 0.7},
    };

    for (var entry in rules.entries) {
      List<String> symptomsCombination = entry.key;
      Map<String, double> diagnosisInfo = entry.value;

      if (symptoms.every((symptom) => symptomsCombination.contains(symptom))) {
        probability = diagnosisInfo.values.first * (symptoms.length / symptomsCombination.length);
        diagnosis = diagnosisInfo.keys.first;
        break;
      }
    }

    return DiagnosisResult(diagnosis, probability);
  }
}
