import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PatientsOverviewScreen extends StatefulWidget {
  const PatientsOverviewScreen({Key? key}) : super(key: key);

  @override
  State<PatientsOverviewScreen> createState() => _PatientsOverviewScreenState();
}

class _PatientsOverviewScreenState extends State<PatientsOverviewScreen> {
  late Future<List<PatientData>> _patientDataFuture;

  @override
  void initState() {
    super.initState();
    _patientDataFuture = _fetchPatientData();
  }

  Future<List<PatientData>> _fetchPatientData() async {
    List<PatientData> patientDataList = [];
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('patients')
          .get();
      snapshot.docs.forEach((doc) {
        String gender = doc['gender'];
        int age = int.parse(doc['age']);
        patientDataList.add(PatientData(gender, 1, age));
      });
      return patientDataList;
    } catch (e) {
      print("Error fetching patient data: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        title: Text('Patients Overview', style: TextStyle(color: Colors.blueGrey[900])),
        backgroundColor: Colors.blueGrey[100],
      ),
      body: FutureBuilder<List<PatientData>>(
        future: _patientDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching data', style: TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available', style: TextStyle(color: Colors.blueGrey[900]))); // Adjusted text color
          } else {
            List<PatientData> data = snapshot.data!;
            int totalPatients = data.length;
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Patients: $totalPatients',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[900],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Patients Distribution by Gender',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[900],
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildPieChart(data),
                  SizedBox(height: 40),
                  Text(
                    'Patients Age Distribution',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[900],
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildColumnChart(data),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildPieChart(List<PatientData> data) {
    Map<String, int> genderDistribution = {};
    data.forEach((patient) {
      genderDistribution[patient.gender] =
          (genderDistribution[patient.gender] ?? 0) + 1;
    });
    List<PatientData> pieData = genderDistribution.entries
        .map((entry) => PatientData(entry.key, entry.value, 0))
        .toList();

    return Container(
      height: 300,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blueGrey[900],
      ),
      child: SfCircularChart(
        legend: Legend(
          isVisible: true,
          position: LegendPosition.bottom,
          textStyle: TextStyle(color: Colors.white),
        ),
        series: <PieSeries<PatientData, String>>[
          PieSeries<PatientData, String>(
            dataSource: pieData,
            xValueMapper: (PatientData patient, _) => patient.gender,
            yValueMapper: (PatientData patient, _) => patient.count,
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              labelPosition: ChartDataLabelPosition.outside,
              textStyle: TextStyle(color: Colors.white), // Adjust label text color
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColumnChart(List<PatientData> data) {
    return Container(
      height: 300,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blueGrey[900],
      ),
      child: SfCartesianChart(
        legend: const Legend(
          isVisible: true,
          position: LegendPosition.bottom,
          textStyle: TextStyle(color: Colors.white),
        ),
        primaryXAxis: const CategoryAxis(
          labelStyle: TextStyle(color: Colors.white, fontSize: 14), // Adjust label text color and size
        ),
        primaryYAxis: const NumericAxis(
          labelStyle: TextStyle(color: Colors.white, fontSize: 14), // Adjust label text color and size
        ),
        series: <ColumnSeries<PatientData, String>>[
          ColumnSeries<PatientData, String>(
            name: 'Age',
            dataSource: data,
            xValueMapper: (PatientData patient, _) => patient.gender,
            yValueMapper: (PatientData patient, _) => patient.age,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelPosition: ChartDataLabelPosition.inside,
              textStyle: TextStyle(color: Colors.white), // Adjust label text color
            ),
          ),
        ],
      ),
    );
  }

}

class PatientData {
  final String gender;
  final int count;
  final int age;

  PatientData(this.gender, this.count, this.age);
}
