import 'package:flutter/material.dart';
import '../view/course_view.dart';
import '../global/data.dart';
import '../page/course_modify_page.dart';

class CoursePage extends StatefulWidget {
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  @override
  Widget build(BuildContext context) {
    return 
      Scaffold(
        floatingActionButton: FloatingActionButton(tooltip: '添加课程',
          onPressed: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (e)=>
            CourseModifyPage()
          )), child: 
          Icon(Icons.add)
        ) , 
        appBar: AppBar(
          title: Text('课程'),
        ),  body: 
        Container(child:
          term.courses.isNotEmpty 
          ? ListView(children: 
              term.courses.map((c) =>
                Container(padding: EdgeInsets.symmetric(horizontal: 4),child:                
                  CourseView(c)
                )
              ).toList()
            )
          : Container( child: 
              Center(child: 
                Text('空空如也', style: Theme.of(context).textTheme.caption)
              )
            )
        )
      )
    ;
  }
}
