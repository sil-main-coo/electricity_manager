import 'package:electricity_manager/data/remote/take_back_report_remote_provider.dart';
import 'package:electricity_manager/di/locator.dart';
import 'package:electricity_manager/models/take_back_report_model.dart';
import 'package:electricity_manager/screens/components/app_button.dart';
import 'package:electricity_manager/screens/components/app_button_icon.dart';
import 'package:electricity_manager/screens/create_reports/take_back_electricity/detail_take_back_report_screen.dart';
import 'package:electricity_manager/screens/home/summary_page/widgets/bar_chart_sample2.dart';
import 'package:electricity_manager/utils/commons/text_styles.dart';
import 'package:electricity_manager/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xls;
import 'widgets/navigator_bar_widget.dart';

class SummaryTakeBackPage extends StatefulWidget {
  const SummaryTakeBackPage({Key? key, required this.reportsInYear})
      : super(key: key);

  final Map<int, List<TakeBackReportModel>> reportsInYear;

  @override
  _SummaryTakeBackPageState createState() => _SummaryTakeBackPageState();
}

class _SummaryTakeBackPageState extends State<SummaryTakeBackPage> {
  late Map<int, List<TakeBackReportModel>> _reports;
  DateTime _currentDate = DateTime.now();

  bool _isError = false;
  bool _loading = false;

  final _reportsDB = getIt.get<TakeBackReportRemoteProvider>();

  @override
  void initState() {
    super.initState();
    _reports = widget.reportsInYear;
  }

  Future _fetchReportsInYear(int year) async {
    setState(() {
      _loading = true;
      _isError = false;
    });

    try {
      final result = await _reportsDB.getReportsInYear(year);
      setState(() {
        _reports = result;
      });
    } catch (e) {
      setState(() {
        _isError = true;
      });
    }

    setState(() {
      _loading = false;
    });
  }

  Future<void> _generateExcel(
      DateTime date, List<TakeBackReportModel> reports) async {
    //Create a Excel document.

    //Creating a workbook.
    final xls.Workbook workbook = xls.Workbook();
    //Accessing via index
    final xls.Worksheet sheet = workbook.worksheets[0];
    sheet.showGridlines = true;

    // Enable calculation for worksheet.
    sheet.enableSheetCalculations();

    //Set data in the worksheet.
    sheet.getRangeByName('B2:H4').merge();

    sheet.getRangeByName('B2').setText(
        'Bảng kê vật tư thu hồi ${Utils.dateToMonthAndYearString(date)}'
            .toUpperCase());
    sheet.getRangeByName('B2').cellStyle.fontSize = 22;
    sheet.getRangeByName('B2').cellStyle.hAlign = xls.HAlignType.center;
    sheet.getRangeByName('B2').cellStyle.vAlign = xls.VAlignType.center;

    sheet.getRangeByName('B5:H5').cellStyle.bold = true;
    sheet.getRangeByIndex(5, 2).setText('STT');
    sheet.getRangeByIndex(5, 3).setText('Thời gian');
    sheet.getRangeByIndex(5, 4).setText('Tên khách hàng');
    sheet.getRangeByIndex(5, 5).setText('Địa chỉ');
    sheet.getRangeByIndex(5, 6).setText('Tên vật tư');
    sheet.getRangeByIndex(5, 7).setText('Số lượng');
    sheet.getRangeByIndex(5, 8).setText('Ghi chú');

    int stt = 1;
    int row = 6;

    reports.forEach((rp) {
      if (rp.devices != null) {
        print(rp.devices!.length);
        for (int i = 0; i < rp.devices!.length; i++) {
          final device = rp.devices![i];
          sheet.getRangeByIndex(row, 2).setText('$stt'); // stt
          sheet.getRangeByIndex(row, 3).setText(rp.createAtString); // time
          sheet.getRangeByIndex(row, 4).setText(rp.clientName); // full name
          sheet.getRangeByIndex(row, 5).setText(rp.clientAddress); // address
          sheet.getRangeByIndex(row, 6).setText(device.name); // name
          sheet.getRangeByIndex(row, 7).setText(device.count.toString()); // sl
          sheet.getRangeByIndex(row, 8).setText(device.note); // note
          row++;
          stt++;
        }
      }
    });

    //Save and launch the excel.
    final List<int> bytes = workbook.saveAsStream();
    //Dispose the document.
    workbook.dispose();

    //Save and launch the file.
    await Utils.saveAndLaunchFile(bytes, 'thu-hoi-thang-${date.month}.xlsx');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thống kê vật tư thu hồi',
          style: titleWhite.copyWith(fontSize: 22.sp),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: NavigatorBarWidget(
        dateTime: _currentDate,
        onChanged: (date) async {
          if (_currentDate.year == date.year &&
              _currentDate.month == date.month) return;

          if (_currentDate.year == date.year) {
            setState(() {
              _currentDate = DateTime(date.year, date.month);
            });
          } else {
            setState(() {
              _currentDate = DateTime(date.year, date.month);
            });
            await _fetchReportsInYear(_currentDate.year);
          }
        },
      ),
      body: _isError
          ? Center(
              child: Text('Đã xảy ra lỗi. Vui lòng thử lại!'),
            )
          : _loading
              ? Center(
                  child: const CircularProgressIndicator(),
                )
              : _bodyWidget(),
    );
  }

  Widget _bodyWidget() {
    Map<int, int> chartMap = {};
    _reports.forEach((monthIndex, reports) {
      if (reports.isEmpty) {
        chartMap[monthIndex] = 0;
      } else {
        if (chartMap[monthIndex] == null) {
          chartMap[monthIndex] = 0;
        }
        reports.forEach((rp) {
          chartMap[monthIndex] = chartMap[monthIndex]! + rp.deviceTotal();
        });
      }
    });

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BarChartSample(
            data: chartMap,
          ),
          Center(
            child: Text(
              'Biểu đồ năm ${_currentDate.year}',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  color: Colors.blue[600]),
            ),
          ),
          SizedBox(
            height: 8.w,
          ),
          Divider(),
          SizedBox(
            height: 8.w,
          ),
          Row(
            children: [
              Text('Vật tư tháng ${_currentDate.month}'.toUpperCase(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp,
                      color: Colors.blue[600])),
              SizedBox(
                width: 24.w,
              ),
              if (_reports[_currentDate.month - 1] != null &&
                  _reports[_currentDate.month - 1]!.isNotEmpty)
                Expanded(
                  child: AppIconButton(
                    onPressed: () => _generateExcel(
                        _currentDate, _reports[_currentDate.month - 1]!),
                    label: 'Xuất file',
                    icon: Icons.upload_sharp,
                  ),
                ),
            ],
          ),
          if (_reports[_currentDate.month - 1] == null ||
              _reports[_currentDate.month - 1]!.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.w),
              child: Center(
                child: Text('Không có dữ liệu'),
              ),
            ),
          if (_reports[_currentDate.month - 1] != null &&
              _reports[_currentDate.month - 1]!.isNotEmpty)
            ListView.separated(
                shrinkWrap: true,
                primary: false,
                itemBuilder: (_, index) {
                  final report = _reports[_currentDate.month - 1]![index];
                  return _rowWidget(report);
                },
                separatorBuilder: (_, __) => Divider(),
                itemCount: _reports[_currentDate.month - 1]!.length)
        ],
      ),
    );
  }

  Widget _rowWidget(TakeBackReportModel report) {
    final bodyStyle = TextStyle(
      fontSize: 18.sp,
    );
    final titleStyle = TextStyle(
        fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.blue);
    final captionStyle = TextStyle(
      fontSize: 14.sp,
    );

    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => DetailTakeBackReportScreen(
                    reportModel: report,
                  ))),
      behavior: HitTestBehavior.translucent,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    report.clientName ?? '',
                    style: titleStyle,
                  ),
                  Text(
                    'Đ/C: ${report.clientAddress ?? ''}',
                    style: captionStyle,
                  ),
                  Text(
                    'Ngày: ${report.createAtString}',
                    style: captionStyle,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                report.deviceTotal().toString(),
                style: bodyStyle,
              ),
            ),
            Icon(Icons.arrow_forward)
          ],
        ),
      ),
    );
  }
}
