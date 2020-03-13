import 'package:flutter/material.dart';
import '../model/course.dart';
import '../global/settings.dart';
import '../util/const.dart';
import '../util/util.dart';
import '../controller/schedule_edit.dart';
import '../util/view.dart';
import 'package:flutter_picker/flutter_picker.dart';



class ScheduleModifyPage extends StatefulWidget {

  final ScheduleEdit schedule;
  ScheduleModifyPage(this.schedule);

  _ScheduleModifyPageState createState() => _ScheduleModifyPageState();
}

class _ScheduleModifyPageState extends State<ScheduleModifyPage> {

  ScheduleEdit schedule;

  void initState() {
    super.initState();
    schedule = widget.schedule;
  }

  void _save(){
    schedule.commit();
    Navigator.of(context).pop();
  }

  void _showAlert(){
    showAlert(context, 
      content: const Text('确认要删除吗？'),
      onConfirm: (){
        schedule.origin.delete();
        Navigator.of(context).pop(); 
      }
    );
  }

  static List<PickerItem> _parityItem = [
    PickerItem(text: Text('全部'), value: Parity.both),
    PickerItem(text: Text('单周'), value: Parity.odd),
    PickerItem(text: Text('双周'), value: Parity.even),
  ];
  static const _parity = {
    Parity.both : 0,
    Parity.odd : 1,
    Parity.even : 2
  };
  static const _parityString = {
    Parity.both : '全部',
    Parity.odd : '单周',
    Parity.even : '双周',
  };

  _showWeekdayPicker() {
    Picker(cancelText: '取消', confirmText: '确认', hideHeader: true,
      adapter: PickerDataAdapter(data: 
        weekdayRange.map((n)=>
          PickerItem(text: Text(weekdayString[n]), value: n, children: _parityItem)
        ).toList()
      ),
      delimiter: [PickerDelimiter(child: 
        Container(width: 50.0, alignment: Alignment.center)
      )],
      selecteds: [schedule.weekday - 1, _parity[schedule.parity]],
      title: Text('选择上课星期'),
      onConfirm: (Picker picker, List value) => setState(() {
        var values = picker.getSelectedValues();
        schedule.weekday = values[0];
        schedule.parity = values[1];       
      })    
    ).showDialog(context);
  }
  _showWeekBeginPicker() {
    showRangePicker(context, Range.between(1, termWeeks),
      title: Text('选择开始周'),
      selected: schedule.weeks.from,
      onConfirm: (value) => setState((){
        schedule.weeks.from = value;
      })
    );
  }
  _showWeekEndPicker() {
    showRangePicker(context, Range.between(1, termWeeks),
      title: Text('选择结束周'),
      selected: schedule.weeks.to,
      onConfirm: (value) => setState((){
        schedule.weeks.to = value;
      })
    );
  }
  _showClassPicker() {
    showRangePicker(context, Range.between(1, dayClasses),
      title: Text('选择课时'),
      selected: schedule.classIndex + 1,
      onConfirm: (value) => setState((){
        schedule.setClass(value - 1);
      })
    );
  }
  _showClassBeginTimePicker(){
    showMaterialTimePicker(context,
      time: schedule.classSpan.from,
      onConfirm: (value) => setState((){
        schedule.classSpan.from = value;
      })
    );
  }
  _showClassEndTimePicker(){
    showMaterialTimePicker(context,
      time: schedule.classSpan.to,
      onConfirm: (value) => setState((){
        schedule.classSpan.to = value;
      })
    );
  }

  var _textStyle = TextStyle(fontSize: 16);
  @override
  Widget build(BuildContext context) {
    return 
      Scaffold(appBar: 
        schedule.isNew
        ? AppBar(title: Text('新建课时'), backgroundColor: Color(schedule.course.color))
        : AppBar(title: Text('修改课时'), backgroundColor: Color(schedule.course.color), actions: [
            IconButton(icon: Icon(Icons.delete),
              tooltip: '删除课时',
              onPressed: ()=>_showAlert(),
            )
          ])
        , floatingActionButton: 
        FloatingActionButton(tooltip: '保存',
          onPressed: _save, child: 
          Icon(Icons.check)
        ) , body: 
        SafeArea(top: false, bottom: false, child: 
          DropdownButtonHideUnderline(child: 
            ListView(padding: const EdgeInsets.all(16.0), children: [   
              Text(schedule.course.name, style: Theme.of(context).textTheme.display2), 
              const SizedBox(height: 16),
              TextField(enabled: true,
                controller: schedule.location,
                decoration: const InputDecoration(
                  labelText: '上课地点'
                ),
              ),
              InputDropdown(labelText: '上课星期', child: 
                Text('${weekdayString[schedule.weekday]} (${_parityString[schedule.parity]})', style: _textStyle),
                onPressed: _showWeekdayPicker,
              ),
              Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Expanded(child: 
                  InputDropdown(labelText: '上课周', child: 
                    Text('第 ${schedule.weeks.from} 周', style: _textStyle),
                    onPressed: _showWeekBeginPicker,
                  )    
                ),
                Container(padding: EdgeInsets.all(10), child: 
                  Text('至')
                ),
                Expanded(child: 
                  InputDropdown(labelText: '', child: 
                    Text('第 ${schedule.weeks.to} 周', style: _textStyle),
                    onPressed: _showWeekEndPicker,
                  )    
                ),
              ]),
              InputDropdown(labelText: '课时', child: 
                Text('第 ${schedule.classIndex + 1} 节课', style: _textStyle),
                onPressed: _showClassPicker,
              ),
              const SizedBox(height: 8),
              Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Expanded(child: 
                  InputDropdown(labelText: '上课时间', child: 
                    Text('${schedule.classSpan.from}', style: _textStyle),
                    onPressed: _showClassBeginTimePicker,
                  )    
                ),
                Container(padding: EdgeInsets.all(10), child: 
                  Text('至')
                ),
                Expanded(child: 
                  InputDropdown(labelText: '', child: 
                    Text('${schedule.classSpan.to}', style: _textStyle),
                    onPressed: _showClassEndTimePicker,
                  )
                ),
              ]),
            ])
          )
        )
      )
    ;
  }
}