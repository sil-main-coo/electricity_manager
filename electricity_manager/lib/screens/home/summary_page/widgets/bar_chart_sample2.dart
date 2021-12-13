import 'package:electricity_manager/screens/components/app_button_icon.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class BarChartSample extends StatefulWidget {
  const BarChartSample(
      {Key? key,
      this.label,
      this.callback,
      required this.data})
      : super(key: key);

  final String? label;
  final Function? callback;
  final Map<int, int> data;

  @override
  _BarChartSampleState createState() => _BarChartSampleState();
}

class _BarChartSampleState extends State<BarChartSample> {
  Map<int, int> _inputData = {};
  List<BarChartGroupData> _barGroups = [];
  int _maxY = 1;

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    _inputData = widget.data;
    _inputData.forEach((monthIndex, total) {
      if (_maxY < total) {
        _maxY = total;
      }
    });

    _barGroups = List<BarChartGroupData>.generate(
        _inputData.length,
            (index) => BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
                y: _inputData[index] == null
                    ? 0
                    : _inputData[index]!.toDouble(),
                colors: [Colors.lightBlueAccent, Colors.blue])
          ],
          showingTooltipIndicators: [0],
        ));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label!=null)
          Text(
            widget.label!.toUpperCase(),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
                color: Colors.blue[600]),
          ),
        SizedBox(
          height: 24.w,
        ),
        Container(
          height: 200.h,
          child: BarChart(
            BarChartData(
              barTouchData: barTouchData,
              titlesData: titlesData,
              borderData: borderData,
              barGroups: _barGroups,
              alignment: BarChartAlignment.spaceAround,
              maxY: _maxY.toDouble(),
            ),
          ),
        ),
        SizedBox(
          height: 8.w,
        ),
        if (widget.callback != null)
          AppIconButton(
            onPressed: () => widget.callback!(),
            label: 'Chi tiết',
            icon: Icons.arrow_forward,
          ),
      ],
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: const EdgeInsets.all(0),
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.y.round().toString(),
               TextStyle(
                color: Colors.grey,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            );
          },
        ),
      );

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => const TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          margin: 20,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return 'T1';
              case 1:
                return 'T2';
              case 2:
                return 'T3';
              case 3:
                return 'T4';
              case 4:
                return 'T5';
              case 5:
                return 'T6';
              case 6:
                return 'T7';
              case 7:
                return 'T8';
              case 8:
                return 'T9';
              case 9:
                return 'T10';
              case 10:
                return 'T11';
              case 11:
                return 'T12';
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(showTitles: true),
        topTitles: SideTitles(showTitles: false),
        rightTitles: SideTitles(showTitles: false),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );
}
