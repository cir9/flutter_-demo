import '../util/view.dart';
import '../global/data.dart';
import '../model/course.dart';
import 'package:flutter/material.dart';



class CourseEdit extends EditController<Course>{

  CourseEdit([Course origin]): super(origin);

  var name = TextEditingController();
  var short = TextEditingController();
  Color color;

  void dispose(){
    name.dispose();
    short.dispose();
  }

  void initCreate(){
    color = Colors.blue;
  }

  void initEdit() {
    name.text = origin.name;
    short.text = origin.short;
    color = Color(origin.color);
  }

  Course commitEdit(){
    origin.name = name.text;
    origin.short = short.text;
    origin.color = color.value;
    return origin;
  }
  Course commitCreate(){
    var res = Course(
      name.text, short: short.text,
      color : color.value
    );
    term.courses.add(res);
    return res;
  }
  
}