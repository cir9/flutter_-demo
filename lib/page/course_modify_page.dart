import 'package:flutter/material.dart';
import '../controller/course_edit.dart';
import '../util/view.dart';
import './course_info_page.dart';
import 'package:flutter_colorpicker/material_picker.dart';

class CourseModifyPage extends StatefulWidget {

  final CourseEdit course;

  CourseModifyPage([CourseEdit course]): course = course ?? CourseEdit() ;

  _CourseModifyPageState createState() => _CourseModifyPageState();
}

class _CourseModifyPageState extends State<CourseModifyPage> {
  CourseEdit course;

  final _form = GlobalKey<FormState>();

  void initState(){
    super.initState();
    course = widget.course;
  }

  void _save(){
    if(_form.currentState.validate()){
      Navigator.of(context).pop();
      course.commit(onCreate: (c){
        navigateTo(context, () => CourseInfoPage(c));
      });
    }
  }
  void _delete(){
    showAlert(context, 
      content: const Text('确认要删除吗？'),
      onConfirm: (){
        course.origin.delete();
        Navigator.of(context)..pop()..pop(); 
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return 
      Scaffold(appBar:    
        course.isNew
        ? AppBar(title: Text('新建课程'))
        : AppBar(title: 
            Text('修改课程'), actions: [
            IconButton(onPressed: _delete, tooltip: '删除课程',
              icon: Icon(Icons.delete),
            )
          ])
        , floatingActionButton: 
        FloatingActionButton(tooltip: '保存', onPressed: _save, child: 
          Icon(Icons.check)
        ) , body: 
        SafeArea(top: false, bottom: false, child:     
          Form(key: _form, child: 
            ListView(padding: const EdgeInsets.all(16.0), children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(flex: 3,  child: 
                  Column(children: [
                    TextFormField(enabled: true,
                      controller: course.name,
                      decoration: const InputDecoration(labelText: '全称'),
                      validator: (v) => v.isEmpty ? '不能为空' : null ,
                    ),
                    TextFormField(enabled: true,
                      controller: course.short,
                      decoration: const InputDecoration(labelText: '简称')
                    ),
                  ])
                ),
                SizedBox(width: 15),
                Container(margin: EdgeInsets.only(top: 30.0),child: 
                  InkWell(highlightColor: Colors.transparent,
                    onTap: _showColorPicker, child: 
                    Ink(width: 100, height: 80,
                      color: course.color, child: 
                      Container()
                    )
                  )
                )
              ])
            ])
          )
        )
      )
    ;
  }


  void _showColorPicker(){
    showDialog(context: context, builder: (c) =>
      AlertDialog(
        titlePadding: EdgeInsets.all(0.0),
        contentPadding: EdgeInsets.all(0.0),content: 
        SingleChildScrollView(child: 
          MaterialPicker(
            pickerColor: course.color,
            onColorChanged: (c)=>setState((){
              course.color = c;
              Navigator.of(context).pop();
            }),
          ),
        ),
      )
    );
  }
}