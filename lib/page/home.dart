import 'package:flutter/material.dart';
import 'calendar_page.dart';
import 'course_page.dart';
import 'setting_page.dart';
import 'today_page.dart';
import '../global/settings.dart';
import '../global/data.dart';


class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();

    Future.wait([loadData(),loadSettings()]).then((e){
      setState((){
        _isLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return 
      MaterialApp(
        theme: ThemeData(brightness: Brightness.light,primarySwatch: Colors.teal),
        home: _isLoaded ? DynamicCalendarPage() : Container(color: Colors.white),
        locale: Locale('zh','CN'),
        routes: {
          '/courses': (e) => CoursePage(),
          '/settings': (e) => SettingPage(),
          '/today': (e) => TodayPage() 
        },
      )
    ;
  }
}