import 'package:flutter/material.dart';
import 'package:task_manager/globals.dart';

class CustomDatePicker extends StatefulWidget {
  const CustomDatePicker({super.key});

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        taskDate = selectedDate.toLocal().toString().split(' ')[0];
        // Handle the selected date
        print("Selected Date: $selectedDate");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Selected Date:',
              style: TextStyle(fontSize: 14),
            ),
            Text(
              taskDate.split(' ')[0],
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),

        InkWell(
          onTap: () => _selectDate(context),
          child: Container(
            alignment: Alignment.center,
          height: 30,
            width: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(120),
              color: Colors.black
            ),
            child: Text('Select Date',style: TextStyle(color: Colors.white, fontSize: 14),),
          ),
        ),
      ],
    );
  }
}
