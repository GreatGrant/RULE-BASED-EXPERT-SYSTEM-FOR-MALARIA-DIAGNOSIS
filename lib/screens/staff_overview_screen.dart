import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StaffOverviewScreen extends StatefulWidget {
  const StaffOverviewScreen({Key? key}) : super(key: key);

  @override
  _StaffOverviewScreenState createState() => _StaffOverviewScreenState();
}

class _StaffOverviewScreenState extends State<StaffOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Staff Overview'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Staff Distribution by Department',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            _buildPieChart(),
            SizedBox(height: 40),
            Text(
              'Staff Age Distribution',
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
        series: <PieSeries<StaffData, String>>[
          PieSeries<StaffData, String>(
            dataSource: _getStaffData(),
            xValueMapper: (StaffData staff, _) => staff.department,
            yValueMapper: (StaffData staff, _) => staff.count,
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
        series: <ColumnSeries<StaffData, String>>[
          ColumnSeries<StaffData, String>(
            dataSource: _getStaffData(),
            xValueMapper: (StaffData staff, _) => staff.department,
            yValueMapper: (StaffData staff, _) => staff.age,
            dataLabelSettings: DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    );
  }

  List<StaffData> _getStaffData() {
    // Dummy data, replace with actual staff data
    return [
      StaffData('Department 1', 15, 25),
      StaffData('Department 2', 20, 30),
      StaffData('Department 3', 10, 35),
      StaffData('Department 4', 18, 40),
      StaffData('Department 5', 25, 45),
    ];
  }
}

class StaffData {
  final String department;
  final int count;
  final int age;

  StaffData(this.department, this.count, this.age);
}
