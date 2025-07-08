import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foriyana_app/core/util/date_format.dart';
import 'package:foriyana_app/core/util/string_util.dart';
import 'package:foriyana_app/presentation/notused/statistic_cubit.dart';

@immutable
abstract class ChartState {}

class ChartInitial extends ChartState {}

class ChartLoaded<T> extends ChartState {
  final dynamic dates;
  final String metric;

  ChartLoaded(this.dates, this.metric);
}

class ChartCubit extends Cubit<ChartState> {
  ChartCubit() : super(ChartInitial()); // Default data

  void updateSelectedMetric(dynamic dates, String metric) {
    emit(ChartLoaded(dates, metric)); // Emit new data for the chart
  }
}

class ReportChartWidget extends StatefulWidget {
  final dynamic dates;
  final String metric;
  const ReportChartWidget({
    super.key,
    required this.dates,
    required this.metric,
  });

  @override
  State<ReportChartWidget> createState() => ReportChartWidgetState();
}

class ReportChartWidgetState extends State<ReportChartWidget> {
  Map<String, dynamic> dates = {
    // "2025-04-01": {"Personal Info": 1},
    // "2025-04-02": {"Personal Info": 2},
    // "2025-04-03": {"Personal Info": 3},
  };
  List<FlSpot> dataSpots = [];
  String selectedMetric = 'Personal Info';
  List valueList = [];

  @override
  void initState() {
    setDataChart();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setDataChart() {
    dates = widget.dates;
    this.selectedMetric = widget.metric;
    valueList.clear();
    dataSpots = dates.entries.toList().asMap().entries.map((entry) {
      double val = double.parse(
        entry.value.value[selectedMetric].toString(),
      );
      valueList.add(val);
      return FlSpot(entry.key.toDouble(), val);
    }).toList();
    valueList.sort();
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
      color: Color(0xff848A9C),
    );
    String text = '';

    int index = value.toInt();
    List dateKeys = dates.keys.toList();
    if (index >= 0 && index < dates.length) {
      final date = DateTime.parse(dateKeys[index]);
      final formatted = DateUtil.formatQuery(
        date,
        dateFormat: 'd MMM',
      ); // contoh: 17 Mar
      // Ambil format tanggal: "04-01"
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Transform.rotate(
          angle: -0.7, // Miring ke kiri, bisa ubah sesuai selera
          child: Text(formatted, style: TextStyle(fontSize: 10)),
        ),
      );
      // return Text(
      //   StringUtil.castToString(dateKeys[index]).substring(5),
      //   style: TextStyle(fontSize: 10),
      // );
    }
    return Text(text, style: style, textAlign: TextAlign.left);
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
      color: Color(0xff848A9C),
    );
    String text = value.toInt().toString();
    return Text(text, style: style, textAlign: TextAlign.left);
  }

  @override
  Widget build(BuildContext context) {
    setDataChart();

    return Container(
      height: 300,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            drawHorizontalLine: true,
            horizontalInterval: 1,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return const FlLine(
                color: Color.fromARGB(255, 206, 205, 205),
                strokeWidth: 1,
              );
            },
            getDrawingVerticalLine: (value) {
              return const FlLine(
                color: Color.fromARGB(255, 206, 205, 205),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                // reservedSize: 80,
                interval: valueList.isNotEmpty && valueList.length > 7
                    ? valueList.length / 7
                    : 1,
                getTitlesWidget: bottomTitleWidgets,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: valueList.isNotEmpty && valueList.last > 10
                    ? valueList.last / 10
                    : 1, //valueList.isNotEmpty ? valueList.length / 1 : 10,
                getTitlesWidget: leftTitleWidgets,
                // reservedSize: 42,
              ),
            ),
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              // tooltipBgColor: Colors.black.withOpacity(0.7),
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final index = spot.spotIndex;
                  List dateKeys = dates.keys.toList();
                  final date = DateTime.parse(dateKeys[index]);
                  final formattedDate = DateUtil.formatQuery(
                    date,
                    dateFormat: 'd MMM',
                  ); // contoh: 10 Apr
                  final value = spot.y.toInt(); // misal: 5.0

                  return LineTooltipItem(
                    '$formattedDate\nTotal: $value',
                    const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      // fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList();
              },
            ),
            handleBuiltInTouches: true,
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xff37434d)),
          ),
          minX: 0,
          maxX: dataSpots.length.toDouble() - 1,
          minY: 0,
          maxY: valueList.isNotEmpty ? valueList.last : 10,
          lineBarsData: [
            LineChartBarData(
              spots: dataSpots,
              isCurved: false,
              color: Color(0xff0D4290),
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }
}
