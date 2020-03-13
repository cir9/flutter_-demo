
import '../util/util.dart';
import './data.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';


var dayBeginTime = Time(7);
Time get dayEndTime{
  return term.classSpans.getItem(dayClasses - 1).to;
}
DateTime termBeginTime = DateTime(2018,9,3);
var termWeeks = 20;
var dayClasses = 10;
var classSpanMinutes = 45;
var spareSpanMinutes = 10;
var weekdayRange = Range.between(1,5);
var yay = false;

Future<void> loadSettings() async{
  final prefs = await SharedPreferences.getInstance();

  dayBeginTime = Time.parse(prefs.getString('dayBeginTime') ?? '7:00');
  var temp = prefs.getString('termBeginTime') ;
  if(temp == null) currentWeek = 1;
  else termBeginTime = DateTime.parse(temp);
  termWeeks = prefs.getInt('termWeeks') ?? 20;
  dayClasses = prefs.getInt('dayClasses') ?? 10;
  classSpanMinutes = prefs.getInt('classSpanMinutes') ?? 45;
  spareSpanMinutes = prefs.getInt('spareSpanMinutes') ?? 10;
  weekdayRange.from = prefs.getInt('weekdayFrom') ?? 1;
  weekdayRange.to = prefs.getInt('weekdayTo') ?? 5;
  yay = prefs.getBool('yay') ?? false;

  print('settings loaded');
}

Future<void> louder(bool y) async{
  yay = y;
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('yay', yay);
}


int get currentWeek{
  if(termBeginTime != null)
    return (DateTime.now().difference(termBeginTime).inDays / 7).floor() + 1;
  return 1;
} 
set currentWeek(int value){
  var now = DateTime.now();
  var temp = now.subtract(Duration(days: now.weekday + value * 7 - 8));
  termBeginTime = DateTime(temp.year,temp.month,temp.day);
  print(termBeginTime);
}

int get currentWeekday => DateTime.now().weekday;



bool isToday(int week,int weekday) => week == currentWeek && currentWeekday == weekday;

double getDayPassedMinutes(int week,int weekday){
  var day = termBeginTime.add(Duration(
    days:     (week-1)*7 + weekday-1,
    hours:    dayBeginTime.hour, 
    minutes:  dayBeginTime.minute
  ));
  double diff = min(
    DateTime.now().difference(day).inMilliseconds / 60000, 
    (dayEndTime - dayBeginTime).toMinutes()
  );
  return max(diff, 0.0);
}