import 'package:flutter/material.dart';
import '../model/course.dart';
import '../util/view.dart';
import '../util/const.dart';
import '../page/schedule_modify_page.dart';
import '../controller/schedule_edit.dart';

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

  String _getWeekSpanText(){
    String attr = '';
    switch(schedule.parity){
      case Parity.odd:
        attr = '(单周)';
        break;
      case Parity.even:
        attr = '(双周)';
        break;
      case Parity.both:
    }
    return '${schedule.weeks} 周 $attr';
  }


  void _showMenu(BuildContext context){
    showLongPressMenu(context, items: [
      MenuItem(onTap: ()=>navigateTo(context, ()=>ScheduleModifyPage(ScheduleEdit(course, schedule))),
        leading: Icon(Icons.edit), title: Text('修改课时')
      ),
      MenuItem(onTap: ()=>setState((){schedule.delete(); _isHidden = true;}),
        leading: Icon(Icons.delete, color: Colors.red), title: Text('删除课时', style: TextStyle(color: Colors.red))
      ), 
      Container(height: 6.0, color: Color(course.color))
    ]);
  }

  Widget _buildLeft(){
    return
      Container(width: 100, padding: EdgeInsets.fromLTRB(16,8,0,10), child:  
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(weekdayShort[schedule.weekday], style: Theme.of(context).textTheme.display1.copyWith(fontSize: 32)),
          Text(_getWeekSpanText(), style: Theme.of(context).textTheme.caption ),
        ])
      )
    ;
  }

  Widget _buildRight(){
    var items = <Widget>[
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Icon(Icons.access_time, size: 18.0, color: Theme.of(context).hintColor),
        Text('${schedule.classSpan.from} - ${schedule.classSpan.to}', overflow: TextOverflow.ellipsis)
      ])
    ];
    if(schedule.location.isNotEmpty)
      items.add(
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Icon(Icons.location_on, size: 18.0, color: Theme.of(context).hintColor),
          Flexible(child: 
            Text('${schedule.location}', textAlign: TextAlign.right)
          )
        ])
      );      
    return
      Container(width: 150, padding: EdgeInsets.fromLTRB(0,12,20,12), child: 
        Column( mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: items
        )
      )
    ;
  }

  @override
  Widget build(BuildContext context) {
    return 
      _isHidden ? Container() :
      Column(children: [                
        InkWell(
          onTap: ()=> navigateTo(context, () => 
            ScheduleModifyPage(ScheduleEdit(schedule.course, schedule))
          ),
          onLongPress: ()=> _showMenu(context), child: 
          Container(child: 
            IntrinsicHeight(child: 
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                _buildLeft(),
                Text('第 ${schedule.classIndex+1} 节课'),
                _buildRight()
              ]),
            )
          )
        ),
        Divider(height: 0)
      ])
    ;
  }
}