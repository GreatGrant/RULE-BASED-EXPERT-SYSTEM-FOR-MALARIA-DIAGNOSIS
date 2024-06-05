import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rbes_for_malaria_diagnosis/services/user_helper.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StaffOverviewScreen extends StatefulWidget {
  const StaffOverviewScreen({super.key});

  @override
  State<StaffOverviewScreen> createState() => _StaffOverviewScreenState();
}

class _StaffOverviewScreenState extends State<StaffOverviewScreen> {
  late Future<List<StaffData>> _staffDataFuture;

  @override
  void initState() {
    super.initState();
    _staffDataFuture = UserHelper.fetchStaffData(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Staff Overview', style: TextStyle(color: Colors.blueGrey[900])),
      ),
      body: FutureBuilder<List<StaffData>>(
        future: _staffDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child:  LoadingIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data', style: TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available', style: TextStyle(color: Colors.blueGrey[900])));
          } else {
            List<StaffData> data = snapshot.data!;
            int totalStaff = data.length;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
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
                  const SizedBox(height: 20),
                  Text(
                    'Staff Distribution by Department',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[900],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildPieChart(data),
                  const SizedBox(height: 40),
                  Text(
                    'Staff Age Distribution',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[900],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildColumnChart(data),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildPieChart(List<StaffData> data) {
    Map<String, int> departmentDistribution = {};
    for (var staff in data) {
      departmentDistribution[staff.department] =
          (departmentDistribution[staff.department] ?? 0) + 1;
    }
    List<StaffData> pieData = departmentDistribution.entries
        .map((entry) => StaffData(entry.key, entry.value, 0))
        .toList();

    return Container(
      height: 300,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blueGrey[900],
      ),
      child: SfCircularChart(
        legend: const Legend(
          isVisible: true,
          position: LegendPosition.bottom,
          textStyle: TextStyle(color: Colors.white),
        ),
        series: <PieSeries<StaffData, String>>[
          PieSeries<StaffData, String>(
            dataSource: pieData,
            xValueMapper: (StaffData staff, _) => staff.department,
            yValueMapper: (StaffData staff, _) => staff.count,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelPosition: ChartDataLabelPosition.outside,
              textStyle: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColumnChart(List<StaffData> data) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16.0),
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
          labelStyle: TextStyle(color: Colors.white, fontSize: 14),
        ),
        primaryYAxis: const NumericAxis(
          labelStyle: TextStyle(color: Colors.white, fontSize: 14),
        ),
        series: <ColumnSeries<StaffData, String>>[
          ColumnSeries<StaffData, String>(
            name: 'Age',
            dataSource: data,
            xValueMapper: (StaffData staff, _) => staff.department,
            yValueMapper: (StaffData staff, _) => staff.age,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelPosition: ChartDataLabelPosition.inside,
              textStyle: TextStyle(color: Colors.white),
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
