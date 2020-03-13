import 'package:flutter/material.dart';
import '../global/data.dart';
import '../global/settings.dart';
import '../util/view.dart';
import '../model/course.dart';


class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(appBar: 
        AppBar(title: 
          Text('关于')
        ), body: 
        ListView(children: [
          ListTile(onTap: () {term=Term(); saveData();},title: 
            Text('清空数据')
          ),
          ListTile(onTap: () => saveData(),title: 
            Text('保存数据测试')
          ),
          ListTile(onTap: (){term=Term(); loadData();},title: 
            Text('加载数据测试')
          ),
          ListTile(
            onTap: (){
              testLoadData().then((e){
                navigateTo(context, () => Scaffold(appBar:AppBar(), body: Text(e)));
              }).catchError((){
                navigateTo(context, () => Scaffold(appBar:AppBar(), body: Text('no such file')));
              });
            }, title: 
            Text('查看测试数据')
          ),
          ListTile(onTap: (){louder(false);},title: 
            Text('模拟初次开启')
          ),
        ])
      )
    ;
  }
}