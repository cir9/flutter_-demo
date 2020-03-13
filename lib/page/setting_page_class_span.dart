import 'package:flutter/material.dart';
import '../util/view.dart';
import '../global/data.dart';


class ClassSpanSettingPage extends StatefulWidget {
  _ClassSpanSettingPageState createState() => _ClassSpanSettingPageState();
}

class _ClassSpanSettingPageState extends State<ClassSpanSettingPage> {
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(appBar: 
        AppBar(title: 
          Text('设置上课时间'),
        ), body:
        ListView(children: 
          term.classSpans.mapWithIndex((index,span) => 
            Column(children: [
              ListTile(
                title: Text('第 ${index+1} 节课开始时间'),
                subtitle: Text('${span.from}'),
                onTap: ()=> showMaterialTimePicker(context,
                  time: span.from,
                  onConfirm: (time)=>setState((){
                    term.classSpans.setItemFromTime(index, time);
                  })
                ),
              ),
              Divider(height: 0)
            ])
          ).toList()
        )
      )
    ;
  }
}