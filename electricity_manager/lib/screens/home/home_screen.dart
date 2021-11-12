import 'package:electricity_manager/screens/home/summary_page/summary_page.dart';
import 'package:electricity_manager/utils/commons/text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

import 'drawer_widget.dart';
import 'feature_page/feature_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pages = [FeaturePage(), SummaryPage()];
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quản lý đồng hồ điện',
          style: titleWhite.copyWith(fontSize: 22.sp),
        ),
        centerTitle: true,
      ),
      body: IndexedStack(
        index: _index,
        children: _pages,
      ),
      drawer: DrawerWidget(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (index) {
          setState(() {
            _index = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Chức năng'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bubble_chart), label: 'Tổng kết')
        ],
      ),
    );
  }
}
