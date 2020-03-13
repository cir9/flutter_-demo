import 'package:flutter/material.dart';
import '../view/calandar_view.dart';
import '../global/settings.dart';
import '../global/data.dart';
import '../util/util.dart';
import '../util/view.dart';
import '../view/drawer.dart';
import '../page/setting_page_time.dart';
import '../controller/course_edit.dart';
import '../page/course_modify_page.dart';





class DynamicCalendarPage extends StatefulWidget {
  _DynamicCalendarPageState createState() => _DynamicCalendarPageState();
}

class _DynamicCalendarPageState extends State<DynamicCalendarPage> {

  @override
    void initState() {
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    return CalendarPage(termWeeks);
  }
}



class CalendarPage extends StatefulWidget {

  final int tabs;
  CalendarPage(this.tabs);

  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> with TickerProviderStateMixin {

  TabController _controller;

  Range _weeks;

  void initTab(){
    int curWeek = currentWeek;
    if(curWeek > widget.tabs){
      curWeek = widget.tabs;
    }
    _weeks = Range.between(1, widget.tabs);
    _controller = TabController(
      vsync: this,
      length: widget.tabs, 
      initialIndex: curWeek - 1 
    );
  }

  @override
  void didUpdateWidget(CalendarPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget.tabs != termWeeks){
      initTab();
      print('rebuild calendar');
    }
  }

  @override
  void initState() {
    super.initState();
    initTab();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return 
      term.courses.isEmpty
      ? (yay
        ? Scaffold(drawer: AppDrawer(), appBar:  
            AppBar(title: Text('日程表'),
              actions: [                
                IconButton(onPressed: () => navigateTo(context, ()=>CourseModifyPage(CourseEdit())),
                  tooltip: '添加课程',
                  icon: Icon(Icons.add),
                )
              ]
            ), body: 
            Center(child: 
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                SizedBox(height: 200),
                Text('还没有添加任何课程', style: Theme.of(context).textTheme.subtitle),
                SizedBox(height: 5),
                RaisedButton(child: Text('添加课程', style: Theme.of(context).textTheme.caption),
                  onPressed: () => navigateTo(context, ()=> CourseModifyPage(CourseEdit())),
                ),
              ])
            )
          )
        : Scaffold(drawer: AppDrawer(), appBar:  
            AppBar(title: Text('日程表')), body: 
            Center(child: 
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                SizedBox(height: 200),
                Text('还没有设置课程时间', style: Theme.of(context).textTheme.subtitle),
                SizedBox(height: 5),
                RaisedButton(child: Text('设置课程时间', style: Theme.of(context).textTheme.caption),
                  onPressed: (){
                    louder(true);
                    navigateTo(context, ()=> TimeSettingPage());
                  }
                ),
              ])
            )
          )
        )
      : Scaffold(
          drawer: AppDrawer(),
          appBar: AppBar(
            title:  Text('日程表'),
            actions: [
              IconButton(onPressed: () => setState((){
                _controller.index = currentWeek > widget.tabs ? widget.tabs - 1 :  currentWeek - 1;
              }),
                tooltip: '选择当前周',
                icon: Icon(Icons.today),
              ),
              IconButton(onPressed: () => navigateTo(context, ()=>CourseModifyPage(CourseEdit())),
                tooltip: '添加课程',
                icon: Icon(Icons.add),
              )
            ],
            bottom: TabBar(controller: _controller, isScrollable: true,
              tabs: _weeks.map<Tab>((n) => 
                n == currentWeek 
                ? Tab(icon: Text('第 $n 周', style: TextStyle(fontWeight: FontWeight.w900))) 
                : Tab(text: '第 $n 周') 
              ).toList()
            )
          ), body:
          TabBarView(controller: _controller, children: 
            _weeks.map((n) =>
              WeekScheduleView(n)
            ).toList()           
          )
        )
    ;
  }
}





