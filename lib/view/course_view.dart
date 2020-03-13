import 'package:flutter/material.dart';
import '../model/course.dart';
import '../global/settings.dart';
import '../page/course_info_page.dart';
import '../page/course_modify_page.dart';
import '../controller/course_edit.dart';
import '../util/view.dart';



class CourseView extends StatefulWidget {
  final Course course;
  final int coursesInWeek;


  CourseView(this.course):
    coursesInWeek = course.getSchedulesInWeek(currentWeek).toList().length;


  _CourseViewState createState() => _CourseViewState();
}

class _CourseViewState extends State<CourseView> {

  Course course;
  int coursesInWeek;
  bool _isHidden = false;

  void initState(){
    super.initState();
    course = widget.course;
    coursesInWeek = widget.coursesInWeek;
  }

  void _showMenu(BuildContext context){
    showLongPressMenu(context, items: [
      MenuItem(onTap: ()=>navigateTo(context, ()=>CourseInfoPage(course, tag: course.curriculum)),
        leading: Icon(Icons.more_horiz), title: Text('查看课程信息')
      ),
      MenuItem(onTap: ()=>navigateTo(context, ()=>CourseModifyPage(CourseEdit(course))),
        leading: Icon(Icons.edit), title: Text('修改课程')
      ),
      MenuItem(onTap: ()=>setState((){course.delete(); _isHidden = true;}),
        leading: Icon(Icons.delete, color: Colors.red), title: Text('删除课程', style: TextStyle(color: Colors.red))
      ), 
      Container(height: 6.0, color: Color(course.color))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return
      _isHidden ? Container() :
      Container(padding: EdgeInsets.only(top: 2.0, bottom: 2.0), child:
        Card(child:
          InkWell(
            onTap: ()=> navigateTo(context, ()=>CourseInfoPage(course)),
            onLongPress: ()=> _showMenu(context), child:
            Container(child: 
              Row(children: [
                Hero(tag: course, child:
                  Container(width: 8.0,height: 100.0,
                    color: Color(course.color)
                  )
                ),
                SizedBox(width: 16.0),
                Expanded(child:               
                  Container( child: 
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(course.displayName, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.headline),
                      Text(course.short.isEmpty ? '' : course.name , overflow: TextOverflow.ellipsis, 
                        style: Theme.of(context).textTheme.caption
                      ),
                      SizedBox(height: 6.0),
                      Text(coursesInWeek > 0 ? '这周有 $coursesInWeek 节课' : '这周没有课'),
                      Container(height: 4.0)
                    ])
                  )
                )
              ])
            )
          )
        )
      )
    ;
  }
}