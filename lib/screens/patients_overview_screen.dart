import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PatientsOverviewScreen extends StatefulWidget {
  const PatientsOverviewScreen({Key? key}) : super(key: key);

  @override
  State<PatientsOverviewScreen> createState() => _PatientsOverviewScreenState();
}

class _PatientsOverviewScreenState extends State<PatientsOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patients Overview'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Patients Distribution by Gender',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            _buildPieChart(),
            SizedBox(height: 40),
            Text(
              'Patients Age Distribution',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            _buildColumnChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    return Container(
      height: 300,
      child: SfCircularChart(
        series: <PieSeries<PatientData, String>>[
          PieSeries<PatientData, String>(
            dataSource: _getPatientData(),
            xValueMapper: (PatientData patient, _) => patient.gender,
            yValueMapper: (PatientData patient, _) => patient.count,
            dataLabelSettings: DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    );
  }

  Widget _buildColumnChart() {
    return Container(
      height: 300,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        series: <ColumnSeries<PatientData, String>>[
          ColumnSeries<PatientData, String>(
            dataSource: _getPatientData(),
            xValueMapper: (PatientData patient, _) => patient.gender,
            yValueMapper: (PatientData patient, _) => patient.age,
            dataLabelSettings: DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    );
  }

  List<PatientData> _getPatientData() {
    // Dummy data, replace with actual patient data
    return [
      PatientData('Male', 100, 25),
      PatientData('Female', 150, 30),
    ];
  }
}

class PatientData {
  final String gender;
  final int count;
  final int age;

  PatientData(this.gender, this.count, this.age);
}
