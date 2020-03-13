import 'package:flutter/material.dart';
import '../model/course.dart';
import '../global/settings.dart';
import '../global/data.dart';
import '../util/const.dart';
import '../util/view.dart';

import '../page/course_info_page.dart';
import '../page/schedule_modify_page.dart';
import '../controller/schedule_edit.dart';

var _grayBorderSide = BorderSide(width: 1.0,color: Color(0x10000000));
var _borderLeft = BoxDecoration(border: Border(left: _grayBorderSide));
var _borderY = BoxDecoration(border: Border(top:_grayBorderSide, bottom: _grayBorderSide));
var _timelineWidth = 45.0;


class ScheduleView extends StatefulWidget {
  final Schedule schedule;

  ScheduleView(this.schedule);

  _ScheduleViewState createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {

  Schedule schedule;
  Course course;
  bool _isHidden = false;

  @override
  void initState() {
    super.initState();
    schedule = widget.schedule;
    course = schedule.course;
  }

  static const textStyles = [
    const TextStyle(color: Colors.white, shadows: [Shadow(blurRadius: 2.0)], fontWeight: FontWeight.bold),
    const TextStyle(color: Colors.white, shadows: [Shadow(blurRadius: 2.0)])
  ];

  void _showMenu(BuildContext context){
    showLongPressMenu(context, items: [
      MenuItem(onTap: ()=>navigateTo(context, ()=>CourseInfoPage(course, tag: course.curriculum)),
        leading: Icon(Icons.more_horiz), title: Text('查看课程信息')
      ),
      MenuItem(onTap: ()=>navigateTo(context, ()=>ScheduleModifyPage(ScheduleEdit(course, schedule))),
        leading: Icon(Icons.edit), title: Text('修改课时')
      ),
      MenuItem(onTap: ()=>setState((){schedule.delete(); _isHidden = true;}),
        leading: Icon(Icons.delete, color: Colors.red), title: Text('删除课时', style: TextStyle(color: Colors.red))
      ), 
      Container(height: 6.0, color: Color(course.color))
    ]);
  }

  @override
  Widget build(BuildContext context) {   
    return
      _isHidden ? Container() :
      Positioned(left: 0, right: 0,
        top: schedule.displayTop, child:  
        InkWell(
          onTap: () => navigateTo(context, ()=> CourseInfoPage(schedule.course, tag: schedule)),
          onLongPress: () => _showMenu(context), child: 
          Container(margin: EdgeInsets.all(2.0),
            height: schedule.displayHeight - 4, child:
            Stack(children: [
              Positioned(child: 
                Hero(tag: schedule, child: 
                  Container(color:  Color(schedule.color))
                )
              ),
              Positioned(left:0, right:0, top:0, bottom:0, child: 
                Column(children: [
                  Text(schedule.displayName, style: textStyles[0], overflow: TextOverflow.ellipsis),
                  Flexible(child: 
                    Text(schedule.location, style: textStyles[1])                 
                  )
                ])
              )
            ])
          )
        )
      )
    ;
  }
}

class DayClassSpanView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return 
      Stack(children: 
        term.classSpans.map((e) =>
          Positioned(left:0 , right: 0,
            top: e.displayTop, child: 
            Container(decoration: _borderY, 
              height: e.displayHeight, child: 
              InkWell(
                highlightColor: Theme.of(context).primaryColor,
                onTap: ()=>0
              )
            )
          )
        ).toList()
      )
    ;
  } 
}

class DayScheduleView extends StatelessWidget {

  DayScheduleView(this.week,this.weekday);

  final int week;
  final int weekday;

  @override
  Widget build(BuildContext context) => 
    Expanded(child: 
      Container(decoration: _borderLeft, child: 
        Stack(children: [          
          DayClassSpanView(),
          Stack(children: 
            term.getSchedulesInDay(week, weekday).map<Widget>((s) => 
              ScheduleView(s)
            ).toList()
          )
        ])
      )
    )
  ;
}




class ClassSpanView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return 
      Stack(children: 
        term.classSpans.map((e) =>
          Positioned(left:0 , right: 0,
            top: e.displayTop, child: 
            Container(decoration: _borderY, padding: const EdgeInsets.only(right: 5.0, top: 2.0),
              height: e.displayHeight, 
              child: Text(e.from.toString(),textAlign: TextAlign.right,)
            )
          )
        ).toList()
      )
    ;
  } 
}


class TimeLineView extends StatelessWidget{

  
  @override
  Widget build(BuildContext context) {
    return 
      Container(width: _timelineWidth, decoration: _borderLeft, child: 
        ClassSpanView()
      )
    ;
  }

}

class TimeSpanView extends StatefulWidget {
  final int week;
  TimeSpanView(this.week);
  _TimeSpanViewState createState() => _TimeSpanViewState(week);
}
class _TimeSpanViewState extends State<TimeSpanView> {

  final int week;
  _TimeSpanViewState(this.week);

  @override
  Widget build(BuildContext context) {
    return 
      Row(crossAxisAlignment: CrossAxisAlignment.start ,children: [
        Container(width: _timelineWidth)
      ]..addAll(weekdayRange.map((d) =>
        Expanded(child:
          Container(color: const Color(0x30000000),
            height: getDayPassedMinutes(week,d)
          )
        )
      )))
    ;
  }
}



class WeekScheduleView extends StatelessWidget {

  final int week;
  
  static const _textStyles = [
    const TextStyle(fontWeight: FontWeight.bold),
    const TextStyle()
  ];

  WeekScheduleView(this.week);

  @override
  Widget build(BuildContext context) =>
    Column(children: [
      Container(height: 25.0, child:       
        Row(crossAxisAlignment: CrossAxisAlignment.center, children:[
          Container(width: _timelineWidth)
        ]..addAll(weekdayRange.map((d) => 
          Expanded(child:
            Text(weekdayString[d], 
              textAlign: TextAlign.center, style: _textStyles[isToday(week, d)?0:1]
            )
          )
        )))
      ),
      Expanded(child: 
        CustomScrollView(slivers: [
          SliverToBoxAdapter(child: 
            SizedBox(
              height: (dayEndTime - dayBeginTime).toMinutes(), child: 
              Stack(children: [               
                TimeSpanView(week),
                Row(crossAxisAlignment: CrossAxisAlignment.stretch, children:[
                  TimeLineView()
                ]..addAll(weekdayRange.map((d) => 
                  DayScheduleView(week,d)
                ))),
              ])
            )
          )
        ])
      )
    ])
  ;
}

