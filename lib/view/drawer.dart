import 'package:flutter/material.dart';
import '../global/settings.dart';
import '../util/const.dart';



class AppDrawer extends StatelessWidget {
  
  // void _gotoPage(BuildContext context,String routeName){
  //   Navigator.of(context)..pop()..popAndPushNamed(routeName);
  // }
  
  @override
  Widget build(BuildContext context) {
    return 
      Drawer(child: 
        Column(crossAxisAlignment: CrossAxisAlignment.stretch,  children: [
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
              SizedBox(height: 30.0),
            ]) 
          ),
          ListTile(onTap: () => Navigator.of(context).pushNamed('/today') ,
            leading: Icon(Icons.today),
            title: Text('今天')
          ),
          ListTile(onTap: () => Navigator.of(context).pushNamed('/courses') ,
            leading: Icon(Icons.school),
            title: Text('课程')
          ),
          // ListTile(
          //   leading: Icon(Icons.school),
          //   title: Text('学期')
          // ) ,
          Expanded(child: Container(),),
          Divider(),
          ListTile(onTap: () => Navigator.of(context).pushNamed('/settings') ,
            leading: Icon(Icons.settings),
            title: Text('设置')
          )
        ])
      )
    ;
  }
}