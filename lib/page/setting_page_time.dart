import 'package:flutter/material.dart';
import '../global/settings.dart';
import '../util/const.dart';
import '../util/util.dart';
import '../util/view.dart';
import '../global/data.dart';
import 'package:flutter_picker/flutter_picker.dart';
import './setting_page_class_span.dart';
import 'package:shared_preferences/shared_preferences.dart';




class TimeSettingPage extends StatefulWidget {
  _TimeSettingPageState createState() => _TimeSettingPageState();
}

class _TimeSettingPageState extends State<TimeSettingPage> {

  SharedPreferences _prefs;
  
  void initState(){
    super.initState();
    () async {
      _prefs = await SharedPreferences.getInstance();
    }();
  }

  _showWeekdayRangePicker() {
    Picker(cancelText: '取消', confirmText: '确认', hideHeader: true,
      adapter: PickerDataAdapter(data: 
        Range.between(1,7).map((n)=>
          PickerItem(text: Text(weekdayShort[n]), value: n, children: 
            Range.between(n,7).map((m)=>
              PickerItem(text: Text(weekdayShort[m]), value: m)
            ).toList()
          )
        ).toList()
      ),
      delimiter: [PickerDelimiter(child: 
        Container(width: 50.0, alignment: Alignment.center, child: 
          Text('至'),
        )
      )],
      selecteds: [weekdayRange.from - 1, weekdayRange.to - weekdayRange.from],
      title: Text('每周上课时间'),
      onConfirm: (Picker picker, List value) => setState(() {
        var values = picker.getSelectedValues();
        weekdayRange.from = values[0];
        weekdayRange.to = values[1];     
        _prefs.setInt('weekdayFrom', weekdayRange.from);
        _prefs.setInt('weekdayTo', weekdayRange.to);
      })
      
    ).showDialog(context);
  }

  _showTermWeeksPicker() {
    showRangePicker(context, Range.between(1,52),
      title: Text('当前学期周数'),
      selected: termWeeks,
      onConfirm: (int value) => setState(() {
        termWeeks = value;
        _prefs.setInt('termWeeks', termWeeks);
      })
    );
  }
  _showCurrentWeekPicker() {
    showRangePicker(context, Range.between(1,termWeeks),
      title: Text('当前周数'),
      selected: currentWeek <= termWeeks ? currentWeek : 1,
      onConfirm: (int value) => setState(() {
        currentWeek = value;
        _prefs.setString('termBeginTime',termBeginTime.toIso8601String());
      })
    );
  }
  _showDayClassesPicker() {
    showRangePicker(context, Range.between(1,20),
      title: Text('每日课程节数'),
      selected: dayClasses,
      onConfirm: (int value) => setState(() {
        dayClasses = value;
        _prefs.setInt('dayClasses', dayClasses);
      })
    );
  }
  _showClassSpanMinutesInput(){
    showNumberInput(context, suffix: '分钟',
      title: Text('上课时长'),
      value: classSpanMinutes,
      onConfirm: (value) => setState((){
        classSpanMinutes = value;
        term.classSpans.setSpanLength(value);
        _prefs.setInt('classSpanMinutes', classSpanMinutes);
      })
    );
  }
  _showSpareSpanMinutesInput(){
    showNumberInput(context, suffix: '分钟',
      title: Text('默认课间时长'),
      value: spareSpanMinutes,
      onConfirm: (value) => setState((){
        spareSpanMinutes = value;
        _prefs.setInt('spareSpanMinutes', spareSpanMinutes);
      })
    );
  }
  _showDayBeginTimePicker(){
    showMaterialTimePicker(context,
      time: dayBeginTime,
      onConfirm: (value) => setState((){
        dayBeginTime = value;
        _prefs.setString('dayBeginTime', dayBeginTime.toString());
      })
    );
  }
  // _showDayEndTimePicker(){
  //   showMaterialTimePicker(context,
  //     time: dayEndTime,
  //     onConfirm: (value) => setState((){
  //       dayEndTime = value;
  //       _prefs.setString('dayEndTime', dayEndTime.toString());
  //     })
  //   );
  // }


  @override
  Widget build(BuildContext context) {
    return 
      Scaffold(appBar: 
        AppBar(title: 
          Text('课程时间')
        ), body: 
        ListView(children: [
          ListTile(title: Text('每周上课时间'),
            subtitle: Text('${weekdayShort[weekdayRange.from]} 至 ${weekdayShort[weekdayRange.to]}'),
            onTap: _showWeekdayRangePicker,
          ),
          ListTile(title: Text('当前学期周数'),
            subtitle: Text('本学期共 $termWeeks 周'),
            onTap: _showTermWeeksPicker,
          ),
          ListTile(title: Text('当前周数'),
            subtitle: Text('现在是第 $currentWeek 周'),
            onTap: _showCurrentWeekPicker,
          ),
          Divider(),
          ListTile(title: Text('每日课程'),
            subtitle: Text('$dayClasses 节课'),
            onTap: _showDayClassesPicker,
          ),
          ListTile(title: Text('每日开始时间'),
            subtitle: Text('$dayBeginTime'),
            onTap: _showDayBeginTimePicker,
          ),
          // ListTile(title: Text('每日结束时间'),
          //   subtitle: Text('$dayEndTime'),
          //   onTap: _showDayEndTimePicker,
          // ),
          ListTile(title: Text('上课时长'),
            subtitle: Text('$classSpanMinutes 分钟'),
            onTap: _showClassSpanMinutesInput,
          ),
          ListTile(title: Text('默认课间时长'),
            subtitle: Text('$spareSpanMinutes 分钟'),
            onTap: _showSpareSpanMinutesInput,
          ),
          Divider(),
          ListTile(title: Text('设置上课时间'),
            onTap: () => navigateTo(context, ()=>ClassSpanSettingPage()),
          ),
        ])
      )
    ;
  }
}