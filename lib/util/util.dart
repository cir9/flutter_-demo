


abstract class LightEnumarable<T>{
  Iterable<T> counts();

  Iterable<M> map<M>(M f(T t)){
    return counts().map(f);
  }

  void foreach(void f(T t)){
    counts().forEach(f);
  }

  bool contains(T t);
}



abstract class Range extends LightEnumarable<int> implements Comparable<Range>{

  int from;
  int to;

  
  Range(this.from, [this.to]) : assert(from != null) {
    to ??= from;
  }

  int get length; 
  int get max;

  factory Range.between(int from, [int to]){
    return BetweenRange(from, to);
  }

  int compareTo(Range other) {
    return from.compareTo(other.from);
  }

}

class BetweenRange extends Range{

  BetweenRange(int from, int to) : super(from, to);

  int get length => to - from + 1;
  int get max => to;

  Iterable<int> counts() sync*{
    int k = from;
    while(k <= to) yield k++;
  }

  bool contains(int number) => number >= from && number <= to;

  String toString()  => '$from - $to';

  BetweenRange.fromJson(Map<String,dynamic> json)
      : super(json['from'], json['to']);
  
  Map<String,dynamic> toJson(){
    return {'from': from, 'to': to};
  }
}


class Time implements Comparable<Time>{

  Time(this.hour,[this.minute = 0]);
  Time.fromMinute(num minute){
    this.hour = (minute / 60).floor();
    this.minute = (minute % 60).round();
  }
  Time.parse(String string){
    var parts = string.split(':');
    hour = int.parse(parts[0]);
    minute = int.parse(parts[1]);
  }

  int hour;
  int minute;
  
  Time.fromJson(Map<String,dynamic> e):
    hour = e['hour'], minute = e['minute']
  ;
  Map<String,dynamic> toJson() => {
    'hour': hour, 'minute': minute
  };

  double toHours() => hour + minute / 60;
  double toMinutes() => hour * 60.0 + minute;

  Time addMinutes(int minutes){
    return Time.fromMinute(toMinutes() + minutes);
  }

  operator - (Time other) => Time.fromMinute(toMinutes() - other.toMinutes());
  operator + (Time other) => Time.fromMinute(toMinutes() + other.toMinutes());

  String toString() => '$hour:${minute<10?'0$minute':minute}';

  @override
  int compareTo(Time other) {
    int res = hour.compareTo(other.hour);
    if(res != 0) return res;
    return minute.compareTo(other.minute);
  }

}
