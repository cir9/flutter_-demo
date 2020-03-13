import '../util/view.dart';
import '../util/util.dart';
import '../global/data.dart';
import '../global/settings.dart';
import '../model/course.dart';
import 'package:flutter/material.dart';


class ScheduleEdit extends EditController<Schedule>{

  Course course;

  ScheduleEdit(this.course, [Schedule origin]) : super(origin);

  int weekday;
  Parity parity;
  Range weeks;
  ClassSpan classSpan;
  int classIndex;
  var location = TextEditingController();

  void initCreate(){
    weekday = 1;
    parity = Parity.both;
    weeks = Range.between(1, termWeeks);
    classIndex = 0;
    classSpan = term.getClassSpan(0);
  }

  void initEdit() {
    weekday = origin.weekday;
    parity = origin.parity;
    weeks = origin.weeks;
    classSpan = origin.classSpan;
    classIndex = origin.classIndex;
    location.text = origin.location;
  }

  void setClass(int classIndex){
      this.classIndex = classIndex;
      classSpan = term.getClassSpan(classIndex);
  }

  Schedule commitEdit() {
    origin.weekday = weekday;
    origin.parity = parity;
    origin.weeks = weeks;
    origin.classSpan = classSpan;
    origin.classIndex = classIndex;
    origin.location = location.text;
    return origin;
  }

  Schedule commitCreate() {
    var res = Schedule(
      weekday: weekday,
      parity: parity,
      weeks: weeks,
      classSpan: classSpan,
      classIndex: classIndex,
      location: location.text
    );
    course.addSchedule(res);
    return res;
  }



}