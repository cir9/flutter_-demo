import 'package:flutter/material.dart';
import '../util/view.dart';
import '../page/setting_page_time.dart';
import '../global/data.dart';
import '../model/course.dart';
import 'about_page.dart';



 class SettingPage extends StatelessWidget {
   @override
   Widget build(BuildContext context) {
     return
      Scaffold(
        appBar: AppBar(
          title: Text('设置'),
        ),
        body: ListView(children: [
          ListTile(onTap: () => navigateTo(context, ()=>TimeSettingPage()),title: 
            Text('课程时间')
          ),
          Divider(),
          ListTile(onTap: ()=> navigateTo(context, ()=>AboutPage()),title: 
            Text('关于')
          ),
        ])
      )
     ;
   }
 }