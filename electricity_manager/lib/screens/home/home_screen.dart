import 'package:electricity_manager/app_bloc/app_bloc.dart';
import 'package:electricity_manager/di/locator.dart';
import 'package:electricity_manager/screens/home/summary_page/summary_page.dart';
import 'package:electricity_manager/utils/commons/text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'drawer_widget.dart';
import 'feature_page/feature_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _appBloc = getIt.get<AppBloc>();

  final _pages = [FeaturePage(), SummaryPage()];
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _appBloc.isAdmin ? 'Quản trị phần mềm' : 'Quản lý sự cố',
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
          BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.home), label: 'Chức năng'),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.chartLine), label: 'Thống kê')
        ],
      ),
    );
  }
}
