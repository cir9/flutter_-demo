import 'package:course/controller/course_edit.dart';
import 'package:course/page/course_info_page.dart';
import 'package:course/page/course_modify_page.dart';
import 'package:flutter/material.dart';
import '../model/course.dart';
import '../util/view.dart';
import '../page/schedule_modify_page.dart';
import '../controller/schedule_edit.dart';

class ScheduleDetailView extends StatelessWidget {

  final Schedule schedule;
  final Course course;

  ScheduleDetailView(this.schedule): course = schedule.course;

 void _showMenu(BuildContext context){
    showLongPressMenu(context, items: [      
      MenuItem(onTap: ()=>navigateTo(context, ()=>CourseInfoPage(course, tag: course.curriculum)),
        leading: Icon(Icons.more_horiz), title: Text('查看课程信息')
      ),
      MenuItem(onTap: ()=>navigateTo(context, ()=>CourseModifyPage(CourseEdit(course))),
        leading: Icon(Icons.edit), title: Text('修改课程')
      ),
      MenuItem(onTap: ()=>navigateTo(context, ()=>ScheduleModifyPage(ScheduleEdit(course, schedule))),
        leading: Icon(Icons.edit), title: Text('修改课时')
      ),
      Container(height: 6.0, color: Color(course.color))
    ]);
  }

  Widget _buildRight(BuildContext context){
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
      Column(children: [                
        InkWell(
          onTap: ()=>navigateTo(context, ()=>CourseInfoPage(course, tag: course.curriculum)),
          onLongPress: ()=> _showMenu(context), child: 
          Container(child: 
            IntrinsicHeight(child: 
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(children: [
                  Hero(tag: course.curriculum, child:
                    Container(width: 6.0, color: Color(course.color))
                  ),
                  Container(padding: EdgeInsets.fromLTRB(18,6,0,14), child:  
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('第 ${schedule.classIndex + 1} 节课', style: Theme.of(context).textTheme.caption),
                      SizedBox(height: 8.0),
                      Text('${schedule.displayName}', style: TextStyle(fontSize: 24)),
                    ])
                  )
                ]),
                _buildRight(context)
              ]),
            )
          )
        ),
        Divider(height: 0)
      ])
    ;
  }
}
