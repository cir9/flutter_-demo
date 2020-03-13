import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../model/course.dart';
import '../view/schedule_view.dart';
import '../page/schedule_modify_page.dart';
import '../page/course_modify_page.dart';
import '../controller/course_edit.dart';
import '../controller/schedule_edit.dart';
import '../util/view.dart';


class CourseInfoPage extends StatelessWidget {
  
  final Course course;
  final Object tag;

  CourseInfoPage(this.course, {Object tag}):
    tag = tag ?? course;


  @override
  Widget build(BuildContext context) {
    return 
      Scaffold(
        floatingActionButton: FloatingActionButton(tooltip: '添加课时',
          onPressed: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (e)=>
            ScheduleModifyPage(ScheduleEdit(course))
          )), child: 
          Icon(Icons.add)
        ) , body:
        CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              expandedHeight: 200.0,
              actions: [
                IconButton(tooltip: '编辑课程', icon: Icon(Icons.edit),
                  onPressed: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (e)=>
                    CourseModifyPage(CourseEdit(course))
                  )
                )),
                IconButton(tooltip: '删除课程', icon: Icon(Icons.delete),
                  onPressed: ()=>showAlert(context, 
                    content: const Text('确认要删除吗？'),
                    onConfirm: (){
                      course.delete();
                      Navigator.of(context)..pop(); 
                    }
                  )
                ),
              ], flexibleSpace: 
              FlexibleSpaceBar(
                background: Container(child:
                  Stack(children: [
                    Positioned(child: 
                      Hero(tag: tag, child: 
                        Container(color: Color(course.color))
                      )
                    ),
                    Positioned(left: 30, top: 95, right: 30, child:                     
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(course.displayName,
                          overflow: TextOverflow.ellipsis,  style: TextStyle(
                          color: Theme.of(context).canvasColor,
                          fontSize: 48.0
                        )),
                        Container(height: 10.0),
                        Text(course.short.isEmpty ? '' : course.name,
                          overflow: TextOverflow.ellipsis , style: TextStyle(
                          color: Theme.of(context).canvasColor,
                        )),
                      ])
                    )
                  ])
                ),
              ),
            ),
            SliverList(delegate: 
              SliverChildListDelegate([
                AnnotatedRegion<SystemUiOverlayStyle>(
                  value: SystemUiOverlayStyle.dark, child: 
                  course.curriculum.isNotEmpty
                  ? Column(children: 
                      (course.curriculum.toList()..sort()).map((s)=>
                        ScheduleView(s)
                      ).toList()
                    )
                  : Container(padding:EdgeInsets.only(top: 50.0), child: 
                      Center(child: 
                        Text('还没有为这门课程添加课时', style: Theme.of(context).textTheme.caption)
                      )
                    )
                )
              ])
            )
          ]
        )
      )
    ;
  }
}