import 'package:electricity_manager/data/remote/resolve_report_remote_provider.dart';
import 'package:electricity_manager/data/remote/take_back_report_remote_provider.dart';
import 'package:electricity_manager/di/locator.dart';
import 'package:electricity_manager/models/resolve_report_model.dart';
import 'package:electricity_manager/models/take_back_report_model.dart';
import 'package:electricity_manager/screens/home/summary_page/summary_export_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'summary_take_back_page.dart';
import 'widgets/bar_chart_sample2.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({Key? key}) : super(key: key);

  @override
  _SummaryPageState createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  final _takeBackReportsDB = getIt.get<TakeBackReportRemoteProvider>();
  final _resolveReportsDB = getIt.get<ResolveReportRemoteProvider>();
  final _now = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildTakeBackBody(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.w),
              child: Divider(),
            ),
            _exportDevice()
          ],
        ),
      ),
    );
  }

  Widget _buildTakeBackBody() {
    return FutureBuilder<Map<int, List<TakeBackReportModel>>>(
      future: _takeBackReportsDB.getReportsInYear(_now.year),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          final reports = snapshot.data!;
          Map<int, int> takeBackMap = {};

          reports.forEach((monthIndex, reports) {
            if (reports.isEmpty) {
              takeBackMap[monthIndex] = 0;
            } else {
              if (takeBackMap[monthIndex] == null) {
                takeBackMap[monthIndex] = 0;
              }
              reports.forEach((rp) {
                takeBackMap[monthIndex] =
                    takeBackMap[monthIndex]! + rp.deviceTotal();
              });
            }
          });
          return BarChartSample(
            label: 'Vật tư thu hồi/năm',
            data: takeBackMap,
            callback: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => SummaryTakeBackPage(
                          reportsInYear: reports,
                        ))),
          );
        }
        return Center(
          child: const CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _exportDevice() {
    return FutureBuilder<Map<int, List<ResolveReportModel>>>(
      future: _resolveReportsDB.getReportsInYear(_now.year),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          final reports = snapshot.data!;
          Map<int, int> exportMap = {};

          reports.forEach((monthIndex, reports) {
            if (reports.isEmpty) {
              exportMap[monthIndex] = 0;
            } else {
              if (exportMap[monthIndex] == null) {
                exportMap[monthIndex] = 0;
              }
              reports.forEach((rp) {
                exportMap[monthIndex] =
                    exportMap[monthIndex]! + rp.deviceTotal();
              });
            }
          });
          return BarChartSample(
            label: 'Vật tư xuất kho/năm',
            data: exportMap,
            callback: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => SummaryResolvePage(
                          reportsInYear: reports,
                        ))),
          );
        }
        return Center(
          child: const CircularProgressIndicator(),
        );
      },
    );
  }
}
