import 'package:flutter/material.dart';
import '../util/view.dart';

class DateTimePicker extends StatelessWidget {
  const DateTimePicker({
    Key key,
    this.labelText,
    this.selectedTime,
    this.selectTime
  }) : super(key: key);

  final String labelText;
  final TimeOfDay selectedTime;
  final ValueChanged<TimeOfDay> selectTime;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime
    );
    if (picked != null && picked != selectedTime)
      selectTime(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          flex: 3,
          child: InputDropdown(
            labelText: labelText,
            child: Text(selectedTime.format(context),style: TextStyle(fontSize: 16),),
            onPressed: () { _selectTime(context); },
          ),
        ),
      ],
    );
  }
}