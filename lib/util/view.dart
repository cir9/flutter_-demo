import 'package:flutter/material.dart';
import './util.dart';
import '../global/data.dart';
import 'package:flutter_picker/flutter_picker.dart';


abstract class EditController<T>{
  
  EditController([this.origin]){
   // _isNew = origin == null;
    if(isNew) initCreate();
    else initEdit();
  }
  
  T origin;
  //bool _isNew;
  bool get isNew => origin == null;

  void initCreate(){}
  void initEdit();
  T commitEdit();
  T commitCreate();

  T commit({VoidCallback onCreate(T result)}){
    T res;
    if(isNew){
      res = commitCreate();
      if(onCreate != null) onCreate(res);
    } else
      res = commitEdit();
    saveData();
    return res;
  }
}

void navigateTo(BuildContext context, Widget Function() builder) =>
  Navigator.of(context).push(MaterialPageRoute(builder: (e)=>builder()))
;

class InputDropdown extends StatelessWidget {
  const InputDropdown({
    Key key,
    this.child,
    this.labelText,
    this.valueText,
    this.valueStyle,
    this.onPressed }) : super(key: key);

  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(highlightColor: Colors.transparent,
      onTap: onPressed, child: 
      InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
        ),
        baseStyle: valueStyle, child: 
        Stack(children: [
          Container(padding: EdgeInsets.only(top: 4),child: child,),
          Positioned.directional(end: 0, bottom: 0, textDirection: TextDirection.ltr, child: 
            Icon(Icons.arrow_drop_down,
              color: Theme.of(context).brightness == Brightness.light ? Colors.grey.shade700 : Colors.white70
            )
          )
        ])
      ),
    );
  }
}



void showRangePicker(BuildContext context, Range range, {
                     Widget title, void onConfirm(int value), int selected}) {
  Picker(cancelText: '取消', confirmText: '确认', hideHeader: true,
    adapter: PickerDataAdapter(data: 
      range.map((n)=>
        PickerItem(text: Text('$n'), value: n)
      ).toList()
    ),
    selecteds: [selected - 1],
    title: title,
    onConfirm: (Picker picker, List value) => onConfirm(picker.getSelectedValues()[0])
  ).showDialog(context);
}

Future<void> showMaterialTimePicker(BuildContext context, {
             void onConfirm(Time value), Time time}) async {
    
  var selectedTime = TimeOfDay(hour: time.hour, minute: time.minute);
  final TimeOfDay picked = await showTimePicker(context: context,
    initialTime: selectedTime
  );
  if (picked != null && picked != selectedTime)
    onConfirm(Time(picked.hour, picked.minute));
}

void showNumberInput(BuildContext context,{
                     Widget title, void onConfirm(int value), int value, 
                     String suffix = ''}){

  var controller = TextEditingController(text: value.toString());
  showDialog(context: context, builder: (c) =>
    AlertDialog(
      title: title,
      content: Row(children: [
        Expanded(child: 
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
          )
        ),
        SizedBox(width: 20),
        Text(suffix)
      ]),
      actions: [
        FlatButton(child: const Text('取消'),
          onPressed: () { Navigator.of(context).pop(false); },
        ),
        FlatButton(child: const Text('确认'),
          onPressed: () { 
            Navigator.of(context).pop(true); 
            onConfirm(int.parse(controller.text));
          },
        ),
      ]
    )
  );
}

Future<bool> showAlert(BuildContext context,{
                       Widget title = const Text('警告'), 
                       Widget content, void onConfirm()} ) async {
  return await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: title,
        content: content,
        actions: [
          FlatButton(
            child: const Text('取消'),
            onPressed: () { Navigator.of(context).pop(false);},
          ),
          FlatButton(
            child: const Text('确认'),
            onPressed: () { 
              Navigator.of(context).pop(true);
              onConfirm();
            },
          ),
        ],
      );
    },
  ) ?? false;
}


void showLongPressMenu(BuildContext context, {List<Widget> items}){
  showDialog(context: context, builder: (c) =>
    AlertDialog(
        titlePadding: EdgeInsets.all(0.0),
        contentPadding: EdgeInsets.all(0.0), content:
        Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: items)
    )
  );
}

class MenuItem extends StatelessWidget {

  final VoidCallback onTap;
  final Widget leading;
  final Widget title;

  MenuItem({this.onTap, this.leading, this.title});

  @override
  Widget build(BuildContext context) {
    return     
      InkWell(onTap: (){Navigator.of(context).pop(); onTap();}, child: 
        Container(padding: EdgeInsets.all(16.0), child: 
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(width: 24.0, child: leading), 
            SizedBox(width: 16.0), 
            title
          ])
        )
      )
    ;
  }
}
