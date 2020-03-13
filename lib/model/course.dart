
import 'package:course/util/util.dart';

import '../util/util.dart';
import '../global/settings.dart';
import '../global/data.dart';


enum Parity{
  odd, even, both
}

class Schedule implements Comparable<Schedule>{

  int weekday;
  int classIndex;
  ClassSpan classSpan;
  BetweenRange weeks;
  Course course;
  String location;
  Parity parity;

  Schedule({this.weekday = 1, this.classIndex = 1, this.classSpan, this.weeks,
            this.location = '', this.parity = Parity.both});
  Schedule.empty();

  Schedule.fromJson(this.course, Map<String,dynamic> e):
    weekday = e['weekday'], classIndex = e['classIndex'],
    classSpan = ClassSpan.fromJson(e['classSpan']),
    weeks = BetweenRange.fromJson(e['weeks']),
    location = e['location'],
    parity = Parity.values[e['parity']]
  ;
  Map<String,dynamic> toJson() => {
    'weekday': weekday, 'classIndex': classIndex,
    'classSpan': classSpan.toJson(),
    'weeks': weeks.toJson(),
    'location': location,
    'parity': parity.index,
  };

  void becomePartOf(Course course) => this.course = course;

  int get color => course.color;
  String get displayName => course.displayName ;
  double get displayTop => classSpan.displayTop;
  double get displayHeight => classSpan.displayHeight;
  bool containsWeek(int week){
    
    switch(parity){
      case Parity.both:
        return weeks.contains(week);
      case Parity.odd:
        return week.isOdd && weeks.contains(week);
      case Parity.even:
        return week.isEven && weeks.contains(week);
    }
    return false;
  }

  void delete(){
    course.curriculum.remove(this);
  }

  @override
  int compareTo(Schedule other) {
    int res = weeks.compareTo(other.weeks);
    if(res != 0) return res;
    res = weekday.compareTo(other.weekday);
    if(res != 0) return res;
    res = classSpan.compareTo(other.classSpan);
    if(res != 0) return res;
    return weeks.from.compareTo(other.weeks.from);
  }

}

class Course{

  String name;
  String short;
  int color;
  List<Schedule> curriculum;

  Course(this.name, {this.short = '', List<Schedule> curriculum, this.color = 0xff2196f3}): curriculum = curriculum ?? []{
    this.curriculum.forEach((s) => s.becomePartOf(this));
  }

  Course.fromJson(Map<String,dynamic> e):
    name = e['name'], short = e['short'], color = e['color'] {
    curriculum = e['curriculum'].map<Schedule>((r) => Schedule.fromJson(this, r)).toList();
  }
  Map<String,dynamic> toJson() => {
    'name': name, 'short': short, 'color': color,
    'curriculum': curriculum.map<dynamic>((r) => r.toJson()).toList()
  };

  String get displayName => short.isNotEmpty ? short : name ;

  void addSchedule(Schedule schedule){
    schedule.becomePartOf(this);
    curriculum.add(schedule);    
  }

  Iterable<Schedule> getSchedulesInDay(int week, int weekday) =>
    curriculum.where((s) => 
      s.weekday == weekday && s.containsWeek(week)
    );

  Iterable<Schedule> getSchedulesInWeek(int week) =>
    curriculum.where((s) => s.containsWeek(week));

  void delete(){
    term.courses.remove(this);
  }
}


class ClassSpan implements Comparable<ClassSpan>{
  Time from;
  Time to;

  ClassSpan(this.from,this.to);
  ClassSpan.copyFrom(ClassSpan other): from = other.from, to = other.to;

  ClassSpan.fromJson(Map<String,dynamic> e):
    from = Time.fromJson(e['from']), to = Time.fromJson(e['to'])
  ;
  Map<String,dynamic> toJson() => {
    'from': from.toJson(), 'to': to.toJson()
  };

  double get displayTop => (from - dayBeginTime).toMinutes();
  double get displayHeight => (to - from).toMinutes();

  @override
  int compareTo(ClassSpan other) {
    int res = from.compareTo(other.from);
    if(res != 0) return res;
    return to.compareTo(other.to);
  }
}

class ClassSpans{
  final List<ClassSpan> items;

  ClassSpans([List<ClassSpan> items]):
    items = items ?? [];

  ClassSpans.fromJson(List<dynamic> e):
    items = e.map<ClassSpan>((r) => r.fromJson(r)).toList()
  ;
  List<dynamic> toJson() => 
    items.map((r) => r.toJson()).toList()
  ;

  ClassSpan getItem(int index){
    if(index >= items.length){
      Time last = items.length > 0 ? items.last.to.addMinutes(spareSpanMinutes) : dayBeginTime;
      int appendCount = index - items.length;
      return ClassSpan(
        last.addMinutes((spareSpanMinutes + classSpanMinutes) * appendCount),
        last.addMinutes((spareSpanMinutes + classSpanMinutes) * appendCount + classSpanMinutes)
      );
    }
    return items[index];
  }

  void setSpanLength(int minutes){
    for(var span in items){
      span.to = span.from.addMinutes(minutes);
    }
    saveData();
  }


  void setItem(int index, ClassSpan item){
    if(index >= items.length){
      Range.between(items.length, index - 1).foreach((i){
        items.add(getItem(i));
      });
      items.add(item);
    }else{
      items[index] = item;
    }
    saveData();
  }

  void setItemFromTime(int index, Time from){
    setItem(index, ClassSpan(from, from.addMinutes(classSpanMinutes)));
  }

  Iterable<M> map<M>(M f(ClassSpan t)){
    return Range.between(0,dayClasses-1).map((n)=>
      f(getItem(n))
    );
  }
  Iterable<M> mapWithIndex<M>(M f(int i, ClassSpan t)){
    return Range.between(0,dayClasses-1).map((n)=>
      f(n,getItem(n))
    );
  }


}

class Term {
  final List<Course> courses;
  final ClassSpans classSpans;

  Term({List<Course> courses, ClassSpans classSpans}):
    courses = courses ?? [],
    classSpans = classSpans ?? ClassSpans();

  Term.fromJson(Map<String,dynamic> e):
    courses = e['courses'].map<Course>((r) => Course.fromJson(r)).toList(),
    classSpans = ClassSpans.fromJson(e['classSpans'])
  ;
  Map<String,dynamic> toJson() => {
    'courses': courses.map<dynamic>((r) => r.toJson()).toList(),
    'classSpans': classSpans.toJson()
  };

  void addCourse(Course course) => courses.add(course);

  int get maxWeek{
    int max = 1;
    for(var c in courses){
      for(var e in c.curriculum){
        if(e.weeks.max > max) max = e.weeks.max;
      }
    }
    return max;
  }

  ClassSpan getClassSpan(int index){
    return ClassSpan.copyFrom(classSpans.getItem(index));
  }

  Iterable<Schedule> getSchedulesInDay(int week, int weekday) =>
    courses.map((c) => 
      c.getSchedulesInDay(week, weekday)
    ).expand((e) => e);

  Iterable<Schedule> getSchedulesToday() => getSchedulesInDay(currentWeek, currentWeekday);
}




