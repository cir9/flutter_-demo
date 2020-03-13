import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../global/settings.dart';
import '../global/data.dart';
import '../util/const.dart';
import '../view/schedule_detail_view.dart';


class TodayPage extends StatefulWidget {
  _TodayPageState createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {


  @override
  Widget build(BuildContext context) {
    var curriculum = term.getSchedulesToday().toList()..sort();
    return 
      Scaffold(body: 
        CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text('今日课程'),
              expandedHeight: 200.0, flexibleSpace: 
              FlexibleSpaceBar(
                background: Container(child:                  
                  Container(color: Theme.of(context).primaryColor, padding: EdgeInsets.all(30), child: 
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,  children: [
                      SizedBox(height: 50.0),
                      Text('第 $currentWeek 周' ,style: TextStyle(
                        color: Theme.of(context).canvasColor,
                        fontSize: 36.0
                      )),
                      SizedBox(height: 8.0),
                      Text(weekdayString[currentWeekday], style: TextStyle(color: Theme.of(context).canvasColor)),
                    ]) 
                  ),
                ),
              ),
            ),
            SliverList(delegate: 
              SliverChildListDelegate([
                AnnotatedRegion<SystemUiOverlayStyle>(
                  value: SystemUiOverlayStyle.dark, child: 
                  curriculum.isNotEmpty
                  ? Column(children: 
                      curriculum.map((s)=>
                        ScheduleDetailView(s)
                      ).toList()
                    )
                  : Container(padding:EdgeInsets.only(top: 50.0), child: 
                      Center(child: 
                        Text('今天没课！', style: Theme.of(context).textTheme.caption)
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