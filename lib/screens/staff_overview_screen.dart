import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StaffOverviewScreen extends StatefulWidget {
  const StaffOverviewScreen({Key? key}) : super(key: key);

  @override
  _StaffOverviewScreenState createState() => _StaffOverviewScreenState();
}

class _StaffOverviewScreenState extends State<StaffOverviewScreen> {
  late List<StaffData> _staffData = [];

  @override
  void initState() {
    super.initState();
    _fetchStaffData();
  }

  Future<void> _fetchStaffData() async {
    try {
      QuerySnapshot staffSnapshot =
      await FirebaseFirestore.instance.collection('staff').get();

      setState(() {
        _staffData = staffSnapshot.docs.map((doc) {
          return StaffData(
            doc['department'] ?? '',
            1,
            int.parse(doc['age'] ?? '0'),
          );
        }).toList();
      });
    } catch (e) {
      print("Error fetching staff data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalStaff = _staffData.length;

    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        title: Text('Staff Overview', style: TextStyle(color: Colors.blueGrey[900])),
        backgroundColor: Colors.blueGrey[100],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Staff: $totalStaff',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[900],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Staff Distribution by Department',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[900],
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
                color: Colors.blueGrey[900],
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
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blueGrey[900],
      ),
      child: SfCircularChart(
        key: ValueKey<String>('staff_pie_chart'),
        legend: Legend(
          isVisible: true,
          position: LegendPosition.bottom,
          textStyle: TextStyle(color: Colors.white),
        ),
        series: <PieSeries<StaffData, String>>[
          PieSeries<StaffData, String>(
            key: ValueKey<String>('staff_pie_series'),
            dataSource: _staffData,
            xValueMapper: (StaffData staff, _) => staff.department,
            yValueMapper: (StaffData staff, _) => staff.count,
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              textStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColumnChart() {
    return Container(
      height: 300,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blueGrey[900],
      ),
      child: SfCartesianChart(
        key: ValueKey<String>('staff_column_chart'),
        legend: Legend(
          isVisible: true,
          position: LegendPosition.bottom,
          textStyle: TextStyle(color: Colors.white),
        ),
        primaryXAxis: CategoryAxis(
          labelStyle: TextStyle(color: Colors.white), // Adjusted label text color
        ),
        primaryYAxis: NumericAxis(
          labelStyle: TextStyle(color: Colors.white), // Adjusted label text color
        ),
        series: <ColumnSeries<StaffData, String>>[
          ColumnSeries<StaffData, String>(
            dataSource: _staffData,
            xValueMapper: (StaffData staff, _) => staff.department,
            yValueMapper: (StaffData staff, _) => staff.age,
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              textStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StaffData {
  final String department;
  final int count;
  final int age;

  StaffData(this.department, this.count, this.age);
}
