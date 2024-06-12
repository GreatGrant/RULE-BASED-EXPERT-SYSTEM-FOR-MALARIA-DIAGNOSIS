
import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
  final String x;
  final double y;

  ChartSampleData({required this.x, required this.y});
}
